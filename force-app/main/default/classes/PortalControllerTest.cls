@IsTest(SeeAllData=true)
public class PortalControllerTest {

    @IsTest(SeeAllData=true)
    static void getRepairList() {

        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u){
            Test.startTest();
            List<Rotor_Repair_Status__c> rs = PortalController.getRotorRepairList();
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getSingleRepair() {
        Rotor_Repair_Status__c rotorRepair = [SELECT Id FROM Rotor_Repair_Status__c LIMIT 1];

        Test.startTest();
        Rotor_Repair_Status__c rs1 = PortalController.getRotorRepair(rotorRepair.Id);
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    static void getOrderList() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u) {
            Test.startTest();
            List<Order> orders = PortalController.getOpenOrders(account.Id);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getOrderHistory() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        Test.startTest();        
        List<Order> testOrders = PortalController.getOrderHistory(account.Id);
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    static void getQuoteHistory() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        Test.startTest();        
        List<Quote> testQuotes = PortalController.getQuoteHistory(account.Id);
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    static void getServiceReportList() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test'];

        System.runAs(u) {
            Test.startTest();
            List<Service_Report__c> srs = PortalController.getServiceReports(account.Id);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getAccountTest() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u) {
            Test.startTest();
            Account accountDetail = PortalController.getAccountShippingAddress(account.Id);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getUserTest() {

        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u) {
            Test.startTest();
            User usr2 = PortalController.getDsm(u.Id);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getOpenServiceTopics() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u){
            Test.startTest();
            List<Service_Topic_Item__c> sri = PortalController.getOpenServiceTopics(account.Id, 10);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getUserRelatedAccounts() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u){
            Test.startTest();
            List<PortalController.CurrentUserRelatedAccounts> results = PortalController.getUserRelatedAccounts();
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getOpenQuotes() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u){
            Test.startTest();
            List<Quote> quotes = PortalController.getOpenQuotes(account.Id);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getMachines() {

        Machine_Section__c mac = [Select Machine__r.Account__c From Machine_Section__c Where Name = 'Fourdrinier' Limit 1];
        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = mac.Machine__r.Account__c
        );
        insert contact;        

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = mac.Machine__r.Account__c;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        System.runAs(u){
            Test.startTest();
            List<PortalController.MachineWrapper> macs = PortalController.getMachines(mac.Machine__r.Account__c);
            Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void getQuoteFile() {
        Account account = new Account(
            Name = 'Test Account RRS'
        );
        insert account;

        Account account2 = new Account(
            Name = 'Test Account RRS2'
        );
        insert account2;

        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Employment_Status__c=null,
                AccountId = account.Id
        );
        insert contact;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = contact.Id,
            AccountId = account2.Id
        );
        insert acr;

        //Create Community User
        Id profileId = [SELECT Id FROM Profile WHERE Name ='Customer Community Plus User - Standard'].Id;
        User communityUser = createUser('', profileId, 'Community User', 'Test');
        communityUser.ContactId = contact.Id;
        communityUser.Portal_Account_Selection__c = account.Id;
        insert communityUser;

        User u = [SELECT Id FROM User WHERE Name = 'Community User Test' LIMIT 1];

        Quote quote = [SELECT Id FROM Quote LIMIT 1];

        System.runAs(u){
            Test.startTest();
            String result = PortalController.getQuoteFile(quote.Id);
            Test.stopTest();

            System.debug(result != null);
        }
    }

    @IsTest(SeeAllData=true)
    static void getDrawingFileInternal1() {        
        Drawing__c draw = [SELECT Id FROM Drawing__c Where Type__c = 'Assembly' And Division__c = 'KSD' LIMIT 1];
       
        Test.startTest();
        String result = PortalController.getDrawingFileInternal(draw.Id);
        Test.stopTest();       
    }

    @IsTest(SeeAllData=true)
    static void getDrawingFileInternal2() {
        Drawing__c draw1 = new Drawing__c(
            Division__c = 'KSD',
            Name = 'Test Drawing 1',
            Title__c = 'Test Drawing'
        );
        insert draw1;
       
        Test.startTest();
        String result = PortalController.getDrawingFileInternal(draw1.Id);
        Test.stopTest();       
    }

    @IsTest(SeeAllData=true)
    static void getQuoteDisplayData() {

        Quote quote = [SELECT Id, Account__c FROM Quote WHERE Division__c = 'KSD' Order by CreatedDate DESC LIMIT 1];    

        Test.startTest();
        List<PortalController.QuoteWrapper> result = PortalController.getQuoteDisplayData(quote.Account__c);
        Test.stopTest();  
    }    

    @IsTest(SeeAllData=true)
    static void getDrawings() {

        Quote quote = [SELECT Id, Account__c FROM Quote WHERE Division__c = 'KSD' Order by CreatedDate DESC LIMIT 1]; 

        Test.startTest();
        List<Drawing__c> result = PortalController.getDrawings(quote.Account__c);
        Test.stopTest();  
    } 

    private static User createUser(String roleId, String profId, String firstName, String lastName) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tempUser = new User(
                FirstName = firstName,
                LastName = lastName,
                email = uniqueName + '@sfdc' + orgId + '.org',
                Username = uniqueName + '@sfdc' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = profId
        );
        if (String.isBlank(roleId) == false) {
            tempUser.UserRoleId = roleId;
        }
        return tempUser;
    }
}