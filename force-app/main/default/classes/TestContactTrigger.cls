@isTest
public without sharing class TestContactTrigger 
{
    static testMethod void testcontact()
    {

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());
        
        Account objAccount = new Account(Name='Test Account', Site='USA', ShippingCity=null, ShippingState= null);
        insert objAccount;

        Contact cnt = new Contact(FirstName = 'Test', LastName = 'Contact', Employment_Status__c=null, Account = objAccount);
        insert cnt;
        cnt = [select id, Employment_Status__c from Contact where FirstName = 'Test' and LastName = 'Contact' LIMIT 1];
        cnt.Employment_Status__c = 'Active';
        update cnt;
        cnt.Employment_Status__c = 'Inactive';
        update cnt;
        
    }
}