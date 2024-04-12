public with sharing class MainAlarmPanelHelper {
	public static List<Account> getAccounts(Set<Id> accountIds) {
        List<Account> accounts = new List<Account>();
        
        for(Account acc : [SELECT Id, Name FROM Account WHERE Id IN :accountIds]) {
            accounts.add(acc);
        }
        
        return accounts;
    }
}