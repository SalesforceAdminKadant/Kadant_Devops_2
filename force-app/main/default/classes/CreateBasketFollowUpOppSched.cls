global class CreateBasketFollowUpOppSched implements Schedulable {

   global void execute(SchedulableContext SC) {

        String startDate = string.valueOf(date.today().addDays(-187)); 

        CreateBasketFollowUpOppBatch cftb = new CreateBasketFollowUpOppBatch(startDate);
        database.executebatch(cftb, 5);

   }

}