global class UpdateAccountAnnualSalesSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        UpdateAccountAnnualSalesBatch aas = new UpdateAccountAnnualSalesBatch(null, true, true, false);
        database.executebatch(aas, 18);

   }

}