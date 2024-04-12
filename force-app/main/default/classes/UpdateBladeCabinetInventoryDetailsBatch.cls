global class UpdateBladeCabinetInventoryDetailsBatch implements Database.Batchable<sObject> {

    global String q;
    global String strBladeCabinetID;
    global String strAccountID;
 
    global UpdateBladeCabinetInventoryDetailsBatch(Id bladeCabinetID, Id accountID)
    {
        strBladeCabinetID = bladeCabinetID;
        strAccountID = accountID;
        q = 'Select Id, Name From Blade_Cabinet_Inventory_Minimum__c Where Blade_Cabinet__c  = \'' + bladeCabinetID + '\'';
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope)
    {
        for (Blade_Cabinet_Inventory_Minimum__c bcim : (List<Blade_Cabinet_Inventory_Minimum__c>)scope)
        {
            UpdateBladeCabinetInventoryDetails u = new UpdateBladeCabinetInventoryDetails();
            u.updateMe(strBladeCabinetID, strAccountID, bcim.Id, bcim.Name);
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
                mail.setSubject('UpdateBladeCabinetInventoryDetails status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
    }
}