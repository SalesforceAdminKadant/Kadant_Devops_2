@isTest(SeeAllData=True)
public without sharing class TestPriceAgreementTrigger 
{
    static testMethod void testQuote()
    {

        Account objAcct = [select Id from Account LIMIT 1];
        PriceBook2 objPB = [select Id from PriceBook2 LIMIT 1];
        Price_Agreement__c objPA = [select Id from Price_Agreement__c LIMIT 1];

        Price_Agreement__c pa = new Price_Agreement__c(Account__c=objAcct.Id, Price_Book__c = objPB.Id, Description__c = 'Test',
            Status__c = 'Draft', Cloned_From_Id__c = objPA.Id, Cloned_Price_Increase__c = 5);
        insert pa;
        
    }
}