// All test methods in this class can access all data.
@isTest(SeeAllData=true)
public class TestMachineSectionTrigger {

    // This test accesses an existing machine. 
    // It also creates and accesses a new test machine section.
    static testMethod void testMachineTrigger() {
        // Query an existing account in the organization. 
        Machine__c objMachine = [SELECT Id, Name FROM Machine__c LIMIT 1];
        System.assert(objMachine != null);
        
        // Create a test machine section based on the machine.
        Machine_Section__c objMS = new Machine_Section__c(Name='Test', Machine__c = objMachine.Id, RecordTypeId = Schema.SObjectType.Machine_Section__c.getRecordTypeInfosByName().get('Paper: Dryer').getRecordTypeId());
        insert objMS;
        
        // Query the test machine section that was inserted.
        Machine_Section__c testMS = [SELECT Id, Name, Machine_Type__c FROM Machine_Section__c WHERE Id = :objMS.Id LIMIT 1];
        System.assert(testMS != null);
        System.assert(testMS.Machine_Type__c == 'Paper');

        testMS.Section_Type__c = 'Dryer';
        update testMS;
        testMS = [SELECT Id, RecordType.Name FROM Machine_Section__c WHERE Id = :testMS.Id LIMIT 1];
        System.assert(testMS.RecordType.Name == 'Paper: Dryer');

    }
  
}