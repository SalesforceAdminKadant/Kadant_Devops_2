global class UpdateSalesBudgetsBatch implements Database.Batchable<sObject> {

    global String strYear;
    global String q;
 
    global UpdateSalesBudgetsBatch(String strYearParm) {    
        
        if(strYearParm == Null)
        {
            Date todaysDate = date.today();
            Integer currentYearInt = date.today().year();
            strYear = String.valueOf(currentYearInt);
            if (todaysdate.Month() >= 9){
                currentYearInt = currentYearInt +1;
                strYear = String.valueOf(currentYearInt);
            }           
        }else{
            strYear = strYearParm;
        }

        q = 'SELECT Id FROM sales_budget__c Where Year__c = \'' + strYear + '\' and id in (select sales_budget__c from account_sales_targets__c)';
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        if(scope.size()>0){
            for (Sales_Budget__c a : (List<Sales_Budget__c>)scope) {
                UpdateSalesBudgets usbs = new UpdateSalesBudgets();
                usbs.updateCurrent(a.id, strYear);
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
                mail.setSubject('UpdateSalesBudgetsBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
        
    }

}