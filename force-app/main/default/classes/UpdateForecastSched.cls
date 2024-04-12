global class UpdateForecastSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        kadant_settings__c ks = [select current_forecasting_quarter__c, previous_forecasting_quarter__c from kadant_settings__c LIMIT 1];

        UpdateForecastBatch u = new UpdateForecastBatch(ks.current_forecasting_quarter__c);
        database.executebatch(u, 1);

   }

}