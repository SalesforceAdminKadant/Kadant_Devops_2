global class UpdateBladeCabinetInventoryMinimums
{
    public void updateMe(string cabinetID, string partNumber)
    {
        string strProduct;
        Blade_Cabinet__c blc = [Select Id, Account__r.Id From Blade_Cabinet__c Where Id = :cabinetID Limit 1];
        
        AggregateResult[] groupedResults = [select Part_Number__c, Sum(Quantity__c) qty, Customer_Item_Number__c from Blade_Cabinet_Inventory__c Where Blade_Cabinet__c = :cabinetId and Part_Number__c = :partNumber Group By Part_Number__c, Customer_Item_Number__c]; 
        if(groupedResults != null && groupedResults.size() > 0)
        { 
            for(AggregateResult aggr:groupedResults)
            {             
                Blade_Cabinet_Inventory_Minimum__c [] bcim1 = [SELECT Id, Current_Inventory_Level__c, Customer_Item_Number__c FROM Blade_Cabinet_Inventory_Minimum__c Where Blade_Cabinet__c = :cabinetId And Name = :(string)aggr.get('Part_Number__c') LIMIT 1];
                Product2[] prod = [Select Id From Product2 Where Location__c = 'KSD' and Name = :(string)aggr.get('Part_Number__c')];
                if(prod.size() <= 0)
                    strProduct = null;
                else
                    strProduct = prod[0].id;
                if(bcim1.size() == 0)
                {
                    Blade_Cabinet_Inventory_Minimum__c objBCIM = new Blade_Cabinet_Inventory_Minimum__c(Name = (string)aggr.get('Part_Number__c'), Blade_Cabinet__c = cabinetId, Product__c = strProduct, Current_Inventory_Level__c = (decimal)aggr.get('qty'), Customer_Item_Number__c = (string)aggr.get('Customer_Item_Number__c'));
                    insert objBCIM;
                }
                else
                {
                    bcim1[0].Current_Inventory_Level__c = (decimal)aggr.get('qty');
                    bcim1[0].Product__c = strProduct;
                    bcim1[0].Customer_Item_Number__c = (string)aggr.get('Customer_Item_Number__c');
                    update bcim1[0];
                }

            }
        }
    }
}