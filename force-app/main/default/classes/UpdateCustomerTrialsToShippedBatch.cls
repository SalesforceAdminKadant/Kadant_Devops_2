global class UpdateCustomerTrialsToShippedBatch implements Database.Batchable<sObject> {

    global String q;
 
    global UpdateCustomerTrialsToShippedBatch() {    
        
        q = 'SELECT Id FROM Trial__c Where (NOT Status__c In(\'SHIPPED\',\'C-SUCCESS\',\'C-FAILURE\',\'C-INCONCLUSIVE\',\'REJECTED\')) And Order_Ship_Date__c != Null';
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (Trial__c t : (List<Trial__c>)scope) {
            UpdateCustomerTrialsToShipped uctts = new UpdateCustomerTrialsToShipped();
            uctts.updateMe(t.id);
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
                mail.setSubject('UpdateCustomerTrialsToShippedBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }

    }

}