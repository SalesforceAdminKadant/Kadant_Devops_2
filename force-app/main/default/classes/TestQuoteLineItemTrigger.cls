@isTest(SeeAllData=True)
public without sharing class TestQuoteLineItemTrigger 
{
    static testMethod void testQuoteLineItem()
    {

        QuoteLineItem qli2 = [select Id, QuoteId, Product2Id, Quote.Language__c, Quote.Pricebook2Id from QuoteLineItem Where Quote.Pricebook2.Name = 'Kadant Europe Price Book' And Product2.IsActive = True And Quote.Pricebook2.IsActive = True LIMIT 1];

        Quote q = [select Id, CurrencyISOCode from Quote Where Id = :qli2.QuoteId LIMIT 1];
        
        PricebookEntry objPBE = [select Id, Product2Id from PricebookEntry Where Pricebook2Id = :qli2.Quote.Pricebook2Id And Product2.IsActive = True And CurrencyIsoCode = :q.CurrencyIsoCode And IsActive = True LIMIT 1];

        QuoteLineItem qli1 = new QuoteLineItem(QuoteId=qli2.QuoteId, Quantity=1, PricebookEntryId=objPBE.Id, UnitPrice = 1.00, Product2Id = qli2.Product2Id);
        insert qli1;
        
    }
}