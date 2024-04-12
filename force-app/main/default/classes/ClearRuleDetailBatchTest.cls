@isTest
public class ClearRuleDetailBatchTest {
	@isTest
    public static void unitTest1(){
        Rule__c r = new Rule__c();
        r.RuleMachineKey__c='1234d';
        r.ExternalId__c='abcd123';
        r.RuleLongNm__c = 'test rule';
        insert r;
        
        Rule_Detail__c rd = new Rule_Detail__c();
        rd.Name = 'test';
        rd.Rule__c = r.Id;
        rd.RuleExecutionDtTm__c = system.today();
        rd.AlertStatusLevel__c  = 2;
        rd.AlertStatus__c       = 'INACTIVE';
        rd.Tag__c               = 'BR_HDR_PR';
        rd.TelemetryBeginDtTm__c = system.today();
        rd.RuleLongNm__c = 'test rule';
        rd.TagValue__c          = 230;
        insert rd;
        Rule_Detail__c rd2 = new Rule_Detail__c();
        rd2.Name = 'test';
        rd2.Rule__c = r.Id;
        rd2.RuleExecutionDtTm__c = system.today();
        rd2.AlertStatusLevel__c  = 2;
        rd2.AlertStatus__c       = 'TRIGGERED';
        rd2.Tag__c               = 'BR_HDR_PR';
        rd2.TelemetryBeginDtTm__c = system.today();
        rd2.RuleLongNm__c = 'test rule';
        rd2.TagValue__c          = 230;
        insert rd2;
        Test.startTest();
        ClearRuleDetailBatch batch = new ClearRuleDetailBatch();
        batch.execute(null);
        Test.stopTest();
    }
}