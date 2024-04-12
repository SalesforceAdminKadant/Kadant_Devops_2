global class UpdateAccountAnnualSales 
{

    public Account_Annual_Sales__c[] aassCurr = new List<Account_Annual_Sales__c>();

    public void updateCurrent(string id, Date startDate, Date endDate, String strYear, Boolean boolUpdatePrevYTD)
    {
        String strDivision;
        
        Account_Annual_Sales__c[] aasToDelete = [SELECT Id FROM Account_Annual_Sales__c WHERE Account__c = :id and Name = :strYear];
        delete aasToDelete;
        if(!aasToDelete.isEmpty())
            Database.emptyRecycleBin(aasToDelete);
            
        aassCurr.Clear();
        
        AggregateResult [] ad = [SELECT Name div
                FROM Account_Division__c 
                where Account__c = :id
                group by Name
                order by Name];
        for (AggregateResult  ar : ad)
        {
            strDivision = string.valueOf(ar.get('div'));
            if(strDivision == 'KSD')
                DoForKSDDivision_Current(id, strDivision, startDate, endDate, strYear, boolUpdatePrevYTD);
            else
                DoForOtherDivisions(id, strDivision, startDate, endDate, strYear, boolUpdatePrevYTD);
        }

        if(!aassCurr.isEmpty())
            insert aassCurr;

    }

    public void DoForKSDDivision_Current(string id, string strDivision, Date startDate, Date endDate, String strYear, Boolean boolUpdatePrevYTD)
    {
    
        decimal decPreviousYear;
        Date prevStartDate = startDate.AddDays(-365);
        Date prevEndDate = endDate.AddDays(-365);

        AggregateResult [] gr1 = [SELECT Sum(Converted_Total_Price__c)thePrice, PricebookEntry.Product2.Comission_Category__c cc, Order.Account.CurrencyIsoCode curr
            FROM OrderItem 
            where Order.AccountId = :id
            and Order.EffectiveDate >= :startDate
            and Order.EffectiveDate < :endDate
            and Order.Division__c = :strDivision
            group by PricebookEntry.Product2.Comission_Category__c, Order.Account.CurrencyIsoCode];
        for (AggregateResult  ar1 : gr1)
        {
            if(boolUpdatePrevYTD)
            {
                AggregateResult [] gr2 = [SELECT Sum(Converted_Total_Price__c)thePrice, PricebookEntry.Product2.Comission_Category__c cc, Order.Account.CurrencyIsoCode curr
                    FROM OrderItem 
                    where Order.AccountId = :id
                    and Order.EffectiveDate >= :prevStartDate
                    and Order.EffectiveDate < :prevEndDate
                    and Order.Division__c = :strDivision
                    group by PricebookEntry.Product2.Comission_Category__c, Order.Account.CurrencyIsoCode];
                for (AggregateResult ar2 : gr2)
                {
                    decPreviousYear = Decimal.valueOf(string.valueOf(ar2.get('thePrice')));
                }
            }
            else
                decPreviousYear = null;
 
            Account_Annual_Sales__c aas = new Account_Annual_Sales__c (Name = strYear,
                Account__c = id,
                Annual_Sales__c = Decimal.valueOf(string.valueOf(ar1.get('thePrice'))),
                Previous_YTD_Annual_Sales__c = decPreviousYear,
                Division__c = strDivision,
                Business_Category__c = string.valueOf(ar1.get('cc')),
                CurrencyIsoCode = string.valueOf(ar1.get('curr')));
            if(!aassCurr.contains(aas))
                aassCurr.add(aas);
        }

    }

    private void DoForOtherDivisions(string id, string strDivision, Date startDate, Date endDate, String strYear, Boolean boolUpdatePrevYTD)
    {

        decimal decPreviousYear;
        Date prevStartDate = startDate.AddDays(-365);
        Date prevEndDate = endDate.AddDays(-365);

        AggregateResult [] gr1 = [SELECT Sum(Converted_Total_Price__c)thePrice, Business_Category_Text__c bc, Order.Account.CurrencyIsoCode curr
                FROM OrderItem 
                where Order.AccountId = :id
                and Order.EffectiveDate >= :startDate
                and Order.EffectiveDate < :endDate
                and Order.Sale_Type__c != 'ICI'
                and Order.Division__c = :strDivision
                group by Business_Category_Text__c, Order.Account.CurrencyIsoCode];
        for (AggregateResult ar1: gr1)
        {
            if(boolUpdatePrevYTD)
            {
                AggregateResult [] gr2 = [SELECT Sum(Converted_Total_Price__c)thePrice, Business_Category_Text__c bc, Order.Account.CurrencyIsoCode curr
                    FROM OrderItem 
                        where Order.AccountId = :id
                        and Order.EffectiveDate >= :prevStartDate
                        and Order.EffectiveDate < :prevEndDate
                        and Order.Sale_Type__c != 'ICI'
                        and Order.Division__c = :strDivision
                        group by Business_Category_Text__c, Order.Account.CurrencyIsoCode];
                for (AggregateResult ar2 : gr2)
                {
                    decPreviousYear = Decimal.valueOf(string.valueOf(ar2.get('thePrice')));
                }
            }
            else
                decPreviousYear = null;
            Account_Annual_Sales__c aas = new Account_Annual_Sales__c (Name = strYear,
                Account__c = id,
                Annual_Sales__c = Decimal.valueOf(string.valueOf(ar1.get('thePrice'))),
                Previous_YTD_Annual_Sales__c = decPreviousYear,
                Division__c = strDivision,
                Business_Category__c = string.valueOf(ar1.get('bc')),
                CurrencyIsoCode = string.valueOf(ar1.get('curr')));
            if(!aassCurr.contains(aas))
                aassCurr.add(aas);
        }

    }

}