public class MassCreateSalesTargets{
    @AuraEnabled 
    public List<sObject> accList = new List<sObject>();
    
    @AuraEnabled 
    public List<Account> delRec = new List<Account>();
    
    @AuraEnabled 
    public static List<Account> getAccounts(String recordtype, String ownerID, string budgetID)
    {
       
        MassCreateSalesTargets alc = new MassCreateSalesTargets();
        Id currentUserId = ownerID;
            system.debug(recordtype + 'owner' + ownerID + 'budget' + budgetID);
        Date todaysDate = date.today();
        Integer currentYearInt = date.today().year();
            if (todaysdate.Month() >= 9){currentYearInt = currentYearInt +1;}
        String currentYear = string.valueOf(currentYearInt);
        String searchString1 = '';
        String searchString2 = '';
        String searchString3 = '';
        List<String> ratingCategories = new List<String> ();
        system.debug(currentYear);
        
        if(recordtype == 'KL ASM Budget'){
            ratingCategories.add('A');
            ratingCategories.add('AF');
            ratingCategories.add('TS');
            ratingCategories.add('W');
            ratingCategories.add('RF');
            searchString1 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.OwnerId = :currentUserId and a.Strategex_Rank__c IN :ratingCategories and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) order by fy_sales_current__c desc';
            searchString2 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.Id IN(select AccountId from AccountTeamMember where UserId = :currentUserId)  and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) and a.Strategex_Rank__c IN :ratingCategories order by fy_sales_current__c desc';
            searchString3 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.OwnerId != :currentUserId and a.Id IN(select Account__c from Account_Division__c where Account_Owner__c = :currentUserId)  and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) and a.Strategex_Rank__c IN :ratingCategories order by fy_sales_current__c desc';    
        }
        if(recordtype == 'KBC Budget'){
            ratingCategories.add('A');
            ratingCategories.add('AR');
            ratingCategories.add('K');
            searchString1 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.OwnerId = :currentUserId and a.Strategex_Rank__c IN :ratingCategories and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) order by fy_sales_current__c desc';
            searchString2 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.Id IN(select AccountId from AccountTeamMember where UserId = :currentUserId)  and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) and a.Strategex_Rank__c IN :ratingCategories order by fy_sales_current__c desc';
            searchString3 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.OwnerId != :currentUserId and a.Id IN(select Account__c from Account_Division__c where Account_Owner__c = :currentUserId)  and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) and a.Strategex_Rank__c IN :ratingCategories order by fy_sales_current__c desc';    
        }
        if(recordtype == 'PSG-E RSM Budget'){
            ratingCategories.add('Farming/Nurturing');
            ratingCategories.add('Growth/New Business');
                system.debug(ratingCategories);
            searchString1 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.OwnerId = :currentUserId and a.Rating IN :ratingCategories and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) order by fy_sales_current__c desc';
            searchString2 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.Id IN(select AccountId from AccountTeamMember where UserId = :currentUserId)  and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) and a.Rating IN :ratingCategories order by fy_sales_current__c desc';
            searchString3 = 'SELECT Id, Name, Site, Rating, Strategex_Rank__c, FY_Sales_Previous__c, FY_Sales_Current__c,FY_Sales_2_Years_Ago__c from Account a where a.OwnerId != :currentUserId and a.Id IN(select Account__c from Account_Division__c where Account_Owner__c = :currentUserId)  and a.id NOT IN(select account__c from account_sales_targets__c where name = :currentYear and sales_budget__c = :budgetID) and a.Rating IN :ratingCategories order by fy_sales_current__c desc';
        }
        
        List<sObject> accList2 = new List<sObject>();
        List<sObject> accList3 = new List<sObject>();
        
        system.debug(searchString1);
        
        alc.accList = Database.query(searchString1);
        accList2 = Database.query(searchString2);
        accList3 = Database.query(searchString3);
        
        alc.accList.addAll(accList3);
        alc.accList.addAll(accList2);
       
        return alc.accList;

    }
   
    @AuraEnabled 
    public static List<Account> delSlctRec(List<String> slctRec, id BudgetId)
    {

        MassCreateSalesTargets alc = new MassCreateSalesTargets();
        Date todaysDate = date.today();
        Integer currentYearInt = date.today().year();
            if (todaysdate.Month() >= 9){currentYearInt = currentYearInt +1;}
        String currentYear = string.valueOf(currentYearInt);
        system.debug(currentYear);
        alc.delRec = [SELECT Id FROM Account WHERE Id IN: slctRec ];
        List<Account_Sales_Targets__c> newASTlist = new List<Account_Sales_Targets__c>();
        Id currentUserId = UserInfo.getUserId();
        System.debug(BudgetId);
        for(Account a : alc.delRec){
            Account_Sales_Targets__c objAST = new Account_Sales_Targets__c(Account__c = a.Id,Name = currentYear,Sales_Budget__c = BudgetId );
            newASTlist.add(objAST);

        }
        if(!newASTlist.isEmpty())
            insert newASTlist;

        alc.accList.clear();
                
        return alc.accList;
       
    }
}