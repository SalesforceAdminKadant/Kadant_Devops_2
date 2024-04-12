public class IsRecordLocked {

    /*******************************************************/
    /* Check to see if a record is locked                  */
    /*******************************************************/
    @InvocableMethod(label='Retrieve if a record is locked or not.')
    public static List<Boolean> IsRecordLocked(List<Id> recordIds) {
        List<Boolean> b = new List<Boolean>{};
        for(Id recordId : recordIds)
        {
            if(Approval.isLocked(recordId))
                b.add(true);
            else
                b.add(false);
        }
        return b;
    }

}