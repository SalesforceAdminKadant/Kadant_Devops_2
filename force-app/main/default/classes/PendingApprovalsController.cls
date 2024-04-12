public with sharing class PendingApprovalsController {
    @AuraEnabled(cacheable=true)
    public static List<wrapperClass> getPendingApprovals(string user_id) {
        List<wrapperClass> wrapList = new List<wrapperClass>();
        for (ProcessInstance pi: [SELECT Id, TargetObjectId, TargetObject.Name, TargetObject.Type,  
            (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, Comments, ProcessNode.Name, CreatedDate FROM StepsAndWorkitems WHERE StepStatus = 'Pending') 
            FROM ProcessInstance WHERE Status = 'Pending' and ProcessInstance.SubmittedById = :user_id ORDER BY TargetObjectId] ) {
                for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) {
                    wrapperClass pendingApprovalWrap = new wrapperClass();
                    pendingApprovalWrap.RecordName = String.valueOf(pi.TargetObject.Name);
                    pendingApprovalWrap.SfObject = String.valueOf(pi.TargetObject.Type);
                    pendingApprovalWrap.RecordId = String.valueOf(pi.TargetObjectId);
                    String tmpName = String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0];
                    pendingApprovalWrap.RecordObject = tmpName.replace('_', ' ');
                    pendingApprovalWrap.AssignedToName = String.valueOf(pih.OriginalActor.Name);
                    pendingApprovalWrap.ApproverName = pih.Actor.Name;
                    pendingApprovalWrap.CreatedDate = String.valueOf(pih.CreatedDate);                    
                    wrapList.add(pendingApprovalWrap);               
                }  
            }
        return wrapList;
    }    

    public class wrapperClass{
        @AuraEnabled public String RecordName {get; set;}
        @AuraEnabled public String RecordId {get; set;}
        @AuraEnabled public String SfObject {get; set;}
        @AuraEnabled public String RecordObject {get; set;}
        @AuraEnabled public String AssignedToName {get; set;}
        @AuraEnabled public String ApproverName {get; set;}
        @AuraEnabled public String CreatedDate {get; set;}
    }   
}