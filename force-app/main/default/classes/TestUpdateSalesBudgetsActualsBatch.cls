@isTest(SeeAllData=true)
public class TestUpdateSalesBudgetsActualsBatch {

    static testMethod void TestUpdateSalesBudgetsActualsProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        UpdateSalesBudgetsActualsBatch sbs = new UpdateSalesBudgetsActualsBatch('2020');
        database.executebatch(sbs, 5);

        Test.stopTest();
    }
    
}