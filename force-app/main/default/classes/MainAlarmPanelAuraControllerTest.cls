@isTest
public class MainAlarmPanelAuraControllerTest {
    static testmethod void myUnitTest(){
        Id p = [select id from profile where name LIKE '%Community%' LIMIT 1].id;
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Asset ass = new Asset();
        ass.Name = 'test asset';
        ass.AccountId = acc.Id;        
        ass.Site_ID__c = 1234132;
        ass.Division__c = 'KJ';
        insert ass;
        
        Contact con = new Contact();
        con.FirstName = 'test'; 
        con.LastName = 'testington';
        con.Email = 'testington@sfdc.com';
        con.AccountId = acc.Id;
        insert con;
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
       
        insert user;
        
        
        Rule__c r = new Rule__c();
        r.RuleMachineKey__c='1234d';
        r.ExternalId__c='abcd123';
        r.Asset__c = ass.Id;
        insert r;
        
        Rule_Detail__c rd = new Rule_Detail__c();
        rd.Name = 'test';
        rd.Rule__c = r.Id;
        insert rd;
        
        System.runAs(user) { 
            List<Account> accounts = MainAlarmPanelAuraController.getAccounts();
        	system.assert(accounts.size() > 0);
            MainAlarmPanelAuraController.getAssets(accounts[0].Id);
            try {
                MainAlarmPanelAuraController.getData(ass.Id);
            } catch(Exception ex) {
                system.debug(ex.getMessage());
            }
        	
        }
        MainAlarmPanelAuraController.getRules(ass.Id);
        MainAlarmPanelAuraController.getRuleDetails(r.Id);
        
        MainAlarmPanelAuraController.getSortedRules('ASC', ass.Id);
        MainAlarmPanelAuraController.getSortedRules('DESC', ass.Id);
        MainAlarmPanelAuraController.headerData header = new MainAlarmPanelAuraController.headerData();
        header.clientName = '';
        header.clientLocation = '';
        header.assetName = '';
        header.userTimezone = '';
        header.assetTimezone = '';
    }
}