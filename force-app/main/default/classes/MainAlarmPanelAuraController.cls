/*
* @author Naveen Sakhamuri
* @date 2/6/2020 
*
* @group Community
*
* @description: Controller class to provide data for the rule dashboard.
* @Change History
*
*   Tag         Author              Date         Incident No.   Requested-BY      Description     
* *****************************************************************************************************************              
*   1.0.0       Naveen Sakhamuri    2/6/2020                                        Initial Version 
* *****************************************************************************************************************/
public without sharing class MainAlarmPanelAuraController {
    

    public class CurrentUserRelatedAccounts 
    {
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public Boolean isCurrentPortalSelectedAccount;
    }
    //Get the list of account 
    @AuraEnabled
    public static List<Account> getAccounts() 
    {
        Set<Id> allAccountIds = new Set<Id>();
        

        User currentUser = [SELECT Id, ContactId, Portal_Account_Selection__c FROM User WHERE Id =:UserInfo.getUserId()];

        for(AccountContactRelation acr : [SELECT Id, AccountId, Account.Account_and_Site__c FROM AccountContactRelation WHERE ContactId =:currentUser.contactId]){

            allAccountIds.add(acr.AccountId);
        }
        if(allAccountIds.size() > 0)
        {
            return [select id, name from Account where Id IN :allAccountIds];
        }

        return null;
    }
    
    //Get the list of assets associated to the current user's account.
    @AuraEnabled
    public static List<Asset> getAssets(String accId) {
        
        List<Asset> assets = [SELECT Id, Name FROM Asset where AccountId = : accId];
        return assets; 
    }
    
    //Get the header data for the dashboard.
    @AuraEnabled
    public static String getData(String assetId) {
        User usr = [SELECT Id, ContactId FROM User WHERE Id = :userInfo.getUserId()];
        
        headerData hd = new headerData();
        hd.userTimezone = UserInfo.getTimeZone().getID();
        if(!String.isBlank(assetId)) {
            Asset asset = [SELECT Id, Name, AccountId, Account.Name, Account.Site, Timezone__c FROM Asset WHERE Id = :assetId LIMIT 1];
            hd.assetName = asset.Name;
            hd.assetTimezone = asset.Timezone__c;
            hd.clientName = asset.Account.Name;
            hd.clientLocation = asset.Account.Site;
        }
        return JSON.serialize(hd);
    }
    
    //Get the rules associated to a particular asset for the dashboard
    @AuraEnabled
    public static Rule__c[] getRules(String assetId) {
        Map<String, Rule__c> ruleMap = new Map<String, Rule__c>();
        for (Rule__c rule : [
                SELECT Id, AlertAlarmDtTm__c, AlertLastActiveDt__c, AlertLastActiveDtTm__c, AlertLastTriggeredDt__c,
                        AlertLastTriggeredDtTm__c, AlertStartOfActiveDtTm__c, AlertStatus__c, AlertStatusDtTm__c,
                        AlertStatusID__c, AlertStatusImageURL__c, Asset__c, DisplayAlertStatusID__c, Machine__c, MachineID__c,
                        MachineLongNm__c, Name, RuleActiveText__c, RuleID__c, RuleLongNm__c, RuleMachineKey__c, RuleNm__c,SiteID__c
                FROM Rule__c
                WHERE Asset__c = :assetId
                ORDER BY RuleLongNm__c
        ]) {
            ruleMap.put(rule.Id, rule);
        }

        return ruleMap.values();
    }
    
    //Get the rule details information for a particular rule.
    @AuraEnabled
    public static Rule_Detail__c[] getRuleDetails(String ruleId) { 
        List<Rule_Detail__c> detailList = new List<Rule_Detail__c>();
        detailList =[SELECT Id,AlarmContinuous__c, AlertID__c, AlertStatus__c, AlertStatusLevel__c, CoefA__c, CoefB__c, CoefC__c,
                        CoefD__c, CoefE__c, ExecutionEmailBody__c, ExecutionSetPointValue__c, ExecutionValue__c, Machine__c, MachineID__c,
                        MachineLongNm__c, PartitionID__c, Rule__c, RuleExecutionDt__c, RuleExecutionDtTm__c, RuleExecutionID__c, RuleID__c,
                        RuleLongNm__c, RuleMachineKey__c, RuleNm__c, RuleSetPointID__c, RuleSetPointValue__c, RuleTagSeqNo__c, SetPoint__c,
                        SetPointType__c, Tag__c, TagID__c, TagLongNm__c, TagValue__c, TelemetryBeginDt__c, TelemetryBeginDtTm__c,
                        TelemetryEndDtTm__c, SiteID__c
                FROM Rule_Detail__c
                WHERE Rule__c = :ruleId LIMIT 100];
        return detailList;
    }
    
    //Get the rule data related to a particular asset in a given sorted format.
    @AuraEnabled
    public static Rule__c[] getSortedRules(String direction, String assetId) {
        Map<String, Rule__c> ruleMap = new Map<String, Rule__c>();
        if(Direction == 'ASC') {
            for (Rule__c rule : [
                    SELECT Id, AlertAlarmDtTm__c, AlertLastActiveDt__c, AlertLastActiveDtTm__c, AlertLastTriggeredDt__c,
                            AlertLastTriggeredDtTm__c, AlertStartOfActiveDtTm__c, AlertStatus__c, AlertStatusDtTm__c,
                            AlertStatusID__c, AlertStatusImageURL__c, Asset__c, DisplayAlertStatusID__c, Machine__c, MachineID__c,
                            MachineLongNm__c, Name, RuleActiveText__c, RuleID__c, RuleLongNm__c, RuleMachineKey__c, RuleNm__c,SiteID__c
                    FROM Rule__c
                    WHERE Asset__c = :assetId
                    ORDER BY AlertLastActiveDtTm__c ASC NULLS LAST
            ]) {
                ruleMap.put(rule.Id, rule);
            }
        } else {
            for (Rule__c rule : [
                    SELECT Id, AlertAlarmDtTm__c, AlertLastActiveDt__c, AlertLastActiveDtTm__c, AlertLastTriggeredDt__c,
                            AlertLastTriggeredDtTm__c, AlertStartOfActiveDtTm__c, AlertStatus__c, AlertStatusDtTm__c,
                            AlertStatusID__c, AlertStatusImageURL__c, Asset__c, DisplayAlertStatusID__c, Machine__c, MachineID__c,
                            MachineLongNm__c, Name, RuleActiveText__c, RuleID__c, RuleLongNm__c, RuleMachineKey__c, RuleNm__c,SiteID__c
                    FROM Rule__c
                    WHERE Asset__c = :assetId
                    ORDER BY AlertLastActiveDtTm__c DESC NULLS LAST
            ]) {
                ruleMap.put(rule.Id, rule);
            }
        }

        return ruleMap.values();
    }
    
    //Wrapper class for the header data
    public class headerData {
        @AuraEnabled
        public String clientName;
        
        @AuraEnabled
        public String clientLocation;
        
        @AuraEnabled
        public String assetName;

        @AuraEnabled
        public String userTimezone;

        @AuraEnabled
        public String assetTimezone;
    }
}