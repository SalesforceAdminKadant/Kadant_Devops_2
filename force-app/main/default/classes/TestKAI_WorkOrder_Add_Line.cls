@isTest(SeeAllData=true)
public class TestKAI_WorkOrder_Add_Line
{
    @IsTest(SeeAllData=true)
    static void test1() {

        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        Asset asst = new Asset(
            Name = 'Test Asset',
            SerialNumber = '123456',
            Division__c = 'KPGBR',
            AccountId = account.Id,
            ContactId = contact.Id,
            Status = 'Idle'
        );
        insert asst;

        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE Name = 'Paal Price Book' AND IsActive = true LIMIT 1];

        WorkOrder wo = new WorkOrder(
            account = account,
            Division__c = 'KPGBR',
            contact = contact,
            AssetId = asst.Id,
            CurrencyIsoCode = 'GBP',
            Pricebook2Id = pb.Id
        );
        insert wo;

        Test.startTest();
        String notOkay = KAI_WorkOrder_Add_Line.IsAssetShipToOk(wo.Id);
        Assert.areEqual('true', notOkay);
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    static void test2() {
        Account account = new Account(
            Name = 'Test Account RRS',
            AccountNumber = '123456789'
        );
        insert account;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        Account account2 = new Account(
            Name = 'Test Account RRS2',
            ParentId = account.Id,
            AccountNumber = '9874561'
        );
        insert account2;

        Contact contact2 = new Contact(
                FirstName = 'Test',
                LastName = 'Contact2',
                Employment_Status__c=null,
                AccountId = account2.Id
        );
        insert contact2;

        Asset asst = new Asset(
            Name = 'Test Asset',
            SerialNumber = '123456',
            Division__c = 'KPGBR',
            AccountId = account.Id,
            Billing_Account__c = account2.Id,
            ContactId = contact2.Id,
            Status = 'Idle'
        );
        insert asst;

        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE Name = 'Paal Price Book' AND IsActive = true LIMIT 1];

        WorkOrder wo = new WorkOrder(
            account = account,
            Division__c = 'KPGBR',
            contact = contact,
            AssetId = asst.Id,
            CurrencyIsoCode = 'GBP',
            Pricebook2Id = pb.Id
        );
        insert wo;

        Test.startTest();
        String okay = KAI_WorkOrder_Add_Line.IsAssetShipToOk(wo.Id);
        Assert.areEqual('false', okay);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void test3() {
        Account account = new Account(
            Name = 'Test Account RRS',
            AccountNumber = '1234567'
        );
        insert account;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        Asset asst = new Asset(
            Name = 'Test Asset',
            SerialNumber = '123456',
            Division__c = 'KPGBR',
            AccountId = account.Id,
            ContactId = contact.Id,
            Status = 'Idle'
        );
        insert asst;

        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE Name = 'Paal Price Book' AND IsActive = true LIMIT 1];

        WorkOrder wo = new WorkOrder(
            account = account,
            Division__c = 'KPGBR',
            contact = contact,
            AssetId = asst.Id,
            CurrencyIsoCode = 'GBP',
            Pricebook2Id = pb.Id
        );
        insert wo;

        Product2 prod = [SELECT Id, Name, Description FROM Product2 Where Name like 'SV-RM-%' AND Location__c = 'KPGBR' AND IsActive = true LIMIT 1];
        PricebookEntry pbe = [SELECT Id FROM PriceBookEntry WHERE product2.Id =:prod.Id AND IsActive = true AND CurrencyIsoCode = 'GBP' AND Pricebook2Id = :pb.Id LIMIT 1];

        WorkOrderLineItem woline = new WorkOrderLineItem(
            WorkOrderId = wo.Id,
            PriceBookEntryID = pbe.Id,
            Quantity = 2,
            UnitPrice = 12.50, 
            Discount = 0, 
            Description = prod.description            
        );       
        insert woline;  

        Map<String,String> SelectedPartMap = New Map<String,String>{'e'=>'f', 'g'=> 'h'};         
        Map<String,String> SelectedPartMapQty2 = New Map<String,String>{ prod.Id =>'1'};

