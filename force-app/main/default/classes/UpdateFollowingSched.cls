global class UpdateFollowingSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        UpdateFollowingBatch uf = new UpdateFollowingBatch(null);
        database.executebatch(uf, 50);

   }

}