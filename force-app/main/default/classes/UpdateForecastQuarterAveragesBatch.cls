global class UpdateForecastQuarterAveragesBatch implements Database.Batchable<sObject> {

    string q;
    List<User> users;
    string strQuarterYear;
    integer intQuarter;
    string strYear;
    integer intYear1;
    integer intYear2;
    date startDate1;
    date endDate1;
    date startDate2;
    date endDate2;
    
    global UpdateForecastQuarterAveragesBatch(integer intParmQuarter, string strParmYear, string strParmQuarterYear) {
    
        intQuarter = intParmQuarter;
        strYear = strParmYear;
        intYear1 = integer.valueOf(strParmYear) - 1;
        intYear2 = integer.valueOf(strParmYear) - 2;
        strQuarterYear = strParmQuarterYear;
        
        Period curt = [
            SELECT p.StartDate, p.EndDate 
            FROM Period p
            WHERE Type = 'Quarter' AND CALENDAR_YEAR(p.StartDate) = :intYear1 And p.Number = :intParmQuarter LIMIT 1];
            startDate1 = curt.StartDate;
            endDate1 = curt.EndDate;

        curt = [
            SELECT p.StartDate, p.EndDate 
            FROM Period p
            WHERE Type = 'Quarter' AND CALENDAR_YEAR(p.StartDate) = :intYear2 And p.Number = :intParmQuarter LIMIT 1];
            startDate2 = curt.StartDate;
            endDate2 = curt.EndDate;
                    
        users = [select Id from User where Quartely_Forecasting__c = true and IsActive = true];

        q = 'SELECT Id FROM Forecast_Item__c WHERE Forecast__r.Name = \'' + strQuarterYear + '\' AND Forecast__r.OwnerId IN :users';
        
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (Forecast_Item__c f : (List<Forecast_Item__c>)scope) {
            UpdateForecastQuarterAverages u = new UpdateForecastQuarterAverages();
            u.updateMe(f.Id, startDate1, endDate1, startDate2, endDate2);
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
            if(a.NumberOfErrors != 0)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateForecastQuarterAveragesBatch status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
    }
}