global with sharing class UpdateForecast 
{
    //the start dates 
    public Date s1{get; set;}
    public Date s2{get; set;}
    public Date s3{get; set;}
    public Date s4{get; set;}
    public Date s5{get; set;}
    public Date s6{get; set;}
    public Date s7{get; set;}
    public Date s8{get; set;}
    public Date s9{get; set;}
    public Date s10{get; set;}
    public Date s11{get; set;}
    public Date s12{get; set;}
    
    //the end dates
    public Date e1{get; set;}
    public Date e2{get; set;}
    public Date e3{get; set;}
    public Date e4{get; set;}
    public Date e5{get; set;}
    public Date e6{get; set;}
    public Date e7{get; set;}
    public Date e8{get; set;}
    public Date e9{get; set;}
    public Date e10{get; set;}
    public Date e11{get; set;}
    public Date e12{get; set;}
    
    map<string, decimal> valueMap1 = new map<string, decimal>();
    map<string, decimal> valueMap2 = new map<string, decimal>();
    map<string, decimal> valueMap3 = new map<string, decimal>();
    map<string, decimal> valueMap4 = new map<string, decimal>();
    map<string, decimal> valueMap5 = new map<string, decimal>();
    map<string, decimal> valueMap6 = new map<string, decimal>();
    map<string, decimal> valueMap7 = new map<string, decimal>();
    map<string, decimal> valueMap8 = new map<string, decimal>();
    map<string, decimal> valueMap9 = new map<string, decimal>();
    map<string, decimal> valueMap10 = new map<string, decimal>();
    map<string, decimal> valueMap11 = new map<string, decimal>();
    map<string, decimal> valueMap12 = new map<string, decimal>();
    
    public Forecast__c forecast;
    
    String strUserDivision;
    
    public list<Period> periods
    {
        get
        {
            if(periods == null)
                periods = [Select p.Type, p.StartDate, p.Number, p.Id, p.FiscalYearSettingsId, p.FiscalYearSettings.Name, p.EndDate
                    From Period p
                    Where type = 'Quarter' Order By EndDate desc];
                               
            return periods;
        }
        set;
    }
    
    public void updateForecast(string id)
    {
        forecast = [select Id, OwnerId, Owner_Division__c, Name, Forecast_Period__c, Forecast_Year__c, Forecast_Quarter__c
            From Forecast__c
            Where Id = :id And Account_Forecast__c = false];
        
        getDates();
        
        strUserDivision = forecast.Owner_Division__c;
        
        //Get all the accounts where this DSM/RSM is a Team Member
        List<Account> members = [SELECT Id
            From Account
            Where (OwnerId = :forecast.OwnerId Or KSD_DSM__c = :forecast.OwnerId Or KJ_RSM__c = :forecast.OwnerId)];
        Set<Id> accountIds = new Set<Id>();
        for(Account member : members)
        {
            accountIds.add(member.Id);
        }

        list<Forecast_Item__c> forUpdate = [select Id, Forecast_Category__c, Location__c, Product_Category__c, Val1__c, Val2__c, Val3__c, Val4__c, Val5__c, Val6__c,
            Val7__c, Val8__c, Val9__c, Last_Year_Total__c, X2_Years_Ago_Total__c, X3_Years_Ago_Total__c
            From Forecast_Item__c
            Where Forecast__c = :id];

        AggregateResult [] gr1 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s1
                and ServiceDate < :e1
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr1)
        {               
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap1.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }

        AggregateResult [] gr2 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s2
                and ServiceDate < :e2
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr2)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap2.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));
        }

        AggregateResult [] gr3 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s3
                and ServiceDate < :e3
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr3)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap3.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));  
        }

        AggregateResult [] gr4 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s4
                and ServiceDate < :e4
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr4)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap4.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));  
        }
        
        AggregateResult [] gr5 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s5
                and ServiceDate < :e5
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr5)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap5.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }

        AggregateResult [] gr6 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s6
                and ServiceDate < :e6
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr6)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap6.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));  
        }

        AggregateResult [] gr7 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s7
                and ServiceDate < :e7
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr7)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap7.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));   
        }

        AggregateResult [] gr8 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s8
                and ServiceDate < :e8
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr8)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap8.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }

        AggregateResult [] gr9 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s9
                and ServiceDate < :e9
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr9)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap9.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }
        
        AggregateResult [] gr10 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s10
                and ServiceDate < :e10
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr10)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap10.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }
        
        AggregateResult [] gr11 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s11
                and ServiceDate < :e11
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr11)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap11.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }
        
        AggregateResult [] gr12 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem 
                where (Order.AccountId IN :accountIds Or Order.Account.OwnerId = :forecast.OwnerId)
                and ServiceDate >= :s12
                and ServiceDate < :e12
                and Order.Division__c = :strUserDivision
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Family,PricebookEntry.Product2.Comission_Category__c];
        for (AggregateResult  ar : gr12)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap12.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
        }
        
        for(Forecast_Item__c fb : forUpdate)
        {
            string combiKey = fb.Product_Category__c.touppercase() +'-' + fb.Forecast_Category__c.touppercase();
            if (valueMap1.containskey(combiKey) && valueMap1.get(combiKey) != 0){fb.Val1__c = valueMap1.get(combiKey);}
            else {fb.Val1__c = 0;}
            if (valueMap2.containskey(combiKey) && valueMap2.get(combiKey) != 0){fb.Val2__c = valueMap2.get(combiKey);}
            else{fb.Val2__c = 0;}
            if (valueMap3.containskey(combiKey) && valueMap3.get(combiKey) != 0){fb.Val3__c = valueMap3.get(combiKey);}
            else{fb.Val3__c = 0;}
            if (valueMap4.containskey(combiKey) && valueMap4.get(combiKey) != 0){fb.Val4__c = valueMap4.get(combiKey);}
            else{fb.Val4__c = 0;}
            if (valueMap5.containskey(combiKey) && valueMap5.get(combiKey) != 0){fb.Val5__c = valueMap5.get(combiKey);}
            else{fb.Val5__c = 0;}
            if (valueMap6.containskey(combiKey) && valueMap6.get(combiKey) != 0){fb.Val6__c = valueMap6.get(combiKey);}
            else{fb.Val6__c = 0;}
            if (valueMap7.containskey(combiKey) && valueMap7.get(combiKey) != 0){fb.Val7__c = valueMap7.get(combiKey);}
            else{fb.Val7__c = 0;}
            if (valueMap8.containskey(combiKey) && valueMap8.get(combiKey) != 0){fb.Val8__c = valueMap8.get(combiKey);}
            else{fb.Val8__c = 0;}
            if (valueMap9.containskey(combiKey) && valueMap9.get(combiKey) != 0){fb.Val9__c = valueMap9.get(combiKey);}
            else{fb.Val9__c = 0;}
            if (valueMap10.containskey(combiKey) && valueMap10.get(combiKey) != 0){fb.Last_Year_Total__c = valueMap10.get(combiKey);}
            else{fb.Last_Year_Total__c = 0;}
            if (valueMap11.containskey(combiKey) && valueMap11.get(combiKey) != 0){fb.X2_Years_Ago_Total__c = valueMap11.get(combiKey);}
            else{fb.X2_Years_Ago_Total__c = 0;}
            if (valueMap12.containskey(combiKey) && valueMap12.get(combiKey) != 0){fb.X3_Years_Ago_Total__c = valueMap12.get(combiKey);}
            else{fb.X3_Years_Ago_Total__c = 0;}
        }
        
        update forUpdate;
        
    }
    
    public void getDates()
    {
        
        integer limitQ = 0;
        date fCastBaseDate = date.today();
        
        string strYear = forecast.Forecast_Year__c;
        string strQtr = forecast.Forecast_Quarter__c.substring(1,2);
        for(period p : periods)
        {
            if(p.Number == integer.valueOf(strQtr) && p.StartDate.addMonths(1).year() == integer.valueOf(strYear))
            {
                fCastBaseDate = p.startDate;
                break;
            }
        }

        s10 = Date.newInstance((fCastBaseDate.addMonths(1).year() - 1), 1, 1);
        e10 = Date.newInstance(s10.year(), 12, 31);
        s11 = Date.newInstance((s10.year() - 1), 1, 1);
        e11 = Date.newInstance(s11.year(), 12, 31);
        s12 = Date.newInstance((s11.year() - 1), 1, 1);
        e12 = Date.newInstance(s12.year(), 12, 31);
        
        for (Period p : periods)
        {
            if (fCastBaseDate != null)
            {
                Date theChk = fCastBaseDate.addMonths(1);
                if (limitQ == 9)
                    break;
                else if (p.StartDate <= theChk && p.EndDate >= theChk)
                {
                    limitQ += 1;
                    s9 = p.StartDate; 
                    e9 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 1)
                {
                    limitQ += 1;
                    s8 = p.StartDate; 
                    e8 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 2)
                {
                    limitQ += 1;
                    s7 = p.StartDate; 
                    e7 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 3)
                {
                    limitQ += 1;
                    s6 = p.StartDate; 
                    e6 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 4)
                {
                    limitQ += 1;
                    s5 = p.StartDate; 
                    e5 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 5)
                {
                    limitQ += 1;
                    s4 = p.StartDate; 
                    e4 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 6)
                {
                    limitQ += 1;
                    s3 = p.StartDate; 
                    e3 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 7)
                {
                     limitQ += 1;
                     s2 = p.StartDate; 
                     e2 = p.EndDate;
                }
                else if (p.EndDate <= theChk && limitQ == 8)
                {
                     limitQ += 1;
                     s1 = p.StartDate; 
                     e1 = p.EndDate;
                }
            }
        }    
    }
    
}