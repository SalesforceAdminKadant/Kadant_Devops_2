global class UpdateSalesBudgetsSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        Date todaysDate = date.today();
        Integer currentYearInt = date.today().year();
        String strYear = String.valueOf(currentYearInt);
        if (todaysdate.Month() >= 9)
            currentYearInt = currentYearInt +1;
        else           
            currentYearInt = currentYearInt;

        strYear = String.valueOf(currentYearInt);

        //Kadant_Settings__c ks = Kadant_Settings__c.getOrgDefaults();

        //UpdateSalesBudgetsBatch sbs = new UpdateSalesBudgetsBatch(ks.Sales_Budget_Year__c);
        
        UpdateSalesBudgetsBatch sbs = new UpdateSalesBudgetsBatch(strYear);
        database.executebatch(sbs, 5);

   }

}