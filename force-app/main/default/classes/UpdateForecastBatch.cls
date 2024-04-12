global class UpdateForecastBatch implements Database.Batchable<sObject> {
    string q;
    List<User> users;
    string strQuarterYear;
    integer intQuarter;
    string strYear;
    
    global UpdateForecastBatch(string strQuarterYearParm) {
    
        strQuarterYear = strQuarterYearParm;
        intQuarter = integer.valueOf(strQuarterYear.substring(1,2));
        strYear = strQuarterYear.substring(3);
        
        users = [select Id from User where Quartely_Forecasting__c = true and IsActive = true];

        q = 'SELECT Id, Account__c FROM Forecast__c WHERE Name = \'' + strQuarterYear + '\' AND OwnerId IN :users';
        
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (Forecast__c f : (List<Forecast__c>)scope) {
            UpdateForecast u = new UpdateForecast();
            u.updateForecast(f.Id);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                from AsyncApexJob where Id = :bc.getJobId()];  
   
            UpdateForecastQuarterAveragesBatch u = new UpdateForecastQuarterAveragesBatch(intQuarter, strYear, strQuarterYear);
            database.executebatch(u, 50);

            if(a.NumberOfErrors > 0)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateForecastBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
    }
}