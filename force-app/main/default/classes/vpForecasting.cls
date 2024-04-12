public with sharing class vpForecasting 
{
        public list<Forecast_Item__c> TheItemsW = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TheItemsA = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TheItemsJ = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TheItemsM = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItems = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItems2 = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItems3 = new list<Forecast_Item__c>();
        
        public list<Forecast_Item__c> TotalItemsRegional = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItemsRegional2 = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItemsRegional3 = new list<Forecast_Item__c>();
        
        public String getRegion {get; set;}
        
        Forecast_Item__c totalReg= new Forecast_Item__c(Val1__c = 0,
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
                               
        Forecast_Item__c totalReg2= new Forecast_Item__c(Val1__c = 0,
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
                              
        Forecast_Item__c totalReg3= new Forecast_Item__c(Val1__c = 0,
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
        
        Forecast_Item__c totalCo= new Forecast_Item__c(Val1__c = 0,
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
                                
        Forecast_Item__c totalCo2= new Forecast_Item__c(Val1__c = 0,
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
                                
        Forecast_Item__c totalCo3= new Forecast_Item__c(Val1__c = 0,
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
        
        Forecast_Item__c totalWeb= new Forecast_Item__c(Val1__c = 0,
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
        
        Forecast_Item__c totalA= new Forecast_Item__c(Val1__c = 0,
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
        Forecast_Item__c totalJ= new Forecast_Item__c(Val1__c = 0,
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
        Forecast_Item__c totalM= new Forecast_Item__c(Val1__c = 0,
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
        
        set<id> myUsers = new set<Id>();
        
        
        
    public Period curt;//the current quarter
        
    public String selectedUser {get;set;}
    public String selectedQuarter {get;set;}
    public String selectedManager {get;set;}
    public String currentQuarter{get;set;}
    
    public String strProductFamily {get;set;}
    public String strCommissionCategory {get;set;}
    
    // Selected Tab
    public String selectedTab {get;set;}
    
    //the forecasted column headers
    public String fh1 {get;set;}
    public String fh2 {get;set;}
    public String fh3 {get;set;}
    public String fh4 {get;set;}
    
    //the footers
    public String f1 {get;set;}
    public String f2 {get;set;}
    public String f3 {get;set;}
    public String f4 {get;set;}
    public String f5 {get;set;}
    public String f6 {get;set;}
    public String f7 {get;set;}
    public String f8 {get;set;}
    
        //the headers
    public string h1{get; set;}
    public string h2{get; set;}
    public string h3{get; set;}
    public string h4{get; set;}
    public string h5{get; set;}
    public string h6{get; set;}
    public string h7{get; set;}
    public string h8{get; set;}
    
    //the totals
    
    public String flqweb {get;set;}
    
    public vpForecasting()
    {
        // setting the selected tab on load
        selectedTab = 'Web';
        
        getCurrentQuarter();
        list<selectOption> theOptions = getTheQuarters();
        getDates();
        getUsers();
        getAllUsers();
        getAggResults();
        getAggResults2();
    }
    
    public Forecast__c forecast
        {
                get
                {
                        forecast = [SELECT Owner.Alias FROM Forecast__c WHERE OwnerId =: selectedUser AND Name = :selectedQuarter And Account_Forecast__c = false];
                        return forecast;
                }
                set;
        }
    
    public list<Period> periods
    {
            get
            {
                if(periods == null)
                periods = [Select p.Type, p.StartDate, p.Number, p.Id, p.FiscalYearSettingsId, p.FiscalYearSettings.Name, p.EndDate 
                           From Period p where type = 'Quarter' order by EndDate desc];
                               
                return periods;
            }
            set;
    }
    public List<SelectOption> getTheQuarters()
    {
        list<SelectOption> myOptions = new list<SelectOption>();
        string fYear = string.valueOf(Date.today().year());             
                
        Forecast__c lastforecast = [SELECT Forecast_Quarter__c, Name FROM Forecast__c Where Account_Forecast__c = false ORDER BY Forecast_Year__c DESC, Forecast_Quarter__c DESC LIMIT 1];
        string currentQ = lastforecast.Forecast_Quarter__c;
        string currentQString = lastforecast.Name;
                
        if (currentQ == 'Q1')
        {
            SelectOption option0 = new SelectOption(currentQString, currentQString);
            if (selectedQuarter == null)
                selectedQuarter = option0.getLabel();
            myOptions.add(option0);
            SelectOption option1 = new SelectOption('Q4 ' + string.valueOf(integer.valueOf(fyear)-1), 'Q4 ' + string.valueOf(integer.valueOf(fyear)-1));
            myOptions.add(option1);
            SelectOption option2 = new SelectOption('Q3 ' + string.valueOf(integer.valueOf(fyear)-1), 'Q3 ' + string.valueOf(integer.valueOf(fyear)-1));
            myOptions.add(option2);
            SelectOption option3 = new SelectOption('Q2 ' + string.valueOf(integer.valueOf(fyear)-1), 'Q2 ' + string.valueOf(integer.valueOf(fyear)-1));
            myOptions.add(option3);        
        }
        else if (currentQ == 'Q2')
        {
            SelectOption option0 = new SelectOption(currentQString, currentQString);
            if (selectedQuarter == null)
                selectedQuarter = option0.getLabel();
            myOptions.add(option0);
            SelectOption option1 = new SelectOption('Q1 ' + string.valueOf(integer.valueOf(fyear)), 'Q1 ' + string.valueOf(integer.valueOf(fyear)));
            myOptions.add(option1);
            SelectOption option2 = new SelectOption('Q4 ' + string.valueOf(integer.valueOf(fyear)-1), 'Q4 ' + string.valueOf(integer.valueOf(fyear)-1));
            myOptions.add(option2);
            SelectOption option3 = new SelectOption('Q3 ' + string.valueOf(integer.valueOf(fyear)-1), 'Q3 ' + string.valueOf(integer.valueOf(fyear)-1));
            myOptions.add(option3);          
        }
        else if (currentQ == 'Q3')
        {
            SelectOption option0 = new SelectOption(currentQString, currentQString);
            if (selectedQuarter == null)
                selectedQuarter = option0.getLabel();
            myOptions.add(option0);
            SelectOption option1 = new SelectOption('Q2 ' + string.valueOf(integer.valueOf(fyear)), 'Q2 ' + string.valueOf(integer.valueOf(fyear)));
            myOptions.add(option1);
            SelectOption option2 = new SelectOption('Q1 ' + string.valueOf(integer.valueOf(fyear)), 'Q1 ' + string.valueOf(integer.valueOf(fyear)));
            myOptions.add(option2);
            SelectOption option3 = new SelectOption('Q4 ' + string.valueOf(integer.valueOf(fyear)-1), 'Q4 ' + string.valueOf(integer.valueOf(fyear)-1));
            myOptions.add(option3);          
        }
        else if (currentQ == 'Q4')
        {
            SelectOption option0 = new SelectOption(currentQString, currentQString);
            if (selectedQuarter == null)
                selectedQuarter = option0.getLabel();
            myOptions.add(option0);
            SelectOption option1 = new SelectOption('Q3 ' + string.valueOf(integer.valueOf(fyear)), 'Q3 ' + string.valueOf(integer.valueOf(fyear)));
            myOptions.add(option1);
            SelectOption option2 = new SelectOption('Q2 ' + string.valueOf(integer.valueOf(fyear)), 'Q2 ' + string.valueOf(integer.valueOf(fyear)));
            myOptions.add(option2);
            SelectOption option3 = new SelectOption('Q1 ' + string.valueOf(integer.valueOf(fyear)), 'Q1 ' + string.valueOf(integer.valueOf(fyear)));
            myOptions.add(option3);          
        }
        return myOptions;           
    }
    public void getAggResults()
    {
        //---------------------------Used for bifurcating Kadant Solutions Division------------------------------------
        
        TotalItems.clear();
        
        list<ForecastItemWrapper> toReturn = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c
            order by Sort_Order__c];
            
        map<string, Forecast_Item__c> aggItems = new map<string, Forecast_Item__c>();
        
        if (theBlanks.size() > 0)
        {
            for(Forecast_Category__c fc : theBlanks)
            {
                if(!String.isBlank(fc.Major_Category__c) && !String.isBlank(fc.Forecast_Category__c))
                {
                    string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                    aggItems.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                }
            }
        }
        
        totalCo = new Forecast_Item__c(
                                Val1__c = 0,
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
            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter and Forecast_Item__c.Forecast_Category__c != 'JOHNSON'
            group by Name];
        
        for (AggregateResult  ar : gr)
        {
            string theName = string.valueOf(ar.get('name')).toUpperCase();
            
            if(aggItems.containsKey(theName))
            {
                Forecast_Item__c working = aggItems.get(theName);
                working.Product_Category__c = theName;
                
                if(ar.get('v1') != null) 
                {   
                    working.Value_1__c = Decimal.valueOf(string.valueOf(ar.get('v1'))); 
                    totalCo.Value_1__c += Decimal.ValueOf(string.valueOf(ar.get('v1')));    
                }
                    
                if(ar.get('v2') != null) 
                {
                    working.Value_2__c = Decimal.valueOf(string.valueOf(ar.get('v2')));
                    totalCo.Value_2__c += Decimal.ValueOf(string.valueOf(ar.get('v2')));    
                }
                if(ar.get('v3') != null) 
                {   
                    working.Value_3__c = Decimal.valueOf(string.valueOf(ar.get('v3'))); 
                    totalCo.Value_3__c += Decimal.ValueOf(string.valueOf(ar.get('v3')));    
                }
                if(ar.get('v4') != null) 
                {   
                    working.Value_4__c = Decimal.valueOf(string.valueOf(ar.get('v4'))); 
                    totalCo.Value_4__c += Decimal.ValueOf(string.valueOf(ar.get('v4')));    
                }
                if(ar.get('val1') != null) 
                {   
                    working.Val1__c = Decimal.valueOf(string.valueOf(ar.get('val1'))); 
                    totalCo.Val1__c += Decimal.ValueOf(string.valueOf(ar.get('val1')));     
                }
                if(ar.get('val2') != null) 
                {   
                    working.Val2__c = Decimal.valueOf(string.valueOf(ar.get('val2'))); 
                    totalCo.Val2__c += Decimal.ValueOf(string.valueOf(ar.get('val2')));     
                }
                if(ar.get('val3') != null) 
                {   
                    working.Val3__c = Decimal.valueOf(string.valueOf(ar.get('val3'))); 
                    totalCo.Val3__c += Decimal.ValueOf(string.valueOf(ar.get('val3')));     
                }
                if(ar.get('val4') != null) 
                {   
                    working.Val4__c = Decimal.valueOf(string.valueOf(ar.get('val4'))); 
                    totalCo.Val4__c += Decimal.ValueOf(string.valueOf(ar.get('val4')));     
                }
                if(ar.get('val5') != null) 
                {   
                    working.Val5__c = Decimal.valueOf(string.valueOf(ar.get('val5'))); 
                    totalCo.Val5__c += Decimal.ValueOf(string.valueOf(ar.get('val5')));     
                }
                if(ar.get('val6') != null) 
                {   
                    working.Val6__c = Decimal.valueOf(string.valueOf(ar.get('val6'))); 
                    totalCo.Val6__c += Decimal.ValueOf(string.valueOf(ar.get('val6')));     
                }
                if(ar.get('val7') != null) 
                {   
                    working.Val7__c = Decimal.valueOf(string.valueOf(ar.get('val7'))); 
                    totalCo.Val7__c += Decimal.ValueOf(string.valueOf(ar.get('val7')));     
                }
                if(ar.get('val8') != null) 
                {   
                    working.Val8__c = Decimal.valueOf(string.valueOf(ar.get('val8'))); 
                    totalCo.Val8__c += Decimal.ValueOf(string.valueOf(ar.get('val8')));     
                }
                if(ar.get('lasq') != null) 
                {   
                    working.LastQForecast__c = Decimal.valueOf(string.valueOf(ar.get('lasq'))); 
                    totalCo.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar.get('lasq')));    
                }
                aggItems.put(theName, working);
                
            }    
        }
        
        for(Forecast_Item__c fi : aggItems.values())
        {
            if( (fi.Value_1__c != null && String.valueOf(fi.Value_1__c) != '') ||
                (fi.Value_2__c != null && String.valueOf(fi.Value_2__c) != '') ||
                (fi.Value_3__c != null && String.valueOf(fi.Value_3__c) != '') ||
                (fi.Value_4__c != null && String.valueOf(fi.Value_4__c) != '') ||
                (fi.Val1__c != null && String.valueOf(fi.Val1__c) != '') ||
                (fi.Val2__c != null && String.valueOf(fi.Val2__c) != '') ||
                (fi.Val3__c != null && String.valueOf(fi.Val3__c) != '') ||
                (fi.Val4__c != null && String.valueOf(fi.Val4__c) != '') ||
                (fi.Val5__c != null && String.valueOf(fi.Val5__c) != '') ||
                (fi.Val6__c != null && String.valueOf(fi.Val6__c) != '') ||
                (fi.Val7__c != null && String.valueOf(fi.Val7__c) != '') ||
                (fi.Val8__c != null && String.valueOf(fi.Val8__c) != '') ||
                (fi.LastQForecast__c != null && String.valueOf(fi.LastQForecast__c) != '') 
              )
            {
                ForecastItemWrapper fiw = new ForecastItemWrapper(fi); 
                toReturn.add(fiw);  
            }       
            
        }
                
        toReturn.sort();
        
        for(ForecastItemWrapper t : toReturn)
        {
                TotalItems.add(t.myTask);
        }
        
        //---------------------------Used for bifurcating Kadant Johnson------------------------------------
        
        TotalItems2.clear();
        
        list<ForecastItemWrapper> toReturn2 = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks2 = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c
            order by Sort_Order__c];
            
        map<string, Forecast_Item__c> aggItems2 = new map<string, Forecast_Item__c>();
        
        if (theBlanks2.size() > 0)
        {
            for(Forecast_Category__c fc : theBlanks2)
            {
                if(!String.isBlank(fc.Major_Category__c) && !String.isBlank(fc.Forecast_Category__c))
                {
                    string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                    aggItems2.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                }
            }
        }

        totalCo2 = new Forecast_Item__c(
                                Val1__c = 0,
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
        
        AggregateResult [] gr2 = [SELECT Sum(Value_1__c) v1,
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
            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter and Forecast_Item__c.Forecast_Category__c = 'JOHNSON'
            group by Name];
        
        for (AggregateResult  ar2 : gr2)
        {
            string theName2 = string.valueOf(ar2.get('name')).toUpperCase();
            
            if(aggItems2.containsKey(theName2))
            {
                Forecast_Item__c working2 = aggItems2.get(theName2);
                working2.Product_Category__c = theName2;
                
                if(ar2.get('v1') != null) 
                {   
                    working2.Value_1__c = Decimal.valueOf(string.valueOf(ar2.get('v1'))); 
                    totalCo2.Value_1__c += Decimal.ValueOf(string.valueOf(ar2.get('v1')));  
                }
                    
                if(ar2.get('v2') != null) 
                {
                    working2.Value_2__c = Decimal.valueOf(string.valueOf(ar2.get('v2')));
                    totalCo2.Value_2__c += Decimal.ValueOf(string.valueOf(ar2.get('v2')));  
                }
                if(ar2.get('v3') != null) 
                {   
                    working2.Value_3__c = Decimal.valueOf(string.valueOf(ar2.get('v3'))); 
                    totalCo2.Value_3__c += Decimal.ValueOf(string.valueOf(ar2.get('v3')));  
                }
                if(ar2.get('v4') != null) 
                {   
                    working2.Value_4__c = Decimal.valueOf(string.valueOf(ar2.get('v4'))); 
                    totalCo2.Value_4__c += Decimal.ValueOf(string.valueOf(ar2.get('v4')));  
                }
                if(ar2.get('val1') != null) 
                {   
                    working2.Val1__c = Decimal.valueOf(string.valueOf(ar2.get('val1'))); 
                    totalCo2.Val1__c += Decimal.ValueOf(string.valueOf(ar2.get('val1')));       
                }
                if(ar2.get('val2') != null) 
                {   
                    working2.Val2__c = Decimal.valueOf(string.valueOf(ar2.get('val2'))); 
                    totalCo2.Val2__c += Decimal.ValueOf(string.valueOf(ar2.get('val2')));       
                }
                if(ar2.get('val3') != null) 
                {   
                    working2.Val3__c = Decimal.valueOf(string.valueOf(ar2.get('val3'))); 
                    totalCo2.Val3__c += Decimal.ValueOf(string.valueOf(ar2.get('val3')));       
                }
                if(ar2.get('val4') != null) 
                {   
                    working2.Val4__c = Decimal.valueOf(string.valueOf(ar2.get('val4'))); 
                    totalCo2.Val4__c += Decimal.ValueOf(string.valueOf(ar2.get('val4')));       
                }
                if(ar2.get('val5') != null) 
                {   
                    working2.Val5__c = Decimal.valueOf(string.valueOf(ar2.get('val5'))); 
                    totalCo2.Val5__c += Decimal.ValueOf(string.valueOf(ar2.get('val5')));       
                }
                if(ar2.get('val6') != null) 
                {   
                    working2.Val6__c = Decimal.valueOf(string.valueOf(ar2.get('val6'))); 
                    totalCo2.Val6__c += Decimal.ValueOf(string.valueOf(ar2.get('val6')));       
                }
                if(ar2.get('val7') != null) 
                {   
                    working2.Val7__c = Decimal.valueOf(string.valueOf(ar2.get('val7'))); 
                    totalCo2.Val7__c += Decimal.ValueOf(string.valueOf(ar2.get('val7')));       
                }
                if(ar2.get('val8') != null) 
                {   
                    working2.Val8__c = Decimal.valueOf(string.valueOf(ar2.get('val8'))); 
                    totalCo2.Val8__c += Decimal.ValueOf(string.valueOf(ar2.get('val8')));       
                }
                if(ar2.get('lasq') != null) 
                {   
                    working2.LastQForecast__c = Decimal.valueOf(string.valueOf(ar2.get('lasq'))); 
                    totalCo2.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar2.get('lasq')));  
                }
                aggItems2.put(theName2, working2);
                
            }    
        }
        
        for(Forecast_Item__c fi : aggItems2.values())
        {
            if( (fi.Value_1__c != null && String.valueOf(fi.Value_1__c) != '') ||
                (fi.Value_2__c != null && String.valueOf(fi.Value_2__c) != '') ||
                (fi.Value_3__c != null && String.valueOf(fi.Value_3__c) != '') ||
                (fi.Value_4__c != null && String.valueOf(fi.Value_4__c) != '') ||
                (fi.Val1__c != null && String.valueOf(fi.Val1__c) != '') ||
                (fi.Val2__c != null && String.valueOf(fi.Val2__c) != '') ||
                (fi.Val3__c != null && String.valueOf(fi.Val3__c) != '') ||
                (fi.Val4__c != null && String.valueOf(fi.Val4__c) != '') ||
                (fi.Val5__c != null && String.valueOf(fi.Val5__c) != '') ||
                (fi.Val6__c != null && String.valueOf(fi.Val6__c) != '') ||
                (fi.Val7__c != null && String.valueOf(fi.Val7__c) != '') ||
                (fi.Val8__c != null && String.valueOf(fi.Val8__c) != '') ||
                (fi.LastQForecast__c != null && String.valueOf(fi.LastQForecast__c) != '') 
              )
            {
                ForecastItemWrapper fiw2 = new ForecastItemWrapper(fi); 
                toReturn2.add(fiw2);    
            }       
            
        }
                
        toReturn2.sort();
        
        for(ForecastItemWrapper t : toReturn2)
        {
                TotalItems2.add(t.myTask);
        }
        
        //---------------------------Used for Grand Total Numbers------------------------------------
        
        TotalItems3.clear();
        
        list<ForecastItemWrapper> toReturn3 = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks3 = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c
            order by Sort_Order__c];
            
        map<string, Forecast_Item__c> aggItems3 = new map<string, Forecast_Item__c>();
        
        if (theBlanks3.size() > 0)
        {
            for(Forecast_Category__c fc : theBlanks3)
            {
                if(!String.isBlank(fc.Major_Category__c) && !String.isBlank(fc.Forecast_Category__c))
                {
                    string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                    aggItems3.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                }
            }
        }

        totalCo3 = new Forecast_Item__c(
                                Val1__c = 0,
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
        
        AggregateResult [] gr3 = [SELECT Sum(Value_1__c) v1,
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
            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter
            group by Name];
        
        for (AggregateResult  ar3 : gr3)
        {
            string theName = string.valueOf(ar3.get('name')).toUpperCase();
            
            if(aggItems3.containsKey(theName))
            {
                Forecast_Item__c working3 = aggItems3.get(theName);
                working3.Product_Category__c = theName;
                
                if(ar3.get('v1') != null) 
                {   
                    working3.Value_1__c = Decimal.valueOf(string.valueOf(ar3.get('v1'))); 
                    totalCo3.Value_1__c += Decimal.ValueOf(string.valueOf(ar3.get('v1')));  
                }
                    
                if(ar3.get('v2') != null) 
                {
                    working3.Value_2__c = Decimal.valueOf(string.valueOf(ar3.get('v2')));
                    totalCo3.Value_2__c += Decimal.ValueOf(string.valueOf(ar3.get('v2')));  
                }
                if(ar3.get('v3') != null) 
                {   
                    working3.Value_3__c = Decimal.valueOf(string.valueOf(ar3.get('v3'))); 
                    totalCo3.Value_3__c += Decimal.ValueOf(string.valueOf(ar3.get('v3')));  
                }
                if(ar3.get('v4') != null) 
                {   
                    working3.Value_4__c = Decimal.valueOf(string.valueOf(ar3.get('v4'))); 
                    totalCo3.Value_4__c += Decimal.ValueOf(string.valueOf(ar3.get('v4')));  
                }
                if(ar3.get('val1') != null) 
                {   
                    working3.Val1__c = Decimal.valueOf(string.valueOf(ar3.get('val1'))); 
                    totalCo3.Val1__c += Decimal.ValueOf(string.valueOf(ar3.get('val1')));       
                }
                if(ar3.get('val2') != null) 
                {   
                    working3.Val2__c = Decimal.valueOf(string.valueOf(ar3.get('val2'))); 
                    totalCo3.Val2__c += Decimal.ValueOf(string.valueOf(ar3.get('val2')));       
                }
                if(ar3.get('val3') != null) 
                {   
                    working3.Val3__c = Decimal.valueOf(string.valueOf(ar3.get('val3'))); 
                    totalCo3.Val3__c += Decimal.ValueOf(string.valueOf(ar3.get('val3')));       
                }
                if(ar3.get('val4') != null) 
                {   
                    working3.Val4__c = Decimal.valueOf(string.valueOf(ar3.get('val4'))); 
                    totalCo3.Val4__c += Decimal.ValueOf(string.valueOf(ar3.get('val4')));       
                }
                if(ar3.get('val5') != null) 
                {   
                    working3.Val5__c = Decimal.valueOf(string.valueOf(ar3.get('val5'))); 
                    totalCo3.Val5__c += Decimal.ValueOf(string.valueOf(ar3.get('val5')));       
                }
                if(ar3.get('val6') != null) 
                {   
                    working3.Val6__c = Decimal.valueOf(string.valueOf(ar3.get('val6'))); 
                    totalCo3.Val6__c += Decimal.ValueOf(string.valueOf(ar3.get('val6')));       
                }
                if(ar3.get('val7') != null) 
                {   
                    working3.Val7__c = Decimal.valueOf(string.valueOf(ar3.get('val7'))); 
                    totalCo3.Val7__c += Decimal.ValueOf(string.valueOf(ar3.get('val7')));       
                }
                if(ar3.get('val8') != null) 
                {   
                    working3.Val8__c = Decimal.valueOf(string.valueOf(ar3.get('val8'))); 
                    totalCo3.Val8__c += Decimal.ValueOf(string.valueOf(ar3.get('val8')));       
                }
                if(ar3.get('lasq') != null) 
                {   
                    working3.LastQForecast__c = Decimal.valueOf(string.valueOf(ar3.get('lasq'))); 
                    totalCo3.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar3.get('lasq')));  
                }
                aggItems3.put(theName, working3);
                
            }    
        }
        
        for(Forecast_Item__c fi : aggItems3.values())
        {
            if( (fi.Value_1__c != null && String.valueOf(fi.Value_1__c) != '') ||
                (fi.Value_2__c != null && String.valueOf(fi.Value_2__c) != '') ||
                (fi.Value_3__c != null && String.valueOf(fi.Value_3__c) != '') ||
                (fi.Value_4__c != null && String.valueOf(fi.Value_4__c) != '') ||
                (fi.Val1__c != null && String.valueOf(fi.Val1__c) != '') ||
                (fi.Val2__c != null && String.valueOf(fi.Val2__c) != '') ||
                (fi.Val3__c != null && String.valueOf(fi.Val3__c) != '') ||
                (fi.Val4__c != null && String.valueOf(fi.Val4__c) != '') ||
                (fi.Val5__c != null && String.valueOf(fi.Val5__c) != '') ||
                (fi.Val6__c != null && String.valueOf(fi.Val6__c) != '') ||
                (fi.Val7__c != null && String.valueOf(fi.Val7__c) != '') ||
                (fi.Val8__c != null && String.valueOf(fi.Val8__c) != '') ||
                (fi.LastQForecast__c != null && String.valueOf(fi.LastQForecast__c) != '') 
              )
            {
                ForecastItemWrapper fiw = new ForecastItemWrapper(fi); 
                toReturn3.add(fiw); 
            }       
            
        }
                
        toReturn3.sort();
        
        for(ForecastItemWrapper t : toReturn3)
        {
                TotalItems3.add(t.myTask);
                TotalItems3.clear();
        }
        
    }
    
    public void getAggResults2()
    {
        
        //---------------------------Used for bifurcating Kadant Solutions Division------------------------------------
        TotalItemsRegional.clear();
        list<ForecastItemWrapper> toReturn = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c
            order by Sort_Order__c];
            
                totalReg= new Forecast_Item__c(Val1__c = 0,
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
                                
        map<string, Forecast_Item__c> aggItems = new map<string, Forecast_Item__c>();
        
        if (theBlanks.size() > 0)
        {
            for(Forecast_Category__c fc : theBlanks)
            {
                if(!String.isBlank(fc.Major_Category__c) && !String.isBlank(fc.Forecast_Category__c))
                {
                    string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                    aggItems.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                }
            }
        }

        set<id> userSubset = new set<id>();
        
        if(selectedManager != null)
        {
            for (User u : [select id from User where ManagerId =: selectedManager ])
                userSubset.add(u.Id);
        }
        
        if(selectedManager != null)
        {
            User u1 = [Select Region__c from User where ManagerId =: selectedManager and Region__c != NULL limit 1];
            getRegion = String.valueOf(u1.Region__c);
        }
        
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
            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter and Forecast_Item__c.Forecast_Category__c != 'JOHNSON'
            and Forecast__r.OwnerId IN: userSubset
            group by Name
            order by Name];
        
        for (AggregateResult  ar : gr)
        {
            string theName = string.valueOf(ar.get('name')).toUpperCase();
            if(aggItems.containsKey(theName))
            {
                Forecast_Item__c working = aggItems.get(theName);
                working.Product_Category__c = theName;
          
                if(ar.get('v1') != null) 
                {
                    working.Value_1__c = Decimal.valueOf(string.valueOf(ar.get('v1'))); 
                    totalReg.Value_1__c += Decimal.ValueOf(string.valueOf(ar.get('v1')));   
                }
                if(ar.get('v2') != null) 
                {   
                    working.Value_2__c = Decimal.valueOf(string.valueOf(ar.get('v2'))); 
                    totalReg.Value_2__c += Decimal.ValueOf(string.valueOf(ar.get('v2')));   
                }
                if(ar.get('v3') != null) 
                {   
                    working.Value_3__c = Decimal.valueOf(string.valueOf(ar.get('v3'))); 
                    totalReg.Value_3__c += Decimal.ValueOf(string.valueOf(ar.get('v3')));   
                }
                if(ar.get('v4') != null) 
                {   
                    working.Value_4__c = Decimal.valueOf(string.valueOf(ar.get('v4'))); 
                    totalReg.Value_4__c += Decimal.ValueOf(string.valueOf(ar.get('v4')));   
                }
                if(ar.get('val1') != null) 
                {   
                    working.Val1__c = Decimal.valueOf(string.valueOf(ar.get('val1'))); 
                    totalReg.Val1__c += Decimal.ValueOf(string.valueOf(ar.get('val1')));    
                }
                if(ar.get('val2') != null) 
                {   
                    working.Val2__c = Decimal.valueOf(string.valueOf(ar.get('val2'))); 
                    totalReg.Val2__c += Decimal.ValueOf(string.valueOf(ar.get('val2')));    
                }
                if(ar.get('val3') != null) 
                {   
                    working.Val3__c = Decimal.valueOf(string.valueOf(ar.get('val3'))); 
                    totalReg.Val3__c += Decimal.ValueOf(string.valueOf(ar.get('val3')));    
                }
                if(ar.get('val4') != null) 
                {   
                    working.Val4__c = Decimal.valueOf(string.valueOf(ar.get('val4'))); 
                    totalReg.Val4__c += Decimal.ValueOf(string.valueOf(ar.get('val4')));    
                }
                if(ar.get('val5') != null) 
                {   
                    working.Val5__c = Decimal.valueOf(string.valueOf(ar.get('val5'))); 
                    totalReg.Val5__c += Decimal.ValueOf(string.valueOf(ar.get('val5')));    
                }
                if(ar.get('val6') != null) 
                {   
                    working.Val6__c = Decimal.valueOf(string.valueOf(ar.get('val6'))); 
                    totalReg.Val6__c += Decimal.ValueOf(string.valueOf(ar.get('val6')));    
                }
                if(ar.get('val7') != null) 
                {   
                    working.Val7__c = Decimal.valueOf(string.valueOf(ar.get('val7'))); 
                    totalReg.Val7__c += Decimal.ValueOf(string.valueOf(ar.get('val7')));    
                }
                if(ar.get('val8') != null) 
                {   
                    working.Val8__c = Decimal.valueOf(string.valueOf(ar.get('val8'))); 
                    totalReg.Val8__c += Decimal.ValueOf(string.valueOf(ar.get('val8')));    
                }
                if(ar.get('lasq') != null) 
                {   
                    working.LastQForecast__c = Decimal.valueOf(string.valueOf(ar.get('lasq'))); 
                    totalReg.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar.get('lasq')));   
                }               
                aggItems.put(theName, working);
                
            }
        }
       
        for(Forecast_Item__c fi : aggItems.values())
        {
            if( (fi.Value_1__c != null && String.valueOf(fi.Value_1__c) != '') ||
                (fi.Value_2__c != null && String.valueOf(fi.Value_2__c) != '') ||
                (fi.Value_3__c != null && String.valueOf(fi.Value_3__c) != '') ||
                (fi.Value_4__c != null && String.valueOf(fi.Value_4__c) != '') ||
                (fi.Val1__c != null && String.valueOf(fi.Val1__c) != '') ||
                (fi.Val2__c != null && String.valueOf(fi.Val2__c) != '') ||
                (fi.Val3__c != null && String.valueOf(fi.Val3__c) != '') ||
                (fi.Val4__c != null && String.valueOf(fi.Val4__c) != '') ||
                (fi.Val5__c != null && String.valueOf(fi.Val5__c) != '') ||
                (fi.Val6__c != null && String.valueOf(fi.Val6__c) != '') ||
                (fi.Val7__c != null && String.valueOf(fi.Val7__c) != '') ||
                (fi.Val8__c != null && String.valueOf(fi.Val8__c) != '') ||
                (fi.LastQForecast__c != null && String.valueOf(fi.LastQForecast__c) != '') 
              )
            {
                ForecastItemWrapper fiw = new ForecastItemWrapper(fi); 
                toReturn.add(fiw);
            }           
        }        
        
        toReturn.sort();
        
        for(ForecastItemWrapper t : toReturn)
        {
                TotalItemsRegional.add(t.myTask);
        }
        
        //---------------------------Used for bifurcating Kadant Johnson------------------------------------
        
        TotalItemsRegional2.clear();
        list<ForecastItemWrapper> toReturn2 = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks2 = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c
            order by Sort_Order__c];
            
                totalReg2 = new Forecast_Item__c(Val1__c = 0,
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
                                
        map<string, Forecast_Item__c> aggItems2 = new map<string, Forecast_Item__c>();
        
        if (theBlanks2.size() > 0)
        {
            for(Forecast_Category__c fc : theBlanks2)
            {
                if(!String.isBlank(fc.Major_Category__c) && !String.isBlank(fc.Forecast_Category__c))
                {
                    string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                    aggItems2.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                }
            }
        }

        set<id> userSubset2 = new set<id>();
        
        if(selectedManager != null)
        {
            for (User u : [select id from User where ManagerId =: selectedManager ])
                userSubset2.add(u.Id);
        }
        
        AggregateResult [] gr2 = [SELECT Sum(Value_1__c) v1,
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
            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter and Forecast_Item__c.Forecast_Category__c = 'JOHNSON'
            and Forecast__r.OwnerId IN: userSubset2
            group by Name
            order by Name];
        
        for (AggregateResult  ar2 : gr2)
        {
            string theName2 = string.valueOf(ar2.get('name')).toUpperCase();
            if(aggItems2.containsKey(theName2))
            {
                Forecast_Item__c working2 = aggItems2.get(theName2);
                working2.Product_Category__c = theName2;
          
                if(ar2.get('v1') != null) 
                {
                    working2.Value_1__c = Decimal.valueOf(string.valueOf(ar2.get('v1'))); 
                    totalReg2.Value_1__c += Decimal.ValueOf(string.valueOf(ar2.get('v1'))); 
                }
                if(ar2.get('v2') != null) 
                {   
                    working2.Value_2__c = Decimal.valueOf(string.valueOf(ar2.get('v2'))); 
                    totalReg2.Value_2__c += Decimal.ValueOf(string.valueOf(ar2.get('v2'))); 
                }
                if(ar2.get('v3') != null) 
                {   
                    working2.Value_3__c = Decimal.valueOf(string.valueOf(ar2.get('v3'))); 
                    totalReg2.Value_3__c += Decimal.ValueOf(string.valueOf(ar2.get('v3'))); 
                }
                if(ar2.get('v4') != null) 
                {   
                    working2.Value_4__c = Decimal.valueOf(string.valueOf(ar2.get('v4'))); 
                    totalReg2.Value_4__c += Decimal.ValueOf(string.valueOf(ar2.get('v4'))); 
                }
                if(ar2.get('val1') != null) 
                {   
                    working2.Val1__c = Decimal.valueOf(string.valueOf(ar2.get('val1'))); 
                    totalReg2.Val1__c += Decimal.ValueOf(string.valueOf(ar2.get('val1')));  
                }
                if(ar2.get('val2') != null) 
                {   
                    working2.Val2__c = Decimal.valueOf(string.valueOf(ar2.get('val2'))); 
                    totalReg2.Val2__c += Decimal.ValueOf(string.valueOf(ar2.get('val2')));  
                }
                if(ar2.get('val3') != null) 
                {   
                    working2.Val3__c = Decimal.valueOf(string.valueOf(ar2.get('val3'))); 
                    totalReg2.Val3__c += Decimal.ValueOf(string.valueOf(ar2.get('val3')));  
                }
                if(ar2.get('val4') != null) 
                {   
                    working2.Val4__c = Decimal.valueOf(string.valueOf(ar2.get('val4'))); 
                    totalReg2.Val4__c += Decimal.ValueOf(string.valueOf(ar2.get('val4')));  
                }
                if(ar2.get('val5') != null) 
                {   
                    working2.Val5__c = Decimal.valueOf(string.valueOf(ar2.get('val5'))); 
                    totalReg2.Val5__c += Decimal.ValueOf(string.valueOf(ar2.get('val5')));  
                }
                if(ar2.get('val6') != null) 
                {   
                    working2.Val6__c = Decimal.valueOf(string.valueOf(ar2.get('val6'))); 
                    totalReg2.Val6__c += Decimal.ValueOf(string.valueOf(ar2.get('val6')));  
                }
                if(ar2.get('val7') != null) 
                {   
                    working2.Val7__c = Decimal.valueOf(string.valueOf(ar2.get('val7'))); 
                    totalReg2.Val7__c += Decimal.ValueOf(string.valueOf(ar2.get('val7')));  
                }
                if(ar2.get('val8') != null) 
                {   
                    working2.Val8__c = Decimal.valueOf(string.valueOf(ar2.get('val8'))); 
                    totalReg2.Val8__c += Decimal.ValueOf(string.valueOf(ar2.get('val8')));  
                }
                if(ar2.get('lasq') != null) 
                {   
                    working2.LastQForecast__c = Decimal.valueOf(string.valueOf(ar2.get('lasq'))); 
                    totalReg2.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar2.get('lasq'))); 
                }               
                aggItems2.put(theName2, working2);
                
            }
        }
       
        for(Forecast_Item__c fi : aggItems2.values())
        {
            if( (fi.Value_1__c != null && String.valueOf(fi.Value_1__c) != '') ||
                (fi.Value_2__c != null && String.valueOf(fi.Value_2__c) != '') ||
                (fi.Value_3__c != null && String.valueOf(fi.Value_3__c) != '') ||
                (fi.Value_4__c != null && String.valueOf(fi.Value_4__c) != '') ||
                (fi.Val1__c != null && String.valueOf(fi.Val1__c) != '') ||
                (fi.Val2__c != null && String.valueOf(fi.Val2__c) != '') ||
                (fi.Val3__c != null && String.valueOf(fi.Val3__c) != '') ||
                (fi.Val4__c != null && String.valueOf(fi.Val4__c) != '') ||
                (fi.Val5__c != null && String.valueOf(fi.Val5__c) != '') ||
                (fi.Val6__c != null && String.valueOf(fi.Val6__c) != '') ||
                (fi.Val7__c != null && String.valueOf(fi.Val7__c) != '') ||
                (fi.Val8__c != null && String.valueOf(fi.Val8__c) != '') ||
                (fi.LastQForecast__c != null && String.valueOf(fi.LastQForecast__c) != '') 
              )
            {
                ForecastItemWrapper fiw2 = new ForecastItemWrapper(fi); 
                toReturn2.add(fiw2);
            }           
        }        
        
        toReturn2.sort();
        
        for(ForecastItemWrapper t : toReturn2)
        {
                TotalItemsRegional2.add(t.myTask);
        }
        
        //---------------------------Used for Grand Total Numbers------------------------------------
        
        TotalItemsRegional3.clear();
        list<ForecastItemWrapper> toReturn3 = new list<ForecastItemWrapper>();
        
        List<Forecast_Category__c> theBlanks3 = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c
            order by Sort_Order__c];
            
                totalReg3 = new Forecast_Item__c(Val1__c = 0,
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
                                
        map<string, Forecast_Item__c> aggItems3 = new map<string, Forecast_Item__c>();
        
        if (theBlanks3.size() > 0)
        {
            for(Forecast_Category__c fc : theBlanks3)
            {
                if(!String.isBlank(fc.Major_Category__c) && !String.isBlank(fc.Forecast_Category__c))
                {
                    string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                    aggItems3.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                }
            }
        }

        set<id> userSubset3 = new set<id>();
        
        if(selectedManager != null)
        {
            for (User u : [select id from User where ManagerId =: selectedManager ])
                userSubset3.add(u.Id);
        }
        
        AggregateResult [] gr3 = [SELECT Sum(Value_1__c) v1,
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
            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter
            and Forecast__r.OwnerId IN: userSubset3
            group by Name
            order by Name];
        
        for (AggregateResult  ar3 : gr3)
        {
            string theName3 = string.valueOf(ar3.get('name')).toUpperCase();
            if(aggItems3.containsKey(theName3))
            {
                Forecast_Item__c working3 = aggItems3.get(theName3);
                working3.Product_Category__c = theName3;
          
                if(ar3.get('v1') != null) 
                {
                    working3.Value_1__c = Decimal.valueOf(string.valueOf(ar3.get('v1'))); 
                    totalReg3.Value_1__c += Decimal.ValueOf(string.valueOf(ar3.get('v1'))); 
                }
                if(ar3.get('v2') != null) 
                {   
                    working3.Value_2__c = Decimal.valueOf(string.valueOf(ar3.get('v2'))); 
                    totalReg3.Value_2__c += Decimal.ValueOf(string.valueOf(ar3.get('v2'))); 
                }
                if(ar3.get('v3') != null) 
                {   
                    working3.Value_3__c = Decimal.valueOf(string.valueOf(ar3.get('v3'))); 
                    totalReg3.Value_3__c += Decimal.ValueOf(string.valueOf(ar3.get('v3'))); 
                }
                if(ar3.get('v4') != null) 
                {   
                    working3.Value_4__c = Decimal.valueOf(string.valueOf(ar3.get('v4'))); 
                    totalReg3.Value_4__c += Decimal.ValueOf(string.valueOf(ar3.get('v4'))); 
                }
                if(ar3.get('val1') != null) 
                {   
                    working3.Val1__c = Decimal.valueOf(string.valueOf(ar3.get('val1'))); 
                    totalReg3.Val1__c += Decimal.ValueOf(string.valueOf(ar3.get('val1')));  
                }
                if(ar3.get('val2') != null) 
                {   
                    working3.Val2__c = Decimal.valueOf(string.valueOf(ar3.get('val2'))); 
                    totalReg3.Val2__c += Decimal.ValueOf(string.valueOf(ar3.get('val2')));  
                }
                if(ar3.get('val3') != null) 
                {   
                    working3.Val3__c = Decimal.valueOf(string.valueOf(ar3.get('val3'))); 
                    totalReg3.Val3__c += Decimal.ValueOf(string.valueOf(ar3.get('val3')));  
                }
                if(ar3.get('val4') != null) 
                {   
                    working3.Val4__c = Decimal.valueOf(string.valueOf(ar3.get('val4'))); 
                    totalReg3.Val4__c += Decimal.ValueOf(string.valueOf(ar3.get('val4')));  
                }
                if(ar3.get('val5') != null) 
                {   
                    working3.Val5__c = Decimal.valueOf(string.valueOf(ar3.get('val5'))); 
                    totalReg3.Val5__c += Decimal.ValueOf(string.valueOf(ar3.get('val5')));  
                }
                if(ar3.get('val6') != null) 
                {   
                    working3.Val6__c = Decimal.valueOf(string.valueOf(ar3.get('val6'))); 
                    totalReg3.Val6__c += Decimal.ValueOf(string.valueOf(ar3.get('val6')));  
                }
                if(ar3.get('val7') != null) 
                {   
                    working3.Val7__c = Decimal.valueOf(string.valueOf(ar3.get('val7'))); 
                    totalReg3.Val7__c += Decimal.ValueOf(string.valueOf(ar3.get('val7')));  
                }
                if(ar3.get('val8') != null) 
                {   
                    working3.Val8__c = Decimal.valueOf(string.valueOf(ar3.get('val8'))); 
                    totalReg3.Val8__c += Decimal.ValueOf(string.valueOf(ar3.get('val8')));  
                }
                if(ar3.get('lasq') != null) 
                {   
                    working3.LastQForecast__c = Decimal.valueOf(string.valueOf(ar3.get('lasq'))); 
                    totalReg3.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar3.get('lasq'))); 
                }               
                aggItems3.put(theName3, working3);
                
            }
        }
       
        for(Forecast_Item__c fi : aggItems3.values())
        {
            if( (fi.Value_1__c != null && String.valueOf(fi.Value_1__c) != '') ||
                (fi.Value_2__c != null && String.valueOf(fi.Value_2__c) != '') ||
                (fi.Value_3__c != null && String.valueOf(fi.Value_3__c) != '') ||
                (fi.Value_4__c != null && String.valueOf(fi.Value_4__c) != '') ||
                (fi.Val1__c != null && String.valueOf(fi.Val1__c) != '') ||
                (fi.Val2__c != null && String.valueOf(fi.Val2__c) != '') ||
                (fi.Val3__c != null && String.valueOf(fi.Val3__c) != '') ||
                (fi.Val4__c != null && String.valueOf(fi.Val4__c) != '') ||
                (fi.Val5__c != null && String.valueOf(fi.Val5__c) != '') ||
                (fi.Val6__c != null && String.valueOf(fi.Val6__c) != '') ||
                (fi.Val7__c != null && String.valueOf(fi.Val7__c) != '') ||
                (fi.Val8__c != null && String.valueOf(fi.Val8__c) != '') ||
                (fi.LastQForecast__c != null && String.valueOf(fi.LastQForecast__c) != '') 
              )
            {
                ForecastItemWrapper fiw3 = new ForecastItemWrapper(fi); 
                toReturn3.add(fiw3);
            }           
        }        
        
        toReturn3.sort();
        
        for(ForecastItemWrapper t : toReturn3)
        {
                TotalItemsRegional3.add(t.myTask);
                TotalItemsRegional3.clear();
        }
    }
    
    public void updatethis()
    {
        try
        {
            Forecast__c f = new Forecast__c();
            if (selectedUser != null && selectedUser != '')
            f = [select id from Forecast__c where Forecast_Period__c =: selectedQuarter and OwnerId =: selectedUser And Account_Forecast__c = false limit 1];
            if (f != null)
            {
                UpdateForecast u = new UpdateForecast();
                u.updateForecast(f.Id);
            }
            getUserResults();
        }
        catch(Exception e)
        {
            
        }
    }
    public void updateForecast()
    {  
        try
        {         
            update theItemsW;
            getUserResults();
            getAggResults();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'nt  Save'));
            getUserResults();
        }
    }
    
    public void updateForecastAES()
    {
        try
        {
            update theItemsA;
            getUserResults();
            getAggResults();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'nt  Save'));
            getUserResults();
        }
    }
    public void updateForecastJohnson()
    {
        try
        {
            update theItemsJ;
            getUserResults();
            getAggResults();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'nt  Save'));
            getUserResults();
        }
    }
    public void updateForecastMClean()
    {
        try
        {
            update theItemsM;
            getUserResults();
            getAggResults();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Record is in Approval Process. Can\'nt  Save'));
            getUserResults();
        }
    }

    public void clearTheTotals()
    {
         totalReg= new Forecast_Item__c(Val1__c = 0,
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
                                
        totalReg2= new Forecast_Item__c(Val1__c = 0,
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
                                
        totalReg3= new Forecast_Item__c(Val1__c = 0,
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
        
        totalWeb= new Forecast_Item__c(Val1__c = 0,
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
        
        totalA= new Forecast_Item__c(Val1__c = 0,
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
        totalJ= new Forecast_Item__c(Val1__c = 0,
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
        totalM= new Forecast_Item__c(Val1__c = 0,
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
    }
    public void getUserResults()
    {
        clearthetotals();
        TheItemsW.clear();
        TheItemsA.clear();
        TheItemsJ.clear();
        TheItemsM.clear();
        getDates();
        getAggResults();
        getAggResults2();
        list<Forecast_Item__c> userItems = new list<Forecast_Item__c>();
        if (selectedUser != null && selectedUser != '')
        {                       
                    userItems = [Select f.Value_4__c, 
                        f.Value_3__c, 
                        f.Value_2__c, 
                        f.Value_1__c, 
                        f.Val8__c, 
                        f.Val7__c, 
                        f.Val6__c, 
                        f.Val5__c, 
                        f.Val4__c, 
                        f.Val3__c, 
                        f.Val2__c, 
                        f.Val1__c, 
                        f.Sort_Order__c,
                        f.LastQForecast__c,
                        f.Product_Category__c, 
                        f.Location__c, 
                        f.Forecast__r.Name, 
                        f.Forecast__r.OwnerId, 
                        f.Forecast__c, 
                        f.Forecast_Category__c From Forecast_Item__c f where f.Forecast__r.Name =: selectedQuarter and f.Forecast__r.OwnerId =: selectedUser
                        order by f.Sort_Order__c];
                       
                for (Forecast_Item__c  fi : userItems)
                {
                        if(fi.Location__c != null)
                        {
                                string loco = fi.Location__c.ToUpperCase();
                                if (loco == 'WEB')
                                {                       
                                        TheItemsW.add(fi);
                                        if(fi.Val1__c!=null)
                                            totalWeb.Val1__c += fi.Val1__c;
                                        if(fi.Val2__c!=null)
                                            totalWeb.Val2__c += fi.Val2__c;
                                        if(fi.Val3__c!=null)
                                            totalWeb.Val3__c += fi.Val3__c;
                                        if(fi.Val4__c!=null)
                                            totalWeb.Val4__c += fi.Val4__c;
                                        if(fi.Val5__c!=null)
                                            totalWeb.Val5__c += fi.Val5__c;
                                        if(fi.Val6__c!=null)
                                            totalWeb.Val6__c += fi.Val6__c;
                                        if(fi.Val7__c!=null)
                                            totalWeb.Val7__c += fi.Val7__c;
                                        if(fi.Val8__c!=null)
                                            totalWeb.Val8__c += fi.Val8__c;
                                        if(fi.Value_1__c!=null)
                                            totalWeb.Value_1__c += fi.Value_1__c;
                                        if(fi.Value_2__c!=null)
                                            totalWeb.Value_2__c += fi.Value_2__c;
                                        if(fi.Value_3__c!=null)
                                            totalWeb.Value_3__c += fi.Value_3__c;
                                        if(fi.Value_4__c!=null)
                                            totalWeb.Value_4__c += fi.Value_4__c;
                                        if(fi.LastQForecast__c!=null)
                                            totalWeb.LastQForecast__c += fi.LastQForecast__c;
                                        
                                }
                                else if (loco == 'AES')
                                {
                                        TheItemsA.add(fi);
                                        if(fi.Val1__c!=null)totalA.Val1__c += fi.Val1__c;
                                        if(fi.Val2__c!=null)totalA.Val2__c += fi.Val2__c;
                                        if(fi.Val3__c!=null)totalA.Val3__c += fi.Val3__c;
                                        if(fi.Val4__c!=null)totalA.Val4__c += fi.Val4__c;
                                        if(fi.Val5__c!=null)totalA.Val5__c += fi.Val5__c;
                                        if(fi.Val6__c!=null)totalA.Val6__c += fi.Val6__c;
                                        if(fi.Val7__c!=null)totalA.Val7__c += fi.Val7__c;
                                        if(fi.Val8__c!=null)totalA.Val8__c += fi.Val8__c;
                                        if(fi.Value_1__c!=null)totalA.Value_1__c += fi.Value_1__c;
                                        if(fi.Value_2__c!=null)totalA.Value_2__c += fi.Value_2__c;
                                        if(fi.Value_3__c!=null)totalA.Value_3__c += fi.Value_3__c;
                                        if(fi.Value_4__c!=null)totalA.Value_4__c += fi.Value_4__c;
                                        if(fi.LastQForecast__c!=null)totalA.LastQForecast__c += fi.LastQForecast__c;
                                }
                                else if (loco == 'JOHNSON')
                                {
                                        TheItemsJ.add(fi);
                                        if(fi.Val1__c!=null)totalJ.Val1__c += fi.Val1__c;
                                        if(fi.Val2__c!=null)totalJ.Val2__c += fi.Val2__c;
                                        if(fi.Val3__c!=null)totalJ.Val3__c += fi.Val3__c;
                                        if(fi.Val4__c!=null)totalJ.Val4__c += fi.Val4__c;
                                        if(fi.Val5__c!=null)totalJ.Val5__c += fi.Val5__c;
                                        if(fi.Val6__c!=null)totalJ.Val6__c += fi.Val6__c;
                                        if(fi.Val7__c!=null)totalJ.Val7__c += fi.Val7__c;
                                        if(fi.Val8__c!=null)totalJ.Val8__c += fi.Val8__c;
                                        if(fi.Value_1__c!=null)totalJ.Value_1__c += fi.Value_1__c;
                                        if(fi.Value_2__c!=null)totalJ.Value_2__c += fi.Value_2__c;
                                        if(fi.Value_3__c!=null)totalJ.Value_3__c += fi.Value_3__c;
                                        if(fi.Value_4__c!=null)totalJ.Value_4__c += fi.Value_4__c;
                                        if(fi.LastQForecast__c!=null)totalJ.LastQForecast__c += fi.LastQForecast__c;
                                }
                                else if (loco == 'M-CLEAN')
                                {
                                        TheItemsM.add(fi);
                                        if(fi.Val1__c!=null)totalM.Val1__c += fi.Val1__c;
                                        if(fi.Val2__c!=null)totalM.Val2__c += fi.Val2__c;
                                        if(fi.Val3__c!=null)totalM.Val3__c += fi.Val3__c;
                                        if(fi.Val4__c!=null)totalM.Val4__c += fi.Val4__c;
                                        if(fi.Val5__c!=null)totalM.Val5__c += fi.Val5__c;
                                        if(fi.Val6__c!=null)totalM.Val6__c += fi.Val6__c;
                                        if(fi.Val7__c!=null)totalM.Val7__c += fi.Val7__c;
                                        if(fi.Val8__c!=null)totalM.Val8__c += fi.Val8__c;
                                        if(fi.Value_1__c!=null)totalM.Value_1__c += fi.Value_1__c;
                                        if(fi.Value_2__c!=null)totalM.Value_2__c += fi.Value_2__c;
                                        if(fi.Value_3__c!=null)totalM.Value_3__c += fi.Value_3__c;
                                        if(fi.Value_4__c!=null)totalM.Value_4__c += fi.Value_4__c;
                                        if(fi.LastQForecast__c!=null)totalM.LastQForecast__c += fi.LastQForecast__c;
                                }
                        }
                }
        }
        getTheQuarters();
    }   
    
    public list<Forecast_Item__c> getTheItemsW()
    {
        return TheItemsW;
    }
       
    public list<Forecast_Item__c> getTheItemsA()
    {
        return TheItemsA;
    }   
    public list<Forecast_Item__c> getTheItemsJ()
    {
        return TheItemsJ;
    }   
    public list<Forecast_Item__c> getTheItemsM()
    {
        return TheItemsM;
    }   
    public list<Forecast_Item__c> getTotalItems()
    {
        return TotalItems;
    }
    
    public list<Forecast_Item__c> getTotalItems2()
    {
        return TotalItems2;
    }
    
    public list<Forecast_Item__c> getTotalItems3()
    {
        return TotalItems3;
    }
    
    public list<Forecast_Item__c> getTotalItemsRegional()
    {
        return TotalItemsRegional;
    }
    
    public list<Forecast_Item__c> getTotalItemsRegional2()
    {
        return TotalItemsRegional2;
    }
    
    public list<Forecast_Item__c> getTotalItemsRegional3()
    {
        return TotalItemsRegional3;
    }
    
    public Forecast_Item__c getTotalWeb()
    {
        return totalWeb;
    }
    public Forecast_Item__c getTotalA()
    {
        return totalA;
    }
    public Forecast_Item__c getTotalJ()
    {
        return totalJ;
    }
    public Forecast_Item__c getTotalM()
    {
        return totalM;
    }
    
    public Forecast_Item__c getTotalReg()
    {
        return totalReg;
    }
    
    public Forecast_Item__c getTotalReg2()
    {
        return totalReg2;
    }
    
    public Forecast_Item__c getTotalReg3()
    {
        return totalReg3;
    }
    
    public Forecast_Item__c getTotalCo()
    {
        return totalCo;
    }
    
    public Forecast_Item__c getTotalCo2()
    {
        return totalCo2;
    }
    
    public Forecast_Item__c getTotalCo3()
    {
        return totalCo3;
    }
    
    public List<SelectOption> getUsers()
    {
        List<SelectOption> opns = new List<SelectOption>();
        SelectOption s = new SelectOption('', '--Select One--');
            opns.Add(s); 
        for (User c : [Select FirstName, LastName, Id from User where ManagerId =: UserInfo.getUserId() and Quartely_Forecasting__c = true order by LastName])
        {
            SelectOption so = new SelectOption(c.Id, c.FirstName + ' ' + c.LastName);
            opns.Add(so);  
            myUsers.add(c.Id);     
        }
        return opns;
    }
    
    public List<SelectOption> getAllUsers()
    {
        List<SelectOption> opns = new List<SelectOption>();
        SelectOption s = new SelectOption('', '--Select One--');
            opns.Add(s); 
        for (User c : [Select FirstName, LastName, Id from User where Quartely_Forecasting__c = true order by LastName])
        {
            SelectOption so = new SelectOption(c.Id, c.FirstName + ' ' + c.LastName);
            opns.Add(so);  
            myUsers.add(c.Id);     
        }
        return opns;
    }
    public List<SelectOption> getManagerUsers()
    {
        List<SelectOption> opns = new List<SelectOption>();
        SelectOption s = new SelectOption('', '--Select One--');
            opns.Add(s); 
        for (User c : [Select FirstName, LastName, Id from User where Forecasting_Manager__c = true order by LastName])
        {
            SelectOption so = new SelectOption(c.Id, c.FirstName + ' ' + c.LastName);
            opns.Add(so);  
            myUsers.add(c.Id);     
        }
        return opns;
    }
    public void getCurrentQuarter()
    {
        curt = new Period();
        date theChk = date.today();
        for (Period p : periods)
        {
            if (p.StartDate <= theChk && p.EndDate >= theChk)
            {
                curt = p;
                currentQuarter = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name;
                break;              
            }
        }
    }
    
    public void getDates()
    {
        //determine which quarter is the current one
        curt = new Period();
        
        integer limitQ = 0;
        string fyear;
        integer qNum;
        date fCastBaseDate;
        if (selectedQuarter != null)
        {
                qNum = integer.valueOf(selectedQuarter.substring(1, 2));
                fyear = selectedQuarter.substringAfter(' ');
                
                integer yrIndex = selectedQuarter.length()-4;
                string year = selectedQuarter.substring(yrIndex);
                string qrtr = selectedQuarter.substring(1,2);
                for(period p : periods)
                {
                    if(p.Number == integer.valueOf(qrtr) && p.StartDate.addMonths(1).year() == integer.valueOf(year))
                    {
                            fCastBaseDate = p.startDate;
                            break;
                    }
                }
        
        }
        else
        {
                fCastBaseDate = date.today();
                fyear = string.valueOf(Date.today().year());
        }   
        boolean onCurrent = false;
        
        for (Period p : periods)
        { 
            Date theChk = fCastBaseDate.addMonths(1);
                
            if (limitQ == 8)
                break;
            else if (p.StartDate <= theChk && p.EndDate >= theChk)
            {
                curt = p;
                currentQuarter = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name;
                onCurrent = true;                   
                limitQ += 1;
                h8 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + '(Actual)';
                onCurrent = false;
            }
            else if (p.EndDate <= theChk && limitQ == 1)
            {
                    h7 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
            }
            else if (p.EndDate <= theChk && limitQ == 2)
            {
                    h6 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
            }
            else if (p.EndDate <= theChk && limitQ == 3)
            {
                    h5 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
            }
            else if (p.EndDate <= theChk && limitQ == 4)
            {
                    h4 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
            }
            else if (p.EndDate <= theChk && limitQ == 5)
            {
                    h3 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
            }
            else if (p.EndDate <= theChk && limitQ == 6)
            {
                    h2 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
            }
            else if (p.EndDate <= theChk && limitQ == 7)
            {
                    h1 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)'; 
                    limitQ += 1;
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
                fh4 = 'Q2 ' +string.valueOf(integer.valueOf(fyear)+1);
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