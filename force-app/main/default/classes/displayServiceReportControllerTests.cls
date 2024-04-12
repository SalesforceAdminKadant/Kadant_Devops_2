@isTest(SeeAllData=true)
public class displayServiceReportControllerTests
{
    static displayServiceReportController sController;
    static PageReference sPage;
    
    static testMethod void testMethod1() 
    {
        Service_Report_Item__c srItem = [SELECT Id, Service_Report__c FROM Service_Report_Item__c LIMIT 1];
        Service_Report__c srHeader = [SELECT Id FROM Service_Report__c Where Id = :srItem.Service_Report__c LIMIT 1];
        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Report_Item__c = srItem.Id);
        insert objSPI;

        PageReference pageRef = Page.displayServiceReport;
        pageRef.getParameters().put('id', String.valueOf(srHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srHeader);
        displayServiceReportController testPlan = new displayServiceReportController(sc);       
    }

    static testMethod void testMethod3() 
    {
        Service_Report_Item__c srItem = [SELECT Id, Service_Report__c FROM Service_Report_Item__c WHERE RecordType.Name = 'Yankee' LIMIT 1];
        Service_Report__c srHeader = [SELECT Id FROM Service_Report__c Where Id = :srItem.Service_Report__c LIMIT 1];
        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Report_Item__c = srItem.Id);
        insert objSPI;

        PageReference pageRef = Page.displayServiceReport;
        pageRef.getParameters().put('id', String.valueOf(srHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srHeader);
        displayServiceReportController testPlan = new displayServiceReportController(sc);
    }

    static testMethod void testMethod4() 
    {
        Service_Report_Item__c srItem = [SELECT Id, Service_Report__c FROM Service_Report_Item__c WHERE RecordType.Name = 'Mclean' LIMIT 1];
        Service_Report__c srHeader = [SELECT Id FROM Service_Report__c Where Id = :srItem.Service_Report__c LIMIT 1];
        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Report_Item__c = srItem.Id);
        insert objSPI;

        PageReference pageRef = Page.displayServiceReport;
        pageRef.getParameters().put('id', String.valueOf(srHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srHeader);
        displayServiceReportController testPlan = new displayServiceReportController(sc);
    }

    static testMethod void testMethod5() 
    {
        Service_Report_Item__c srItem = [SELECT Id, Service_Report__c FROM Service_Report_Item__c WHERE RecordType.Name = 'Mclean' LIMIT 1];
        Service_Report__c srHeader = [SELECT Id FROM Service_Report__c Where Id = :srItem.Service_Report__c LIMIT 1];

        // Add a Topic with no Summary
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = srItem.Id;
        sti.Machine_Category__c = 'M-clean';
        sti.Topic__c = 'Beam';
        sti.Component__c = 'Head to Fabric Profile';
        sti.Inspection_Status__c = 'Completed';
        insert sti;

        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Topic_Item__c = sti.Id);
        insert objSPI;

        PageReference pageRef = Page.displayServiceReport;
        pageRef.getParameters().put('id', String.valueOf(srHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srHeader);
        displayServiceReportController testPlan = new displayServiceReportController(sc);
    }

    static testMethod void testMethod6() 
    {
        Service_Report_Item__c srItem = [SELECT Id, Service_Report__c FROM Service_Report_Item__c WHERE RecordType.Name = 'Mclean' LIMIT 1];
        Service_Report__c srHeader = [SELECT Id FROM Service_Report__c Where Id = :srItem.Service_Report__c LIMIT 1];

        // Add a Topic with no Summary
        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = srItem.Id;
        sti.Machine_Category__c = 'M-clean';
        sti.Topic__c = 'Wear Components';
        sti.Component__c = 'Vacuum Hose';
        sti.Inspection_Status__c = 'Replaced';
        insert sti;

        PageReference pageRef = Page.displayServiceReport;
        pageRef.getParameters().put('id', String.valueOf(srHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srHeader);
        displayServiceReportController testPlan = new displayServiceReportController(sc);
    }

    static testMethod void testMethod8() 
    {
        Service_Report_Item__c srItem = [SELECT Id, Service_Report__c FROM Service_Report_Item__c WHERE RecordType.Name = 'Yankee' AND Metalized__c = true LIMIT 1];
        Service_Report__c srHeader = [SELECT Id FROM Service_Report__c Where Id = :srItem.Service_Report__c LIMIT 1];
        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Report_Item__c = srItem.Id);
        insert objSPI;

        PageReference pageRef = Page.displayServiceReport;
        pageRef.getParameters().put('id', String.valueOf(srHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srHeader);
        displayServiceReportController testPlan = new displayServiceReportController(sc);
    }
}