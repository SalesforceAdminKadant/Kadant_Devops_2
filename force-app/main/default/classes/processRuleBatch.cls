global class processRuleBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Rule_Execution_Date__c, RuleExecutionDt__c, RuleExecutionDtTm__c, Rule_Name__c, RuleNm__c, Rule_Long_Name__c, RuleLongNm__c  FROM Rule_Detail__c WHERE Rule_Execution_Date__c = null');
    }
    
    global void execute(Database.BatchableContext BC, List<Rule_Detail__c> scope){
        for(Rule_Detail__c dtl : scope){
            dtl.Rule_Execution_Date__c = dtl.RuleExecutionDtTm__c;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}