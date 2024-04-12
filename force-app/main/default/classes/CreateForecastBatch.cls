global class CreateForecastBatch{
    
    global void main() {

        integer intCurrentQuarter;
        integer intCurrentYear;
        
        //Update custom settings for current and previous forecasting quarters
        kadant_settings__c ks = [select current_forecasting_quarter__c, previous_forecasting_quarter__c from kadant_settings__c LIMIT 1];
        ks.previous_forecasting_quarter__c = ks.current_forecasting_quarter__c;
        intCurrentQuarter = integer.valueOf(ks.current_forecasting_quarter__c.substring(1,2));
        intCurrentYear = integer.valueOf(ks.current_forecasting_quarter__c.substring(3));
        if(intCurrentQuarter == 4)
        {
            ks.current_forecasting_quarter__c = 'Q1 ' + string.valueOf(intCurrentYear + 1);
        }
        else
        {
            ks.current_forecasting_quarter__c = 'Q' + string.valueOf(intCurrentQuarter + 1) + ' ' + string.valueOf(intCurrentYear);
        }
        update(ks);
        
        CreateForecast.main(null, intCurrentQuarter);
            
        UpdateForecastSched ufs = new UpdateForecastSched();
        ufs.execute(null) ;
        
        try
        {
             // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
             //AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                 //TotalJobItems, CreatedBy.Email, ExtendedStatus  
                 //from AsyncApexJob where Id = :bc.getJobId()];  
   
             // Email the Batch Job's submitter that the Job is finished.  
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
             String[] toAddresses = new String[] {'salesforce.admin@kadant.com'};  
             mail.setToAddresses(toAddresses);  
             mail.setSubject('CreateForecastBatch completed');  
             mail.setPlainTextBody('The CreateForecastBatch job completed successfully.');  
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          

        }
        catch(Exception e)
        {
        }
        
    }
}