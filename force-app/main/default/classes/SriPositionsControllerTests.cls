@isTest(SeeAllData=true)
public class SriPositionsControllerTests {

    static ServiceReportItemPositionsController sController;
    static PageReference sPage;

    // Methods for testing
    @isTest(SeeAllData=true)
    static void test1() {
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
        
        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        PageReference pageRef = Page.ServiceReportItemPositions;
        pageRef.getParameters().put('id', String.valueOf(sr.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        ServiceReportItemPositionsController testPlan = new ServiceReportItemPositionsController(sc);
    }

    // Methods for testing
    @isTest(SeeAllData=true)
    static void test2() {
/*
        Service_Report_Item__c srItem = [SELECT Id, Machine_Name__c, Machine_Section__c, Service_Report__c FROM Service_Report_Item__c LIMIT 1];
        Service_Report__c sr = [SELECT Id FROM Service_Report__c WHERE Id = :srItem.Service_Report__c LIMIT 1];
*/        

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

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Report_Item__c sri2 = new Service_Report_Item__c();
        sri2.Service_Report__c = sr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri2.Line_Order_Number__c = 2.0;
        sri2.Machine_Section__c = ms.Id;
        insert sri2;

        PageReference pageRef = Page.ServiceReportItemPositions;
        pageRef.getParameters().put('id', String.valueOf(sri.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        ServiceReportItemPositionsController testPlan = new ServiceReportItemPositionsController(sc);
        
    }
}