@isTest(SeeAllData=true)
public class MachineSectionMapControllerReadOnlyTests 
{
    static MachineSectionMapControllerReadOnly sController;
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

        sController = new MachineSectionMapControllerReadOnly();

        sController.Init();
    }

    static void MakeParts()
    {
        MachineSectionMapControllerReadOnly.UpdatingFromSectionMap = true;

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

        MachineSectionMapControllerReadOnly.UpdatingFromSectionMap = false;
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

        // coverage..
        object o;

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

        map<string, list<MachineSectionMapControllerReadOnly.MetadataInfo>>allMeta = sController.getMetadata();
        for (list<MachineSectionMapControllerReadOnly.MetadataInfo>metas : allMeta.values())
        {
            for (MachineSectionMapControllerReadOnly.MetadataInfo meta : metas)
            {
                b = meta.IsPicklist;
            }
        }
    }
}