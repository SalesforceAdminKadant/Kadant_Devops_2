@isTest(SeeAllData=True)
public without sharing class TestSyncAccountDivisionBatchClass 
{
    static testMethod void testcontact()
    {
        Account objAccount = [select ParentId from Account Where ParentId != Null And RecordType.Name = 'Ship-To Account' And No_of_Account_Division_Records__c > 0 LIMIT 1];
        Database.executeBatch(new SyncAccountDivisionRecordsWithAccount(objAccount.ParentId, True, Null), 50);
        Database.executeBatch(new SyncAccountDivisionRecordsWithAccount(objAccount.ParentId, False, Null), 50);
    }
}