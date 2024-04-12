@isTest(SeeAllData=true)
public class displayMachineControllerTests 
{
    static displayMachineController sController;
    static PageReference sPage;
    
    static testMethod void testMethod1()  
    {        
        ContentDocumentLink docLink = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink Where LinkedEntityId IN (SELECT Id FROM Machine_Section__c) and LinkedEntity.Type='Machine_Section__c' Limit 1];
        ContentVersion cvId = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :docLink.ContentDocumentId LIMIT 1];
        Machine_Section__c macSection = [SELECT Id, Machine__c FROM Machine_Section__c WHERE Id = :docLink.LinkedEntityId LIMIT 1];

        PageReference pageRef = Page.displayMachine;
        pageRef.getParameters().put('id', String.valueOf(macSection.Machine__c));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(cvId);
        displayMachineController testPlan = new displayMachineController(sc);

        Account acc = new Account();
        acc.Name = 'Test Account Machine 1';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 1';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;
        
        pageRef.getParameters().put('id', String.valueOf(mac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(mac);
        displayMachineController testPlan2 = new displayMachineController(sc2);
    }
}