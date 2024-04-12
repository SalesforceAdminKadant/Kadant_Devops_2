global class UpdateWhiteSpaceActuals
{

    public void updateMe(string id)
    {
        String strDivision = 'KSD';
        Date beginDateLastYTD;
        Date endDateLastYTD;
        
        White_Space_Account_Detail__c wsDetails = [SELECT Id, Product__c, Category__c, Actual_YTD__c, Actual_Last_Year__c, Last_YTD_Actual__c, Actual_2_Years_Ago__c, White_Space_Account_Year__r.Name, White_Space_Account_Year__r.Account__c
            FROM White_Space_Account_Detail__c
            WHERE Id = :id LIMIT 1];

        wsDetails.Actual_YTD__c = 0;
        wsDetails.Actual_Last_Year__c = 0;
        wsDetails.Actual_2_Years_Ago__c = 0;
        wsDetails.Last_YTD_Actual__c = 0;

        Integer intYear = Integer.valueOf(wsDetails.White_Space_Account_Year__r.Name);
        beginDateLastYTD = date.newInstance((intYear - 1), 01, 01);
        endDateLastYTD = date.newInstance((intYear - 1), date.today().month(), date.today().day());
        
        AggregateResult [] gr1 = [SELECT Sum(Converted_Total_Price__c)thePrice, Opportunity.CurrencyIsoCode curr
                FROM OpportunityLineItem 
                where Opportunity.AccountId = :wsDetails.White_Space_Account_Year__r.Account__c
                and Product2.Comission_Category__c = :wsDetails.Category__c
                and Product2.Family = :wsDetails.Product__c
                and Calendar_Year(ServiceDate) = :intYear
                and Opportunity.Division__c = :strDivision
                and Opportunity.Order_Active_Quote_Inactive_Quote__c = 'Order'
                group by Opportunity.CurrencyIsoCode];
        
        for (AggregateResult  ar1 : gr1)
        {
            wsDetails.Actual_YTD__c = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
        }
        
        intYear = intYear - 1;
        
        AggregateResult [] gr2 = [SELECT Sum(Converted_Total_Price__c)thePrice, Opportunity.CurrencyIsoCode curr
                FROM OpportunityLineItem 
                where Opportunity.AccountId = :wsDetails.White_Space_Account_Year__r.Account__c
                and Product2.Comission_Category__c = :wsDetails.Category__c
                and Product2.Family = :wsDetails.Product__c
                and Calendar_Year(ServiceDate) = :intYear
                and Opportunity.Division__c = :strDivision
                and Opportunity.Order_Active_Quote_Inactive_Quote__c = 'Order'
                group by Opportunity.CurrencyIsoCode];
        
        for (AggregateResult  ar2 : gr2)
        {               
            wsDetails.Actual_Last_Year__c = Decimal.valueOf(string.valueOf(ar2.get('thePrice')));
        }
        
        intYear = intYear - 1;
        
        AggregateResult [] gr3 = [SELECT Sum(Converted_Total_Price__c)thePrice, Opportunity.CurrencyIsoCode curr
                FROM OpportunityLineItem 
                where Opportunity.AccountId = :wsDetails.White_Space_Account_Year__r.Account__c
                and Product2.Comission_Category__c = :wsDetails.Category__c
                and Product2.Family = :wsDetails.Product__c
                and Calendar_Year(ServiceDate) = :intYear
                and Opportunity.Division__c = :strDivision
                and Opportunity.Order_Active_Quote_Inactive_Quote__c = 'Order'
                group by Opportunity.CurrencyIsoCode];
        
        for (AggregateResult  ar3 : gr3)
        {               
            wsDetails.Actual_2_Years_Ago__c = Decimal.valueOf(string.valueOf(ar3.get('thePrice')));
        }
        
        AggregateResult [] gr4 = [SELECT Sum(Converted_Total_Price__c)thePrice, Opportunity.CurrencyIsoCode curr
                FROM OpportunityLineItem 
                where Opportunity.AccountId = :wsDetails.White_Space_Account_Year__r.Account__c
                and Product2.Comission_Category__c = :wsDetails.Category__c
                and Product2.Family = :wsDetails.Product__c
                and ServiceDate >= :beginDateLastYTD And ServiceDate <= :endDateLastYTD
                and Opportunity.Division__c = :strDivision
                and Opportunity.Order_Active_Quote_Inactive_Quote__c = 'Order'
                group by Opportunity.CurrencyIsoCode];
        
        for (AggregateResult  ar4 : gr4)
        {               
            wsDetails.Last_YTD_Actual__c = Decimal.valueOf(string.valueOf(ar4.get('thePrice')));
        }
        
        Update(wsDetails);

    }

}