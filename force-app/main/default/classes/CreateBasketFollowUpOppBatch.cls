global class CreateBasketFollowUpOppBatch implements Database.Batchable<sObject> {

    global String strtDate;
    global String q;
 
    global CreateBasketFollowUpOppBatch(String strtDate) {    

        q = 'select id from account where recordtypeid = \'0120z000000UOouAAG\' and strategex_rank__c IN(\'W\', \'RF\', \'TS\', \'A\') and id in (select accountid from order where last_ship_date__c > ' + strtDate +  ')';
        
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        if(scope.size()>0){
        	for (Account a : (List<Account>)scope) {
            	CreateBasketFollowUpOpp cbfts = new CreateBasketFollowUpOpp();
            	cbfts.createOpps(a.id, strtDate);
        	}
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
                mail.setSubject('CreateBasketFollowUpOppBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
        
    }

}