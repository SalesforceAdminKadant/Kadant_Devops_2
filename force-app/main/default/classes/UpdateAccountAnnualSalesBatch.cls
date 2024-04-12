global class UpdateAccountAnnualSalesBatch implements Database.Batchable<sObject> {

    global Date startDate;
    global Date endDate;
    global String strYear;
    global String q;
    global Boolean boolRunAccountSalesSummary;
    global Boolean boolUpdatePreviousYTD;
    global Boolean boolGlobalSendCompletionMessage;
 
    global UpdateAccountAnnualSalesBatch(String strYearParm, Boolean boolUpdatePrevYTD, Boolean boolRunASS, Boolean boolSendCompletionMessage) {    
        
        boolRunAccountSalesSummary = boolRunASS;
        boolUpdatePreviousYTD= boolUpdatePrevYTD;
        boolGlobalSendCompletionMessage = boolSendCompletionMessage;

        //date d = Date.Today().addYears(-9);

        FiscalYearSettings fys;
        
        if(strYearParm != Null)
        {
            fys = [Select Name, StartDate, EndDate From FiscalYearSettings where Name = :strYearParm LIMIT 1];
            endDate = fys.EndDate;
        }else{
            fys = [Select Name, StartDate, EndDate From FiscalYearSettings where StartDate <= :Date.Today() and EndDate >= :Date.Today() LIMIT 1];
            endDate = Date.Today();
        }

        startDate = fys.StartDate;
        strYear = fys.Name;

        //q = 'SELECT Id FROM Account Where Id = \'0010z00001RFxe9AAD\'';
        q = 'SELECT Id FROM Account';
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (Account a : (List<Account>)scope) {
            UpdateAccountAnnualSales uaas = new UpdateAccountAnnualSales();
            uaas.updateCurrent(a.id, startDate, endDate, strYear, boolUpdatePreviousYTD);
        }
    }
    
    global void finish(Database.BatchableContext bc) {

        //defer stuff
        //System.Queueable job = new DeferredHandler('UpdateSalesSummary');
        //System.enqueueJob(job);
                
        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                from AsyncApexJob where Id = :bc.getJobId()];  
   
            // Email the Batch Job's submitter that the Job is finished.
            if(a.NumberOfErrors > 0 || boolGlobalSendCompletionMessage == true)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateAccountAnnualSalesBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
        
        if(boolRunAccountSalesSummary == true)
        {
            UpdateAccountSalesSummaryBatch ass = new UpdateAccountSalesSummaryBatch(null);
            database.executebatch(ass, 2);
        }

    }

}