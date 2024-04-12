global class UpdateAccountSalesSummary
{

    public void updateMe(string id, string strRecordType)
    {
        decimal decAmount1;
        decimal decAmount2;
        decimal decAmount3;
        decimal decAmount4;
        decimal decAmount5;
        decimal decAmount6;
        decimal decPrevAmount;
        decimal decTotalAmount1 = 0;
        decimal decTotalAmount2 = 0;
        decimal decTotalAmount3 = 0;
        decimal decTotalAmount4 = 0;
        decimal decTotalAmount5 = 0;
        decimal decTotalAmount6 = 0;
        decimal decTotalPrevAmount = 0;
        string strID;
        string strStartingYear = string.valueof(System.Today().year() - 5);
        integer intCount = 0;
        Account_Sales_Summary__c ass2;
        
        Account_Sales_Summary__c[] assToDelete = [SELECT Id FROM Account_Sales_Summary__c WHERE Account__c = :id];
        delete assToDelete;
        if(!assToDelete.isEmpty())
            Database.emptyRecycleBin(assToDelete);

        AggregateResult[] gr1 = [Select Name yr, Division__c div, Business_Category__c bc, CurrencyIsoCode curr, Sum(Annual_Sales__c) thePrice, Sum(Previous_YTD_Annual_Sales__c) prev
            FROM Account_Annual_Sales__c 
            where Account__c = :id
            and Name >= :strStartingYear
            group by Name, Division__c, Business_Category__c, CurrencyIsoCode];
        
        for (AggregateResult  ar1 : gr1)
        {
            if(strRecordType == 'Kadant Europe Accounts')
            {
                strID = string.valueOf(ar1.get('bc'));
            }else{
                strID = string.valueOf(ar1.get('div'));
            }        

            if(string.valueOf(ar1.get('yr')) == strStartingYear)
                decAmount1 = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
            else
                decAmount1 = 0;
            if(string.valueOf(ar1.get('yr')) == string.valueOf(integer.valueof(strStartingYear)+1))
                decAmount2 = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
            else
                decAmount2 = 0;
            if(string.valueOf(ar1.get('yr')) == string.valueOf(integer.valueof(strStartingYear)+2))
                decAmount3 = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
            else
                decAmount3 = 0;
            if(string.valueOf(ar1.get('yr')) == string.valueOf(integer.valueof(strStartingYear)+3))
                decAmount4 = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
            else
                decAmount4 = 0;
            if(string.valueOf(ar1.get('yr')) == string.valueOf(integer.valueof(strStartingYear)+4))
                decAmount5 = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
            else
                decAmount5 = 0;
            if(string.valueOf(ar1.get('yr')) == string.valueOf(integer.valueof(strStartingYear)+5) && ar1.get('prev') != null)
                decPrevAmount = Decimal.valueOf(string.valueOf(ar1.get('prev')));
            else
                decPrevAmount = 0;
            if(string.valueOf(ar1.get('yr')) == string.valueOf(integer.valueof(strStartingYear)+5))
                decAmount6 = Decimal.valueOf(string.valueOf(ar1.get('thePrice')));
            else
                decAmount6 = 0;

            decTotalAmount1 += decAmount1;
            decTotalAmount2 += decAmount2;
            decTotalAmount3 += decAmount3;
            decTotalAmount4 += decAmount4;
            decTotalAmount5 += decAmount5;
            decTotalAmount6 += decAmount6;
            decTotalPrevAmount += decPrevAmount;

            Account_Sales_Summary__c[] ass1 = [SELECT Id, Name, Division__c, CurrencyIsoCode,
                X1_FY_Sales__c, X2_FY_Sales__c, X3_FY_Sales__c, X4_FY_Sales__c, X5_FY_Sales__c, X6_FY_Sales__c, Prev_YTD_Sales__c
                FROM Account_Sales_Summary__c
                WHERE Account__c = :id And Name = :strID and CurrencyIsoCode = :string.valueOf(ar1.get('curr')) Limit 1];
            if(ass1.size() > 0)
            {
                ass1[0].X1_FY_Sales__c += decAmount1;
                ass1[0].X2_FY_Sales__c += decAmount2;
                ass1[0].X3_FY_Sales__c += decAmount3;
                ass1[0].X4_FY_Sales__c += decAmount4;
                ass1[0].X5_FY_Sales__c += decAmount5;
                ass1[0].X6_FY_Sales__c += decAmount6;
                ass1[0].Prev_YTD_Sales__c += decPrevAmount;
                update ass1[0];
            }else{
                ass2 = new Account_Sales_Summary__c (Name = strID,
                    Account__c = id,
                    X1_FY_Sales__c = decAmount1,
                    X2_FY_Sales__c = decAmount2,
                    X3_FY_Sales__c = decAmount3,
                    X4_FY_Sales__c = decAmount4,
                    X5_FY_Sales__c = decAmount5,
                    X6_FY_Sales__c = decAmount6,
                    Prev_YTD_Sales__c = decPrevAmount,
                    Division__c = string.valueOf(ar1.get('div')),
                    CurrencyIsoCode = string.valueOf(ar1.get('curr')));
                insert ass2;
                intCount += 1;
            }
        }

        if(intCount > 1)
        {
            ass2 = new Account_Sales_Summary__c (Name = 'zTotal',
                Account__c = id,
                X1_FY_Sales__c = decTotalAmount1,
                X2_FY_Sales__c = decTotalAmount2,
                X3_FY_Sales__c = decTotalAmount3,
                X4_FY_Sales__c = decTotalAmount4,
                X5_FY_Sales__c = decTotalAmount5,
                X6_FY_Sales__c = decTotalAmount6,
                Prev_YTD_Sales__c = decTotalPrevAmount,
                Division__c = null,
                CurrencyIsoCode = 'USD');
            insert ass2;
        }
    }

}