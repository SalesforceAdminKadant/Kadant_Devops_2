@isTest(SeeAllData=true)
Private class TestQuoteAutoSync
{
    static testMethod void insertQuote()
    {
    
        Opportunity objOpp = [select Id from Opportunity Where SyncedQuoteId = Null LIMIT 1];

        Quote q = new Quote(Name='TestQuote', Status='Draft', OpportunityId=objOpp.Id, Incoterms__c='EXW');
        Test.startTest();
        insert q;
        Test.stopTest();
        
        //Opportunity o = [select SyncedQuoteId from Opportunity where Id=:objOpp.Id];
        //system.assert(o.SyncedQuoteId != null);
               
    }
}