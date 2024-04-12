@isTest(SeeAllData=true)
public class TestCloneQuoteLineItemsBatch {

    static testMethod void TestCloneQuoteLineItemsProcess() {


        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        QuoteLineItem qli = [Select QuoteId From QuoteLineItem LIMIT 1];
        
        Quote qt = [Select Id, OpportunityId, Pricebook2Id From Quote Where Id = :qli.QuoteId LIMIT 1];

        Opportunity objOpp = [select Id from Opportunity Where Id = :qt.OpportunityID LIMIT 1];

        Quote q = new Quote(Name='TestQuote', Status='Draft', OpportunityId=objOpp.Id, Pricebook2Id=qt.Pricebook2Id, Quote_Created_From__c = qt.Id);
        
        insert q;
        
        CloneQuoteLineItemsBatch cqli = new CloneQuoteLineItemsBatch(qt.Id, q.Id);
        Database.executebatch(cqli);

        Test.stopTest();
    }
    
}