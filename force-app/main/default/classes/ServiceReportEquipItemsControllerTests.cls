@isTest(SeeAllData=true)
public class ServiceReportEquipItemsControllerTests
{
    static ServiceReportEquipmentItemsController sController;
    
    static testMethod void test1() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 1');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 1');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Doctor__c doc = new Machine_Mapping_Doctor__c(
            Label_Name__c = 'SAM Test Doctor',
            Machine_Section__c = ms1.Id
        );
        insert doc;

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
        sri.Machine_Mapping_Doctor__c = doc.Id;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Critical';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;    
        
        Service_Topic_Item__c sti2 = new Service_Topic_Item__c();
        sti2.Service_Report_Item__c = sri.Id;
        sti2.Customer_Action_Summary__c = 'Test for giggles';
        sti2.Status__c = 'Open';
        sti2.Priority__c = 'Low';
        sti2.Machine_Category__c = 'Doctor';
        sti2.Topic__c = 'Blade';
        sti2.Summary__c = '';
        insert sti2; 

        sharinpix__SharinPixImage__c ssi = new sharinpix__SharinPixImage__c();
        ssi.Fit_to_Size__c = 'https://p.sharinpix.com/1/6507e09/app.sharinpix.com%2Fimage_external_urls%2F742260d4-469f-4b8f-96df-46bd8e0c74bd/742260d4-469f-4b8f-96df-46bd8e0c74bd.jpg';
        ssi.sharinpix__Title__c = 'Test Dryer Doctor';
        ssi.sharinpix__Description__c = 'Just a test';
        ssi.Service_Topic_Item__c = sti2.Id;
        insert ssi;
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(doc.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }

    static testMethod void test2() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 2');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 2');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Cleaning__c cln = new Machine_Mapping_Cleaning__c(
            Position_No__c = 'CLN4',
            Machine_Section__c = ms1.Id
        );
        insert cln;

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
        sri.Machine_Mapping_Cleaning__c = cln.Id;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Moderate';
        sti.Machine_Category__c = 'Cleaning';
        sti.Topic__c = '';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(cln.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }

    static testMethod void test3() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 3');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 3');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Filter__c flt = new Machine_Mapping_Filter__c(
            Application__c = 'Sam Test Filter',
            Machine_Section__c = ms1.Id
        );
        insert flt;

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
        sri.Machine_Mapping_Filter__c = flt.Id;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Filter';
        sti.Topic__c = 'Media';
        sti.Summary__c = '';
        insert sti;
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(flt.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }

    static testMethod void test4() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 4');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 4');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Belt__c blt = new Machine_Mapping_Belt__c(
            Postion__c = 'Sam Test Belt',
            Description__c = 'Just a Belt',
            Machine_Section__c = ms1.Id
        );
        insert blt;

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
        sri.Machine_Mapping_Belt__c = blt.Id;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Belt';
        sti.Topic__c = 'Cleanliness';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(blt.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }

    static testMethod void test5() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 5');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 5');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Roll__c rol = new Machine_Mapping_Roll__c(
            Label__c = 'Sam Test Roll',
            Description__c = 'Just a Belt',
            Machine_Section__c = ms1.Id
        );
        insert rol;

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
        sri.Machine_Mapping_Roll__c = rol.Id;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Rolls';
        sti.Topic__c = 'Surface';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(rol.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }

    static testMethod void test6() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 6');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 6');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Drainage__c drn = new Machine_Mapping_Drainage__c(
            Application__c = 'Sam Test Drain',
            Machine_Section__c = ms1.Id
        );
        insert drn;

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
        sri.Machine_Mapping_Drainage__c = drn.Id;
        insert sri;         
        
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Drainage';
        sti.Topic__c = 'Vacuum';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(drn.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }

    static testMethod void test7() 
    {
        Test.StartTest();         
        
        Account acc1 = new Account(Name = 'Test Company 7');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Name = 'Test Machine 7');
        insert mac1;

        Machine_Section__c ms1 = new Machine_Section__c(
            Machine__c = mac1.Id, 
            Section_Type__c = 'Press', 
            Machine_Type__c = 'Paper',
            Sequence__c = 1, 
            RecordTypeId = '0120z000000UOmjAAG',
            Machine_Name__c = 'Sam Machine Section');
        insert ms1;

        Machine_Mapping_Drainage__c drn = new Machine_Mapping_Drainage__c(
            Application__c = 'Sam Test Drain 2',
            Machine_Section__c = ms1.Id
        );
        insert drn;

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
        sri.Machine_Mapping_Drainage__c = drn.Id;
        insert sri;       
        
        PageReference pageRef = Page.ServiceReportEquipmentItems;        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(drn.Id));
        ServiceReportEquipmentItemsController testPlan = new ServiceReportEquipmentItemsController();
        
        Test.StopTest();
    }
}