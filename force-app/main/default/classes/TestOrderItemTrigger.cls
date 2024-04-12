@isTest
public with sharing class TestOrderItemTrigger
{
    static testMethod void testOrderItem()
    {

        Account objAccount = new Account(Name='Test Account');
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
        
        Order opp = new Order(AccountId = objAccount.Id, Name = 'Test Syndicated 2010', Pricebook2Id = pricebookId, Division__c = 'KSD', Status = 'Open', Type = 'Syndicated - New', EffectiveDate = system.today(), EndDate = system.today());
        insert opp;

        OrderItem oli = new OrderItem(OrderId = opp.Id, Line_No__c = 1, pricebookentryId = standardPBE.Id, Product2Id = prod.Id, Quantity = 1, UnitPrice = 7500, Description = '2007 CMR #4 - Anti-Infectives');
        insert oli;

        List<OrderItem> olis = [Select Id From OrderItem Where OrderId =: opp.Id];
        update olis[0];

    }
}