@isTest
public class TestUpdateOrderItemExchangeRate {

    static testMethod void TestBatch() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());
        UpdateOrderItemExchangeRates oier = new UpdateOrderItemExchangeRates();
        Database.executeBatch(oier);
        Test.stopTest();
    }
    
}