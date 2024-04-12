global class UpdateBladeCabinetInventoryMinimumsBatch implements Database.Batchable<sObject> {

    global String q;
    global String strBladeCabinetID;
    global String strAccountID;
 
    global UpdateBladeCabinetInventoryMinimumsBatch(Id bladeCabinetID, Id accountID)
    {
        Blade_Cabinet_Inventory_Detail__c[] bcid = [SELECT Id FROM Blade_Cabinet_Inventory_Detail__c WHERE Blade_Cabinet__c = :bladeCabinetID];
        delete bcid;
        if(!bcid.isEmpty())
            Database.emptyRecycleBin(bcid);

        strBladeCabinetID = bladeCabinetID;
        strAccountID = accountID;
        q = 'Select Part_Number__c From Blade_Cabinet_Inventory__c Where Blade_Cabinet__c  = \'' + bladeCabinetID + '\'';
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope)
    {
        for (Blade_Cabinet_Inventory__c bci : (List<Blade_Cabinet_Inventory__c>)scope)
        {
            UpdateBladeCabinetInventoryMinimums u = new UpdateBladeCabinetInventoryMinimums();
            u.updateMe(strBladeCabinetID, bci.Part_Number__c);
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        try
        {
            // Get the AsyncApexJob that represents the Batch job using the Id from the BatchableContext  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,  
                TotalJobItems, CreatedBy.Email, ExtendedStatus  
                from AsyncApexJob where Id = :bc.getJobId()];  
   
            // Email the Batch Job's submitter that the Job is finished.
            if(a.NumberOfErrors > 0)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('UpdateBladeCabinetInventoryMinimums status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }

        UpdateBladeCabinetInventoryDetailsBatch ass = new UpdateBladeCabinetInventoryDetailsBatch(strBladeCabinetID, strAccountID);
        database.executebatch(ass, 1);

    }
}