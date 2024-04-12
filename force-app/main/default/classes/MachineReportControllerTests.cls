@isTest(SeeAllData=true)
public class MachineReportControllerTests {

    static MachineReportController sController;
    static PageReference sPage;
    
    private static testMethod void mrcTestMethod() 
    {
        Machine__c macId = [SELECT Id FROM Machine__c Where No_of_Sections__c > 0 LIMIT 1];
        Machine_Section__c macSection = [SELECT Id FROM Machine_Section__c WHERE Machine__c = :macId.Id LIMIT 1];
        Machine_Mapping_Doctor__c doctorItems = [SELECT Id FROM Machine_Mapping_Doctor__c WHERE Machine_Section__c = :macSection.Id LIMIT 1];
        //Machine_Mapping_Cleaning__c showerItems = [SELECT Id FROM Machine_Mapping_Cleaning__c WHERE Machine_Section__c = :macSection.Id LIMIT 1];

        PageReference pageRef = Page.MachineReport;
        pageRef.getParameters().put('id', String.valueOf(macId.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(macId);
        MachineReportController testPlan = new MachineReportController(sc);
    }   

    private static testMethod void mrcTestMethod2() 
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        PageReference pageRef = Page.MachineReport;
        pageRef.getParameters().put('id', String.valueOf(mac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(mac);
        MachineReportController testPlan = new MachineReportController(sc);
    }   

    @isTest
    static void mrcTestMethod3() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Cleaning__c cl = new Machine_Mapping_Cleaning__c();
        cl.Machine_Section__c = ms.Id;
        cl.RecordTypeId = '01260000000UOMqAAO';
        insert cl;        

        PageReference pageRef = Page.MachineReport;
        pageRef.getParameters().put('id', String.valueOf(mac.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(mac);
        MachineReportController testPlan = new MachineReportController(sc);
    }
}