global class UpdateFollowingBatch implements Database.Batchable<sObject> {

    global String q;
    global Boolean boolDeleteUserFollows = false;
 
    global UpdateFollowingBatch(String strUserID) {    

        q = 'SELECT Id FROM User Where IsActive = true And UserType = \'Standard\' And Profile.UserLicense.Name In (\'Salesforce\', \'Salesforce Platform\')';

        if(strUserID != null)
        {
            q += ' ' + 'And Id = \'' + strUserID + '\'';
            boolDeleteUserFollows = true;
        }

        if(Test.isRunningTest())
        {
            Follow__c[] f = [Select OwnerId From Follow__c LIMIT 1];
            q += ' ' + 'And Id = \'' + f[0].OwnerId + '\' LIMIT 1';
        }

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (User u : (List<User>)scope) {
            UpdateFollowing uf = new UpdateFollowing();
            uf.updateMe(u.Id, boolDeleteUserFollows);
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
            if(a.NumberOfErrors > 0 || Test.isRunningTest())
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateFollowingBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }

        }
        catch(Exception e)
        {
        }
    }

}