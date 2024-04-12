public without sharing class PortalController {
    @AuraEnabled(cacheable=true)
    public static List<Rotor_Repair_Status__c> getRotorRepairList() {
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT Id,
                        Name,
                        Account_Name__c,
                        Status__c,
                        RMA__c,
                        Order_Number__c,
                        Shipped_Date__c,
                        Tracking_Number__c
                        FROM Rotor_Repair_Status__c
                        WHERE Account__c =:portalAccountId];
    }

    @AuraEnabled(cacheable=true)
    public static Rotor_Repair_Status__c getRotorRepair(String id) {
        return [SELECT Id, Name, Account_Name__c, Status__c, RMA__c, Order_Number__c, Shipped_Date__c, Tracking_Number__c, Carrier__c FROM Rotor_Repair_Status__c WHERE Id = :id LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Order> getOpenOrders(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT Id,
                        Name,
                        PoNumber,
                        EffectiveDate,
                        Order_Owner__c,
                        OrderNumber,
                        TotalAmount,
                        Division__c,
                        (SELECT Id, Line_No__c, Quantity, Our_Item_Number__c, Description, Scheduled_Ship_Date__c, TotalPrice, Portal_Tracking__c FROM OrderItems ORDER BY Line_No__c)
                        FROM Order
                        WHERE AccountId = :portalAccountId
                            AND Status NOT IN ('Closed', 'Entered')
                            ORDER BY EffectiveDate DESC];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrderHistory(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT  Id,
                        Name,
                        PoNumber,
                        EffectiveDate,
                        Order_Owner__c,
                        OrderNumber,
                        TotalAmount,
                        Portal_Tracking__c,
                        Last_Ship_Date__c,
                        Division__c,
                        (SELECT Id, Line_No__c, Quantity, Our_Item_Number__c, Description, TotalPrice, Portal_Tracking__c FROM OrderItems ORDER BY Line_No__c)
                        FROM Order
                        WHERE AccountId = :portalAccountId
                            AND Status = 'Closed'
                            AND EffectiveDate >= LAST_N_DAYS:90
                            ORDER BY CreatedDate DESC LIMIT 200];
    }
 
    @AuraEnabled(cacheable=true)
    public static List<Quote> getOpenQuotes(String acctId) {
        //return [SELECT Id, Opportunity.Id, Name, Opportunity.Name, Quote_Number__c, Quote_Date__c, ExpirationDate, Quote_Total__c FROM Quote WHERE Account__c = '0013000000DK6EPAA1' ORDER BY CreatedDate DESC LIMIT 10];
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT  Id,
                        Name,
                        Quote_Number__c,
                        Quote_Date__c,
                        ExpirationDate,
                        Quote_Total__c
                        FROM Quote
                        WHERE Account__c =: portalAccountId
                        AND Opportunity.Open__c = True
                        ORDER BY CreatedDate DESC];
    }

    @AuraEnabled(cacheable=true)
    public static List<Quote> getQuoteHistory(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT Id, 
                        Name, 
                        Opportunity.Name,
                        Quote_Total__c,
                        (SELECT Id, Line_No__c, Quantity, Product_Name__c, Description, TotalPrice FROM QuoteLineItems ORDER BY LineNumber)
                        FROM Quote 
                        WHERE Account__c = :portalAccountId 
                        AND Opportunity.Open__c = False AND Quote_Date__c >= LAST_N_DAYS:90 ORDER BY CreatedDate DESC LIMIT 200];
    }

    @AuraEnabled(cacheable=true)
    public static List<MachineWrapper> getMachines(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        List<MachineWrapper> macWrap = new List<MachineWrapper>();        
        
        List<Machine__c> macs = [SELECT Id, Name, Grade_Category__c, Primary_Grade__c, Machine_Status__c FROM Machine__c WHERE Account__c = :portalAccountId ORDER BY Name LIMIT 5];                        
        if (!macs.isEmpty())
        {
            for (Machine__c mac : macs)
            {                    
                List<Machine_Section__c> sections = [SELECT Id, Name, Section_Type__c, Configuration__c FROM Machine_Section__c WHERE Machine__c = :mac.Id ORDER BY Sequence__c LIMIT 10];
                List<MacSection> msecs = new List<MacSection>();
                if (!sections.isEmpty())
                {
                    for (Machine_Section__c sec : sections)
                    {
                        MacSection ms = new MacSection();
                        ms.sectionId = sec.Id;
                        ms.sectionName = sec.Name;
                        ms.sectionType = sec.Section_Type__c;
                        ms.sectionConfig = sec.Configuration__c;
                        ms.sfUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/KadantAccessPortal/apex/Machine_Section_MapReadOnly?id=' + sec.Id;
                        msecs.add(ms);
                    }
                }                   
                MachineWrapper objWrap = new MachineWrapper(mac.Id, mac.Name, mac.Grade_Category__c, mac.Primary_Grade__c, mac.Machine_Status__c, msecs);
                macWrap.add(objWrap);
            }                
        }        
        return macWrap;
    }

    @AuraEnabled(cacheable=true)
    public static List<Service_Report__c> getServiceReports(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT  Id,
                        Name,
                        Machine__r.Name,
                        Visit_Date__c,
                        Objective__c
                        FROM Service_Report__c
                        WHERE Account__c = :portalAccountId
                        AND Status__c = 'Approved'
                        ORDER BY Visit_Date__c DESC
                        LIMIT 10];
    }

    @AuraEnabled (cacheable=true)
    public static Account getAccountShippingAddress(String id){
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT  Id,
                        Name,
                        ShippingAddress,
                        KSD_DSM__c
                        FROM Account
                        WHERE Id =:portalAccountId];                        
    }

    @AuraEnabled (cacheable=true)
    public static User getDsm(String id){
        return [SELECT Id, Name, Email, MobilePhone FROM User WHERE Id = :id];       
    }

    @AuraEnabled (cacheable=true)
    public static string getDrawingFileInternal(String id){
        String cvgId = 'No CV!';        
        List<ContentDocumentLink> docLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :id];
        list<id> ids = new list<id>();
        for(ContentDocumentLink a : docLink){
            ids.add(a.ContentDocumentId); 
        }
        if (!docLink.isEmpty())
        {
            // now go and get the actual SVG file ID that gets used in the Visual Force page
            ContentVersion[] cvId = [SELECT Id FROM ContentVersion 
                    WHERE ContentDocumentId IN :ids AND PublishStatus = 'P' AND IsLatest = true AND IsDeleted = false 
                    ORDER BY LastModifiedDate DESC LIMIT 1];
            if (!cvId.isEmpty())
            {
                //cvgId = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + cvId[0].Id;
                cvgId = cvId[0].Id;
            }
        }
        else {
            cvgId = 'No CDL';
        }        
        return cvgId;
    }

    @AuraEnabled (cacheable=true)
    public static string getQuoteFile(String id){
        String cvgId = 'No CV!';
        
        // Go and Get the Opportuntiy record ID to pass to the Content Document
        List<Quote> quotes = [SELECT OpportunityId, Name FROM Quote WHERE Id = :id LIMIT 1];
        if (!quotes.isEmpty())
        {
            List<ContentDocumentLink> docLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :quotes[0].OpportunityId];
            String quoteName = '%' + quotes[0].Name + '%';
            list<id> ids = new list<id>();
            for(ContentDocumentLink a : docLink){
                ids.add(a.ContentDocumentId); 
            }
            if (!docLink.isEmpty())
            {
                // now go and get the actual SVG file ID that gets used in the Visual Force page
                ContentVersion[] cvId = [SELECT Id FROM ContentVersion 
                        WHERE ContentDocumentId IN :ids AND PublishStatus = 'P' AND IsLatest = true AND IsDeleted = false 
                        AND Title LIKE :quoteName ORDER BY LastModifiedDate DESC LIMIT 1];
                if (!cvId.isEmpty())
                {
                    cvgId = URL.getSalesforceBaseUrl().toExternalForm() + '/KadantAccessPortal/sfc/servlet.shepherd/version/download/' + cvId[0].Id;
                    //cvgId = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + cvId[0].Id;
                }
            }
            else {
                cvgId = 'No CDL';
            }
        }
        else {
            cvgId = 'No Quotes found';
        }        
        return cvgId;
    }
 
    @AuraEnabled (cacheable=true)
    public static List<Service_Topic_Item__c> getOpenServiceTopics(String acctId, Integer maxRecords){
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT  Id,
                        Machine__c,
                        CreatedDate,
                        Position__c,
                        Priority__c,
                        Topic__c,
                        Customer_Action_Summary__c,
                        Status__c,
                        Service_Report_Item__r.Service_Report__r.Name, 
                        Service_Report_Item__r.Service_Report__r.Id
                        FROM Service_Topic_Item__c
                        WHERE Service_Report_Item__r.Service_Report__r.Account__c = :portalAccountId
                        AND Service_Report_Item__r.Service_Report__r.Id != null
                        AND Status__c = 'Open'
                        ORDER BY Priority__c, CreatedDate DESC
                        LIMIT :maxRecords];
    }

    @AuraEnabled (cacheable=true)
    public static List<CurrentUserRelatedAccounts> getUserRelatedAccounts(){
        List<CurrentUserRelatedAccounts> allRelatedAccounts = new List<CurrentUserRelatedAccounts>();
        String userCurrentAccountSelection = '';

        User currentUser = [SELECT Id, ContactId, Portal_Account_Selection__c FROM User WHERE Id =:UserInfo.getUserId()];
        userCurrentAccountSelection = currentUser.Portal_Account_Selection__c;

        if(String.isBlank(userCurrentAccountSelection)){
            userCurrentAccountSelection = [SELECT AccountId FROM AccountContactRelation WHERE ContactId =:currentUser.ContactId AND IsDirect = TRUE]?.AccountId;
            if(String.isNotBlank(userCurrentAccountSelection)){
                currentUser.Portal_Account_Selection__c = userCurrentAccountSelection;
                update currentUser;
            }
        }

        for(AccountContactRelation acr : [SELECT Id, AccountId, Account.Account_and_Site__c FROM AccountContactRelation WHERE ContactId =:currentUser.contactId]){
            CurrentUserRelatedAccounts relatedAccount = new CurrentUserRelatedAccounts();
            relatedAccount.accountId = acr.AccountId;
            relatedAccount.accountName = acr.Account.Account_and_Site__c;
            relatedAccount.isCurrentPortalSelectedAccount = acr.AccountId == userCurrentAccountSelection ? true : false;
            allRelatedAccounts.add(relatedAccount);
        }

        return allRelatedAccounts;
    }

    public class CurrentUserRelatedAccounts {
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public Boolean isCurrentPortalSelectedAccount;
    }

    private static String getUserPortalSelectedAccount(){
        user u = [SELECT Id, Name, Profile.Name, Portal_Account_Selection__c FROM User WHERE Id =: UserInfo.getUserId()];
        return [SELECT Portal_Account_Selection__c FROM User WHERE Id =:UserInfo.getUserId()]?.Portal_Account_Selection__c;
    }

    @AuraEnabled (cacheable=true)
    public static List<QuoteWrapper> getQuoteDisplayData(String acctId){
        //'0013000000DK6MGAA1';
        String portalAccountId = getUserPortalSelectedAccount();
        List<QuoteWrapper> listWrap = new List<QuoteWrapper>();        
        try {
            // Go and Get the Opportuntiy record ID to pass to the Content Document
            List<Quote> quotes = [SELECT Id, Name, OpportunityId, Opportunity.Name, Quote_Number__c, ExpirationDate, Quote_Total__c FROM Quote WHERE Account__c = :portalAccountId AND Opportunity.Open__c = True ORDER BY CreatedDate DESC];                        
            if (!quotes.isEmpty())
            {
                for (Quote quot : quotes)
                {
                    String theUrl = '';
                    Boolean exists = true;
                    List<ContentDocumentLink> docLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :quot.Id];
                    String quoteName = '%' + quot.Name + '%';
                    String stat = 'Active';
                    Date startDate = System.today();
                    Boolean expired = false;
                    Integer days = 0;
                    if (quot.ExpirationDate != null)
                    {
                        days = quot.ExpirationDate.daysBetween(startDate);
                    }
                    if (days >= 30)
                    {
                        stat = 'Expired';
                        expired = true;
                    }
                    list<id> ids = new list<id>();                    
                    for(ContentDocumentLink cdl : docLink){
                        ids.add(cdl.ContentDocumentId); 
                    }
                    if (!docLink.isEmpty())
                    {                        
                        // now go and get the actual SVG file ID that gets used in the Visual Force page
                        // removed for testing!!!  = AND PublishStatus = 'P' AND IsLatest = true AND IsDeleted = false 
                        ContentVersion[] cvId = [SELECT Id FROM ContentVersion 
                                WHERE ContentDocumentId IN :ids AND PublishStatus = 'P' AND IsLatest = true AND IsDeleted = false 
                                AND Title LIKE :quoteName ORDER BY LastModifiedDate DESC LIMIT 1];
                        if (!cvId.isEmpty())
                        {
                            //theUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/ContentDocument/' + cdlId + '/view';                     
                            theUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/KadantAccessPortal/sfc/servlet.shepherd/version/download/' + cvId[0].Id;                     
                            //cvgId = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + cvId[0].Id;
                        }
                        else 
                        {
                            exists = false;
                            theUrl = 'no CV!';    
                        }
                    }  
                    else
                    {
                        exists = false;                        
                        theUrl = 'no CD!';
                    }                      
                    QuoteWrapper objWrap = new QuoteWrapper(quot.id, quot.Name, quot.Opportunity.Name, expired, stat, quot.Quote_Total__c, theUrl, exists);
                    listWrap.add(objWrap);
                }                
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return listWrap;
    } 

    @AuraEnabled(cacheable=true)
    public static List<Drawing__c> getDrawings(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        return [SELECT Id, Name, Title__c, Category__c, Machine__r.Name FROM Drawing__c WHERE Type__c = 'Assembly' AND Account__c = :portalAccountId ORDER BY Date_Modified__c DESC LIMIT 200];
    }

    @AuraEnabled(cacheable=true)
    public static List<Blade_Cabinet_Inventory_Minimum__c> getBladeCabinetMinimum(String acctId) {
        String portalAccountId = getUserPortalSelectedAccount();
        return [Select Id, Name, Customer_Item_Number__c, Current_Inventory_Level__c, Minimum_Inventory_Level__c, On_Order_In_Transit_Quantity__c, Product__r.Description, Product__r.Blade_Quick_Identifier__c From Blade_Cabinet_Inventory_Minimum__c Where Blade_Cabinet__r.Account__c = :portalAccountId And Product__r.Description <> '' And Product__r.Blade_Quick_Identifier__c <> '' Order By Name Limit 50];
    }

    public class QuoteWrapper {
        @AuraEnabled
        public String id ;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String quoteName;     
        @AuraEnabled
        public Boolean expired;   
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Decimal quoteTotal;
        @AuraEnabled
        public String sfUrl;
        @AuraEnabled
        public Boolean quoteExists;

        public QuoteWrapper(String id, String name, String quoteName, Boolean expired, String status, Decimal quoteTotal, String sfUrl, Boolean quoteExists) {
            this.id = id;
            this.name = name;
            this.quoteName = quoteName;
            this.expired = expired;
            this.status = status;            
            this.quoteTotal = quoteTotal;
            this.sfUrl = sfUrl;
            this.quoteExists = quoteExists;
        }
    }

    public class MachineWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String gradeCategory;     
        @AuraEnabled
        public String primaryGrade;   
        @AuraEnabled
        public String status;
        @AuraEnabled
        public List<MacSection> macSection;

        public MachineWrapper(String id, String name, String gradeCategory, String primaryGrade, String status, List<MacSection> macSection) {
            this.id = id;
            this.name = name;
            this.gradeCategory = gradeCategory;
            this.primaryGrade = primaryGrade;
            this.status = status; 
            this.macSection = macSection;
        }
    }

    public class MacSection {
        @AuraEnabled
        public String sectionId;
        @AuraEnabled
        public String sectionName;
        @AuraEnabled
        public String sfUrl;
        @AuraEnabled
        public String sectionType;
        @AuraEnabled
        public String sectionConfig;
    }
}