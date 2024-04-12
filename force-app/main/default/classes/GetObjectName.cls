global class GetObjectName
{
    @InvocableMethod
    public static List<string> returnObjectName(List<ID> recordIdS)
    {
        // object Ids to return
        List<string> objectNames = new List<string>();
        if(recordIds.size() > 0)
        {
            for(Id recordId : recordIds)
            {
                // get record name
                String objectName = recordId.getSobjectType().getDescribe().getName();
                // add object name to list
                objectNames.add(objectName);
            }
        }
        return objectNames;
    }
}