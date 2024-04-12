@IsTest(SeeAllData=true)
public class BomControllerTest {
    @IsTest(SeeAllData=true)
    static void getAssetBomData() {
        Account account = new Account(
            Name = 'Test Asset Account'
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
            AccountId = account.Id,
            ContactId = contact.Id,
            Name = 'Test Asset 1',
            CurrencyIsoCode = 'USD',
            Division__c = 'KSD'
        );
        insert asst;

        Test.startTest();
        String rs1 = BomController.getAssetBomData(asst.Id);
        Test.stopTest();
    }

    
    static void getBomData() {        
        Product2 prod1 = new Product2(
            Name = 'Test Parent Product',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod1;
        Product2 prod2 = new Product2(
            Name = 'Test Child Product',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod2;
        Product2 prod3 = new Product2(
            Name = 'Test Grand Child',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod3;
        Product2 prod4 = new Product2(
            Name = 'Test GG Child',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod4;
        Product2 prod5 = new Product2(
            Name = 'Test GGG Child',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod5;
        Product2 prod6 = new Product2(
            Name = 'Test Add GG Child',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod6;
        Product2 prod7 = new Product2(
            Name = 'Test AddG Child',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod7;

        Bill_of_Material__c bom1 = new Bill_of_Material__c(
            Sequence__c = 10,
            Qty_Per__c = 1,
            Parent_Product__c = prod1.Id,
            Child_Product__c = prod2.Id
        );
        insert bom1;
        Bill_of_Material__c bom2 = new Bill_of_Material__c(
            Sequence__c = 10,
            Qty_Per__c = 1,
            Parent_Product__c = prod2.Id,
            Child_Product__c = prod3.Id
        );
        insert bom2;
        Bill_of_Material__c bom3 = new Bill_of_Material__c(
            Sequence__c = 10,
            Qty_Per__c = 1,
            Parent_Product__c = prod3.Id,
            Child_Product__c = prod4.Id
        );
        insert bom3;
        Bill_of_Material__c bom3a = new Bill_of_Material__c(
            Sequence__c = 20,
            Qty_Per__c = 1,
            Parent_Product__c = prod3.Id,
            Child_Product__c = prod6.Id
        );
        insert bom3a;
        Bill_of_Material__c bom4 = new Bill_of_Material__c(
            Sequence__c = 10,
            Qty_Per__c = 1,
            Parent_Product__c = prod4.Id,
            Child_Product__c = prod5.Id
        );
        insert bom4;
        Bill_of_Material__c bom4a = new Bill_of_Material__c(
            Sequence__c = 20,
            Qty_Per__c = 1,
            Parent_Product__c = prod4.Id,
            Child_Product__c = prod7.Id
        );
        insert bom4a;

        Test.startTest();
        String rs1 = BomController.GetBomData(prod1.Id);
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    static void getProduct() {        
        Product2 prod1 = new Product2(
            Name = 'Test Parent Product',
            Description = 'My Test',            
            CurrencyIsoCode = 'USD'
        );
        insert prod1;

        Test.startTest();
        Product2 rs1 = BomController.GetProduct(prod1.Id);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void getAssetsData() {
        Account parentAcct = new Account(
            Name = 'Test Parernt Asset Account 1'
        );
        insert parentAcct;
        Account account = new Account(
            Name = 'Test Asset Account 1',
            ParentId = parentAcct.Id
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
            AccountId = parentAcct.Id,
            ContactId = contact.Id,
            Name = 'Test Asset 2',
            CurrencyIsoCode = 'USD',
            Division__c = 'KSD'
        );
        insert asst;

        Test.startTest();
        List<Asset> rs1 = BomController.GetAssets(parentAcct.Id);
        Test.stopTest();
    }
}