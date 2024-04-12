public class UnLockRecordQueueable implements Queueable{

    public List<Id> recordList;

    @InvocableMethod
    public static Void UnLockRecordQueueable(List<Id> recordIds) {
        System.enqueueJob(new UnLockRecordQueueable(recordIds));
    }

    public UnLockRecordQueueable(List<Id> recordIds)
    {
        recordList = recordIds;
    }

    public void execute(QueueableContext qc)
    {
        for(Id recordId : recordList)
        {
            if(Approval.isLocked(recordId))
                Approval.UnLock(recordId, false);
        }
    }
}