@isTest(SeeAllData=true)
public class PendingApprovalsControllerTest {
    static testMethod void testMethod1() 
    {
        List<ProcessInstance> pi = [SELECT Id, SubmittedById FROM ProcessInstance WHERE Status = 'Pending' LIMIT 1];
        string user_id = pi[0].SubmittedById;

        Test.startTest();
        List<PendingApprovalsController.wrapperClass> testList = PendingApprovalsController.getPendingApprovals(user_id);
        System.assertNotEquals(testList, null);
        Test.stopTest();
    }  
}