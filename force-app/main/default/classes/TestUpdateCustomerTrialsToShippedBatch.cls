@isTest
public class TestUpdateCustomerTrialsToShippedBatch {

    static testMethod void TestUCTTSBatchProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        UpdateCustomerTrialsToShippedBatch uctts = new UpdateCustomerTrialsToShippedBatch();
        Database.executebatch(uctts);

        Test.stopTest();
    }
    
}