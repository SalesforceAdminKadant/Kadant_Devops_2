@isTest
public class TestUpdateWhiteSpaceActualsBatch {

    static testMethod void TestWSABatchProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        UpdateWhiteSpaceActualsBatch wsa = new UpdateWhiteSpaceActualsBatch();
        Database.executebatch(wsa);

        Test.stopTest();
    }
    
}