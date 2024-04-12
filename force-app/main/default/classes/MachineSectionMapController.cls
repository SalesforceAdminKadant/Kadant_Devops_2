global without sharing class MachineSectionMapController 
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

    private static list<string>sPartTypes = new list<string>
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

    public MachineSectionMapController()
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
        return MachineSectionMapController.sPartTypes;
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

            string u = '/apex/Machine_Section_Map?id=' + mRecordId + ret;

            if (isLex)
            {
                map<string, object>args = new map<string, object>();
                map<string, string>attr = new map<string, string>();

                attr.put('address', u);
                attr.put('recordId', mRecordId);

                attr.put('id', params.get('id'));
                attr.put('theme', params.get('theme'));
                attr.put('returl', params.get('retURL'));

                args.put('componentDef', 'c:UMachineSectionMap');
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

            // for (RecordType rt : UGears.GetRecordTypes('Machine_Mapping_Doctor__c').values())
            // {
            //     types.add(rt.Name);
            // }

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
    global static void UpdateEditInfo(string sectionId)
    {
        long maxTime = long.valueOf(UGears.GetCustomSetting('Inactive Editor Timeout'));
        if (maxTime > 0)
        {
            Machine_Section__c ms = new Machine_Section__c
            (
                Id = Id.valueOf(sectionId),
                Last_Edit_User__c = UserInfo.getUserId(),
                Last_Edit_Timestamp__c = Datetime.now()
            );

            update ms;
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

    @RemoteAction 
    global static void ClearEditInfo(string sectionId)
    {
        long maxTime = long.valueOf(UGears.GetCustomSetting('Inactive Editor Timeout'));
        if (maxTime > 0)
        {
            Machine_Section__c ms = new Machine_Section__c
            (
                Id = Id.valueOf(sectionId),
                Last_Edit_User__c = null,
                Last_Edit_Timestamp__c = null
            );
            update ms;
        }
    }

    @RemoteAction
    global static string UpdatePreference(string prefName, string newVal)
    {
        UGears.ClearPrefs();
        Id prefId;
        for (Machine_Mapping_User_Preference__c pref : [
                SELECT Id
                FROM Machine_Mapping_User_Preference__c 
                WHERE OwnerId = :UserInfo.getUserId() AND Name = :prefName
                LIMIT 1])
        {
            prefId = pref.Id;
            break;
        }

        Machine_Mapping_User_Preference__c pref = new Machine_Mapping_User_Preference__c
        (
            Id = prefId,
            Name = prefName,
            Value__c = newVal
        );
        upsert pref;
        return null;
    }

    @RemoteAction 
    global static string DeleteAttachment(string cvStr)
    {
        string ret;
        try
        {
            Id cvId = Id.valueOf(cvStr);

            for (ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvId LIMIT 1])
            {
                ContentDocument cd = new ContentDocument(Id = cv.ContentDocumentId);

                delete cd;
            }
        }
        catch (Exception ex)
        {
            system.debug(ex);

            ret = ex.getMessage();
        }
        return ret;
    }

    @RemoteAction
    global static string GetAttachments(string partId)
    {
        Id pId = Id.valueOf(partId);
        set<Id>docIds = new set<Id>();
        for (ContentDocumentLink cdl : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :pId])
        {
            docIds.add(cdl.ContentDocumentId);
        }

        list<ContentVersion>cvs = new list<ContentVersion>();

        if (docIds.size() > 0)
        {
            for (ContentVersion cv : [
                SELECT
                    Id,
                    ContentModifiedBy.Alias,
                    ContentModifiedBy.Name,
                    ContentModifiedById,
                    ContentModifiedDate,
                    ContentSize,
                    CreatedBy.Alias,
                    CreatedBy.Name,
                    CreatedById,
                    CreatedDate,
                    FileExtension,
                    FileType,
                    Title
                FROM ContentVersion
                WHERE ContentDocumentId IN :docIds AND PublishStatus = 'P'
                ORDER BY Title ASC])
            {
                cvs.add(cv);
            }
        }
        string j = JSON.serialize(cvs);
        system.debug('GetAttachments: ' + j);
        return j;
    }

    @RemoteAction
    global static string UploadFile(string partIdStr, string cvIdStr, string aName, string bod) 
    {
        ContentVersion cv;
        Id partId = Id.valueOf(partIdStr);
        boolean needCdl = false;

        map<string, object>ret = new map<string, object>();

        if (!string.isBlank(cvIdStr))
        {
            Id cvId = Id.valueOf(cvIdStr);

            for (ContentVersion c : [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId LIMIT 1])
            {
                cv = c;
            }
        }

        if (cv == null)
        {
            needCdl = true;

            cv = new ContentVersion
            (
                Title = aName,
                PathOnClient = aName,
                IsMajorVersion = false
            );
        }

        string newBody;
        newBody = cv.VersionData != null ? EncodingUtil.base64Encode(cv.VersionData) + bod : bod;
        cv.VersionData = EncodingUtil.base64Decode(newBody);
        upsert cv;
        ret.put('cv', cv.Id);

        if (needCdl)
        {
            cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ID = :cv.Id];
            ContentDocumentLink cdl = new ContentDocumentLink
            (
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = partId,
                ShareType = 'V'
            );
            insert cdl;
        }
        return JSON.serialize(ret);
    }

    @RemoteAction
    global static string InsertParts(string partsSer)
    {
        //system.debug ('+InsertParts');
        UpdatingFromSectionMap = true;
        try
        {
            list<object>parts = (list<object>)JSON.deserializeUntyped(partsSer);
            map<string, Schema.sObjectType>allTypes = Schema.getGlobalDescribe();
            list<sObject>inserts = new list<sObject>();
            for (object part : parts)
            {
                map<string, object>pMap = (map<string, object>)part;

                string type = (string)pMap.get('type');

                DescribeSObjectResult thisType = allTypes.get(type).getDescribe();

                map<string, sObjectField>typeFields = thisType.fields.getMap();

                sObject so = allTypes.get(type).newSObject();

                for (string key : pMap.keySet())
                {
                    system.debug(key + ' = ' + pMap.get(key));

                    if (key != 'type')
                    {
                        DescribeFieldResult f = typeFields.get(key).getDescribe();

                        system.debug(f);

                        SoapType soap = f.getSoapType();
                        object val = pMap.get(key);

                        if (soap == SoapType.Double)
                        {
                            so.put(key, double.valueOf(val));
                        }
                        else if (soap == SoapType.Integer)
                        {
                            so.put(key, integer.valueOf(val));
                        }
                        else if (soap == SoapType.DATE)
                        {                            
                            String myTmp = String.valueOf(val);
                            Date test = Date.valueOf(myTmp);
                            so.put(key, test);
                        }
                        else
                        {
                            so.put(key, val);
                        }
                    }
                }
                inserts.add (so);
                //system.debug ('made so ' + so);
            }
            Database.SaveResult[] results = database.insert(inserts);
            for (Database.SaveResult result : results)
            {
                system.debug ('save result: ' + result);
            }
            system.debug ('-InsertParts');
            return JSON.serialize(results);
        }
        finally
        {
            UpdatingFromSectionMap = false;
        }
    }

    @RemoteAction
    global static boolean RemoveParts(list<Id>partIds) 
    {
        UpdatingFromSectionMap = true;
        boolean ret = true;

        // todo: is there anything to do if any of this fails? since we only know about
        // parts that gojs deserialize tells us about, if seems like we should probably
        // just smile and nod if something goes wrong...
        try
        {
            Database.DeleteResult [] res = database.delete (partIds, false);

            for (Database.DeleteResult dr : res)
            {
                if (!dr.isSuccess())
                {
                    system.debug ('delete failed on ' + dr);
                    ret = false;
                }
            }
        }
        catch (Exception ex)
        {
            ret = false;
            system.debug ('exception deleting parts: ' + ex);
        }
        finally
        {
            UpdatingFromSectionMap = false;
        }
        return ret;
    }

    @RemoteAction
    global static string VerifyPartsExist (Id section, list<Id>partIds)
    {
        string soql = 
            'SELECT Id, ' +
            '   (SELECT Id FROM Machine_Mapping_Belts__r WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Cleaning__r WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Drainage__r WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Doctors__r  WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Filters__r  WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Rolls__r    WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Rotary_Joints__r WHERE Id IN :partIds), ' +
            '   (SELECT Id FROM Machine_Mapping_Accessories__r  WHERE Id IN :partIds) ' +
            ' FROM Machine_Section__c WHERE Id = :section';

        Machine_Section__c ms = database.query(soql);
        set<Id>ids = new set<Id>(partIds);

        // remove ids we got back from the passed-in partIds. whatever's left
        // over is missing
        TrimList (ms.Machine_Mapping_Belts__r, ids);
        TrimList (ms.Machine_Mapping_Cleaning__r, ids);
        TrimList (ms.Machine_Mapping_Doctors__r, ids);
        TrimList (ms.Machine_Mapping_Drainage__r, ids);
        TrimList (ms.Machine_Mapping_Filters__r, ids);
        TrimList (ms.Machine_Mapping_Rolls__r, ids);
        TrimList (ms.Machine_Mapping_Rotary_Joints__r, ids);
        TrimList (ms.Machine_Mapping_Accessories__r, ids);

        map<string, object>retMap = new map<string, object>();

        if (ids.size() > 0)
        {
            // figure out some nice text to show to the user about which parts 
            // are missing based on prefixes of ids that are left
    
            map<string, integer>prefixCounts = new map<string, integer>();

            for (Id mId : ids)
            {
                system.debug ('missing ' + mId);

                string prefix = ((string)mId).substring(0, 3);

                integer prev = prefixCounts.get(prefix);
                if (prev == null)
                    prefixCounts.put (prefix, 1);
                else
                    prefixCounts.put (prefix, prev + 1);
            }

            string txt = '';

            for (DescribeSObjectResult dso : Schema.describeSObjects(sPartTypes))
            {
                integer count = prefixCounts.get(dso.getKeyPrefix());
                if (count != null)
                {
                    if (txt != '')
                        txt += '\n';
                         
                    txt += (count == 1 ? dso.getLabel() : dso.getLabelPlural()) + ' (' + count + ')';
                }
            }

            retMap.put ('missingText', txt);
            retMap.put ('missingIds', ids);
        }
        else
        {
            retMap.put ('missingText', '');

            system.debug ('no missing ids');
        }
        return JSON.serialize(retMap);
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


    @RemoteAction
    global static string CloneMachineSection(string sectionId, string newName)
    {
        // 1: soql all the info on the existing machine section and related lists
        // 2: clone just the section, change the name, insert to get the new section id
        // 3a: clone all the related objects
        // 3b: update each section id to the new one
        // 3c: do NOT clear out relationships like belt_id__c on rolls and roll__c on doctors/rotarys
        // 4: insert related objects
        // 5: create map of old id -> new id
        // 6: go back thru 3c and update relationships using old/new map
        // 7: replace old ids with new ids in json & resave machine_section__c
        // 8: return new machine_section__c id

        UpdatingFromSectionMap = true;
        Machine_Section__c newSection = new Machine_Section__c();

        try
        {
            // 1: soql all the info on the existing machine section and related lists
            string soql = 'SELECT Id,';

            list<string>fields = new list<string>();

            Schema.DescribeSObjectResult sectionDesc = Schema.describeSObjects(new list<string>{'Machine_Section__c'})[0];

            for (Schema.SObjectField f : sectionDesc.fields.getMap().values())
            {
                Schema.DescribeFieldResult dfr = f.getDescribe();

                if (dfr.isCreateable())
                    fields.add (dfr.getName());
            }

            soql += string.join(fields, ',');
            soql += ' FROM Machine_Section__c WHERE Id = :sectionId LIMIT 1';

            Machine_Section__c oldSection = database.query(soql);

            map<string, list<sObject>>oldRelateds = new map<string, list<sObject>>();

            for (DescribeSObjectResult dso : Schema.describeSObjects(sPartTypes))
            {
                fields = new list<string>();

                for (Schema.SObjectField f : dso.fields.getMap().values())
                {
                    Schema.DescribeFieldResult  dfr = f.getDescribe();

                    if (dfr.isCreateable())
                    {
                        fields.add (dfr.getName());
                    }
                }

                string q = 
                    'SELECT Id,' + string.join(fields, ',') + 
                    ' FROM ' + dso.getName() + 
                    ' WHERE Machine_Section__c = :sectionId';

                // ugh.. i did have a nice, fancy thing to build a single query with subqueries for related
                // parts but keep hitting "Aggregate query has too many rows for direct assignment" errors.
                // Tried **many** workarounds but ended up with soql in a loop. Gross but works :\

                list<sObject>relateds = database.query(q);

                oldRelateds.put (dso.getName(), relateds);
            }

            // 2: clone just the section, change the name, insert to get the new section id
            for (Schema.SObjectField f : sectionDesc.fields.getMap().values())
            {
                Schema.DescribeFieldResult dfr = f.getDescribe();

                if (dfr.isCreateable())
                    newSection.put (f, oldSection.get(dfr.getName()));
            }

            newSection.Name = newName;

            //boolean broken = (boolean)oldSection.get('Debug_Clone_Error__c');
            //if (broken != null && broken)
            //{
            //  throw new DmlException('A forced debug error occurred');
            //}

            insert newSection;

            map<string, string>ret = new map<string, string>();

            ret.put ('section', newSection.Id);

            // 3a: clone all the related objects
            list<sObject>newParts = new list<sObject>();
            list<Id>oldIds = new list<Id>();

            for (string partType : sPartTypes)
            {
                list<sObject>rlist = oldRelateds.get(partType);
                if (rlist != null)
                {
                    for (sObject so : rlist)
                    {
                        sObject clone = so.clone(false, true);

                        oldIds.add (so.Id);
                        newParts.add(clone);

                        // 3b: update each section id to the new one
                        clone.put ('Machine_Section__c', newSection.Id);

                        // 3c: do NOT clear out relationships like belt__c on rolls and roll__c on doctors/rotarys
                    }
                }
            }

            if (newParts.size() > 0)
            {
                map<string, Machine_Part_Config__mdt>configs = new map<string, Machine_Part_Config__mdt>();
                for (Machine_Part_Config__mdt config : [
                    SELECT Id, Record_Type__c, Filter_Field__c
                    FROM Machine_Part_Config__mdt
                    WHERE Active__c = true AND Filter_Field__c != null])
                {
                    configs.put(config.Record_Type__c, config);
                }

                map<Id, string>recTypes = new map<Id, string>();
                for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE IsActive = true AND sObjectType IN :sPartTypes])
                {
                    recTypes.put(rt.Id, rt.Name);
                }

                // 4: insert related objects
                insert newParts;
                list<sObject>updates = new list<sObject>();

                // 5: create map of old id -> new id
                for (integer i = 0; i < newParts.size(); i++)
                {
                    ret.put (oldIds[i], newParts[i].Id);
                }

                // 6: go back thru 3c and update relationships using old/new map
                for (sObject so : newParts)
                {
                    string soType = so.getSObjectType().getDescribe().getName();

                    if (soType == 'Machine_Mapping_Doctor__c' || soType == 'Machine_Mapping_Rotary_Joint__c')
                    {
                        Id roll = (Id)so.get('Roll__c');
                        if (roll != null)
                        {
                            system.debug ('replacing roll');
                            system.debug (so);
                            so.put ('Roll__c', ret.get(roll));
                            system.debug (so);

                            updates.add (so);
                        }
                    }
                    else
                    if (soType == 'Machine_Mapping_Roll__c')
                    {
                        Id belt = (Id)so.get('Belt__c');
                        if (belt != null)
                        {
                            system.debug ('replacing belt');
                            system.debug (so);
                            so.put ('Belt__c', ret.get(belt));
                            system.debug (so);

                            updates.add (so);
                        }
                    }
                    else
                    {
                        string rtId = (string)so.get('RecordTypeId');

                        string rtName = recTypes.get(Id.valueOf(rtId));

                        if (rtName != null)
                        {
                            Machine_Part_Config__mdt config = configs.get(rtName);
                            if (config != null)
                            {
                                system.debug('config for filter update: ' + config);

                                Id filter = (Id)so.get(config.Filter_Field__c);
                                if (filter != null)
                                {
                                    system.debug ('replacing filter');
                                    system.debug (so);
                                    so.put (config.Filter_Field__c, ret.get(filter));
                                    system.debug (so);

                                    updates.add (so);                                   
                                }
                            }
                        }
                    }
                }
                update updates;
            }
            // 7: replace old ids with new ids in json & resave machine_section__c
            string newJson = oldSection.JSON__c;
            for (string oldId : ret.keySet())
            {
                if (oldId != 'section')
                {
                    if (newJson.indexOf (oldId) != -1)
                    {
                        newJson = newJson.replaceAll(oldId, ret.get(oldId));
                    }

                    string shorty = oldId.subString (0, 15);
                    if (newJson.indexOf(shorty) != -1)
                        newJson = newJson.replaceAll(shorty, ret.get(oldId));
                }
            }
            newSection.JSON__c = newJson;
            update newSection;
        }
        finally
        {
            UpdatingFromSectionMap = false;
        }
        // 8: return new machine_section__c id
        return newSection.Id;
    }

    @RemoteAction
    global static string SavePicture(string sectionId, string svg)
    {
        string fileName = UGears.GetCustomSetting('SVG Print Name');

        Id docId;
        Id sId = Id.valueOf(sectionId);
        boolean needCdl = true;

        for (ContentDocumentLink cdl : [
                SELECT Id, ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE 
                    ContentDocument.Title = :fileName AND
                    LinkedEntityId = :sId
                ORDER BY ContentDocument.CreatedDate DESC
                LIMIT 1])
        {
            docId = cdl.ContentDocumentId;
            needCdl = false;
        }

        ContentVersion cv = new ContentVersion
        (
            Title = fileName,
            PathOnClient = fileName + '.SVG',
            IsMajorVersion = true,
            ContentDocumentId = docId,
            VersionData = EncodingUtil.base64Decode(svg)
        );

        insert cv;

        if (needCdl)
        {
            for (ContentVersion newCv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id])
            {
                ContentDocumentLink cdl = new ContentDocumentLink
                (
                    ContentDocumentId = newCv.ContentDocumentId,
                    LinkedEntityId = sId,
                    ShareType = 'V'
                );

                insert cdl;
            }
        }
        return null;
    }
    
    @RemoteAction
    global static string SaveMap(string sectionId, string cvIdStr, string svg, boolean doneUploading)
    {    
        string fileName = UGears.GetCustomSetting('SVG Print Name');
        Id docId;
        ContentVersion cv;
        Id sId = Id.valueOf(sectionId);
        boolean needCdl = true;
        
        // See if there is already a CDL on first pass through with a large file and delete the previous file
        if (string.isBlank(cvIdStr))
        {
            for (ContentDocumentLink oldCdl : [
                    SELECT Id, ContentDocumentId 
                    FROM ContentDocumentLink 
                    WHERE 
                        ContentDocument.Title = :fileName AND
                        LinkedEntityId = :sId
                    ORDER BY ContentDocument.CreatedDate DESC
                    LIMIT 1])
            {
                Id oldDocId = oldCdl.ContentDocumentId;
                delete oldCdl;
            }
        }        
        
        map<string, object> ret = new map<string, object>();
        
        if (!string.isBlank(cvIdStr))
        {
            for (ContentDocumentLink cdl : [
                    SELECT Id, ContentDocumentId 
                    FROM ContentDocumentLink 
                    WHERE 
                        ContentDocument.Title = :fileName AND
                        LinkedEntityId = :sId
                    ORDER BY ContentDocument.CreatedDate DESC
                    LIMIT 1])
            {
                docId = cdl.ContentDocumentId;
                needCdl = false;
            }
        }
        
        if (!string.isBlank(cvIdStr))
        {
            Id cvId = Id.valueOf(cvIdStr);
    
            for (ContentVersion c : [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId LIMIT 1])
            {
                cv = c;
            }
        }

        if (cv == null)
        { 
            cv = new ContentVersion
            (
                Title = fileName,
                PathOnClient = fileName + '.SVG',
                IsMajorVersion = false,
                ContentDocumentId = docId
            );
        }        
        string newBody;        
        newBody = cv.VersionData != null ? EncodingUtil.base64Encode(cv.VersionData) + svg : svg;        
        cv.VersionData = EncodingUtil.base64Decode(newBody);
        upsert cv;        
        ret.put('cv', cv.Id);        
        if (needCdl)
        {
            for (ContentVersion newCv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ID = :cv.Id])
            {
                ContentDocumentLink cdl = new ContentDocumentLink
                (
                    ContentDocumentId = newCv.ContentDocumentId,
                    LinkedEntityId = sId,
                    ShareType = 'V',
                    Visibility = 'AllUsers'
                );
                insert cdl;
            }
        }
        return JSON.serialize(ret);
    }

    public Id MachineSectionId
    {
        get { return mRecordId; }
    }
    
    public Id MachineId
	{
	    get { return mMachine; }
	}

    public list<Machine_Section__c>MachineSections
    {
        get
        {
            if (mMachine == null)
            {
                // getting account id also gets machine id
                Id tmp = AccountId;
            }

            list<Machine_Section__c>ret = new list<Machine_Section__c>();

            for (Machine_Section__c ms : [
                    SELECT Id, Name, Sequence__c
                    FROM Machine_Section__c 
                    WHERE Machine__c = :mMachine
                    ORDER BY Sequence__c, Name ASC])
            {
                ret.add(ms);
            }
            return ret;
        }
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
            if (UGears.GetCustomSetting('Section Map Read Only') == null)
            {
                if (AccountId != null)
                {
                    for (UserRecordAccess ura : [
                        SELECT 
                            RecordId, 
                            HasEditAccess
                        FROM UserRecordAccess 
                        WHERE 
                            UserId = :UserInfo.getUserId() AND 
                            RecordId = :mAccountId
                        LIMIT 1])
                    {
                        readOnly = !ura.HasEditAccess;
                    }
                }

                if (!readOnly)
                {
                    string j = LastEditInfo;

                    if (j != null && j.length() > 3) // not {}
                    {
                        system.debug('IsReadOnly: "' + j + '"');
                        readOnly = true;
                    }
                }
            }
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

    @RemoteAction
    global static string PartSearch(String part, String acctId) {
        map<string, object> ret = new map<string, object>();
        // Get OpportunityLineItem that matches the Search String
        OpportunityLineItem[] olis = [select id, Account_Site__c, Our_Item_Number__c, Description, Customer_Item_Number__c from OpportunityLineItem where Our_Item_Number__c = :part AND Opportunity.AccountId = :acctId ORDER BY CreatedDate DESC LIMIT 1];
        if (!olis.isEmpty())
        {
            OpportunityLineItem oli = olis[0];
            ret.put('description', oli.Description);
            ret.put('customerItem', oli.Customer_Item_Number__c);
            ret.put('kadantPart', oli.Our_Item_Number__c);
        }
        else 
        {
            ret.put('description', 'No part found.'); 
            ret.put('customerItem', '');
            ret.put('kadantPart', '');           
        }                
        return JSON.serialize(ret);
    }

    @RemoteAction
    global static string GetDrawingId(String name) {
        map<string, object> ret = new map<string, object>();
        //System.Debug('Drawing Name: ' + name);
        Drawing__c[] dr = [SELECT ID FROM Drawing__c WHERE Name = :name LIMIT 1];
        if (!dr.isEmpty())
        {
            ret.put('drawing_id', dr[0].ID);
            //System.Debug('Drawing Name: ' + name);
        }
        else 
        {
            ret.put('drawing_id', '');
        }
        return JSON.serialize(ret);
    }
}