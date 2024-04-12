trigger TaskTrigger on Task (before insert, before update, after insert, after update, before delete, after delete) {

    //Before trigger
    if(trigger.isBefore){
        if(trigger.isInsert){
            initializeBeforeValues(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, 'Insert');
        }
        if(trigger.isUpdate){
            initializeBeforeValues(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, 'Update');
        }
    }

    //After trigger
    if(trigger.isAfter){
        if(trigger.isInsert){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }
        if(trigger.isUpdate){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
        }
    }

    //Following method is to do before stuff
    private static void initializeBeforeValues(list<Task> lstTasksNew, list<Task> lstTasksOld, map<Id,Task> mapTasksNew, Map<Id,Task> mapTasksOld, String strOperation){

        for(Task tsk : lstTasksNew){
            if(!trigger.isDelete)
            {
                //If an Opportunity, populate the Opportunity__c field
                if(tsk.WhatId != null && tsk.WhatId__c.startsWith('006'))
                {
                    tsk.Opportunity__c = tsk.WhatId;
                    if(tsk.Related_to__c == null)
                        tsk.Related_to__c = 'Opportunity';
                }

                //If an Order, populate the Order__c field
                if(tsk.WhatId != null && tsk.WhatId__c.startsWith('80'))
                {
                    tsk.Order__c = tsk.WhatId;
                    if(tsk.Related_to__c == null)
                        tsk.Related_to__c = 'Order';
                }

                //If a Lead, populate the Lead_c field
                if(tsk.WhoId != null && tsk.WhoId__c.startsWith('00Q'))
                {
                    tsk.Lead__c = tsk.WhoId;
                    if(tsk.Related_to__c == null)
                        tsk.Related_to__c = 'Lead';
                }

                if(trigger.isInsert)
                {
                    if(tsk.Status == 'Deferred' && tsk.Owner_Name__c == 'Salesforce Admin')
                    {
                        Quote[] q = [Select Id, OwnerId, Owner.Username From Quote Where Id = :tsk.WhatId LIMIT 1];
                        if(!q.isEmpty())
                        {
                            tsk.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Task').getRecordTypeId();
                            if(q[0].Owner.Username != 'salesforce.admin@kadant.com')
                            {
                                tsk.OwnerId = q[0].OwnerId;
                                tsk.Status = 'Not Started';
                            }
                            else
                                tsk.Status = 'Completed';
                        }
                    }
                }
            }
        }

    }

    //Following method is to do after stuff
    private static void doAfterStuff(list<Task> lstTasksNew, map<Id,Task> mapTasksNew, Map<Id,Task> mapTasksOld, String strOperation){
    
        List<Task> lstTasks = new List<Task>();//List of Tasks that are synced and can be removed
        List<Quote> lstQuotes = new List<Quote>();
        List<Sample_Request__c> lstSamples = new List<Sample_Request__c>();
        for(Task tsk : lstTasksNew){
            if(trigger.isUpdate)
            {
                if(tsk.Status == 'Completed' && mapTasksOld.get(tsk.Id).Status != 'Completed')
                {
                    if(tsk.WhatId != null && tsk.WhatId.getSObjectType().getDescribe().getName() == 'Quote' && tsk.Subject == 'Send Quote to Customer')
                    {
                        Quote[] qs = [Select Id, OwnerId From Quote Where Id = :tsk.WhatId And (NOT Status in('Presented','Won','Lost','Canceled')) LIMIT 1];
                        if(!qs.isEmpty())
                        {
                            qs[0].Status = 'Presented';
                            lstQuotes.add(qs[0]);
                        }
                    }
                    if(tsk.WhatId != null && tsk.WhatId.getSObjectType().getDescribe().getLabel() == 'Sample Request')
                    {
                        Sample_Request__c[] sr = [Select Id, Status__c From Sample_Request__c Where Id = :tsk.WhatId And Status__c != 'Completed' LIMIT 1];
                        if(!sr.isEmpty())
                        {
                            sr[0].Status__c = 'Completed';
                            lstSamples.add(sr[0]);
                        }
                    }
                }
                // Remove any other synced tasks
                if(tsk.Status == 'Completed' && mapTasksOld.get(tsk.Id).Status != 'Completed' && tsk.Task_Sync_ID__c != null)
                {
                    for(Task objTask : [SELECT Id
                        FROM Task
                        WHERE Task_Sync_ID__c = :tsk.Task_Sync_ID__c And Id != :tsk.Id])
                    {
                        if (!lstTasks.contains(objTask))
                            lstTasks.add(objTask);
                    }
                }
            }
            
            //Send out of office notification, if needed
            if(!trigger.isDelete && tsk.Creator_Name__c != 'Salesforce Admin' && tsk.OwnerId != tsk.CreatedById && ((trigger.isInsert) || (trigger.isUpdate && tsk.OwnerId != mapTasksOld.get(tsk.Id).OwnerId)))
            {
                OutOfOffice[] ooo = [SELECT Id, EndDate FROM OutOfOffice WHERE UserId = :tsk.OwnerId And IsEnabled = True And Day_Only(StartDate) <= :Date.Today() And Day_Only(EndDate) >= :Date.Today() Limit 1];
                if(ooo.size() > 0)
                {
                    KadantHelperClasses.sendPlainTextEmailToUser(tsk.CreatedById, 'Out of office notification', 'Hello ' + tsk.Creator_Name__c + '.  The person (' + tsk.Owner_Name__c + ') you have just assigned a task to is out of the office until ' + ooo[0].EndDate.Format('yyyy-MM-dd') + '.  The task will remain assigned to that person unless you re-assign it to someone else.');
                }
            }
        }

        try
        {
            if(!lstQuotes.isEmpty())
                Update lstQuotes;
        }
        catch(Exception ex1)
        {
            try
            {
                if(!lstQuotes.isEmpty())
                    Update lstQuotes;
            }
            catch(Exception ex2)
            {
            }
        }
        if(!lstSamples.isEmpty())
            Update lstSamples;
        if(!lstTasks.isEmpty())
            Delete lstTasks;

    }
    
}