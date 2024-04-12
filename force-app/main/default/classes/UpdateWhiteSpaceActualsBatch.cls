global class UpdateWhiteSpaceActualsBatch implements Database.Batchable<sObject> {

    global String q;
 
    global UpdateWhiteSpaceActualsBatch() {    
        
        q = 'SELECT Id FROM White_Space_Account_Detail__c';
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (White_Space_Account_Detail__c ws : (List<White_Space_Account_Detail__c>)scope) {
            UpdateWhiteSpaceActuals uws = new UpdateWhiteSpaceActuals();
            uws.updateMe(ws.id);
        }
    }
    
    global void finish(Database.BatchableContext bc) {

        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                from AsyncApexJob where Id = :bc.getJobId()];  
   
            // Email the Batch Job's submitter that the Job is finished.
            if(a.NumberOfErrors > 0)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateWhiteSpaceActualsBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
        
    }

}