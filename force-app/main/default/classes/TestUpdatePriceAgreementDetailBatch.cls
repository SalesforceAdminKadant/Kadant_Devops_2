@isTest
public class TestUpdatePriceAgreementDetailBatch {

    static testMethod void TestBatchProcess() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());
        UpdatePriceAgreementDetailBatch pad = new UpdatePriceAgreementDetailBatch(null);
        Database.executeBatch(pad);
        Test.stopTest();
    }
    
}