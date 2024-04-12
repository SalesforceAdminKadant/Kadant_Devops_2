public class UGears 
{
    @TestVisible
    private static map<string, string>sFakeData;

    private static map<string, map<string, RecordType>>sRecTypes;

    @testVisible
    private static map<string, string>sPreferences;

    public class RecordTypeException extends Exception {}

    public static void ClearPrefs()
    {
        sPreferences = null;
    }

    public static map<string, string>GetUserPreferences()
    {
        if (sPreferences == null)
        {
            sPreferences = new map<string, string>();

            for (Machine_Mapping_User_Preference__c pref : [
                    SELECT Name, Value__c 
                    FROM Machine_Mapping_User_Preference__c
                    WHERE OwnerId = :UserInfo.getUserId()])
            {
                sPreferences.put(pref.Name, pref.Value__c);
            }
        }

        return sPreferences;
    }

    public static string GetCustomSetting (string what)
    {
        string ret = null;

        if (Test.isRunningTest() && sFakeData != null && sFakeData.containsKey(what))
        {
            ret = sFakeData.get(what);
        }
        else
        {
            for (Custom_Setting__mdt cs : [
                SELECT Value__c 
                FROM Custom_Setting__mdt 
                WHERE 
                    Name__c = :what AND 
                    Active__c = true 
                ORDER BY Label
                LIMIT 1])
            {
                ret = cs.Value__c;
            }
        }

        return ret;
    }

    //public static Id GetRecTypeByDevName (string objType, string devName)
    //{
    //  // note the lack of null checks here and below - if this doesn't work,
    //  // take the fault as something is seriously hosed
    //
    //  map<string, RecordType>types = GetRecordTypes (objType);
    //
    //  if (!types.containsKey(devName))
    //      throw new RecordTypeException ('RecordType ' + objType + '.' + devName + ' not found');
    //
    //  return types.get (devName).Id;
    //}

    public static string GetRecTypeDevName (string objType, string rtName)
    {
        string ret;

        for (RecordType rt : GetRecordTypes(objType).values())
        {
            if (rt.Name == rtName)
            {
                ret = rt.DeveloperName;
                break;
            }
        }

        return ret;
    }

    //public static Id GetRecTypeByName (string objType, string n)
    //{
    //  Id ret;
    //
    //  for (RecordType rt : GetRecordTypes(objType).values())
    //  {
    //      if (rt.Name == n)
    //      {
    //          ret = rt.Id;
    //          break;
    //      }
    //  }
    //
    //  return ret;
    //}

    public static map<string, RecordType> GetRecordTypes (string objType)
    {
        if (sRecTypes == null)
        {
            sRecTypes = new map<string, map<string, RecordType>>();

            for (RecordType rti : [SELECT 
                                        Id, 
                                        sObjectType, 
                                        NamespacePrefix, 
                                        Name, 
                                        //IsPersonType,  // only on orgs that have this enabled
                                        DeveloperName, 
                                        Description,
                                        BusinessProcessId 
                                    FROM 
                                        RecordType
                                    WHERE
                                        IsActive = true])
            {
                map<string, RecordType>prev = sRecTypes.get (rti.sObjectType);
                if (prev == null)
                {
                    prev = new map<string, RecordType>();
                    sRecTypes.put (rti.sObjectType, prev);
                }

                prev.put (rti.DeveloperName, rti);
            }
        }

        return sRecTypes.get (objType);
    }
}