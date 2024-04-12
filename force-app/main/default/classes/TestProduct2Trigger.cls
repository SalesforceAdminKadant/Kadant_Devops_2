@isTest
public with sharing class TestProduct2Trigger 
{
    static testMethod void testProduct2()
    {
        Product2 objProduct = new Product2(Name='Test Product', Location__c='KJE', CurrencyISOCode = 'EUR');
        insert objProduct;
        
        Product_Description__c objPD = new Product_Description__c(Description__c = 'Test', Product__c = objProduct.Id, Language__c = 'English');
        insert objPD;

        Price_Book_Entry_History__c objPBEH = new Price_Book_Entry_History__c(Previous_List_Price__c = 123.45, Product__c = objProduct.Id);
        insert objPBEH;

        delete objProduct;
                
    }
}