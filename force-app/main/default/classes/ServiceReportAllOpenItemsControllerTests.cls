@isTest(SeeAllData=true)
public class ServiceReportAllOpenItemsControllerTests
{
    static ServiceReportAllOpenItemsController sController;
    static PageReference sPage;
    
    static testMethod void testMethod1() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 1');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 1');
        insert mac1;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc1.Id;
        sr.Reason_for_Service__c = 'adding testing for reason for service';
        sr.Objective__c = 'adding testing objective';                
        sr.Machine__c = mac1.Id;
        sr.Visit_Date__c = System.today();
        insert sr; 

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Topic_Item__c = sti.Id);
        insert objSPI;

        PageReference pageRef = Page.ServiceReportItemPositions;
        pageRef.getParameters().put('id', String.valueOf(mac1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        ServiceReportAllOpenItemsController testPlan = new ServiceReportAllOpenItemsController(sc);

        Test.StopTest();
    }

    static testMethod void testMethod2() 
    {
        Test.StartTest();

        Account acc2 = new Account(Name = 'Test Company 2');
        insert acc2; 

        Machine__c mac2 = new Machine__c(Account__c = acc2.Id, Name = 'Test Machine 2');
        insert mac2;       
        
        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc2.Id;
        sr.Reason_for_Service__c = 'adding testing for reason for service1';
        sr.Objective__c = 'adding testing objective1';        
        sr.Machine__c = mac2.Id;
        sr.Visit_Date__c = System.today();
        insert sr;   

        PageReference pageRef = Page.ServiceReportItemPositions;
        pageRef.getParameters().put('id', String.valueOf(mac2.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        ServiceReportAllOpenItemsController testPlan = new ServiceReportAllOpenItemsController(sc);

        Test.StopTest();
    }

    static testMethod void testMethod3() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 3');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 2');
        insert mac1;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc1.Id;
        sr.Reason_for_Service__c = 'adding testing for reason for service';
        sr.Objective__c = 'adding testing objective';                
        sr.Machine__c = mac1.Id;
        sr.Visit_Date__c = System.today();
        insert sr; 

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Critical';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = null;
        insert sti;

        PageReference pageRef = Page.ServiceReportItemPositions;
        pageRef.getParameters().put('id', String.valueOf(mac1.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        ServiceReportAllOpenItemsController testPlan = new ServiceReportAllOpenItemsController(sc);

        Test.StopTest();
    }
}