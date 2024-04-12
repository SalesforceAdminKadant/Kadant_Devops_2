global class SyncAccountDivisionRecordsWithAccount implements Database.Batchable<sObject> {

    Global Id gACCT;
    Global Boolean gCREDITHOLD;
    Global String gCREDITHOLDREASON;

    Global SyncAccountDivisionRecordsWithAccount(Id acct, Boolean credithold, String creditholdreason)
    {
        gACCT = acct;
        gCREDITHOLD = credithold;
        gCREDITHOLDREASON = creditholdreason;
    }

    public class FlowInputs
    {
        @InvocableVariable public List<Id> AcctId;
        @InvocableVariable public List<Boolean> CreditHold;
        @InvocableVariable public List<String> CreditHoldReason;
    }

    @invocablemethod
    public static void SyncAccountDivisionRecordsWithAccount(List<FlowInputs> requests)
    {
        List<Id> acctlist = new List<Id>();
        List<Boolean> creditholdlist = new List<Boolean>();
        List<String> creditholdreasonlist = new List<String>();

        for(FlowInputs req : requests)   
        {
            acctlist.addAll(req.AcctId);
            creditholdlist.addAll(req.CreditHold);
            creditholdreasonlist.addAll(req.CreditHoldReason);
        }

        for (Integer i = 0; i < acctlist.size(); i++) {
            Id jobId = Database.executeBatch(new SyncAccountDivisionRecordsWithAccount(acctlist[i], creditholdlist[i], creditholdreasonlist[i]), 50);
        }

    }

    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        Boolean boolCreditHold = gCREDITHOLD;
        String query = 'SELECT ID, CREDIT_HOLD__C, CREDIT_HOLD_REASON__C FROM ACCOUNT_DIVISION__C WHERE ACCOUNT__R.PARENTID = :gACCT AND ACCOUNT__R.RECORDTYPE.NAME = \'Ship-To Account\' AND CREDIT_HOLD__C != :boolCreditHold';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account_Division__c> scope)
    {
         for(Account_Division__c ad : scope){
             ad.Credit_Hold__c = gCREDITHOLD;            
             ad.Credit_Hold_Reason__c = gCREDITHOLDREASON;            
         }
         if (scope.size() > 0)
             update scope;
    }

   public void finish(Database.BatchableContext BC)
   {

   }

}