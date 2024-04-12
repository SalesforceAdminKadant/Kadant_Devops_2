@isTest(SeeAllData=true)
public class VisitReportControllerTest {

    static VisitReportController sController;
    static PageReference sPage;

    @isTest static void testMethod1(){
    
            Task task = [SELECT ID, Visit_Report__c FROM Task WHERE Visit_Report__c <> null AND Visit_Report__r.Visit_Report_Objective__c <> null LIMIT 1 ];
            Visit_Report__c VisitReport = [SELECT Id FROM Visit_Report__c WHERE Id=:task.Visit_Report__c LIMIT 1];
            String sId = VisitReport.Id;

            PageReference pageRef = Page.DisplayVisitReport;
            pageRef.getParameters().put('id', sId);
            pageRef.getParameters().put('Internal', 'TRUE');
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(VisitReport);
            VisitReportController testPlan = new VisitReportController(sc);
    
    } 

    @isTest static void testMethod2(){
    
        Event event = [SELECT ID, Visit_Report__c FROM Event WHERE Visit_Report__c <> null AND Visit_Report__r.Visit_Report_Objective__c <> null AND WhatId <> null LIMIT 1 ];
        Visit_Report__c VisitReport = [SELECT Id FROM Visit_Report__c WHERE Id=:event.Visit_Report__c LIMIT 1];
        String sId = VisitReport.Id;

        PageReference pageRef = Page.DisplayVisitReport;
        pageRef.getParameters().put('id', sId);
        pageRef.getParameters().put('Internal', 'FALSE');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(VisitReport);
        VisitReportController testPlan = new VisitReportController(sc);
    
    } 
}