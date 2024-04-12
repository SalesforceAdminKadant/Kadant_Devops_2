global class UpdateSalesBudgetsActualsSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        String currentYear = string.valueOf(date.today().year()); 

        UpdateSalesBudgetsActualsBatch sbs = new UpdateSalesBudgetsActualsBatch(currentYear);
        database.executebatch(sbs, 5);

   }

}