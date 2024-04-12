global class UpdatePricebookEntryCurrencySched implements Schedulable {

   global void execute(SchedulableContext SC) {

      UpdatePricebookEntryCurrencyBatch u = new UpdatePricebookEntrycurrencyBatch();
      database.executebatch(u, 100);

   }

}