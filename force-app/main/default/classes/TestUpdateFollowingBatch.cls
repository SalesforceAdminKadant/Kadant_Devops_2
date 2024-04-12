@isTest(SeeAllData=true)
public class TestUpdateFollowingBatch {

    static testMethod void TestFollowingBatchProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        List<Id> listId = new List<Id>();
        Follow__c[] f = [Select OwnerId From Follow__c LIMIT 1];
        listId.Add(f[0].OwnerId);
        UpdateFollowsInvocable.deleteUserFollows(listId);
        //UpdateFollowingBatch uf= new UpdateFollowingBatch(f[0].OwnerId);
        //Database.executebatch(uf, 1);

        UpdateFollowingSched sh1 = new UpdateFollowingSched();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Update Following', sch, sh1); 

        Test.stopTest();
    }
    
}