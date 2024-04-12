global class UpdateWhiteSpaceActualsSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        UpdateWhiteSpaceActualsBatch uws = new UpdateWhiteSpaceActualsBatch();
        database.executebatch(uws, 25);

   }

}