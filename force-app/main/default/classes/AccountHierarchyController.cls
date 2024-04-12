public class AccountHierarchyController {

    @AuraEnabled
    public static Boolean hasParent(String accountId) {
        List<Account> listAccounts = [SELECT ParentId FROM Account WHERE Id = :accountId LIMIT 1];
        Account acct = listAccounts[0];
        return acct.ParentId != null;
    }

    @AuraEnabled
    public static Integer numChildren(String accountId) {
        List<Account> listAccounts = [SELECT Id FROM Account WHERE ParentId = :accountId];
        return listAccounts.size();
    }
}