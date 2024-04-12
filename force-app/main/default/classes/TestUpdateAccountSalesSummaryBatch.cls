@isTest
public class TestUpdateAccountSalesSummaryBatch {

    static testMethod void TestASSBatchProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        UpdateAccountSalesSummaryBatch ass = new UpdateAccountSalesSummaryBatch(null);
        Database.executebatch(ass);

        Test.stopTest();
    }
    
}