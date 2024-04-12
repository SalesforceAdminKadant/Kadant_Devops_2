global without sharing class MachineSectionMapControllerReadOnly 
{
    private list<string>mMachinePartTypes {get; private set;}

    public map<string, list<string>>MachinePartMap {get; private set;}
    public map<string, string>KeyToName {get; private set;}
    public map<string, string>KeyToRecordType {get; private set;}
    public map<string, string>KeyToIcon {get; private set;}
    public map<string, string>KeyToIconR {get; private set;}
    public map<string, string>KeyToSObject {get; private set;}
    public map<string, string>KeyToMime {get; private set;}
    public transient map<string, string>KeyToBase64 {get; private set;}

    private list<string>sPaletteGroupKeys {get; set;}
    public map<string, list<PaletteEntry>>PaletteEntries {get; set;}
    public boolean NoSectionMaps {get; private set;}

    private Id mAccountId;
    private Id mRecordId;
    private Id mMachine;
    private static map<string, list<MetadataInfo>>sMetadata;

    @testVisible
    private static boolean UpdatingFromSectionMap = false;

    public static list<string>sPartTypes = new list<string>
    {
        'Machine_Mapping_Doctor__c', 
        'Machine_Mapping_Rotary_Joint__c',
        'Machine_Mapping_Cleaning__c',
        'Machine_Mapping_Filter__c',
        'Machine_Mapping_Drainage__c',
        'Machine_Mapping_Roll__c',
        'Machine_Mapping_Belt__c',
        'Machine_Mapping_Accessory__c'
    };

    public MachineSectionMapControllerReadOnly()
    {
        PageReference pr = ApexPages.currentPage();
        map<string, string>params = pr.getParameters();

        for (string key : params.keySet())
        {
            system.debug(key + ' = ' + params.get(key));
        }

        system.debug('theme = ' + UserInfo.getUiTheme());
        system.debug('url = ' + pr.getUrl());
    }

    public list<string>getPartObjectTypeNames()
    {
        return MachineSectionMapControllerReadOnly.sPartTypes;
    }

    public string ReturnUrl
    {
        get
        {
            map<string, string>params = ApexPages.currentPage().getParameters();
            return params.get('retUrl');        
        }
    }

    public PageReference Init()
    {
        PageReference ref;

        map<string, string>params = ApexPages.currentPage().getParameters();

        boolean isLex = false;
        boolean needRedirect = false;
        string theme = params.get('theme');

        if (theme == 'Theme1' || theme == 'Theme2' || theme == 'Theme3')
        {
            // classic
            isLex = false;
        }
        else
        if (theme != null)
        {
            // lightning
            isLex = true;
            needRedirect = true;
        }

        string pId = params.get('id');
        if (!string.isEmpty(pId))
        {
            for (DescribeSObjectResult dso : Schema.describeSObjects(new list<string>{'Machine__c'}))
            {
                if (pId.startsWith(dso.getKeyPrefix()))
                {
                    NoSectionMaps = true;

                    // they gave us a machine id instead of a section id.. redirect to 
                    // the first section
                    for (Machine_Section__c ms : [
                            SELECT Id
                            FROM Machine_Section__c 
                            WHERE Machine__c = :pId
                            ORDER BY Sequence__c
                            LIMIT 1])
                    {
                        NoSectionMaps = false;

                        mRecordId = ms.Id;

                        needRedirect = true;
                    }
                }
                else
                {
                    mRecordId = pId;
                }
            }
        }

        if (needRedirect)
        {
            string ret = params.get('retURL');
            if (!string.isBlank(ret))
                ret = '&retURL=' + ret;

            string u = '/apex/Machine_Section_MapReadOnly?id=' + mRecordId + ret;

            if (isLex)
            {
                map<string, object>args = new map<string, object>();
                map<string, string>attr = new map<string, string>();

                attr.put('address', u);
                attr.put('recordId', mRecordId);

                attr.put('id', params.get('id'));
                attr.put('theme', params.get('theme'));
                attr.put('returl', params.get('retURL'));

                args.put('componentDef', 'c:UMachineSectionMapReadOnly');
                args.put('state', new map<string, string>());
                args.put('attributes', attr);

                system.debug('args = ' + args);

                string j = JSON.serialize(args);

                ref = new PageReference('/one/one.app#' + EncodingUtil.base64Encode(Blob.valueOf(j)));
            }
            else
            {
                ref = new PageReference(u);
            }

            ref.setRedirect(true);
        }
        return ref;
    }

    public list<string>DoctorTypes
    {
        get
        {
            list<string>types = new list<string>();
            for (RecordType rti : [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Machine_Mapping_Doctor__c' AND IsActive = true])
            {
                types.add(rti.Name);
            }

            return types;
        }
    }

    public string LastEditInfo
    {
        get
        {
            map<string, string>ret = new map<string, string>();

            long maxTime = long.valueOf(UGears.GetCustomSetting('Inactive Editor Timeout'));
            if (maxTime > 0)
            {
                for (Machine_Section__c ms : [
                        SELECT Id, Last_Edit_User__c, Last_Edit_User__r.Name, Last_Edit_Timestamp__c 
                        FROM Machine_Section__c 
                        WHERE Id = :mRecordId])
                {
                    system.debug('LastEditInfo: ' + ms);
                    if (ms.Last_Edit_User__c != null)
                    {
                        ret.put('name', ms.Last_Edit_User__r.Name);
                        ret.put('time', string.valueOf(ms.Last_Edit_Timestamp__c.getTime()));

                        maxTime = long.valueOf(UGears.GetCustomSetting('Inactive Editor Reset'));
                        if (maxTime > 0)
                        {
                            long resetTime = ms.Last_Edit_Timestamp__c.getTime() + (maxTime * 60 * 1000);
                        
                            if (DateTime.now().getTime() > resetTime)
                            {
                                system.debug('resetting edit info - over reset time for ' + ms);
                        
                                // reset return values back to null
                                ret.clear();

                                ms = new Machine_Section__c
                                (
                                    Id = mRecordId,
                                    Last_Edit_User__c = null,
                                    Last_Edit_Timestamp__c = null
                                );
                        
                                update ms;
                            }
                        }
                    }
                }
            }
            string s = JSON.serialize(ret);
            system.debug('LastEditInfo returns: ' + s);
            return s;
        }
    }

    @RemoteAction 
    global static void UpdateEditCleaningBelt(string showerId, string beltId)
    {    
        string testBelt = beltId.length() == 0 ? null : beltId;   
        Machine_Mapping_Cleaning__c mmc = new Machine_Mapping_Cleaning__c
        (
            Id = Id.valueOf(showerId),
            Belt__c = testBelt
        );
        update mmc;        
    }
 
    private static void TrimList (list<sObject>soList, set<Id>partIds)
    {
        if (soList != null)
        {
            for (sObject so : soList)
            {
                partIds.remove(so.Id);
            }
        }
    }

    public Id MachineSectionId
    {
        get { return mRecordId; }
    }
    
    public Id MachineId
	{
	    get { return mMachine; }
	}

    public Id AccountId
    {
        get
        {
            if (mAccountId == null)
            {
                PageReference current = ApexPages.currentPage();
                if (current != null)
                {
                    map<string, string>params = current.getParameters();

                    mRecordId = params.get('id');

                    for (Machine_Section__c m : [
                        SELECT 
                            Machine__c,
                            Machine__r.Account__c
                        FROM Machine_Section__c
                        WHERE Id = :mRecordId
                        LIMIT 1])
                    {
                        if (m.Machine__r != null)
                        {
                            mMachine = m.Machine__c;
                            mAccountId = m.Machine__r.Account__c;
                        }
                    }
                }
            }
            return mAccountId;
        }
    }

    public string MapTitle
    {
        get
        {
            string ret = '';

            if (mRecordId != null)
            {
                for (Machine_Section__c m : [
                    SELECT 
                        Id, 
                        Name,
                        Machine__r.Name,
                        Machine__r.Account__r.Account_and_Site__c
                    FROM Machine_Section__c
                    WHERE Id = :mRecordId
                    LIMIT 1])
                {
                    ret = 
                        m.Machine__r.Account__r.Account_and_Site__c + ': ' +
                        m.Machine__r.Name + ', ' +
                        m.Name;
                }
            }
            return ret;
        }
    }

    public map<string, string>UserPreferences
    {
        get { return UGears.GetUserPreferences(); }
    }

    public string EditTimeout
    {
        get { return UGears.GetCustomSetting('Inactive Editor Timeout'); }
    }

    public string EditTimeoutWarn
    {
        get { return UGears.GetCustomSetting('Inactive Editor Warning'); }
    }

    public boolean DragDropEnabled
    {
        get { return UGears.GetCustomSetting('Drag Drop Enabled') != null; }
    }

    public string FileOpenPrefix
    {
        get { return UGears.GetCustomSetting('File Open Prefix'); }
    }

    public string CircleNoteForeground
    {
        get { return UGears.GetCustomSetting('Circle Note Foreground'); }
    }

    public string CircleNoteBackground
    {
        get { return UGears.GetCustomSetting('Circle Note Background'); }
    }

    public string OutsideArrowRadiusAdjust
    {
        get { return UGears.GetCustomSetting('Outside Arrow Radius Adjust'); }
    }

    public string OutsideARrowDegrees
    {
        get { return UGears.GetCustomSetting('Outside Arrow Degrees'); }
    }

    public string OutsideArrowDistance
    {
        get { return UGears.GetCustomSetting('Outside Arrow Distance'); }
    }

    public string BoxNoteFont
    {
        get { return UGears.GetCustomSetting('Box Note Font'); }
    }

    public string CircleNoteFont
    {
        get { return UGears.GetCustomSetting('Circle Note Font'); }
    }

    public string CircleNoteSize
    {
        get { return UGears.GetCustomSetting('Circle Note Size'); }
    }

    public string PaletteFont
    {
        get { return UGears.GetCustomSetting('Palette Font'); }
    }

    public string LabelFont
    {
        get { return UGears.GetCustomSetting('Label Font'); }
    }

    public string LabelColor
    {
        get { return UGears.GetCustomSetting('Label Color'); }
    }

    public string GoJS_Resource
    {
        get { return UGears.GetCustomSetting('GoJS Resource'); }
    }

    public boolean GoJS_Debug
    {
        get { return UGears.GetCustomSetting('GoJS Debug') != null; }
    }

    public string LicenseKey
    {
        get { return UGears.GetCustomSetting('GoJS Key').deleteWhitespace(); }
    }

    public integer RollSizeMultiplier
    {
        get { return integer.valueOf(UGears.GetCustomSetting('Roll Size Multiplier')); }
    }

    public string AutoRollOffet
    {
        get { return UGears.GetCustomSetting ('Pallete Rolls Offset'); }
    }

    public boolean DebugLabelPosition
    {
        get { return UGears.GetCustomSetting('Debug Label Position') != null; }
    }

    public integer MaxSectionNameLength
    {
        get { return Machine_Section__c.Name.getDescribe().getLength(); }
    }

    public boolean IsReadOnly
    {
        get
        {
            boolean readOnly = true;
            return readOnly;
        }
    }

    public list<string>PaletteGroupKeys
    {
        get
        {
            if (sPaletteGroupKeys == null)
            {
                object o = MachinePartTypes;
            }
            return sPaletteGroupKeys;
        }
    }

    public list<string>MachinePartTypes
    {
        get
        {
            if (mMachinePartTypes == null)
            {
                mMachinePartTypes = new list<string>();
                MachinePartMap = new map<string, list<string>>();
                KeyToName = new map<string, string>();
                KeyToRecordType = new map<string, string>();
                KeyToIcon = new map<string, string>();
                KeyToIconR = new map<string, string>();
                KeyToSObject = new map<string, string>();

                sPaletteGroupKeys = new list<string>();
                PaletteEntries = new map<string, list<PaletteEntry>>();

                set<string>images = new set<string>{ 'KadantLogo' };

                for (string partType : sPartTypes)
                {
                    AddPartType (partType, null, images);
                }
                KeyToMime = new map<string, string>();
                KeyToBase64 = new map<string, string>();

                for (StaticResource sr : [SELECT Id, Name, ContentType, Body FROM StaticResource WHERE Name IN :images])
                {
                    system.debug('resource ' + sr.ContentType + ' for ' + sr.Name);
                    KeyToMime.put(sr.Name, sr.ContentType);
                    KeyToBase64.put(sr.Name, EncodingUtil.base64Encode(sr.Body));
                }
            }
            system.debug ('types = ' + mMachinePartTypes);
            return mMachinePartTypes;
        }
    }

    private string MakeKey (string orig)
    {
        string key = orig.replaceAll('[^a-zA-Z0-9]', '_');
        key = key.replace ('__', '_');

        while (key.endsWith('_'))
            key = key.substring (0, key.length() - 1);

        return key;
    }

    public string PaletteBeltName
    {
        get { return MakeKey (Label.Palette_Belts_Name); }
    }

    private void AddPartType (string partType, string title, set<string>images)
    {
        system.debug ('AddPartType ' + partType + ', title=' + title);
        for (DescribeSObjectResult dso : Schema.describeSObjects(new list<string>{partType}))
        {
            string name = dso.getLabel();
            if (name.startsWith ('Machine Mapping - '))
                name = name.substringAfter('Machine Mapping - ');

            string key;
            key = string.isEmpty(title) ? MakeKey(name) : MakeKey(title);
            sPaletteGroupKeys.add (key);
            mMachinePartTypes.add(key);
            KeyToSObject.put (key, partType);

            list<string>types = new list<string>();

            list<PaletteEntry>entries = PaletteEntries.get (key);
            if (entries == null)
            {
                entries = new list<PaletteEntry>();
                PaletteEntries.put (key, entries);
            }

            list<Schema.RecordTypeInfo>rtis = dso.getRecordTypeInfos();

            for (Schema.RecordTypeInfo rti : rtis)
            {
                string rtName = rti.getName();

                if (rti.isMaster() == False && rti.IsActive() == True)
                {
                    types.add (rtName);

                    string devName = UGears.GetRecTypeDevName(partType, rtName);

                    KeyToIcon.put (rtName, devName);
                    KeyToIconR.put (rtName, devName + '_r');
                    KeyToRecordType.put (rtName, rti.getRecordTypeId());

                    images.add(partType == 'Machine_Mapping_Doctor__c' ? devName + '_r' : devName);

                    PaletteEntry e = new PaletteEntry(partType, name, rti.getRecordTypeId(), rtName);

                    entries.add (e);

                    system.debug ('added ' + e);
                }
            }
            entries.sort();
            entries[0].IsFirst = true;
            types.sort();
            MachinePartMap.put (key, types);
            KeyToName.put (key, name);
        }
    }


    public set<string>MetadataTypes
    {
        get { return getMetadata().keySet(); }
    }

    public map<string, list<MetadataInfo>>getMetadata()
    {
        if (sMetadata == null)
        {
            sMetadata = new map<string, list<MetadataInfo>>();
            set<string>types = new set<string>();

            // all sobject types we know...
            for (string pg : PaletteGroupKeys)
            {
                for (PaletteEntry pe : PaletteEntries.get(pg))
                    types.add (pe.ObjectType);
            }

            for (string so : types)
            {
                Schema.DescribeSobjectResult dor = Schema.describeSObjects(new list<string>{so})[0];
                system.debug ('making metadata for ' + so);
                list<Schema.RecordTypeInfo>rtis = dor.getRecordTypeInfos();

                for (Schema.RecordTypeInfo rti : rtis)
                {
                    string rt = rti.getName();
                    system.debug ('record type ' + rt);

                    if (rt == 'Master')
                        continue;

                    list<MetadataInfo>mil = new list<MetadataInfo>();

                    sMetadata.put (rt, mil);

                    map<string, Schema.FieldSet>fsets = dor.fieldSets.getMap();
                    if (fsets != null)
                    {
                        string key = MakeKey(rt);
                        system.debug ('key = ' + key);

                        Schema.FieldSet fs = fsets.get(key);
                        if (fs != null)
                        {
                            for (Schema.FieldSetMember fsm : fs.getFields())
                            {
                                DescribeFieldResult dfs = dor.fields.getMap().get(fsm.getFieldPath()).getDescribe();

                                if (dfs.getType() == DisplayType.Reference)
                                {
                                    system.debug ('skipping ref type for ' + fsm);
                                    system.debug(dfs);

                                    list<sObjectType>tos = dfs.getReferenceTo();
                                    if (tos == null)
                                    {
                                        system.debug('ref to null!');
                                    }
                                    else
                                    {
                                        integer i = 0;
                                        for (sObjectType sot : tos)
                                        {
                                            system.debug('ref to ' + (i++) + ' = ' + sot);
                                        }
                                    }

                                    continue;
                                }

                                MetadataInfo mdi = new MetadataInfo();

                                mdi.Label = fsm.getLabel();
                                mdi.FieldPath = fsm.getFieldPath();
                                mdi.IsRequired = fsm.getRequired() || fsm.getDBREquired();
                                mdi.IsReadOnly = dfs.isUpdateable() == false;
                                mdi.DefaultValue = string.valueOf(dfs.getDefaultValue());

                                string help = dfs.getInlineHelpText();
                                if (!string.isBlank((help)))
                                    help = help.replace ('"', '&#34;');

                                mdi.HelpText = help;

                                SOAPType soap = dfs.getSOAPType();

                                mdi.IsCheckbox = soap == SOAPType.Boolean;
                                mdi.IsDate = soap == SOAPType.Date;
                                mdi.IsNumber = soap == SOAPType.Double || soap == SOAPType.Integer;

                                DisplayType dt = dfs.getType();

                                mdi.VisibleLines = dt == DisplayType.TextArea ? (dfs.getLength() > 255 ? 5 : 3) : 1;

                                if (mdi.IsNumber)
                                    mdi.MaxLen = dfs.getPrecision() + 1; // +1 for decimal .
                                else
                                    mdi.MaxLen = dfs.getLength();

                                try
                                {
                                    list<Schema.PicklistEntry>pes = dfs.getPicklistValues();

                                    if (pes != null && pes.size() > 0)
                                    {
                                        mdi.Picks = new list<Schema.PicklistEntry>();
                                        mdi.Picks.addAll(pes);
                                    }
                                }
                                catch (Exception ex)
                                {
                                    // supposedly, trying to get picklist values on a non-picklist generates
                                    // a runtime error but it doesn't seem to actually do that.. either way, 
                                    // we don't care - just leave the array empty and move on
                                }
                                //system.debug ('add mdi for ' + mdi);
                                mil.add (mdi);
                            }
                        }
                    }
                }
            }
        }
        return sMetadata;
    }

    public set<string>getResourceNames()
    {
        set<string>ret = KeyToMime == null ? new set<string>() : KeyToMime.keySet();
        system.debug('ResourceNames: ' + ret);
        return ret;
    }

    public list<string>MachinePartConfigs
    {
        get
        {
            list<string>ret = new list<string>();
            for (Machine_Part_Config__mdt config : [
                SELECT 
                    Id, 
                    Allow_Link_From__c, 
                    Allow_Link_To__c, 
                    Filter_Field__c,
                    Canvas_Scale__c, 
                    Doctor_Offset_X__c, 
                    Doctor_Offset_Y__c, 
                    Label_Color__c, 
                    Label_Editable__c, 
                    Label_Field__c,
                    Label_Multiline__c, 
                    Label_Offset_X__c, 
                    Label_Offset_Y__c, 
                    Label_Use_Defaults__c, 
                    Link_Use_Defaults__c, 
                    Palette_Scale__c, 
                    Record_Type__c, 
                    Snap_Distance__c
                FROM Machine_Part_Config__mdt
                WHERE Active__c = true])
            {
                ret.add(JSON.serialize(config));
            }
            return ret;
        }
    }

    public integer FirstAutoRollSize
    {
        get { return AutoRollSizeValues[0]; }
    }

    public list<integer>AutoRollSizeValues
    {
        get
        {
            list<integer>vals = new list<integer>();
            for (string v : UGears.GetCustomSetting('Roll Sizes to Add').split(','))
            {
                vals.add (integer.valueOf(v.trim()));
            }
            return vals;
        }
    }


    public string AutoRollAddSize
    {
        get { return UGears.GetCustomSetting('Pallete Rolls To Add Size'); }
    }

    public list<integer>AutoRollValues
    {
        get
        {
            list<integer>vals = new list<integer>();

            for (string v : UGears.GetCustomSetting('Palette Rolls To Add').split(','))
            {
                vals.add (integer.valueOf(v.trim()));
            }
            return vals;
        }
    }

    public static void CheckTriggerAllowed (list<sObject>records)
    {
        if (!UpdatingFromSectionMap)
        {
            if (UGears.GetCustomSetting('Disable Machine Part Triggers') == null)
            {
                for (sObject record : records)
                {
                    record.addError (Label.Use_Map_To_Delete);
                }
            }
        }
    }

    public class PaletteEntry implements Comparable
    {
        public string ObjectType {public get; private set;}   // whatever__c
        public string ObjectLabel {public get; private set;}  // friendly name
        public string RecTypeId {public get; private set;}  // record type id
        public string RecTypeLabel {public get; private set;} // record type label
        public boolean IsFirst {public get; public set;}

        public PaletteEntry (string ot, string ol, string ri, string rl)
        {
            ObjectType = ot;
            ObjectLabel = ol;
            RecTypeId = ri;
            RecTypeLabel = rl;
            IsFirst = false;
        }

        public integer compareTo(object other) 
        {
            return RecTypeLabel.compareTo (((PaletteEntry)other).RecTypeLabel);
        }
    }

    public class MetadataInfo
    {
        public string Label {get; set;}
        public string FieldPath {get; set;}

        public boolean IsReadOnly {get; set;}
        public boolean IsRequired {get; set;}
        public boolean IsNumber {get; set;}
        public boolean IsDate {get; set;}
        public boolean IsCheckbox {get; set;}

        public integer MaxLen {get; set;}
        public list<Schema.PicklistEntry>Picks {get; set;}
        public string DefaultValue {get; set;}
        public string HelpText {get; set;}
        public integer VisibleLines {get; set;}

        public boolean IsPicklist
        {
            get { return Picks != null && Picks.size() > 0; }
        }
    }
}