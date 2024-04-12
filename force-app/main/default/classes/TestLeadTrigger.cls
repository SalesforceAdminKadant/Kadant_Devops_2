@isTest
public without sharing class TestLeadTrigger 
{
    static testMethod void testLead()
    {

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());
        Lead reg = new Lead(FirstName = 'Test',LastName = 'User',Status = 'Undetermined',Company = 'Test Company', Division__c = 'KJE', IsConverted=false, Country_ID__c = 'BE', OwnerId = '0056000000585j3AAA');
        insert reg;
        Task tsk = new Task(WhoId = reg.Id, Subject = 'Lead Follow-up', Status = 'Not Started', OwnerId = reg.OwnerId);
        insert tsk;
        List<Lead> updlead = [SELECT ID, ownerId from lead where FirstName = 'Test' and LastName = 'User' and Status = 'Undetermined' and Company = 'Test Company' and Division__c = 'KJE' and IsConverted=false and Country_ID__c = 'BE' ];
        for(Lead upd: updlead){
            upd.OwnerId = '005600000056iHrAAI';
        }
        update updlead;
    }
}