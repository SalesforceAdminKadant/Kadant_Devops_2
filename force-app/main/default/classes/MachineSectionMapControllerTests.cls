@isTest(SeeAllData=true)
public class MachineSectionMapControllerTests 
{
    static MachineSectionMapController sController;
    static PageReference sPage;

    static Account sAccount;
    static Machine__c sMachine;
    static Machine_Section__c sSection1;
    static Machine_Section__c sSection2;

    static Machine_Mapping_Belt__c sBelt;
    static Machine_Mapping_Roll__c sRoll1;
    static Machine_Mapping_Roll__c sRoll2;
    static Machine_Mapping_Doctor__c sDoc1;
    static Machine_Mapping_Doctor__c sDoc2;

    static Machine_Mapping_Cleaning__c sClean;
    static Machine_Mapping_Filter__c sFilter;

    static string RETURL = 'BackToHere';

    static void MakeData()
    {
        sAccount = new Account(Name = 'TestCo');

        insert sAccount;

        sMachine = new Machine__c (Account__c = sAccount.Id, Name = 'Bruce');

        insert sMachine;

        sSection1 = new Machine_Section__c(Machine__c = sMachine.Id, Name = 'Section 1', Sequence__c = 1);
        sSection2 = new Machine_Section__c(Machine__c = sMachine.Id, Name = 'Section 2', Sequence__c = 2);

        insert new list<sObject>{sSection1, sSection2};
    }

    static void Start (boolean useMachine)
    {
        MakeData();

        Test.setCurrentPage(Page.Machine_Section_Map);

        map<string, string>params = ApexPages.currentPage().getParameters();

        params.put ('id', useMachine ? sMachine.Id : sSection1.Id);
        params.put ('retURL', RETURL);

        sController = new MachineSectionMapController();

        sController.Init();
    }

    static void MakeParts()
    {
        MachineSectionMapController.UpdatingFromSectionMap = true;

        sBelt = new Machine_Mapping_Belt__c(Machine_Section__c = sSection1.Id);

        insert sBelt;

        sRoll1 = new Machine_Mapping_Roll__c(Machine_Section__c = sSection1.Id, Belt__c = sBelt.Id, Label__c = 'r1');
        sRoll2 = new Machine_Mapping_Roll__c(Machine_Section__c = sSection1.Id, Belt__c = sBelt.Id, Label__c = 'r2');

        insert new list<sObject>{ sRoll1, sRoll2 };

        sDoc1 = new Machine_Mapping_Doctor__c(Machine_Section__c = sSection1.Id, Roll__c = sRoll1.Id);
        sDoc2 = new Machine_Mapping_Doctor__c(Machine_Section__c = sSection1.Id, Roll__c = sRoll2.Id);

        insert new list<sObject>{ sDoc1, sDoc2 };



        map<string, Id>cleanRts = new map<string, Id>();
        for (DescribeSObjectResult dso : Schema.describeSObjects(new list<string>{'Machine_Mapping_Cleaning__c'}))
        {
            for (Schema.RecordTypeInfo rti : dso.getRecordTypeInfos())
            {
                if (rti.isActive())
                {
                    cleanRts.put(rti.getName(), rti.getRecordTypeId());
                    system.debug('cleanRt: ' + rti);
                }
            }
        }

        string filterProp;
        Id recType;

        for (Machine_Part_Config__mdt config : [
                SELECT Id, Record_Type__c, Filter_Field__c 
                FROM Machine_Part_Config__mdt
                WHERE 
                    Active__c = true AND 
                    Filter_Field__c != null AND
                    Record_Type__c IN :cleanRts.keySet()])
        {
            system.debug('config: ' + config);
            filterProp = config.Filter_Field__c;
            recType = cleanRts.get(config.Record_Type__c);
            break;
        }

        if (filterProp != null)
        {
            sFilter = new Machine_Mapping_Filter__c(Machine_Section__c = sSection1.Id);

            insert sFilter;

            sClean = new Machine_Mapping_Cleaning__c(Machine_Section__c = sSection1.Id, RecordTypeId = recType);

            sClean.put(filterProp, sFilter.Id);

            insert sClean;
        }

        MachineSectionMapController.UpdatingFromSectionMap = false;
    }

    static string Encode(string fromString)
    {
        Blob b = Blob.valueOf(fromString);

        string s = EncodingUtil.base64Encode(b);

        return s;
    }

    @isTest(SeeAllData=true)
    static void TestAttachments()
    {
        Start(false);
        MakeParts();

        string ret;
        map<string, object>m;
        list<object>l;

        ret = MachineSectionMapController.UploadFile(sBelt.Id, null, 'test', Encode('first chunk\n'));

        m = (map<string, object>)JSON.deserializeUntyped(ret);

        string cvId = (string)m.get('cv');

        ret = MachineSectionMapController.UploadFile(sBelt.Id, cvId, 'test', Encode('second chunk!\n'));

        list<ContentDocumentLink>cdls = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :sBelt.Id];

        system.assertEquals(1, cdls.size());


