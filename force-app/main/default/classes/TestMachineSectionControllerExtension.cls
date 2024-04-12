@isTest(SeeAllData=true)
public class TestMachineSectionControllerExtension 
{
    static testMethod void testMethod1() 
    {
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        insert testAccount;

        Machine__c testMachine = new Machine__c();
        testMachine.Account__c = testAccount.Id;
        testMachine.Name='Test Machine';
        insert testMachine;

        Machine_Section__c objMS = new Machine_Section__c();
        objMS.Name = 'Test Section';
        objMS.Machine__c = testMachine.Id;
        insert objMS ;
        
        
        Test.StartTest(); 

            ApexPages.StandardController sc = new ApexPages.StandardController( objMS );
            MachineSectionControllerExtension testTest = new MachineSectionControllerExtension(sc);
            testTest.redirectPage();
            
        Test.StopTest();
    }
}