/*
* @author naveen
* @date 18/02/19 
* @description: Batch class to delete rule details at specific intervals.
* @Change History
*
*   Tag         Author              Date         Incident No.   Requested-BY      Description     
* *****************************************************************************************************************              
*   1.0.0       naveen            18/02/19                                        Initial Version 
* *****************************************************************************************************************/
global class ClearRuleDetailBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    //For scheduling the batch
    public static void schedule()
    {
        System.schedule('Clear Rule Details Batch', '0 0 0,4,8,12,16,20 * * ?', new ClearRuleDetailBatch() );
    }
    
    global void execute(SchedulableContext sc) 
    {
        Database.executeBatch(new ClearRuleDetailBatch(), 200);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        Integer hours = (Integer.valueOf(System.Label.Rule_Detail_Retention_Hours)) * (-1);
        Datetime hoursback = System.Now().addHours(hours);
        if(Test.isRunningTest()) {
            hoursback = System.Now();
        }
        return Database.getQueryLocator('SELECT Name, Id, CreatedDate FROM Rule_Detail__c WHERE CreatedDate <= :hoursback');
    }
    
    global void execute(Database.BatchableContext BC, List<Rule_Detail__c> scope)
    {
        delete scope;
    }
    global void finish(Database.BatchableContext BC){}
}