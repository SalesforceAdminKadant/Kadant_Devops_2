@isTest(SeeAllData=True)
public class TestMassCreateSalesTargets {


    @isTest
    static void PSGETest() {
        
        Date todaysDate = date.today();
        String testuser = '';
        List<String> testaccountids = new List<String>();
        String testbudgetid = '';
        String testrecordtype = 'PSG-E RSM Budget';
        
        List<Account_Sales_Targets__c> testresults = [select account__c, sales_budget__c, sales_budget__r.ownerid from account_sales_targets__c where name = '2021' and sales_budget__r.recordtype.name = :testrecordtype limit 1];
        for(Account_Sales_Targets__c a: testresults){
            testuser = a.sales_budget__r.ownerid;
            testbudgetid = a.sales_budget__c;
            testaccountids.add(a.account__c);
        }
        
        MassCreateSalesTargets.getAccounts(testrecordtype,testuser,testbudgetid);
        
        MassCreateSalesTargets.delSlctRec(testaccountids,testbudgetid);


    }
    @isTest    
    static void KLTest() {
        
        String testuser = '';
        List<String> testaccountids = new List<String>();
        String testbudgetid = '';
        String testrecordtype = 'KL ASM Budget';
        
        List<Account_Sales_Targets__c> testresults = [select account__c, sales_budget__c, sales_budget__r.ownerid from account_sales_targets__c where name = '2021' and sales_budget__r.recordtype.name = :testrecordtype limit 1];
        for(Account_Sales_Targets__c a: testresults){
            testuser = a.sales_budget__r.ownerid;
            testbudgetid = a.sales_budget__c;
            testaccountids.add(a.account__c);
        }
        
        MassCreateSalesTargets.getAccounts(testrecordtype,testuser,testbudgetid);
        
        MassCreateSalesTargets.delSlctRec(testaccountids,testbudgetid);


    }
}