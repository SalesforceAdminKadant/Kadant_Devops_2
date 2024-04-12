public class UnLockRecord {

    /*******************************************************/
    /* Unlock a record                                     */
    /*******************************************************/
    @InvocableMethod
    public static Void unLockRecord(List<Id> recordIds) {
        for(Id recordId : recordIds)
        {
            if(Approval.isLocked(recordId))
                Approval.UnLock(recordId, false);
        }
    }

}