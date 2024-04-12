@isTest(SeeAllData=true)
public class SaveKBCvisitreportToFilesTest {
    static testMethod void testMethod1(){
        //Task task = [SELECT ID, Visit_Report__c FROM Task WHERE Visit_Report__c <> null AND Visit_Report__r.Visit_Report_Objective__c <> null LIMIT 1 ];
        Visit_Report__c VisitReport = [SELECT Id FROM Visit_Report__c LIMIT 1];
        // WHERE Id=:task.Visit_Report__c
        String sId = VisitReport.Id;

        SaveKBCvisitreportToFiles.FlowInputs input = new SaveKBCvisitreportToFiles.FlowInputs();
        input.RecordId = sId;
        input.sInternal = 'True';

        SaveKBCvisitreportToFiles.SaveKBCvisitreportToFiles(new List<SaveKBCvisitreportToFiles.FlowInputs>{input});

        //SaveKBCvisitreportToFiles.SaveKBCvisitreportToFiles(input);
    } 
}