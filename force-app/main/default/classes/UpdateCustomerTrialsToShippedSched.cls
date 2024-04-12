global class UpdateCustomerTrialsToShippedSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        UpdateCustomerTrialsToShippedBatch uctts = new UpdateCustomerTrialsToShippedBatch();
        database.executebatch(uctts, 200);

   }

}