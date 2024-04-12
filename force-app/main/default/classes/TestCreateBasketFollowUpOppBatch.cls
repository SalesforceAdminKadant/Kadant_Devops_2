@isTest(SeeAllData=true)
public class TestCreateBasketFollowUpOppBatch {

    static testMethod void TestCreateBasketFollowUpOppBatchProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        CreateBasketFollowUpOppBatch cftb = new CreateBasketFollowUpOppBatch('2020-12-31');
        database.executebatch(cftb, 5);

        Test.stopTest();
    }
    
}