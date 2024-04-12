global class UpdateBladeCabinetInventory implements Database.Batchable<sObject>
{
    global String q;
    global Id strBladeCabinetID;
    global Id strAccountID;
    
    global UpdateBladeCabinetInventory(Id bcID, Id accountID)
    {
        strBladeCabinetID = bcID;
        strAccountID = accountID;
        q = 'SELECT Id, Product__c, Order_Product__c, Part_Number__c, Order_Number__c FROM Blade_Cabinet_Inventory__c WHERE Blade_Cabinet__c = \'' + bcID + '\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(q);
    }

    global void execute(Database.BatchableContext BC, List<Blade_Cabinet_Inventory__c> scope)
    {
        boolean boolUpdated = false;

        for(Blade_Cabinet_Inventory__c bci : scope)
        {
            if(bci.Part_Number__c != null)
            {
                Product2[] prod = [Select Id, Description, Blade_Quick_Identifier__c From Product2 Where Location__c = 'KSD' And Name = :bci.Part_Number__c Limit 1];
                if(prod.size() > 0)
                {
                    bci.Product__c = prod[0].Id;
                    bci.Part_Description__c = prod[0].Description;
                    bci.Quick_Identifier__c = prod[0].Blade_Quick_Identifier__c;
                }
            }

            if(bci.Order_Number__c != null && bci.Order_Number__c.Length() >= 8 && bci.Order_Number__c.Length() <= 9 && bci.Order_Number__c.isNumeric())
            {
                String strLineNo;
                if(bci.Order_Number__c.Length() == 8)
                    strLineNo = bci.Order_Number__c.mid(6, 1) + '.' + bci.Order_Number__c.mid(7, 1);
                else
                    strLineNo = bci.Order_Number__c.mid(6, 2) + '.' + bci.Order_Number__c.mid(8, 1);
                OrderItem[] oi = [Select Id, Customer_Item_Number__c From OrderItem Where Order.Division__c = 'KSD' And Order.Name = :bci.Order_Number__c.mid(0, 6) And Line_No__c = :decimal.valueOf(strLineNo) Limit 1];
                if(oi.size() > 0)
                {
                    bci.Customer_Item_Number__c = oi[0].Customer_Item_Number__c;
                    bci.Order_Product__c = oi[0].Id;
                    boolUpdated = true;
                }
            }
            if(bci.Part_Number__c != null && boolUpdated == false)
            {
                Machine_Mapping_Doctor__c[] mmd = [Select Id, Blade_Customer_Item_Number__c From Machine_Mapping_Doctor__c Where Machine_Section__r.Machine__r.Account__c = :strAccountID And Blade_Kadant_Item_Number__c = :bci.Part_Number__c And Blade_Customer_Item_Number__c != Null Limit 1];
                if(mmd.size() > 0)
                {
                    bci.Customer_Item_Number__c = mmd[0].Blade_Customer_Item_Number__c;
                }
            }
            update bci;
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        UpdateBladeCabinetInventoryMinimumsBatch bci = new UpdateBladeCabinetInventoryMinimumsBatch(strBladeCabinetID, strAccountID);
        database.executebatch(bci, 1);

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
                mail.setSubject('UpdateBladeCabinetInventory status: ' + a.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception e)
        {
        }
    }
}