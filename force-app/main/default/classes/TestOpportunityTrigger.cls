@isTest(SeeAllData=true)
public with sharing class TestOpportunityTrigger
{
    static testMethod void testOpportunity()
    {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());
        
        Account objAccount = new Account(Name='Test Account');
        insert objAccount;
        
        Opportunity objOpportunity1 = new Opportunity(Name='Opportunity1',
                                                      AccountId = objAccount.Id,
                                                      StageName ='Quote Issued - 25%',
                                                      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('KCC, KJI & KSD Quotes').getRecordTypeId(),
                                                      CloseDate = Date.today(),
                                                      Kadant_Receives_Probability_Picklist__c = '25%',
                                                      Management_Info__c = 'a5z0z000001VPNuAAO',
                                                      Quote_Number__c = 'TestQuote123');
        insert objOpportunity1;
        objOpportunity1 = [SELECT Id,StageName,Order_Active_Quote_Inactive_Quote__c FROM Opportunity WHERE Id = :objOpportunity1.Id];
        System.assertEquals('Active',objOpportunity1.Order_Active_Quote_Inactive_Quote__c);

        objOpportunity1 = [SELECT Id,StageName,Order_Active_Quote_Inactive_Quote__c FROM Opportunity WHERE Id = :objOpportunity1.Id];
        
        //System.assertEquals('Quote Issued - 25%',objOpportunity1.StageName);
        //System.assertEquals('Inactive',objOpportunity1.Order_Active_Quote_Inactive_Quote__c);
        
        Opportunity objOpportunity3 = new Opportunity(Name='Opportunity3',
                                                      AccountId = objAccount.Id,
                                                      StageName = 'Closed-Won - 100%',
                                                      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('KL Fiberline Aftermarket').getRecordTypeId(),
                                                      CloseDate = Date.today(),
                                                      Amount = 15000,
                                                      Expiration_Date__c = Date.today() + 30,
                                                      Kadant_Receives_Probability_Picklist__c = '100%',
                                                      KWS_Quote_Number__c = '4');
                                          
        insert objOpportunity3;
        
        objOpportunity1.StageName ='Quote Issued - 25%';
        update objOpportunity1;

        objOpportunity3.KWS_Quote_Number__c = 'TestQuote123';
        update objOpportunity3;
        
        objOpportunity1 = [SELECT Id,StageName,Order_Active_Quote_Inactive_Quote__c FROM Opportunity WHERE Id = :objOpportunity1.Id];
        objOpportunity3 = [SELECT Id,StageName,Order_Active_Quote_Inactive_Quote__c FROM Opportunity WHERE Id = :objOpportunity3.Id];
        
        System.assertEquals(objOpportunity3.StageName, 'Closed-Won - 100%');

        objOpportunity3.StageName = 'Closed-Lost - 0%';
        objOpportunity3.Reason__c = 'Don\'t Know';
        objOpportunity3.Competitor__c = 'Don\'t Know';
        update objOpportunity3;
        
        KadantHelperClasses.reuploadOpportunity(objOpportunity3.Id);

        Account_Division__c[] ad = [Select Id, Account__c From Account_Division__c Where Agent__c != null Limit 1];
        if(ad.size() > 0)
        {
            Opportunity objOpportunity4 = new Opportunity(Name='Opportunity4',
                                                      AccountId = ad[0].Account__c,
                                                      StageName = '25%',
                                                      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('KCC, KJI & KSD Quotes').getRecordTypeId(),
                                                      CloseDate = Date.today(),
                                                      Kadant_Receives_Probability_Picklist__c = '25%',
                                                      KWS_Quote_Number__c = '4',
                                                      Quote_Number__c = '4',
                                                      Description_hidden__c = 'ABC',
                                                      Description = null,
                                                      Close_Date_Quarter__c = 'Q1',
                                                      Sales_Office__c = 'KSD',
                                                      Type = 'KSD Opportunity');
                                          
            insert objOpportunity4;
            objOpportunity4.CloseDate = Date.today().AddDays(1);
            update objOpportunity4;
            delete objOpportunity4;
        }

        
    }
}