public class LockRecord {

    /*******************************************************/
    /* Lock a record                                       */
    /*******************************************************/
    @InvocableMethod
    public static Void lockRecord(List<Id> recordIds) {
        for(Id recordId : recordIds)
        {
            if(!Approval.isLocked(recordId))
                Approval.Lock(recordId, false);
        }
    }

}