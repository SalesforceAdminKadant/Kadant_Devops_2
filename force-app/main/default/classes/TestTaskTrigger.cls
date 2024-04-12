@isTest(SeeAllData=true)
public without sharing class TestTaskTrigger 
{
    static testMethod void testTask()
    {
        
        Quote objQuote = [Select Id From Quote Where RecordType.Name = 'PSG-E Quotes' LIMIT 1];
        Id sfId = [Select Id From User Where Name = 'Salesforce Admin' LIMIT 1].Id;
        
        Task tsk = new Task(OwnerId = sfId, WhatId = objQuote.Id, ActivityDate = System.today());
        insert tsk;

    }
}