@isTest(SeeAllData=True)
public without sharing class TestQuoteTrigger 
{
    static testMethod void testQuote()
    {

        Opportunity objOpp = [select Id from Opportunity LIMIT 1];

        Quote q = new Quote(Name='TestQuote', Status='Draft', OpportunityId=objOpp.Id, Incoterms__c='EXW');
        insert q;
        
    }
}