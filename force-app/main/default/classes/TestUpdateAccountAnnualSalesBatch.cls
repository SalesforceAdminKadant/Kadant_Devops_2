@isTest
public class TestUpdateAccountAnnualSalesBatch {

    static testMethod void TestAASBatchProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        UpdateAccountAnnualSalesBatch aas = new UpdateAccountAnnualSalesBatch(null, true, true, false);
        Database.executebatch(aas);

        Test.stopTest();
    }
    
}