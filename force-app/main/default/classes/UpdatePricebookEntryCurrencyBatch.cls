global class UpdatePricebookEntryCurrencyBatch implements Database.Batchable<sObject> {

    global String q;
    global Boolean boolRun;
    global String strPSGE = 'PSG-E Product%';
 
    global UpdatePricebookEntryCurrencyBatch() {    
                
        Period[] p = [Select Id From Period Where Type = 'Month' And StartDate = :Date.Today()];
        if(!p.IsEmpty())
        {
            boolRun = True;
        }else{
            boolRun = False;
        }        

        q = 'SELECT Id, Product2Id, CurrencyIsoCode, UnitPrice, Product2.RecordType.Name FROM PricebookEntry Where Primary_Currency__c = True And Product2.RecordType.Name Like :strPSGE';
        
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        if(boolRun == True)
        {
            Pricebook2 pb = [Select Id From Pricebook2 Where Name = 'Kadant Europe Price Book' LIMIT 1];

            for (PricebookEntry pbe : (List<PricebookEntry>)scope) {
                UpdatePricebookEntryCurrency upbec = new UpdatePricebookEntryCurrency();
                upbec.updateMe(pbe.Product2Id, pb.Id, pbe.Product2.RecordType.Name);
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        if(boolRun == True)
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
                    mail.setSubject('UpdatePricebookEntryCurrencyBatch status: ' + a.Status);
                    mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus);

                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            catch(Exception e)
            {
            }
        }
    }

}