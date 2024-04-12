global class UpdateForecastQuarterAverages
{

    public void updateMe(string id, date startDate1, date endDate1, date startDate2, date endDate2)
    {
        //Date1 = last year, Date2 = 2 years ago
        
        Forecast_Item__c fcItem = [select Id, Name, Forecast_Category__c, Product_Category__c, Forecast__r.Account__c, Item_Owner__c, Location__c, Sum4__c
            From Forecast_Item__c
            Where Id = :id LIMIT 1];

        AggregateResult [] gr;

        gr = [SELECT Sum(Converted_Total_Price__c)thePrice
            FROM OpportunityLineItem 
            where Opportunity.AccountId = :fcItem.Forecast__r.Account__c
            and ((ServiceDate >= :startDate1 and ServiceDate < :endDate1) or (ServiceDate >= :startDate2 and ServiceDate < :endDate2))
            and Opportunity.Division__c = 'KSD'
            and Opportunity.Order_Active_Quote_Inactive_Quote__c = 'Order'
            and PricebookEntry.Product2.Family = :fcItem.Product_Category__c
            and PricebookEntry.Product2.Comission_Category__c = :fcItem.Forecast_Category__c];

        for (AggregateResult  ar: gr)
        {
            if (ar.get('thePrice') == null)
                fcItem.Sum4__c = 0;
            else
                fcItem.Sum4__c = Decimal.valueOf(string.valueOf(ar.get('thePrice')));
        }
       
        Update(fcItem);

    }

}