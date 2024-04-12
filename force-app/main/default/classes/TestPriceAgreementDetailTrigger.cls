@isTest(SeeAllData=True)
public without sharing class TestPriceAgreementDetailTrigger 
{
    static testMethod void testPriceAgreementDetail()
    {

        Price_Agreement__c pa = [select Id, CurrencyISOCode from Price_Agreement__c LIMIT 1];

        PricebookEntry objPBE = [select Id, Product2.Id from PricebookEntry Where CurrencyISOCode = : pa.CurrencyISOCode LIMIT 1];
                
        Price_Agreement_Detail__c pad = new Price_Agreement_Detail__c(Price_Agreement_Header__c=pa.Id, Price__c = 1.00, Product__c = objPBE.Product2.id);
        insert pad;

        Price_Agreement_Detail__c[] pads = [select Id from Price_Agreement_Detail__c LIMIT 2];
        Test.StartTest(); 
            ApexPages.StandardSetController sc = new ApexPages.StandardSetController(pads);
            PriceAgreementDetailControllerExtension testObj = new PriceAgreementDetailControllerExtension(sc);

            //List<SelectOption> lstOptions  = testObj.testObj();
            //System.assert(lstOptions.size() > 0 );
        Test.StopTest();
        
    }
}