global class UpdatePriceAgreementDetailSched implements Schedulable {

   global void execute(SchedulableContext SC) {

      UpdatePriceAgreementDetailBatch u = new UpdatePriceAgreementDetailBatch(null);
      database.executebatch(u, 10);

   }

}