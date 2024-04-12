public with sharing class AccountSalesTargetsControllerExtension {

    public Integer pageSize;
    public Integer resultSize;
    
    public String recordTypeName { get; set; }
 
    public ApexPages.StandardSetController ASTRecords{
        
        get {
            if(ASTRecords == null)
            {
                List<Sales_Budget__c> recordTypeId = [select id, recordtype.name from sales_budget__c WHERE id=:ApexPages.currentPage().getParameters().get('id') limit 1];
                                
                for(Sales_Budget__c a: recordTypeId)
                {
                    recordTypeName = a.Recordtype.name;
                    system.debug(recordTypeName);
                }
                            
                if(recordtypeName=='PSG-E RSM Budget')
                {
                    ASTRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID,NAME,CURRENCYISOCODE,Account__c, Account__r.FY_Sales_2_Years_Ago__c,Account__r.FY_Sales_Previous__c,Account__r.FY_Sales_Current__c,
                    ACCOUNT__r.Name, Account__r.Rating, DCF_M_CLEAN__C, DCF_BLADES__C, DCF_MCL_AFTERMARKET__C, DCF_MCL_CAPITAL__C, DCF_MCL_SERV_REPAIR__C, DCF_KUK_AFTERMARKET__C, DCF_KUK_CAPITAL__C, DCF_KUK_SERV_REPAIR__C, DCF_KUK_BLADES__C,
                    DCF_KL_AFTERMARKET__C, DCF_KL_CAPITAL__C, DCF_KL_SERV_REPAIR__C, DCF_KL_BLADES__C, DCF_RAD_SERV_REPAIR__C, DCF_RAD_BLADES__C, FH_KJE_AFTERMARKET__C, FH_KJE_CAPITAL__C, FH_KJE_SERV_REPAIR__C, FH_KJE_SCS__C, FH_KJE_INSTALLATION__C,
                    FH_JF_AFTERMARKET__C, FH_JF_CAPITAL__C, FH_JF_SERV_REPAIR__C, SALES_BUDGET__C, PSG_E_Total__c, sales_budget__r.recordtype.name 
                    From Account_Sales_Targets__c 
                    WHERE Sales_Budget__c=:ApexPages.currentPage().getParameters().get('id') Order By Name ]));
                }
                else if(recordTypeName=='KL ASM Budget')
                {
                    ASTRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID,NAME,CURRENCYISOCODE,Account__c, Account__r.FY_Sales_2_Years_Ago__c,Account__r.FY_Sales_Previous__c,Account__r.FY_Sales_Current__c,
                    ACCOUNT__r.Name, Account__r.Strategex_Rank__c, SALES_BUDGET__C, PSG_E_Total__c, FL_KL_Aftermarket__c,FL_KL_Capital__c 
                    From Account_Sales_Targets__c 
                    WHERE Sales_Budget__c=:ApexPages.currentPage().getParameters().get('id') Order By Name ]));
                }
                else if(recordTypeName=='KBC Budget')
                {
                    ASTRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID,NAME,CURRENCYISOCODE,Account__c, Account__r.FY_Sales_2_Years_Ago__c,Account__r.FY_Sales_Previous__c,Account__r.FY_Sales_Current__c,
                    ACCOUNT__r.Name, Account__r.Strategex_Rank__c, SALES_BUDGET__C, KBC_Total_Target__c, SPAM__c, SPSB__c, SPCP__c, GSAM__c, GSCP__c, SPRP__c, INCO__c  
                    From Account_Sales_Targets__c 
                    WHERE Sales_Budget__c=:ApexPages.currentPage().getParameters().get('id') Order By Name ]));
                }
            }
            return ASTRecords;
        }
        private set;
    }

    public AccountSalesTargetsControllerExtension(ApexPages.StandardSetController controller) {
        this.ASTRecords = ASTRecords;
        resultSize = ASTRecords.getResultSize();
        ASTRecords.setPageSize(resultSize);
        pageSize = ASTRecords.getPageSize();
    }
    
    public List<Account_Sales_Targets__c> getASTS(){
        return (List<Account_Sales_Targets__c>)ASTRecords.getRecords();
    }
    
    public Pagereference save(){
        ASTRecords.save();
        return null;
    }

}