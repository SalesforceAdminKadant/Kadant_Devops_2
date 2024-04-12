global class UpdatePriceAgreementDetailBatch implements Database.Batchable<sObject> {

    global String q;
    global String strPADID;
 
    global UpdatePriceAgreementDetailBatch(id strID) {    
        
        if(strID == null)
        {
            q = 'SELECT Id, Price_Agreement_Header__r.Account__c, Product__c FROM Price_Agreement_Detail__c Where Price_Agreement_Header__r.Status__c IN(\'Draft\',\'Approved\')';
        }else{
            strPADID = strID;
            q = 'SELECT Id, Price_Agreement_Header__r.Account__c, Product__c FROM Price_Agreement_Detail__c Where Id = \'' + strID + '\' AND Price_Agreement_Header__r.Status__c IN(\'Draft\',\'Approved\')';
            KadantHelperClasses.sendPlainTextEmail('david.leland@kadant.com','Test',q);
        }
        
        if(Test.isRunningTest())
            q = q + ' ' + 'LIMIT 1';

    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(q);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (Price_Agreement_Detail__c a : (List<Price_Agreement_Detail__c>)scope) {
            UpdatePriceAgreementDetail upad = new UpdatePriceAgreementDetail();
            upad.updateMe(a.id, a.Price_Agreement_Header__r.Account__c, a.Product__c);
        }
    }
    
    global void finish(Database.BatchableContext bc) {

        if(strPADID != null)
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
                    mail.setSubject('UpdatePriceAgreementDetailBatch status: ' + a.Status);
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