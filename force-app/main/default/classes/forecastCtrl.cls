public with sharing class forecastCtrl 
{
        public Id fCastId
        {
                get
                {
                        if (this.fCastId == null) {
                            return apexpages.currentPage().getParameters().get('Id');
                        }
                        return this.fCastId;
                }
                set;
        }
        public Forecast__c forecast
        {
                get{
                        if(forecast == null)
                        {
                                forecast = [SELECT Id, Name, Owner.Alias, Owner_Division__c, Approval_Status__c, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName, P1_Name__c, P1_Value__c,P2_Name__c, P2_Value__c,P3_Name__c, P3_Value__c,P4_Name__c, P4_Value__c, Forecast_Period__c
                                                        FROM Forecast__c WHERE Id =: fCastId];
                        }
                        return forecast;
                }
                set;
        }
        public date fCastBaseDate
        {
                get
                {
                        if(fCastBaseDate == null)
                        {
                            if(forecast.Forecast_Period__c != null)
                            {
                                integer yrIndex = forecast.Forecast_Period__c.length()-4;
                                string year = forecast.Forecast_Period__c.substring(yrIndex);
                                string qrtr = forecast.Forecast_Period__c.substring(1,2);
                                for(period p : periods)
                                {
                                        if(p.Number == integer.valueOf(qrtr) && p.StartDate.addMonths(1).year() == integer.valueOf(year))
                                        {
                                                fCastBaseDate = p.startDate;
                                                break;
                                        }
                                }
                            }
                        }

                        return fCastBaseDate;
                }
                set;
        }
        
        public date fCastHistDate
        {
                get
                {
                        if(fCastHistDate == null)
                        {
                                integer yrIndex = forecast.Forecast_Period__c.length()-4;
                                string year = forecast.Forecast_Period__c.substring(yrIndex);
                                string qrtr = forecast.Forecast_Period__c.substring(1,2);
                                for(period p : periods)
                                {
                                        if(p.Number == integer.valueOf(qrtr) && p.StartDate.year() == integer.valueOf(year))
                                        {
                                                fCastHistDate = p.startDate;
                                                break;
                                        }
                                }
                        }

                        return fCastHistDate;
                }
                set;
        }
        public list<Period> periods
        {
                get{
                        if(periods == null)
                                periods = [Select p.Type, p.StartDate, p.Number, p.Id, p.FiscalYearSettingsId, p.FiscalYearSettings.Name, p.EndDate 
                                           From Period p where type = 'Quarter' order by EndDate desc];
                                   
                    return periods;
                }
                set;
        }
        
        Forecast_Item__c totalReg = new Forecast_Item__c(   
                                                            
                                                            Value_1__c = 0, Value_2__c = 0, 
                                                            Value_3__c = 0, Value_4__c = 0, 
                                                            LastQForecast__c = 0
                                                        );
        
        Forecast_Item__c totalCo= new Forecast_Item__c(
                                                            Val1__c = 0,Val2__c = 0,
                                                            Val3__c = 0,Val4__c = 0,                        
                                                            Val5__c = 0,Val6__c = 0,                        
                                                            Val7__c = 0,Val8__c = 0,                        
                                                            Value_1__c = 0,Value_2__c = 0,                        
                                                            Value_3__c = 0,Value_4__c = 0,                        
                                                            LastQForecast__c = 0                        
                                                        );                                                                                                                 
                                    
        Forecast_Item__c totalS = new Forecast_Item__c(
                                                            
                                                            Value_1__c = 0, Value_2__c = 0,
                                                            Value_3__c = 0, Value_4__c = 0,
                                                            LastQForecast__c = 0
                                                        );
                                
        Forecast_Item__c totalJ = new Forecast_Item__c(
                                                             
                                                            Value_1__c = 0, Value_2__c = 0,
                                                            Value_3__c = 0, Value_4__c = 0,
                                                            LastQForecast__c = 0
                                                        );
                                
        Forecast_Item__c totalM = new Forecast_Item__c(
                                                            
                                                            Value_1__c = 0, Value_2__c = 0,
                                                            Value_3__c = 0, Value_4__c = 0,
                                                            LastQForecast__c = 0
                                                        );
        
    //the headers
    public string h1{get; set;}
    public string h2{get; set;}
    public string h3{get; set;}
    public string h4{get; set;}
    public string h5{get; set;}
    public string h6{get; set;}
    public string h7{get; set;}
    public string h8{get; set;}
    
    //TBN the totals footer Solutions Consumables for forecast
    public decimal ff1{get; set;}
    public decimal ff2{get; set;}
    public decimal ff3{get; set;}
    public decimal ff4{get; set;}
    public decimal ffcq{get; set;}
    
    //TBN the totals footer Solutions Capital for forecast
    public decimal ffm1{get; set;}
    public decimal ffm2{get; set;}
    public decimal ffm3{get; set;}
    public decimal ffm4{get; set;}
    public decimal ffcqm{get; set;}
    
    //TBN the totals footer Johnson for forecast
    public decimal ffj1{get; set;}
    public decimal ffj2{get; set;}
    public decimal ffj3{get; set;}
    public decimal ffj4{get; set;}
    public decimal ffcqj{get; set;}
    
    //the totals footer Solutions Consumables
    public decimal f1{get; set;}
    public decimal f2{get; set;}
    public decimal f3{get; set;}
    public decimal f4{get; set;}
    public decimal f5{get; set;}
    public decimal f6{get; set;}
    public decimal f7{get; set;}
    public decimal f8{get; set;}  
    public decimal fx{get; set;}    

    //the totals footer Solutions Capital
    public decimal fm1{get; set;}
    public decimal fm2{get; set;}
    public decimal fm3{get; set;}
    public decimal fm4{get; set;}
    public decimal fm5{get; set;}
    public decimal fm6{get; set;}
    public decimal fm7{get; set;}
    public decimal fm8{get; set;} 
    public decimal fmx{get; set;} 

    //the totals footer Johnson
    public decimal fj1{get; set;}
    public decimal fj2{get; set;}
    public decimal fj3{get; set;}
    public decimal fj4{get; set;}
    public decimal fj5{get; set;}
    public decimal fj6{get; set;}
    public decimal fj7{get; set;}
    public decimal fj8{get; set;} 
    public decimal fjx{get; set;} 

    //the totals footer cmptot
    public decimal fct1{get; set;}
    public decimal fct2{get; set;}
    public decimal fct3{get; set;}
    public decimal fct4{get; set;}
    public decimal fct5{get; set;}
    public decimal fct6{get; set;}
    public decimal fct7{get; set;}
    public decimal fct8{get; set;} 
    public decimal fctx{get; set;} 

    //the totals footer last quarter forecast
    public decimal flqs{get; set;}
    public decimal flqj{get; set;}
    public decimal flqmc{get; set;}

    //the start dates 
    public Date s1{get; set;}
    public Date s2{get; set;}
    public Date s3{get; set;}
    public Date s4{get; set;}
    public Date s5{get; set;}
    public Date s6{get; set;}
    public Date s7{get; set;}
    public Date s8{get; set;}
    
    //the end dates
    public Date e1{get; set;}
    public Date e2{get; set;}
    public Date e3{get; set;}
    public Date e4{get; set;}
    public Date e5{get; set;}
    public Date e6{get; set;}
    public Date e7{get; set;}
    public Date e8{get; set;}
    
    
    //the forecasted column headers
    public String fh1 {get;set;}
    public String fh2 {get;set;}
    public String fh3 {get;set;}
    public String fh4 {get;set;}
    
    public String currentQuarter{get;set;}
    
    public List<Forecast_Item__c> workingForecastSolutionsConsumables;
    public List<Forecast_Item__c> workingForecastSolutionsCapital;
    public List<Forecast_Item__c> workingForecastJohnson;
    
    public List<Forecast_Item__c> workingForecastSolutionsConsumablesCheck;
    public List<Forecast_Item__c> workingForecastSolutionsCapitalCheck; 
    public List<Forecast_Item__c> workingForecastJohnsonCheck;
        
    public List<Forecast_Item__c> TotalItems;
 
    public map<string, Forecast_Item__c> mapWorkingForecast;
    
    public Map<string, Forecast_Item__c> previousForecast;
    map<string, decimal> valueMap;
    map<string, decimal> valueMap2;
    map<string, decimal> valueMap3;
    map<string, decimal> valueMap4;
    map<string, decimal> valueMap5;
    map<string, decimal> valueMap6;
    map<string, decimal> valueMap7;
    map<string, decimal> valueMap8;
    public Period curt;//the current quarter
    public Boolean flagApproval{get;set;}
    public Boolean showSolutionsConsumableTab{get;set;}
    public Boolean showSolutionsCapitalTab{get;set;}
    public Boolean showJohnsonTab{get;set;}
    public String selectedTab{get;set;}
    public String strLocation{get;set;}
    
    public forecastCtrl()
    {
        if(forecast.Owner_Division__c == 'KSD')
        {
            selectedTab='Solutions Consumables';
            showSolutionsConsumableTab=true;
            showSolutionsCapitalTab=true;
            showJohnsonTab=false;
            strLocation='Solutions';
        }else{
            selectedTab='Johnson';
            showSolutionsConsumableTab=false;
            showSolutionsCapitalTab=false;
            showJohnsonTab=true;
            strLocation='Johnson';
        }
        if(forecast.Approval_Status__c!='Submitted' && forecast.Approval_Status__c!='Approved')
            flagApproval=false;
        else
            flagApproval=true;
        getDates();
        getForecast();
        getLastQuarterForecast();
    }
    
    public forecastCtrl(Boolean isBatch) {
        
    }
    
    public void refreshData()
    {
        getForecast();
        getLastQuarterForecast();
    }
    
    // this is to show records in grid
    public List<Forecast_Item__c> getTheTotalsSolutionsConsumables()
    {
                
                for(Forecast_Item__c fb : workingForecastSolutionsConsumables)
                {
                    string combiKey = fb.Product_Category__c.touppercase() +'-' + fb.Forecast_Category__c.touppercase();
                    
                    if (valueMap.containskey(combiKey) && valueMap.get(combiKey) != 0)
                    {   
                        fb.Val1__c = valueMap.get(combiKey);
                    }
                    else 
                    {   
                        fb.Val1__c = 0;
                    }
                    
                    if (valueMap2.containskey(combiKey) && valueMap2.get(combiKey) != 0)
                    {   
                        fb.Val2__c = valueMap2.get(combiKey);
                    }
                    else
                    {   
                        fb.Val2__c = 0;
                    }
                    
                    if (valueMap3.containskey(combiKey) && valueMap3.get(combiKey) != 0)
                    {
                        fb.Val3__c = valueMap3.get(combiKey);
                    }
                    else
                    {
                        fb.Val3__c = 0;
                    }
                    
                    if (valueMap4.containskey(combiKey) && valueMap4.get(combiKey) != 0)
                    {
                        fb.Val4__c = valueMap4.get(combiKey);
                    }
                    else
                    {
                        fb.Val4__c = 0;
                    }
                    
                    if (valueMap5.containskey(combiKey) && valueMap5.get(combiKey) != 0)
                    {
                        fb.Val5__c = valueMap5.get(combiKey);
                    }
                    else
                    {
                        fb.Val5__c = 0;
                    }
                    
                    if (valueMap6.containskey(combiKey) && valueMap6.get(combiKey) != 0)
                    {
                        fb.Val6__c = valueMap6.get(combiKey);
                    }
                    else
                    {
                        fb.Val6__c = 0;
                    }
                    
                    if (valueMap7.containskey(combiKey) && valueMap7.get(combiKey) != 0)
                    {
                        fb.Val7__c = valueMap7.get(combiKey);
                    }
                    else
                    {
                        fb.Val7__c = 0;
                    }
                    
                    if (valueMap8.containskey(combiKey) && valueMap8.get(combiKey) != 0)
                    {
                        fb.Val8__c = valueMap8.get(combiKey);
                    }
                    else
                    {
                        fb.Val8__c = 0;
                    }
                    
                    if(previousForecast != null && previousForecast.containsKey(combiKey))
                    {
                        fb.LastQForecast__c = previousForecast.get(combiKey).Value_1__c;
                    }            
                    else
                    {
                        fb.LastQForecast__c = 0;
                    }
                }
                
        workingForecastSolutionsConsumablesCheck = workingForecastSolutionsConsumables;       
        return workingForecastSolutionsConsumables;
        
    }
    
    public List<Forecast_Item__c> getTheTotalsJohnson()
    {
        for(Forecast_Item__c fb : workingForecastJohnson)
                {
                    string combiKey = fb.Product_Category__c.touppercase() +'-' + fb.Forecast_Category__c.touppercase();
                    if (valueMap.containskey(combiKey) && valueMap.get(combiKey) != 0)
                    {
                        fb.Val1__c = valueMap.get(combiKey);
                    }
                    else
                    {
                        fb.Val1__c = 0;
                    }
                    if (valueMap2.containskey(combiKey) && valueMap2.get(combiKey) != 0){fb.Val2__c = valueMap2.get(combiKey);}
                    else{fb.Val2__c = 0;
                    }
                    if (valueMap8.containskey(combiKey) && valueMap8.get(combiKey) != 0){fb.Val8__c = valueMap8.get(combiKey);
                    }
                    else
                    {
                        fb.Val8__c = 0;
                    }
                    if (valueMap3.containskey(combiKey) && valueMap3.get(combiKey) != 0){fb.Val3__c = valueMap3.get(combiKey);}
                    else
                    {
                        fb.Val3__c = 0;
                    }
                    if (valueMap4.containskey(combiKey) && valueMap4.get(combiKey) != 0){fb.Val4__c = valueMap4.get(combiKey);}
                    else
                    {
                        fb.Val4__c = 0;
                    }
                    if (valueMap5.containskey(combiKey) && valueMap5.get(combiKey) != 0){fb.Val5__c = valueMap5.get(combiKey);}
                    else
                    {
                        fb.Val5__c = 0;
                    }
                    if (valueMap6.containskey(combiKey) && valueMap6.get(combiKey) != 0){fb.Val6__c = valueMap6.get(combiKey);}
                    else
                    {
                        fb.Val6__c = 0;
                    }
                    if (valueMap7.containskey(combiKey) && valueMap7.get(combiKey) != 0){fb.Val7__c = valueMap7.get(combiKey);}
                    else
                    {
                        fb.Val7__c = 0;
                    }
                    if(previousForecast != null && previousForecast.containsKey(combiKey)){fb.LastQForecast__c = previousForecast.get(combiKey).Value_1__c;}            
                    else
                    {
                        fb.LastQForecast__c = 0;
                    }
            
                }
                
        workingForecastJohnsonCheck = workingForecastJohnson;
        return workingForecastJohnson;
        
    }
    
    public List<Forecast_Item__c> getTheTotalsSolutionsCapital()
    {
        for(Forecast_Item__c fb : workingForecastSolutionsCapital)
                {
                    string combiKey = fb.Product_Category__c.touppercase() +'-' + fb.Forecast_Category__c.touppercase();
                    if (valueMap.containskey(combiKey) && valueMap.get(combiKey) != 0)
                    {
                        fb.Val1__c = valueMap.get(combiKey);
                    }
                    else
                    {
                        fb.Val1__c = 0;
                    }
                    if (valueMap2.containskey(combiKey) && valueMap2.get(combiKey) != 0)
                    {
                        fb.Val2__c = valueMap2.get(combiKey);
                    }
                    else
                    {
                        fb.Val2__c = 0;
                    }
                    if (valueMap8.containskey(combiKey) && valueMap8.get(combiKey) != 0)
                    {
                        fb.Val8__c = valueMap8.get(combiKey);
                    }
                    else
                    {
                        fb.Val8__c = 0;
                    }
                    if (valueMap3.containskey(combiKey) && valueMap3.get(combiKey) != 0)
                    {
                        fb.Val3__c = valueMap3.get(combiKey);
                    }
                    else
                    {
                        fb.Val3__c = 0;
                    }
                    if (valueMap4.containskey(combiKey) && valueMap4.get(combiKey) != 0)
                    {
                        fb.Val4__c = valueMap4.get(combiKey);
                    }
                    else
                    {
                        fb.Val4__c = 0;
                    }
                    if (valueMap5.containskey(combiKey) && valueMap5.get(combiKey) != 0)
                    {
                        fb.Val5__c = valueMap5.get(combiKey);
                    }
                    else
                    {
                        fb.Val5__c = 0;
                    }
                        if (valueMap6.containskey(combiKey) && valueMap6.get(combiKey) != 0)
                    {
                        fb.Val6__c = valueMap6.get(combiKey);
                    }
                    else
                    {
                        fb.Val6__c = 0;
                    }
                    if (valueMap7.containskey(combiKey) && valueMap7.get(combiKey) != 0)
                    {
                        fb.Val7__c = valueMap7.get(combiKey);
                    }
                    else
                    {
                        fb.Val7__c = 0;
                    }
                    if(previousForecast != null && previousForecast.containsKey(combiKey))
                    {                   
                        fb.LastQForecast__c = previousForecast.get(combiKey).Value_1__c;
                    }            
                    else
                    {
                        fb.LastQForecast__c = 0;
                    }
            
                }
        workingForecastSolutionsCapitalCheck = workingForecastSolutionsCapital;
        return workingForecastSolutionsCapital;
        
    }
    
    //this is for district total grid records
    public List<Forecast_Item__c> getTheTotalItems()
    {
        TotalItems = new List<Forecast_Item__c>();
        
        TotalItems.clear();
        
        list<ForecastItemWrapper> toReturn = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks = [select id, Forecast_Category__c, 
                                                        Sort_Order__c,    
                                                        Location__c,         
                                                        Major_Category__c from Forecast_Category__c
                                                        Where Location__c = :strLocation
                                                        order by Sort_Order__c];
           
        map<string, Forecast_Item__c> aggItems = new map<string, Forecast_Item__c>();
        
        for(Forecast_Category__c fc : theBlanks)
        {
            
            string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
            aggItems.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
        }
        
        totalCo = new Forecast_Item__c(Val1__c = 0,
                                Val2__c = 0,
                                Val3__c = 0,
                                Val4__c = 0,
                                Val5__c = 0,
                                Val6__c = 0,
                                Val7__c = 0,
                                Val8__c = 0,
                                Value_1__c = 0,
                                Value_2__c = 0,
                                Value_3__c = 0,
                                Value_4__c = 0,
                                LastQForecast__c = 0);
        
        AggregateResult [] gr = [SELECT Sum(Value_1__c) v1,
                Sum(Value_2__c) v2,
                Sum(Value_3__c) v3,
                Sum(Value_4__c) v4,
                Sum(Val1__c) val1,
                Sum(Val2__c) val2,
                Sum(Val3__c) val3,
                Sum(Val4__c) val4,
                Sum(Val5__c) val5,
                Sum(Val6__c) val6,
                Sum(Val7__c) val7,
                Sum(Val8__c) val8,
                Sum(LastQForecast__c) lasq,
                Name name
            FROM Forecast_Item__c 
            where Forecast_Item__c.Forecast__r.Name =: forecast.Name AND
            Forecast__r.OwnerId =: forecast.OwnerId 
            group by Name];
        
       
        for (AggregateResult  ar : gr)
        {
            string theName = string.valueOf(ar.get('name')).toUpperCase();
            
            if(aggItems.containsKey(theName))
            {
                Forecast_Item__c working = aggItems.get(theName);
                working.Product_Category__c = theName;
                
                if(ar.get('v1') != null) 
                {   working.Value_1__c = Decimal.valueOf(string.valueOf(ar.get('v1'))); 
                    totalCo.Value_1__c += Decimal.ValueOf(string.valueOf(ar.get('v1')));    }
                if(ar.get('v2') != null) 
                {   working.Value_2__c = Decimal.valueOf(string.valueOf(ar.get('v2')));
                    totalCo.Value_2__c += Decimal.ValueOf(string.valueOf(ar.get('v2')));    }
                if(ar.get('v3') != null) 
                {   working.Value_3__c = Decimal.valueOf(string.valueOf(ar.get('v3'))); 
                    totalCo.Value_3__c += Decimal.ValueOf(string.valueOf(ar.get('v3')));    }
                if(ar.get('v4') != null) 
                {   working.Value_4__c = Decimal.valueOf(string.valueOf(ar.get('v4'))); 
                    totalCo.Value_4__c += Decimal.ValueOf(string.valueOf(ar.get('v4')));    }
                if(ar.get('val1') != null) 
                {   working.Val1__c = Decimal.valueOf(string.valueOf(ar.get('val1'))); 
                    totalCo.Val1__c += Decimal.ValueOf(string.valueOf(ar.get('val1')));     }
                if(ar.get('val2') != null) 
                {   working.Val2__c = Decimal.valueOf(string.valueOf(ar.get('val2'))); 
                    totalCo.Val2__c += Decimal.ValueOf(string.valueOf(ar.get('val2')));     }
                if(ar.get('val3') != null) 
                {   working.Val3__c = Decimal.valueOf(string.valueOf(ar.get('val3'))); 
                    totalCo.Val3__c += Decimal.ValueOf(string.valueOf(ar.get('val3')));     }
                if(ar.get('val4') != null) 
                {   working.Val4__c = Decimal.valueOf(string.valueOf(ar.get('val4'))); 
                    totalCo.Val4__c += Decimal.ValueOf(string.valueOf(ar.get('val4')));     }
                if(ar.get('val5') != null) 
                {   working.Val5__c = Decimal.valueOf(string.valueOf(ar.get('val5'))); 
                    totalCo.Val5__c += Decimal.ValueOf(string.valueOf(ar.get('val5')));     }
                if(ar.get('val6') != null) 
                {   working.Val6__c = Decimal.valueOf(string.valueOf(ar.get('val6'))); 
                    totalCo.Val6__c += Decimal.ValueOf(string.valueOf(ar.get('val6')));     }
                if(ar.get('val7') != null) 
                {   working.Val7__c = Decimal.valueOf(string.valueOf(ar.get('val7'))); 
                    totalCo.Val7__c += Decimal.ValueOf(string.valueOf(ar.get('val7')));     }
                if(ar.get('val8') != null) 
                {   working.Val8__c = Decimal.valueOf(string.valueOf(ar.get('val8'))); 
                    totalCo.Val8__c += Decimal.ValueOf(string.valueOf(ar.get('val8')));     }
                if(ar.get('lasq') != null) 
                {   working.LastQForecast__c = Decimal.valueOf(string.valueOf(ar.get('lasq'))); 
                    totalCo.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar.get('lasq')));    }
                aggItems.put(theName, working);
                
            }
                
        }
        
        for(Forecast_Item__c fi : aggItems.values())
        {
            ForecastItemWrapper fiw = new ForecastItemWrapper(fi); 
            toReturn.add(fiw);          
        }
                
        toReturn.sort();
        
        for(ForecastItemWrapper t : toReturn)
        {
            TotalItems.add(t.myTask); 
        }
        return TotalItems;
        
    }
    
    // this is to show (footer)total(Actual) for each tab
    public void mapTheTotals()
    {
        valueMap = new map<string, decimal>();
        decimal footerTotal=0;
        decimal footerTotalJ=0;
        decimal footerTotalM=0;
        
        //set<string> divisionsStrings = new set<string>{'KJ','KSD'};

        //Get all the accounts where this DSM/RSM is a Team Member
        List<Account> members = [SELECT Id FROM Account WHERE (OwnerId = :forecast.OwnerId Or KSD_DSM__c = :forecast.OwnerId Or KJ_RSM__c = :forecast.OwnerId)];
        Set<Id> accountIds = new Set<Id>();
        for(Account member : members) {
            accountIds.add(member.Id);
        }         

        AggregateResult [] gr1 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s1
                and ServiceDate <: e1
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
                
        for (AggregateResult  ar : gr1)
        {
                        
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice')))); 
                
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f1 = footerTotal;
        fj1 = footerTotalJ;
        fm1 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
                  
        valueMap2 = new map<string, decimal>();
        AggregateResult [] gr2 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s2
                and ServiceDate <: e2
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr2)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap2.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));   
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f2 = footerTotal;
        fj2 = footerTotalJ;
        fm2 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
        
        valueMap3 = new map<string, decimal>();
        AggregateResult [] gr3 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s3
                and ServiceDate <: e3
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr3)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap3.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));   
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f3 = footerTotal;
        fj3 = footerTotalJ;
        fm3 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
        
        valueMap4 = new map<string, decimal>();
        AggregateResult [] gr4 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s4
                and ServiceDate <: e4
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr4)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap4.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));   
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f4 = footerTotal;
        fj4 = footerTotalJ;
        fm4 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
        
        valueMap5 = new map<string, decimal>();
        AggregateResult [] gr5 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s5
                and ServiceDate <: e5
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr5)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap5.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));  
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f5 = footerTotal;
        fj5 = footerTotalJ;
        fm5 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
        
        valueMap6 = new map<string, decimal>();
        AggregateResult [] gr6 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s6
                and ServiceDate <: e6
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr6)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap6.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));    
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f6 = footerTotal;
        fj6 = footerTotalJ;
        fm6 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
        
        valueMap7 = new map<string, decimal>();
        AggregateResult [] gr7 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s7
                and ServiceDate <: e7
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr7)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap7.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));     
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f7 = footerTotal;
        fj7 = footerTotalJ;
        fm7 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
        
        valueMap8 = new map<string, decimal>();
        AggregateResult [] gr8 = [SELECT Sum(TotalPrice)thePrice,
                PricebookEntry.Product2.Location__c Loc,
                PricebookEntry.Product2.Family  Fam,
                PricebookEntry.Product2.Comission_Category__c Cat
                FROM OrderItem  
                where Order.AccountId IN :accountIds
                and ServiceDate >=: s8
                and ServiceDate <: e8
                and Order.Division__c = :forecast.Owner_Division__c
                and Order.Account.Mill_Status__c = 'Operating'
                group by PricebookEntry.Product2.Location__c, PricebookEntry.Product2.Family, PricebookEntry.Product2.Comission_Category__c];
        
        for (AggregateResult  ar : gr8)
        {
                string theName = ar.get('Fam') + '-' + ar.get('Cat');
                valueMap8.put(theName.toUpperCase(), Decimal.valueOf(string.valueOf(ar.get('thePrice'))));     
                     
                //calc the footer totals based on the location and category
                string theLoc = String.ValueOf(ar.get('Loc')).toUpperCase();
                string theCat = String.ValueOf(ar.get('Cat')).toUpperCase();
                if (theLoc!= null)
                {
                    if (theLoc.toUppercase() == 'JOHNSON' || theLoc == 'KJ')
                        footerTotalJ+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    else if ((theLoc.toUppercase() == 'SOLUTIONS' || theLoc == 'KSD') && theCat != Null)
                    {
                        if (theCat == 'CONSUMABLES')
                            footerTotal+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                        else if (theCAT == 'CAPITAL')
                            footerTotalM+=Decimal.valueOf(string.valueOf(ar.get('thePrice')));
                    }
                }            
        }
        f8 = footerTotal;
        fj8 = footerTotalJ;
        fm8 = footerTotalM;
        footerTotal=0;
        footerTotalJ=0;
        footerTotalM=0;
    }
    
    public void updateForecastAll()
    {
        updateForecastSolutionsConsumables();
        updateForecastJohnson();
        updateForecastSolutionsCapital();
    }
    
    public Pagereference submit()
    {
        try
        {
            updateForecastSolutionsConsumables();
            updateForecastJohnson();
            updateForecastSolutionsCapital();
            
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(forecast.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            
            User currentUser = [
                SELECT Forecasting_Manager__c FROM User WHERE Id = :UserInfo.getUserId()];
            if (currentUser.Forecasting_Manager__c == true) {
                // Approve the submitted request
                // First, get the ID of the newly created item
                List<Id> newWorkItemIds = result.getNewWorkitemIds();
                
                // Instantiate the new ProcessWorkitemRequest object and populate it
                Approval.ProcessWorkitemRequest req2 = 
                    new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request automatically, because the District Sales Manager is also the Regional Manager.');
                req2.setAction('Approve');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                // Use the ID from the newly created item to specify the item to be worked
                req2.setWorkitemId(newWorkItemIds.get(0));
                
                // Submit the request for approval
                Approval.ProcessResult result2 =  Approval.process(req2); 
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'t  Save'));
        }
        return (new ApexPages.StandardController(forecast)).view();
    }

    public PageReference updateExitForecastSolutionsConsumables()
    {
        updateForecastSolutionsConsumables();
        return (new ApexPages.StandardController(forecast)).view();
    }
    public PageReference cancel()
    {
        return (new ApexPages.StandardController(forecast)).view();
    }
    public void updateForecastSolutionsConsumables()
    {
        try
        {
            update workingForecastSolutionsConsumables;
            getForecast();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'t  Save'));
            getForecast();
        }
    }
    public PageReference updateExitForecastJohnson()
    {
        updateForecastJohnson();
        return (new ApexPages.StandardController(forecast)).view();
    }
    public void updateForecastJohnson()
    {
        try
        {
            update workingForecastJohnson;
            getForecast();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'t  Save'));
            getForecast();
        }
    }
    public PageReference updateExitForecastSolutionsCapital()
    {
        updateForecastSolutionsCapital();
        return (new ApexPages.StandardController(forecast)).view();
    }
    public void updateForecastSolutionsCapital()
    {
        try
        {
            update workingForecastSolutionsCapital;
            getForecast();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'t  Save'));
            getForecast();
        }
    }
    
    public void clearTheTotals()
    {
         totalReg= new Forecast_Item__c(
                                Value_1__c = 0,
                                Value_2__c = 0,
                                Value_3__c = 0,
                                Value_4__c = 0,
                                LastQForecast__c = 0);
        
        totalS= new Forecast_Item__c(
                                Value_1__c = 0,
                                Value_2__c = 0,
                                Value_3__c = 0,
                                Value_4__c = 0,
                                LastQForecast__c = 0);
        
        totalJ= new Forecast_Item__c(
                                Value_1__c = 0,
                                Value_2__c = 0,
                                Value_3__c = 0,
                                Value_4__c = 0,
                                LastQForecast__c = 0);
        totalM= new Forecast_Item__c(
                                Value_1__c = 0,
                                Value_2__c = 0,
                                Value_3__c = 0,
                                Value_4__c = 0,
                                LastQForecast__c = 0);
    }
    
    // this is for forecast footer total
    public void getForecast()
    {
        Date nextDate;
        //schedule the class to every night
        if((Date.today().addMonths(1).toStartOfMonth().addDays(-1)).day() == 28 && (Date.today()).day() == 28 ||
           (Date.today().addMonths(1).toStartOfMonth().addDays(-1)).day() == 29 && (Date.today()).day() == 29 ||
           (Date.today().addMonths(1).toStartOfMonth().addDays(-1)).day() == 30 && (Date.today()).day() == 30 ||
           (Date.today().addMonths(1).toStartOfMonth().addDays(-1)).day() == 31 && (Date.today()).day() == 31 
          )
        {
            nextDate = Date.today().addDays(15);
        }
        else
        {
            nextDate = Date.today().addDays(1);
        }
        
        clearTheTotals();
        
        //check to see if a forecast exists for the current user
        
        string forName = forecast.Forecast_Period__c;
        workingForecastSolutionsConsumables = new list<Forecast_Item__c>();
        workingForecastSolutionsConsumablesCheck = new list<Forecast_Item__c>();
        workingForecastJohnson = new list<Forecast_Item__c>();
        workingForecastSolutionsCapital = new list<Forecast_Item__c>();
         
        
        if(forecast != null) 
        {
            
                //if yes, populate the workingForecast
                List<Forecast_Item__c> workingForecast = [select id, Val1__c ,Val2__c, Val3__c ,Val4__c, Val5__c ,Val6__c, Val7__c ,Val8__c, Value_1__c, Value_2__c, Value_3__c, Value_4__c, Forecast_Category__c, Location__c, Product_Category__c, LastQForecast__c from Forecast_Item__c where Forecast__c = :forecast.Id and Forecast__r.OwnerId = :forecast.OwnerId  order by Location__c, Sort_Order__c];
                
                
                for (Forecast_Item__c fi : workingForecast)
                {
                    if (fi.location__c != null)
                    {
                        string compareLoc = fi.Location__c.ToUpperCase();
                        string compareCat = fi.Forecast_Category__c.ToUpperCase();
                        
                        if((compareLoc == 'SOLUTIONS' || compareLoc == 'KSD') && compareCat == 'CONSUMABLES')
                        {
                            workingForecastSolutionsConsumables.add(fi);                                             
                         
                            if(fi.Value_1__c!=null)
                                totalS.Value_1__c += fi.Value_1__c;
                            if(fi.Value_2__c!=null)
                                totalS.Value_2__c += fi.Value_2__c;
                            if(fi.Value_3__c!=null)
                                totalS.Value_3__c += fi.Value_3__c;
                            if(fi.Value_4__c!=null)
                                totalS.Value_4__c += fi.Value_4__c;
                            if(fi.LastQForecast__c!=null)
                                totalS.LastQForecast__c += fi.LastQForecast__c;                                               
                                                
                            ff4 = totalS.Value_4__c;
                            ff3 = totalS.Value_3__c;
                            ff2 = totalS.Value_2__c;
                            ff1 = totalS.Value_1__c;
                            ffcq = totalS.LastQForecast__c;
                                                
                        }
                        else if (compareLoc == 'JOHNSON' || compareLoc == 'KJ')
                        {
                            workingForecastJohnson.add(fi);
                                                
                            if(fi.Value_1__c!=null)totalJ.Value_1__c += fi.Value_1__c;
                            if(fi.Value_2__c!=null)totalJ.Value_2__c += fi.Value_2__c;
                            if(fi.Value_3__c!=null)totalJ.Value_3__c += fi.Value_3__c;
                            if(fi.Value_4__c!=null)totalJ.Value_4__c += fi.Value_4__c;
                            if(fi.LastQForecast__c!=null)totalJ.LastQForecast__c += fi.LastQForecast__c;
                                                
                            ffj4 = totalJ.Value_4__c;
                            ffj3 = totalJ.Value_3__c;
                            ffj2 = totalJ.Value_2__c;
                            ffj1 = totalJ.Value_1__c;
                            ffcqj = totalJ.LastQForecast__c;
                         }
                         else if ((compareLoc == 'SOLUTIONS' || compareLoc == 'KSD') && compareCat == 'CAPITAL')
                         {
                            workingForecastSolutionsCapital.add(fi);
                                                
                            if(fi.Value_1__c!=null)totalM.Value_1__c += fi.Value_1__c;
                            if(fi.Value_2__c!=null)totalM.Value_2__c += fi.Value_2__c;
                            if(fi.Value_3__c!=null)totalM.Value_3__c += fi.Value_3__c;
                            if(fi.Value_4__c!=null)totalM.Value_4__c += fi.Value_4__c;
                            if(fi.LastQForecast__c!=null)totalM.LastQForecast__c += fi.LastQForecast__c;
                                                
                            ffm4 = totalM.Value_4__c;
                            ffm3 = totalM.Value_3__c;
                            ffm2 = totalM.Value_2__c;
                            ffm1 = totalM.Value_1__c;
                            ffcqm = totalM.LastQForecast__c;
                         }                                    
                    }
                }
        }
        mapTheTotals();
    }
    
    public void getLastQuarterForecast()
    {        
        string forName = forecast.Forecast_Period__c;
        list<Forecast_Item__c> previousForecastItems = [select id, Value_1__c,Value_2__c,Value_3__c,Value_4__c,Forecast_Category__c,Product_Category__c, Location__c
            from Forecast_Item__c where Forecast__r.Name = :forName and Forecast__r.OwnerId = :forecast.OwnerId];
        if(!previousForecastItems.isEmpty())
        mapPreviousForecast(previousForecastItems);
    }
    
    public void mapPreviousForecast(list<Forecast_Item__c> MyForecast)
    {        
        flqs = 0;
        flqj = 0;
        flqmc = 0;
        previousForecast = new map<string, Forecast_Item__c>();
        if (!MyForecast.isEmpty())
        {
                for (Forecast_Item__c fi : MyForecast)
                {
                        string mkey = fi.Product_Category__c + '-' + fi.Forecast_Category__c;
                        previousForecast.put(mkey.toUpperCase(), fi);
                        
                        if (fi.Location__c != null && fi.Value_1__c != null)
                        {
                                if((fi.Location__c.toUpperCase() == 'SOLUTIONS' || fi.Location__c.toUpperCase() == 'KSD') && fi.Forecast_Category__c.toUpperCase() == 'CONSUMABLES')
                                                flqs += fi.Value_1__c;
                                if(fi.Location__c.toUpperCase() == 'JOHNSON' || fi.Location__c.toUpperCase() == 'KJ')
                                                flqj += fi.Value_1__c;
                                if((fi.Location__c.toUpperCase() == 'SOLUTIONS' || fi.Location__c.toUpperCase() == 'KSD') && fi.Forecast_Category__c.toUpperCase() == 'CAPITAL')
                                                flqmc += fi.Value_1__c;
                        }
                }
        }
    }
    
    public void getDates()
    {
        //determine which quarter is the current one
        curt = new Period();
        integer limitQ = 0;
        if (fCastBaseDate != null)
        {
            string fYear = string.valueOf(fCastBaseDate.addMonths(1).year());
            boolean onCurrent = false;
        
            for (Period p : periods)
            { 
                Date theChk = fCastBaseDate.addMonths(1);
              
                if (limitQ == 8)
                    break;
                else if (p.StartDate <= theChk && p.EndDate >= theChk)
                {
                    curt = p;
                    currentQuarter = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + '(Actual)';
                    onCurrent = true;                   
                    limitQ += 1;
                    h8 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + '(Actual)';
                    s8 = p.StartDate; 
                    e8 = p.EndDate;
                    onCurrent = false;
               
                }
                else if (p.EndDate <= theChk && limitQ == 1)
                {
                    h7 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s7 = p.StartDate; 
                    e7 = p.EndDate;
                    
                }
                else if (p.EndDate <= theChk && limitQ == 2) 
                {
                    h6 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s6 = p.StartDate; 
                    e6 = p.EndDate;
                   
                }
                else if (p.EndDate <= theChk && limitQ == 3)
                {
                    h5 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s5 = p.StartDate; 
                    e5 = p.EndDate;
                    
                }
                else if (p.EndDate <= theChk && limitQ == 4)
                {
                    h4 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s4 = p.StartDate; 
                    e4 = p.EndDate;
                    
                }
                else if (p.EndDate <= theChk && limitQ == 5)
                {
                    h3 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s3 = p.StartDate; 
                    e3 = p.EndDate;
                   
                }
                else if (p.EndDate <= theChk && limitQ == 6)
                {
                    h2 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s2 = p.StartDate; 
                    e2 = p.EndDate;
                   
                }
                else if (p.EndDate <= theChk && limitQ == 7)
                {
                    h1 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
                    s1 = p.StartDate; 
                    e1 = p.EndDate;
                }
            }
        
            for (integer i=0; i<3; i++) 
            {
                if (curt.Number == 1)
                {   
                    fh1 = 'Q2 ' + fyear;
                    fh2 = 'Q3 ' + fyear;
                    fh3 = 'Q4 ' + fyear;
                    fh4 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);     
                }
                else if (curt.Number == 2)
                {   
                    fh1 = 'Q3 ' + fyear;
                    fh2 = 'Q4 ' + fyear;
                    fh3 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);
                    fh4 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);     
                }
                else if (curt.Number == 3)
                {   
                    fh1 = 'Q4 ' + fyear;
                    fh2 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);
                    fh3 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);
                    fh4 = 'Q3 ' + string.valueOf(integer.valueOf(fyear)+1);     
                }
                else if (curt.Number == 4)
                {   
                    fh1 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);
                    fh2 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);
                    fh3 = 'Q3 ' + string.valueOf(integer.valueOf(fyear)+1);
                    fh4 = 'Q4 ' + string.valueOf(integer.valueOf(fyear)+1);     
                }
            }
        }
    }
    
    public Forecast_Item__c getTotalCo()
    {
        return totalCo;
    }
}