        ret = MachineSectionMapController.GetAttachments(sBelt.Id);

        l = (list<object>)JSON.deserializeUntyped(ret);

        system.assertEquals(1, l.size());


        ret = MachineSectionMapController.DeleteAttachment(cvId);
        system.debug(ret);


        ret = MachineSectionMapController.GetAttachments(sBelt.Id);

        l = (list<object>)JSON.deserializeUntyped(ret);

        system.assertEquals(0, l.size());
    }

    @isTest(SeeAllData=true)
    static void TestPrefs()
    {
        Machine_Mapping_User_Preference__c pref = new Machine_Mapping_User_Preference__c
        (
            OwnerId = UserInfo.getUserId(),
            Name = 'Test',
            Value__c = 'true'
        );

        insert pref;

        map<string, string>prefs;
        
        prefs = UGears.GetUserPreferences();
        system.assertEquals('true', prefs.get('Test'));

        string ret = MachineSectionMapController.UpdatePreference('Test', 'false');
        system.assertEquals(null, ret);

        prefs = UGears.GetUserPreferences();
        system.assertEquals('false', prefs.get('Test'));
    }

    @isTest(SeeAllData=true)
    static void TestByMachine()
    {
        Start(true);
    }

    @isTest(SeeAllData=true)
    static void TestBoring() 
    {
        Start(false);

        system.assertEquals (RETURL, sController.ReturnUrl);
        system.assertEquals (sSection1.Id, sController.MachineSectionId);

        list<Machine_Section__c>sections = sController.MachineSections;
        system.assertEquals (2, sections.size());
        system.assertEquals (sSection1.Name, sections.get(0).Name);
        system.assertEquals (sSection2.Name, sections.get(1).Name);

        system.assertEquals (false, sController.IsReadOnly);

        MachineSectionMapController.UpdateEditInfo(sSection1.Id);
        MachineSectionMapController.ClearEditInfo(sSection1.Id);

        // coverage..
        object o;

        // old config stuff
        //o = sController.PartOffsets;
        //o = sController.PartScales;
        //o = sController.PaletteScales;
        //o = sController.SnapDistances;

        o = sController.DoctorTypes;
        o = sController.PaletteGroupKeys;
        o = sController.MachinePartTypes;
        o = sController.MetadataTypes;
        o = sController.AutoRollValues;
        o = sController.AutoRollSizeValues;
        o = sController.DebugLabelPosition;
        o = sController.MachinePartConfigs;
        o = sController.getPartObjectTypeNames();
        o = sController.UserPreferences;

        string s;
        s = sController.MapTitle;
        s = sController.PaletteFont;
        s = sController.LabelFont;
        s = sController.LabelColor;
        s = sController.LicenseKey;
        s = sController.PaletteBeltName;
        s = sController.AutoRollOffet;
        s = sController.BoxNoteFont;
        s = sController.CircleNoteFont;
        s = sController.CircleNoteSize;
        s = sController.OutsideArrowDegrees;
        s = sController.OutsideArrowDistance;
        s = sController.CircleNoteForeground;
        s = sController.CircleNoteBackground;
        s = sController.OutsideArrowRadiusAdjust;
        s = sController.GoJS_Resource;
        s = sController.FileOpenPrefix;
        s = sController.EditTimeout;
        s = sController.EditTimeoutWarn;

        UGears.sFakeData = new map<string, string>();
        UGears.sFakeData.put('Inactive Editor Timeout', '120');
        s = sController.LastEditInfo;

        integer i;
        i = sController.MaxSectionNameLength;
        i = sController.RollSizeMultiplier;
        i = sController.FirstAutoRollSize;

        boolean b;
        b = sController.DragDropEnabled;
        b = sController.GoJS_Debug;

        map<string, list<MachineSectionMapController.MetadataInfo>>allMeta = sController.getMetadata();
        for (list<MachineSectionMapController.MetadataInfo>metas : allMeta.values())
        {
            for (MachineSectionMapController.MetadataInfo meta : metas)
            {
                b = meta.IsPicklist;
            }
        }
    }

    @isTest(SeeAllData=true)
    static void TestRemoteActions()
    {
        Start(false);

        string ret;

        list<map<string, string>>all = new list<map<string, string>>();

        map<string, string>part;
        
        part = new map<string, string>();
        part.put ('type', 'Machine_Mapping_Doctor__c');
        part.put ('Machine_Section__c', sSection1.Id);
        part.put ('Label_Name__c', 'new doc1');
        all.add (part);

        part = new map<string, string>();
        part.put ('type', 'Machine_Mapping_Doctor__c');
        part.put ('Machine_Section__c', sSection1.Id);
        part.put ('Label_Name__c', 'new doc2');
        all.add (part);

        ret = MachineSectionMapController.InsertParts(JSON.serialize(all));

        system.assertNotEquals (-1, ret.indexOf('"success":true,'));

        list<Machine_Mapping_Doctor__c>docs;
        docs = [SELECT Id, Machine_Section__c, Label_Name__c FROM Machine_Mapping_Doctor__c
            WHERE Label_Name__c LIKE 'new doc%'];

        system.assertEquals (2, docs.size());


        list<Id>ids = new list<Id>();

        for (Machine_Mapping_Doctor__c doc : docs)
            ids.add (doc.Id);

        ret = MachineSectionMapController.VerifyPartsExist(sSection1.Id, ids);

        system.assertEquals(-1, ret.indexOf('missingIds'));

        ids.add (sAccount.Id);
        ret = MachineSectionMapController.VerifyPartsExist(sSection1.Id, ids);

        system.assertNotEquals(-1, ret.indexOf('missingIds'));



        list<Id>toDel = new list<Id>();

        for (Machine_Mapping_Doctor__c doc : docs)
            toDel.add (doc.Id);

        system.assertEquals (true, MachineSectionMapController.RemoveParts(toDel));
    }

    @isTest(SeeAllData=true)
    static void TestClone()
    {
        Start(false);
        MakeParts();

        map<string, string>parts = new map<string, string>();

        parts.put ('belt', sBelt.Id);
        parts.put ('roll1', sRoll1.Id);
        parts.put ('roll2', sRoll2.Id);
        parts.put ('doc1', sDoc1.Id);
        parts.put ('doc2', sDoc2.Id);

        sSection1.JSON__c = JSON.serialize(parts);

        system.debug ('orig json: ' + sSection1.JSON__c);

        update sSection1;

        string newId = MachineSectionMapController.CloneMachineSection((string)sSection1.Id, 'Cloney');

        Machine_Section__c clone = [SELECT Id, JSON__c FROM Machine_Section__c WHERE Id = :newId];

        system.debug ('new json: ' + clone.JSON__c);
    }

    @isTest(SeeAllData=true)
    static void getPartSearch1() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 1';
        insert acc;

        Product2 prod = new Product2();
        prod.Name = 'SAM Test Part';
        prod.CurrencyIsoCode = 'USD';
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = prod.Id;
        pbe.Pricebook2Id = '01s300000005nhMAAQ';
        pbe.CurrencyIsoCode = 'USD';
        pbe.UnitPrice = 1.25;
        pbe.IsActive = true;
        insert pbe;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.AccountId = acc.Id;
        opp.PriceBook2Id = pbe.Pricebook2Id;
        opp.StageName = '25% - Quote Issued';
        opp.CurrencyIsoCode = 'USD';
        opp.CloseDate = System.today();
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Our_Item_Number__c = prod.Name;
        oli.Product2Id = prod.Id;
        oli.Quantity = 1.00;
        oli.UnitPrice = 1.25;
        oli.PriceBookEntryId = pbe.Id;
        insert oli;       
        
        string test = MachineSectionMapController.PartSearch(prod.Name, acc.Id);
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(test);
        
        System.assertEquals(prod.Name, m.get('kadantPart'));
    }

    @isTest(SeeAllData=true)
    static void getPartSearch2() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 1';
        insert acc;

        Product2 prod = new Product2();
        prod.Name = 'SAM Test Part';
        prod.CurrencyIsoCode = 'USD';
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = prod.Id;
        pbe.Pricebook2Id = '01s300000005nhMAAQ';
        pbe.CurrencyIsoCode = 'USD';
        pbe.UnitPrice = 1.25;
        pbe.IsActive = true;
        insert pbe;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.AccountId = acc.Id;
        opp.PriceBook2Id = pbe.Pricebook2Id;
        opp.StageName = '25% - Quote Issued';
        opp.CurrencyIsoCode = 'USD';
        opp.CloseDate = System.today();
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Product2Id = prod.Id;
        oli.Quantity = 1.00;
        oli.UnitPrice = 1.25;
        oli.PricebookEntryId = pbe.Id;
        insert oli;       
        
        string test = MachineSectionMapController.PartSearch('XZAXZXZX', acc.Id);
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(test);
        
        System.assertEquals('', m.get('kadantPart'));
    }

    @isTest(SeeAllData=true)
    static void getDrawingTest1() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 1';
        insert acc;  
        
        Drawing__c draw = new Drawing__c();
        draw.Name = 'samtest';
        draw.Title__c = 'My test drawing';
        draw.Division__c = 'KSD';
        draw.Account__c = acc.Id;
        insert draw;
        
        string test = MachineSectionMapController.GetDrawingId(draw.Name); 
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(test);       
        
        System.assertEquals(draw.Id, m.get('drawing_id'));
    }

    @isTest(SeeAllData=true)
    static void getDrawingTest2() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 1';
        insert acc;  
        
        Drawing__c draw = new Drawing__c();
        draw.Name = 'samtest';
        draw.Title__c = 'My test drawing';
        draw.Division__c = 'KSD';
        draw.Account__c = acc.Id;
        insert draw;
        
        string test = MachineSectionMapController.GetDrawingId('xzxzxzxzxsd'); 
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(test);       
        
        System.assertEquals('', m.get('drawing_id'));
    }
}