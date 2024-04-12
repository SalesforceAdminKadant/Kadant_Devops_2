public class KAI_Case_Comment_Controller {     
    @AuraEnabled
    public static List<CaseComment> getCaseComments(String caseId) {
        List<CaseComment> caseComments = 
            [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, CreatedBy.Name FROM CaseComment where parentId=:caseId order by CreatedDate desc];
        return caseComments;        
    }
    
    @AuraEnabled
    public static CaseComment addCaseComment(String caseId, String commentBody) {
        CaseComment caseComment = new CaseComment(ParentId=caseId, CommentBody=commentBody);
        insert caseComment;
        return caseComment;        
    }
    
    @AuraEnabled    
    public static CaseComment getCaseComment(String commentId) {
        CaseComment caseComment = [SELECT Id, CommentBody FROM CaseComment where Id=:commentId];
        system.debug('id= : ' + caseComment);
        return caseComment;
    }  
    
    @AuraEnabled
    public static CaseComment updateCaseComment(String commentId, String commentBody) {
        CaseComment caseComment = new CaseComment(Id=commentId, CommentBody=commentBody);
        system.debug('id= : ' + caseComment);
        update caseComment;
        return caseComment;        
    } 
    
    @AuraEnabled    
    public static CaseComment deleteCaseComment(String commentId) {
        CaseComment caseComment = new CaseComment(Id=commentId); 
        system.debug('id= : ' + caseComment);
        delete caseComment;   
        return caseComment;
    } 
}