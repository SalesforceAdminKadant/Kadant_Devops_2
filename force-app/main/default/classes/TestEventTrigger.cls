@isTest(SeeAllData=true)
public without sharing class TestEventTrigger 
{
    static testMethod void testEvent()
    {

        Id evtLamortRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('KL Sales Call').getRecordTypeId();
        Id evtKadantEuropeRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Kadant Europe Visit Report').getRecordTypeId();
        Id KSDServiceRecordTypeID = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Service Event').getRecordTypeId();
        
        Opportunity opp = [select Id From Opportunity LIMIT 1];

        Contact cnt = [select Id From Contact LIMIT 1];

        Lead ld = [select Id From Lead LIMIT 1];
        
        Account objAccount = [select Id From Account LIMIT 1];
        
        Event evt1 = new Event(WhatId = objAccount.Id, RecordTypeId = evtLamortRecordTypeId, ActivityDateTime = System.now(), DurationInMinutes = 60, Event_Type__c = 'Visit Report');
        insert evt1;
        
        Visit_Report__c vr1 = new Visit_Report__c(Account__c = objAccount.Id, Event_ID__c = evt1.Id);
        insert vr1;
        delete vr1;

        Event evt2 = new Event(WhatId = opp.Id, WhoId = cnt.id, RecordTypeId = evtKadantEuropeRecordTypeId, ActivityDateTime = System.now(), DurationInMinutes = 60, Event_Type__c = 'Visit Report');
        insert evt2;

        Visit_Report__c vr2 = new Visit_Report__c(Account__c = objAccount.Id, Event_ID__c = evt2.Id);
        insert vr2;
        
        evt2.WhatId = null;
        evt2.WhoId = ld.id;
        update evt2;
        
        Event evt3 = new Event(WhatId = opp.Id, RecordTypeId = KSDServiceRecordTypeID, StartDateTime = System.now(), EndDateTime = System.now().AddDays(1), Event_Type__c = 'Paid Mill Visit', Product__c = 'Blades');
        insert evt3;
        evt3.EndDateTime = System.now().AddDays(2);
        update evt3;

    }
}