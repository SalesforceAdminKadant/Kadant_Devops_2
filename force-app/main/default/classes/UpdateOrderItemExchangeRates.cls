global class UpdateOrderItemExchangeRates implements Schedulable,Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){

        String q = 'SELECT Id FROM OrderItem Where Incorrect_Exchange_Rate__c = True';

        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

        return Database.getQueryLocator(q);

    }

    global void execute(Database.BatchableContext BC, List<OrderItem> scope){
         for(OrderItem oi : scope){
             oi.Exchange_Rate_STE__c = null;            
         }
         if (scope.size() > 0)
             update scope;
    }   

    global void finish(Database.BatchableContext BC){
    
        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                from AsyncApexJob where Id = :bc.getJobId()];  
   
            // Email the Batch Job's submitter that the Job is finished.
            if(a.NumberOfErrors > 0 || a.JobItemsProcessed > 0)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String[] toAddresses = new String[] {a.CreatedBy.Email};
                String[] toAddresses = new String[] {'david.leland@kadant.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateOrderItemExchangeRates status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures and ' + a.JobItemsProcessed + ' successes. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
    }

    global void execute(SchedulableContext SC) {
      Database.executeBatch(new UpdateOrderItemExchangeRates(),10);

   }

}