        Test.startTest();
        KAI_WorkOrder_Add_Line.searchForRates(wo.Id, 'WorkOrder', wo.Division__c, asst.Id, wo.CurrencyIsoCode, pb.id, 'SV-RM-', '', SelectedPartMap);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void test4() {
        
        WorkType wt = [Select Id From WorkType Where Name = 'Reactive Maintenance' And RecordType.Name ='KPG Work Type' LIMIT 1];
        WorkOrder wo = [Select Id, Division__c, AssetId, CurrencyIsoCode, Pricebook2Id From WorkOrder Where Division__c = 'KPGBR' And WorkTypeId = :wt.Id LIMIT 1];
        
        Product2 prod = [SELECT Id, Name, Description FROM Product2 Where Name like 'SV-RM-%' AND Location__c = 'KPGBR' AND IsActive = true LIMIT 1];

        Map<String,String> SelectedPartMap = New Map<String,String>{'e'=>'f', 'g'=> 'h'};         
        Map<String,String> SelectedPartMapQty2 = New Map<String,String>{ prod.Id =>'1'};

        Test.startTest();
        KAI_WorkOrder_Add_Line.searchForRates(wo.Id, 'WorkOrder', wo.Division__c, wo.AssetId, wo.CurrencyIsoCode, wo.Pricebook2Id, '', 'SERVCONS', SelectedPartMap);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void test5() {
        
        WorkType wt = [Select Id From WorkType Where Name = 'Reactive Maintenance' And RecordType.Name ='KPG Work Type' LIMIT 1];
        WorkOrder wo = [Select Id, Division__c, AssetId, CurrencyIsoCode, Pricebook2Id From WorkOrder Where Division__c = 'KPGBR' And WorkTypeId = :wt.Id LIMIT 1];

        Product2 prod = [SELECT Id, Name, Description FROM Product2 Where Name like 'SV-RM-%' AND Location__c = 'KPGBR' AND IsActive = true LIMIT 1];

        Map<String,String> SelectedPartMap = New Map<String,String>{'e'=>'f', 'g'=> 'h'};         
        Map<String,String> SelectedPartMapQty2 = New Map<String,String>{ prod.Id =>'1'};

        Test.startTest();
        KAI_WorkOrder_Add_Line.searchForRates(wo.Id, 'WorkOrder', wo.Division__c, wo.AssetId, wo.CurrencyIsoCode, wo.Pricebook2Id, '', 'HISTORY', SelectedPartMap);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void test6() {

        WorkType wt = [Select Id From WorkType Where Name = 'Reactive Maintenance' And RecordType.Name ='KPG Work Type' LIMIT 1];
        WorkOrder wo = [Select Id, AccountId, Division__c, AssetId, CurrencyIsoCode, Pricebook2Id From WorkOrder Where Division__c = 'KPGBR' And WorkTypeId = :wt.Id LIMIT 1];

        Product2 prod = [SELECT Id, Name, Description FROM Product2 Where Name like 'SV-RM-%' AND Location__c = 'KPGBR' AND IsActive = true LIMIT 1];
        List<PriceBookEntry> pb = [select id from pricebookentry where pricebook2id = :wo.Pricebook2Id and currencyisocode = :wo.CurrencyIsoCode and product2id = :prod.Id];  
        String woPbeID = pb[0].id;
        Map<String,String> SelectedPartMapQty2 = New Map<String,String>{ prod.Id =>'1'};
        Map<String,String> SelectedPartMap2 = New Map<String,String>{ woPbeID => prod.Name };

        Test.startTest();
        KAI_WorkOrder_Add_Line.GetProductPricing(wo.Id, 'WorkOrder', SelectedPartMap2, SelectedPartMapQty2, wo.Pricebook2Id, wo.CurrencyIsoCode, wo.accountId);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void test7() {

        WorkType wt = [Select Id From WorkType Where Name = 'Reactive Maintenance' And RecordType.Name ='KPG Work Type' LIMIT 1];
        WorkOrder wo = [Select Id, AccountId, Division__c, AssetId, CurrencyIsoCode, Pricebook2Id From WorkOrder Where Division__c = 'KPGBR' And WorkTypeId = :wt.Id LIMIT 1];

        Product2 prod = [SELECT Id, Name, Description FROM Product2 Where Name like 'SV-RM-%' AND Location__c = 'KPGBR' AND IsActive = true LIMIT 1];
        List<PriceBookEntry> pb = [select id from pricebookentry where pricebook2id = :wo.Pricebook2Id and currencyisocode = :wo.CurrencyIsoCode and product2id = :prod.Id];  
        String woPbeID = pb[0].id;
        Map<String,String> SelectedPartMapQty2 = New Map<String,String>{ prod.Id =>'1'};
        Map<String,String> SelectedPartMap2 = New Map<String,String>{ woPbeID => prod.Name };

        Test.startTest();
        KAI_WorkOrder_Add_Line.AddWOLines(wo.Id, SelectedPartMap2, '[{"value":"4","key":"qty'+prod.Id+'"}]','[{"value":"500","key":"up'+prod.Id+'"}]','[{"value":"10","key":"disc'+prod.Id+'"}]','[{"value":"test","key":"spec'+prod.Id+'"}]');
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void test8() {
    
    WorkType wt = [Select Id From WorkType Where Name = 'Reactive Maintenance' And RecordType.Name ='KPG Work Type' LIMIT 1];
        WorkOrder wo = [Select Id, AccountId, Division__c, AssetId, CurrencyIsoCode, Pricebook2Id From WorkOrder Where Division__c = 'KPGBR' And WorkTypeId = :wt.Id LIMIT 1];

        Product2 prod = [SELECT Id, Name, Description FROM Product2 Where Name like 'SV-RM-%' AND Location__c = 'KPGBR' AND IsActive = true LIMIT 1];
        List<PriceBookEntry> pb = [select id from pricebookentry where pricebook2id = :wo.Pricebook2Id and currencyisocode = :wo.CurrencyIsoCode and product2id = :prod.Id];  
        String woPbeID = pb[0].id;
        
        Test.startTest();
        KAI_WorkOrder_Add_Line.ProductOnHoldOrRunOut(woPbeID);
        Test.stopTest();
    }
}