public with sharing class PriceAgreementDetailControllerExtension {

    public Integer pageSize;
    public Integer resultSize;
    
    public ApexPages.StandardSetController PADRecords{
        get {
            if(PADRecords == null) {
                PADRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name, Line_No__c, Product__c, Product_Description__c, Product_Unit_of_Measure__c, Price__c, Current_List_Price__c, Customer_Item__c, Override_ICP__c, Current_ICP_Price__c, ICP_Price__c, Previous_Price__c, List_Price__c, Lead_Time__c, Lead_Time_UOM__c, Discount__c, Discount_Pct__c, Target_Quantity__c FROM Price_Agreement_Detail__c WHERE Price_Agreement_Header__c=:ApexPages.currentPage().getParameters().get('id') Order By Name ]));
            }
            return PADRecords;
        }
        private set;
    }

    public PriceAgreementDetailControllerExtension(ApexPages.StandardSetController controller) {
        this.PADRecords = PADRecords;
        resultSize = PADRecords.getResultSize();
        PADRecords.setPageSize(resultSize);
        pageSize = PADRecords.getPageSize();
    }
    
    public List<Price_Agreement_Detail__c> getPADS(){
        return (List<Price_Agreement_Detail__c>)PADRecords.getRecords();
    }
    
    public Pagereference save(){
        PADRecords.save();
        return null;
    }

}