global class CloneQuoteLineItemsBatch implements Database.Batchable<sObject> {

    global String q;
    global String strGlobalToQuoteID;
 
    global CloneQuoteLineItemsBatch(String strFromQuoteID, String strToQuoteID) {    

        strGlobalToQuoteID = strToQuoteID;
        
        q = 'SELECT Id FROM QuoteLineItem Where QuoteId = \'' + strFromQuoteID + '\' order by Line_No__c, LineNumber';

        if(Test.isRunningTest())
        {
            q += ' ' + 'LIMIT 1';
        }

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (QuoteLineItem ql : (List<QuoteLineItem>)scope) {
            CloneQuoteLineItems cqli = new CloneQuoteLineItems();
            cqli.updateMe(ql.Id, strGlobalToQuoteID);
        }
    }
    
    global void finish(Database.BatchableContext bc) {

        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                from AsyncApexJob where Id = :bc.getJobId()];  
   
            // Email that the job ended with errors.
            if(a.NumberOfErrors > 0 || Test.isRunningTest())
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'salesforce.admin@kadant.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('CloneQuoteLineItemsBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }

        }
        catch(Exception e)
        {
        }
    }

}