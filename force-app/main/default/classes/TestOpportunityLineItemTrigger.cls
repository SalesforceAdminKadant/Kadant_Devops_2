@isTest(SeeAllData=true)
public with sharing class TestOpportunityLineItemTrigger
{
    static testMethod void testOpportunityLineItem()
    {
        Account objAccount = new Account(Name='Test Account', BillingCity ='test', BillingPostalCode ='73337');
        insert objAccount;
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
        insert pb;
        
        Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
        insert prod;
        
        // First insert a price for the standard price book
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
    
        Opportunity opp = new Opportunity(AccountId = objAccount.Id, Pricebook2Id = pb.Id, Name = 'Test Syndicated 2010', Type = 'Syndicated - New', StageName = 'Planning', CloseDate = system.today());
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(opportunityId = opp.Id, pricebookentryId = pbe.Id, Quantity = 1, UnitPrice = 7500, Description = '2007 CMR #4 - Anti-Infectives');
        insert oli;

        List<OpportunityLineItem> olis = [Select Id From OpportunityLineItem Where OpportunityId =: opp.Id];
        update olis[0];

    }
}