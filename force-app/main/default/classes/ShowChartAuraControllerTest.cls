@isTest
public class ShowChartAuraControllerTest {
    static testmethod void myUnitTest(){
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
        rd.TelemetryDtTm__c = system.today();
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
        rd2.TelemetryDtTm__c = system.today();
        rd2.RuleLongNm__c = 'test rule';
        rd2.TagValue__c          = 230;
        insert rd2;
        ShowChartAuraController.getTagsList(r.Id);
        ShowChartAuraController.getChartMap(r.RuleLongNm__c, 'GMT');
        ShowChartAuraController.getLineChartMap(r.Id, rd.Tag__c, 'GMT');
    }
    static testmethod void myUnitTest1(){
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
        rd.TelemetryDtTm__c = system.today();
        rd.TagValue__c          = 230;
        rd.RuleLongNm__c = 'test rule';
        insert rd;
        ShowChartAuraController.getTagsList(r.Id);
        ShowChartAuraController.getChartMap(r.RuleLongNm__c, 'GMT');
        ShowChartAuraController.getLineChartMap(r.Id, rd.Tag__c, 'GMT');
    }
    static testmethod void myUnitTest2(){
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
        rd.AlertStatus__c       = 'TRIGGERED';
        rd.TelemetryDtTm__c = system.today();
        rd.Tag__c               = 'BR_HDR_PR';
        rd.RuleLongNm__c = 'test rule';
        rd.TagValue__c          = 230;
        insert rd;
        ShowChartAuraController.getTagsList(r.Id);
        ShowChartAuraController.getChartMap(r.RuleLongNm__c, 'GMT');
        ShowChartAuraController.getLineChartMap(r.Id, rd.Tag__c, 'GMT');
    }
}