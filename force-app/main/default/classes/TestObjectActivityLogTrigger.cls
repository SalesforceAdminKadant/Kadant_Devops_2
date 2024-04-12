@isTest
public without sharing class TestObjectActivityLogTrigger 
{
    static testMethod void testLead()
    {

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        User u = [Select Id From User LIMIT 1];
        
        Object_Activity_Log__c oal = new Object_Activity_Log__c(Name = 'User', Division__c = 'KSD',
            Object_Id__c = u.Id, Operation__c = 'Insert', Processed__c = False);
        insert oal;
        
    }
}