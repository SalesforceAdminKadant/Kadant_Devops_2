@isTest(SeeAllData=true)
public class displayOscillatorRebuildControllerTests
{
    static displayOscillatorRebuildController sController;
    static PageReference sPage;
    
    static testMethod void testMethod1() 
    {        
        Oscillator_Rebuild_Line_Item__c orItem = [SELECT Id, Oscillator_Rebuild__c FROM Oscillator_Rebuild_Line_Item__c LIMIT 1];
        Oscillator_Rebuild__c orHeader = [SELECT Id FROM Oscillator_Rebuild__c Where Id = :orItem.Oscillator_Rebuild__c LIMIT 1];
        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Oscillator_Rebuild_Line_Item__c = orItem.Id);
        insert objSPI;

        PageReference pageRef = Page.DisplayOscillatorRebuildReport;
        pageRef.getParameters().put('id', String.valueOf(orHeader.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(orHeader);
        DisplayOscillatorRebuildController testPlan = new DisplayOscillatorRebuildController(sc);
    }

    static testMethod void testMethod2() 
    {        
        Oscillator_Rebuild__c srTest = new Oscillator_Rebuild__c();  
        srTest.Repair_Date__c = System.today();
        srTest.Visit_Summary__c = 'Just some testing text for sample data';
        insert srTest;
        
        PageReference pageRef = Page.DisplayOscillatorRebuildReport;
        pageRef.getParameters().put('id', String.valueOf(srTest.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srTest);
        DisplayOscillatorRebuildController testPlan = new DisplayOscillatorRebuildController(sc);
    }

    static testMethod void testMethod3() 
    { 
        Oscillator_Model_Serial_Number__c osn = [SELECT Id, Name FROM Oscillator_Model_Serial_Number__c LIMIT 1];

        Oscillator_Rebuild__c srTest = new Oscillator_Rebuild__c();  
        srTest.Repair_Date__c = System.today();
        srTest.Visit_Summary__c = null;
        insert srTest;

        Oscillator_Rebuild_Line_Item__c orl = new Oscillator_Rebuild_Line_Item__c();
        orl.Oscillator_Rebuild__c = srTest.Id;
        orl.Oscillator_Model_Serial_Number__c = osn.Id;
        orl.Comments__c = null;
        insert orl;
        
        PageReference pageRef = Page.DisplayOscillatorRebuildReport;
        pageRef.getParameters().put('id', String.valueOf(srTest.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(srTest);
        DisplayOscillatorRebuildController testPlan = new DisplayOscillatorRebuildController(sc);
    }
}