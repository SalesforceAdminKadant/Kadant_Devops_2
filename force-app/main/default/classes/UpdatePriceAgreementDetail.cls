global class UpdatePriceAgreementDetail 
{


    public void updateMe(string padId, string acctId, string prodId)
    {

        date d1 = Date.Today();
        date d2 = Date.Today().addYears(-1);
        date d3 = Date.Today().addYears(-2);
        date d4 = Date.Today().addYears(-3);
        date startDate1;
        date endDate1;
        date startDate2;
        date endDate2;
        date startDate3;
        date endDate3;
        date startDate4;
        date endDate4;
        
        FiscalYearSettings fys = [Select Name, StartDate, EndDate From FiscalYearSettings where StartDate <= :d1 and EndDate >= :d1 LIMIT 1];
        startDate1 = fys.StartDate;
        endDate1 = fys.EndDate;
        fys = [Select Name, StartDate, EndDate From FiscalYearSettings where StartDate <= :d2 and EndDate >= :d2 LIMIT 1];
        startDate2 = fys.StartDate;
        endDate2 = fys.EndDate;
        fys = [Select Name, StartDate, EndDate From FiscalYearSettings where StartDate <= :d3 and EndDate >= :d3 LIMIT 1];
        startDate3 = fys.StartDate;
        endDate3 = fys.EndDate;
        fys = [Select Name, StartDate, EndDate From FiscalYearSettings where StartDate <= :d4 and EndDate >= :d4 LIMIT 1];
        startDate4 = fys.StartDate;
        endDate4 = fys.EndDate;

        Price_Agreement_Detail__c padToUpdate = [SELECT Current_Year_Qty__c, Last_Year_Qty__c, X2_Year_s_Ago_Qty__c, X3_Year_s_Ago_Qty__c FROM Price_Agreement_Detail__c WHERE Id = :padId];
        padToUpdate.Current_Year_Qty__c = 0;
        padToUpdate.Last_Year_Qty__c = 0;
        padToUpdate.X2_Year_s_Ago_Qty__c = 0;
        padToUpdate.X3_Year_s_Ago_Qty__c = 0;

        AggregateResult [] gr1 = [SELECT Product2Id, Sum(Quantity)theQty
                FROM OrderItem
                where Order.AccountId = :acctId
                and Order.EffectiveDate >= :startDate1
                and Order.EffectiveDate < :endDate1
                and Product2Id = :prodId
                and Order.Sale_Type__c != 'ICI'
                Group By Product2Id];
        
        for (AggregateResult  ar1 : gr1)
        {               
            padToUpdate.Current_Year_Qty__c += Decimal.valueOf(string.valueOf(ar1.get('theQty'))); 
        }

        AggregateResult [] gr2 = [SELECT Product2Id, Sum(Quantity)theQty
                FROM OrderItem
                where Order.AccountId = :acctId
                and Order.EffectiveDate >= :startDate2
                and Order.EffectiveDate < :endDate2
                and Product2Id = :prodId
                and Order.Sale_Type__c != 'ICI'
                Group By Product2Id];
        
        for (AggregateResult  ar2 : gr2)
        {               
            padToUpdate.Last_Year_Qty__c += Decimal.valueOf(string.valueOf(ar2.get('theQty'))); 
        }
        
        AggregateResult [] gr3 = [SELECT Product2Id, Sum(Quantity)theQty
                FROM OrderItem
                where Order.AccountId = :acctId
                and Order.EffectiveDate >= :startDate3
                and Order.EffectiveDate < :endDate3
                and Product2Id = :prodId
                and Order.Sale_Type__c != 'ICI'
                Group By Product2Id];
        
        for (AggregateResult  ar3 : gr3)
        {               
            padToUpdate.X2_Year_s_Ago_Qty__c += Decimal.valueOf(string.valueOf(ar3.get('theQty'))); 
        }
        
        AggregateResult [] gr4 = [SELECT Product2Id, Sum(Quantity)theQty
                FROM OrderItem
                where Order.AccountId = :acctId
                and Order.EffectiveDate >= :startDate4
                and Order.EffectiveDate < :endDate4
                and Product2Id = :prodId
                and Order.Sale_Type__c != 'ICI'
                Group By Product2Id];
        
        for (AggregateResult  ar4 : gr4)
        {               
            padToUpdate.X3_Year_s_Ago_Qty__c += Decimal.valueOf(string.valueOf(ar4.get('theQty'))); 
        }
        
        update padToUpdate;

    }

}