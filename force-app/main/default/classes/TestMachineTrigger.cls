// All test methods in this class can access all data.
@isTest(SeeAllData=true)
public class TestMachineTrigger {

    // This test creates and deletes a new test machine section.
    static testMethod void testMachineTrigger() {

        // Query an existing account in the organization. 
        Account objAcct = [SELECT Id, Name FROM Account LIMIT 1];
        System.assert(objAcct != null);
        
        // Create a test machine based on the account.
        Machine__c objMachine = new Machine__c(Name='Test', Account__c = objAcct.Id);
        insert objMachine;

        // Delete the test machine.
        delete objMachine;
        
    }
  
}