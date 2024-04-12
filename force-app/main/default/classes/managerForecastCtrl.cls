public with sharing class managerForecastCtrl 
{
        public list<Forecast_Item__c> TheItemsSolutionsConsumables = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TheItemsJohnson = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TheItemsSolutionsCapital = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalForecast = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItems1 = new list<Forecast_Item__c>();    
        public list<Forecast_Item__c> TotalItems2 = new list<Forecast_Item__c>();
        public list<Forecast_Item__c> TotalItems3 = new list<Forecast_Item__c>();
        
        Forecast_Item__c totalf = new Forecast_Item__c(Val1__c = 0,
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
                                                        
        Forecast_Item__c totalReg1 = new Forecast_Item__c(Val1__c = 0,
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
                                                        
        Forecast_Item__c totalReg2 = new Forecast_Item__c(Val1__c = 0,
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
                                
        Forecast_Item__c totalReg3 = new Forecast_Item__c(Val1__c = 0,
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
        
        Forecast_Item__c totalSolutionsConsumables = new Forecast_Item__c(Val1__c = 0,
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
        
        Forecast_Item__c totalJohnson = new Forecast_Item__c(Val1__c = 0,
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
                                                      
        Forecast_Item__c totalSolutionsCapital = new Forecast_Item__c(Val1__c = 0,
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
        
        
        public Period curt{get;set;}//the current quarter
            
        public String selectedUser {get;set;}
        public String selectedUserName {get;set;}
        public String selectedQuarter {get;set;}    
        public String lastModified {get;set;}
        //public String currentQuarter{get;set;}
    
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
        
        public String flqweb {get;set;}
        public Integer roww{get;set;}
        public Boolean flagApproval{get;set;}
        list<Forecast__c> lstForecast;
        public String strAlias{get;set;}
        public Boolean boolSuccess{get;set;}
        public Boolean showSolutionsConsumableTab{get;set;}
        public Boolean showSolutionsCapitalTab{get;set;}
        public Boolean showJohnsonTab{get;set;}
        public String selectedTab{get;set;}
        public String strLocation{get;set;}        

        public Forecast__c forecast
        {
                get{
                   
                         forecast = [SELECT Id, Name, Owner.Alias, OwnerId, Owner.Name, Owner.FirstName, Owner.LastName, P1_Name__c, P1_Value__c,P2_Name__c, P2_Value__c,P3_Name__c, P3_Value__c,P4_Name__c, P4_Value__c, Forecast_Period__c
                                         FROM Forecast__c WHERE OwnerId =: selectedUser and Name=:selectedQuarter And Account_Forecast__c = false];
                         selectedUserName = forecast.Owner.Name;
                                     
                    return forecast;
                   }
                set;
        }
        public managerForecastCtrl()
        {   
            try
            {
                // setting the selected tab on load
                User u = [Select Id, Division From User Where Id = :UserInfo.getUserId()];
                if(u.Division == 'KSD')
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
                strAlias='';
                flagApproval=true;
                //getCurrentQuarter();
                list<selectOption> theOptions = getTheQuarters();            
                getDates();         
                getUsers();          
                getAggResults();
                getTotalIndividualForecast();
            }
            catch(Exception e)
            {
                
            }                   
        }
    
        public list<Period> periods
        {
                get
                {
                    periods = [Select p.Type, p.StartDate, p.Number, p.Id, p.FiscalYearSettingsId, 
                              p.FiscalYearSettings.Name, p.EndDate 
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
        public void clearTheTotals()
        {
             try
             {
                     totalf=new  Forecast_Item__c(Val1__c = 0,
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
                
                    totalSolutionsConsumables = new Forecast_Item__c(Val1__c = 0,
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
                
                            totalJohnson = new Forecast_Item__c(Val1__c = 0,
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
                                                        
                            totalSolutionsCapital = new Forecast_Item__c(Val1__c = 0,
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
            catch(Exception e)
            {
                
            }
        }
        public void getTotalIndividualForecast()
        {
             try
             {
                 if(selectedUser!=null && selectedUser!='')
                 {
                 clearTheTotals();  
                 TotalForecast.clear();
                 list<ForecastItemWrapper> toReturn = new list<ForecastItemWrapper>();
                 List<Forecast_Category__c> theBlanks = [select id, Forecast_Category__c, 
                                                        Sort_Order__c,    
                                                        Location__c,         
                                                        Major_Category__c from Forecast_Category__c
                                                        Where Location__c = :strLocation
                                                        Order By Sort_Order__c];
                map<string, Forecast_Item__c> aggItems = new map<string, Forecast_Item__c>();        
                if(theBlanks!=null && (!theBlanks.isEmpty()))
                {
                    for(Forecast_Category__c fc:theBlanks)
                    {           
                        string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                        aggItems.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
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
                                            Name
                                            FROM Forecast_Item__c 
                                            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter
                                            and Forecast__r.OwnerId= :selectedUser
                                            group by Name
                                            order by Name];
                                            
                    if(gr.size() > 0 && gr!=null)
                    {
                        for (AggregateResult  ar : gr)
                        {
                            string theName = string.valueOf(ar.get('name')).toUpperCase();
                            if(aggItems.containsKey(theName))
                            {
                                Forecast_Item__c working = aggItems.get(theName);
                                working.Product_Category__c = theName;
                                
                                //working.Location__c = string.valueOf(ar.get('Location__c'));
                                if(ar.get('v1') != null) 
                                {
                                    working.Value_1__c = Decimal.valueOf(string.valueOf(ar.get('v1'))); 
                                    totalf.Value_1__c += Decimal.ValueOf(string.valueOf(ar.get('v1')));
                                }
                                if(ar.get('v2') != null) 
                                {
                                    working.Value_2__c = Decimal.valueOf(string.valueOf(ar.get('v2'))); 
                                    totalf.Value_2__c += Decimal.ValueOf(string.valueOf(ar.get('v2')));
                                }
                                if(ar.get('v3') != null) 
                                {
                                    working.Value_3__c = Decimal.valueOf(string.valueOf(ar.get('v3'))); 
                                    totalf.Value_3__c += Decimal.ValueOf(string.valueOf(ar.get('v3')));
                                }
                                if(ar.get('v4') != null) 
                                {
                                    working.Value_4__c = Decimal.valueOf(string.valueOf(ar.get('v4'))); 
                                    totalf.Value_4__c += Decimal.ValueOf(string.valueOf(ar.get('v4')));
                                }
                                if(ar.get('val1') != null) 
                                {
                                    working.Val1__c = Decimal.valueOf(string.valueOf(ar.get('val1'))); 
                                    totalf.Val1__c += Decimal.ValueOf(string.valueOf(ar.get('val1')));
                                }
                                if(ar.get('val2') != null) 
                                {
                                    working.Val2__c = Decimal.valueOf(string.valueOf(ar.get('val2'))); 
                                    totalf.Val2__c += Decimal.ValueOf(string.valueOf(ar.get('val2')));
                                }
                                if(ar.get('val3') != null) 
                                {
                                    working.Val3__c = Decimal.valueOf(string.valueOf(ar.get('val3'))); 
                                    totalf.Val3__c += Decimal.ValueOf(string.valueOf(ar.get('val3')));
                                }
                                if(ar.get('val4') != null) 
                                {
                                    working.Val4__c = Decimal.valueOf(string.valueOf(ar.get('val4'))); 
                                    totalf.Val4__c += Decimal.ValueOf(string.valueOf(ar.get('val4')));
                                }
                                if(ar.get('val5') != null) 
                                {
                                    working.Val5__c = Decimal.valueOf(string.valueOf(ar.get('val5'))); 
                                    totalf.Val5__c += Decimal.ValueOf(string.valueOf(ar.get('val5')));
                                }
                                if(ar.get('val6') != null) 
                                {
                                    working.Val6__c = Decimal.valueOf(string.valueOf(ar.get('val6'))); 
                                    totalf.Val6__c += Decimal.ValueOf(string.valueOf(ar.get('val6')));
                                }
                                if(ar.get('val7') != null) 
                                {
                                    working.Val7__c = Decimal.valueOf(string.valueOf(ar.get('val7')));
                                    totalf.Val7__c += Decimal.ValueOf(string.valueOf(ar.get('val7')));
                                }
                                if(ar.get('val8') != null)
                                {
                                    working.Val8__c = Decimal.valueOf(string.valueOf(ar.get('val8'))); 
                                    totalf.Val8__c += Decimal.ValueOf(string.valueOf(ar.get('val8')));
                                }
                                if(ar.get('lasq') != null) 
                                {
                                    working.LastQForecast__c = Decimal.valueOf(string.valueOf(ar.get('lasq'))); 
                                    totalf.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar.get('lasq')));
                                }
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
                            TotalForecast.add(t.myTask);            
                        }  
                    }
                }
            }
        }
        catch(Exception e)
        {
                
        }
     }
        public void getAggResults()
        {
            try
            {
                //---------------------------Used for bifurcating Kadant Solutions Division------------------------------------
                TotalItems1.clear();  
                                       
                    list<ForecastItemWrapper> toReturn = new list<ForecastItemWrapper>();
                    List<Forecast_Category__c> theBlanks = [select id, Forecast_Category__c, 
                                                            Sort_Order__c,    
                                                            Location__c,         
                                                            Major_Category__c from Forecast_Category__c
                                                            order by Sort_Order__c];
                                                            
                    map<string, Forecast_Item__c> aggItems = new map<string, Forecast_Item__c>();        
                    for(Forecast_Category__c fc:theBlanks)
                    {           
                        string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                        aggItems.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                    }
                    
                     totalReg1 = new Forecast_Item__c(
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
                                            Name
                                            FROM Forecast_Item__c 
                                            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter and Forecast_Item__c.Forecast_Category__c != 'JOHNSON'
                                            and Forecast__r.OwnerId in :myUsers
                                            group by Name
                                            order by Name];
                    for (AggregateResult  ar : gr)
                    {
                        string theName = string.valueOf(ar.get('name')).toUpperCase();
                        if(aggItems.containsKey(theName))
                        {
                            Forecast_Item__c working = aggItems.get(theName);
                            working.Product_Category__c = theName;
                            //working.Location__c = string.valueOf(ar.get('Location__c'));
                            if(ar.get('v1') != null) {working.Value_1__c = Decimal.valueOf(string.valueOf(ar.get('v1'))); totalReg1.Value_1__c += Decimal.ValueOf(string.valueOf(ar.get('v1')));}
                            if(ar.get('v2') != null) {working.Value_2__c = Decimal.valueOf(string.valueOf(ar.get('v2'))); totalReg1.Value_2__c += Decimal.ValueOf(string.valueOf(ar.get('v2')));}
                            if(ar.get('v3') != null) {working.Value_3__c = Decimal.valueOf(string.valueOf(ar.get('v3'))); totalReg1.Value_3__c += Decimal.ValueOf(string.valueOf(ar.get('v3')));}
                            if(ar.get('v4') != null) {working.Value_4__c = Decimal.valueOf(string.valueOf(ar.get('v4'))); totalReg1.Value_4__c += Decimal.ValueOf(string.valueOf(ar.get('v4')));}
                            if(ar.get('val1') != null) {working.Val1__c = Decimal.valueOf(string.valueOf(ar.get('val1'))); totalReg1.Val1__c += Decimal.ValueOf(string.valueOf(ar.get('val1')));}
                            if(ar.get('val2') != null) {working.Val2__c = Decimal.valueOf(string.valueOf(ar.get('val2'))); totalReg1.Val2__c += Decimal.ValueOf(string.valueOf(ar.get('val2')));}
                            if(ar.get('val3') != null) {working.Val3__c = Decimal.valueOf(string.valueOf(ar.get('val3'))); totalReg1.Val3__c += Decimal.ValueOf(string.valueOf(ar.get('val3')));}
                            if(ar.get('val4') != null) {working.Val4__c = Decimal.valueOf(string.valueOf(ar.get('val4'))); totalReg1.Val4__c += Decimal.ValueOf(string.valueOf(ar.get('val4')));}
                            if(ar.get('val5') != null) {working.Val5__c = Decimal.valueOf(string.valueOf(ar.get('val5'))); totalReg1.Val5__c += Decimal.ValueOf(string.valueOf(ar.get('val5')));}
                            if(ar.get('val6') != null) {working.Val6__c = Decimal.valueOf(string.valueOf(ar.get('val6'))); totalReg1.Val6__c += Decimal.ValueOf(string.valueOf(ar.get('val6')));}
                            if(ar.get('val7') != null) {working.Val7__c = Decimal.valueOf(string.valueOf(ar.get('val7'))); totalReg1.Val7__c += Decimal.ValueOf(string.valueOf(ar.get('val7')));}
                            if(ar.get('val8') != null) {working.Val8__c = Decimal.valueOf(string.valueOf(ar.get('val8'))); totalReg1.Val8__c += Decimal.ValueOf(string.valueOf(ar.get('val8')));}
                            if(ar.get('lasq') != null) {working.LastQForecast__c = Decimal.valueOf(string.valueOf(ar.get('lasq'))); totalReg1.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar.get('lasq')));}
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
                        TotalItems1.add(t.myTask);           
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
                           
                    for(Forecast_Category__c fc : theBlanks2)
                    {           
                        string myName = fc.Major_Category__c.toUpperCase()+'-'+fc.Forecast_Category__c.toUpperCase();
                        aggItems2.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc.Sort_Order__c, Product_Category__c = myName)));
                    }
                    
                     totalReg2 = new Forecast_Item__c(
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
                                            Name
                                            FROM Forecast_Item__c 
                                            where Forecast_Item__c.Forecast__r.Name =: selectedQuarter and Forecast_Item__c.Forecast_Category__c = 'JOHNSON'
                                            and Forecast__r.OwnerId in :myUsers
                                            group by Name
                                            order by Name];
                    for (AggregateResult  ar2 : gr2)
                    {
                        string theName2 = string.valueOf(ar2.get('name')).toUpperCase();
                        if(aggItems2.containsKey(theName2))
                        {
                            Forecast_Item__c working2 = aggItems2.get(theName2);
                            working2.Product_Category__c = theName2;
                            //working.Location__c = string.valueOf(ar2.get('Location__c'));
                            if(ar2.get('v1') != null) {working2.Value_1__c = Decimal.valueOf(string.valueOf(ar2.get('v1'))); totalReg2.Value_1__c += Decimal.ValueOf(string.valueOf(ar2.get('v1')));}
                            if(ar2.get('v2') != null) {working2.Value_2__c = Decimal.valueOf(string.valueOf(ar2.get('v2'))); totalReg2.Value_2__c += Decimal.ValueOf(string.valueOf(ar2.get('v2')));}
                            if(ar2.get('v3') != null) {working2.Value_3__c = Decimal.valueOf(string.valueOf(ar2.get('v3'))); totalReg2.Value_3__c += Decimal.ValueOf(string.valueOf(ar2.get('v3')));}
                            if(ar2.get('v4') != null) {working2.Value_4__c = Decimal.valueOf(string.valueOf(ar2.get('v4'))); totalReg2.Value_4__c += Decimal.ValueOf(string.valueOf(ar2.get('v4')));}
                            if(ar2.get('val1') != null) {working2.Val1__c = Decimal.valueOf(string.valueOf(ar2.get('val1'))); totalReg2.Val1__c += Decimal.ValueOf(string.valueOf(ar2.get('val1')));}
                            if(ar2.get('val2') != null) {working2.Val2__c = Decimal.valueOf(string.valueOf(ar2.get('val2'))); totalReg2.Val2__c += Decimal.ValueOf(string.valueOf(ar2.get('val2')));}
                            if(ar2.get('val3') != null) {working2.Val3__c = Decimal.valueOf(string.valueOf(ar2.get('val3'))); totalReg2.Val3__c += Decimal.ValueOf(string.valueOf(ar2.get('val3')));}
                            if(ar2.get('val4') != null) {working2.Val4__c = Decimal.valueOf(string.valueOf(ar2.get('val4'))); totalReg2.Val4__c += Decimal.ValueOf(string.valueOf(ar2.get('val4')));}
                            if(ar2.get('val5') != null) {working2.Val5__c = Decimal.valueOf(string.valueOf(ar2.get('val5'))); totalReg2.Val5__c += Decimal.ValueOf(string.valueOf(ar2.get('val5')));}
                            if(ar2.get('val6') != null) {working2.Val6__c = Decimal.valueOf(string.valueOf(ar2.get('val6'))); totalReg2.Val6__c += Decimal.ValueOf(string.valueOf(ar2.get('val6')));}
                            if(ar2.get('val7') != null) {working2.Val7__c = Decimal.valueOf(string.valueOf(ar2.get('val7'))); totalReg2.Val7__c += Decimal.ValueOf(string.valueOf(ar2.get('val7')));}
                            if(ar2.get('val8') != null) {working2.Val8__c = Decimal.valueOf(string.valueOf(ar2.get('val8'))); totalReg2.Val8__c += Decimal.ValueOf(string.valueOf(ar2.get('val8')));}
                            if(ar2.get('lasq') != null) {working2.LastQForecast__c = Decimal.valueOf(string.valueOf(ar2.get('lasq'))); totalReg2.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar2.get('lasq')));}
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
                    for(Forecast_Category__c fc3 : theBlanks3)
                    {           
                        string myName = fc3.Major_Category__c.toUpperCase()+'-'+fc3.Forecast_Category__c.toUpperCase();
                        aggItems3.put(myName, (new Forecast_Item__c(Name = myName, Sort_Order__c = fc3.Sort_Order__c, Product_Category__c = myName)));
                    }
                    
                    totalReg3 = new Forecast_Item__c(
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
                                            Name
                                            FROM Forecast_Item__c 
                                            where Forecast_Item__c.Forecast__r.Name = :selectedQuarter
                                            and Forecast__r.OwnerId in :myUsers
                                            group by Name
                                            order by Name];
                    for (AggregateResult  ar3 : gr3)
                    {
                        string theName = string.valueOf(ar3.get('name')).toUpperCase();
                        if(aggItems3.containsKey(theName))
                        {
                            Forecast_Item__c working3 = aggItems3.get(theName);
                            working3.Product_Category__c = theName;
                            //working.Location__c = string.valueOf(ar.get('Location__c'));
                            if(ar3.get('v1') != null) {working3.Value_1__c = Decimal.valueOf(string.valueOf(ar3.get('v1'))); totalReg3.Value_1__c += Decimal.ValueOf(string.valueOf(ar3.get('v1')));}
                            if(ar3.get('v2') != null) {working3.Value_2__c = Decimal.valueOf(string.valueOf(ar3.get('v2'))); totalReg3.Value_2__c += Decimal.ValueOf(string.valueOf(ar3.get('v2')));}
                            if(ar3.get('v3') != null) {working3.Value_3__c = Decimal.valueOf(string.valueOf(ar3.get('v3'))); totalReg3.Value_3__c += Decimal.ValueOf(string.valueOf(ar3.get('v3')));}
                            if(ar3.get('v4') != null) {working3.Value_4__c = Decimal.valueOf(string.valueOf(ar3.get('v4'))); totalReg3.Value_4__c += Decimal.ValueOf(string.valueOf(ar3.get('v4')));}
                            if(ar3.get('val1') != null) {working3.Val1__c = Decimal.valueOf(string.valueOf(ar3.get('val1'))); totalReg3.Val1__c += Decimal.ValueOf(string.valueOf(ar3.get('val1')));}
                            if(ar3.get('val2') != null) {working3.Val2__c = Decimal.valueOf(string.valueOf(ar3.get('val2'))); totalReg3.Val2__c += Decimal.ValueOf(string.valueOf(ar3.get('val2')));}
                            if(ar3.get('val3') != null) {working3.Val3__c = Decimal.valueOf(string.valueOf(ar3.get('val3'))); totalReg3.Val3__c += Decimal.ValueOf(string.valueOf(ar3.get('val3')));}
                            if(ar3.get('val4') != null) {working3.Val4__c = Decimal.valueOf(string.valueOf(ar3.get('val4'))); totalReg3.Val4__c += Decimal.ValueOf(string.valueOf(ar3.get('val4')));}
                            if(ar3.get('val5') != null) {working3.Val5__c = Decimal.valueOf(string.valueOf(ar3.get('val5'))); totalReg3.Val5__c += Decimal.ValueOf(string.valueOf(ar3.get('val5')));}
                            if(ar3.get('val6') != null) {working3.Val6__c = Decimal.valueOf(string.valueOf(ar3.get('val6'))); totalReg3.Val6__c += Decimal.ValueOf(string.valueOf(ar3.get('val6')));}
                            if(ar3.get('val7') != null) {working3.Val7__c = Decimal.valueOf(string.valueOf(ar3.get('val7'))); totalReg3.Val7__c += Decimal.ValueOf(string.valueOf(ar3.get('val7')));}
                            if(ar3.get('val8') != null) {working3.Val8__c = Decimal.valueOf(string.valueOf(ar3.get('val8'))); totalReg3.Val8__c += Decimal.ValueOf(string.valueOf(ar3.get('val8')));}
                            if(ar3.get('lasq') != null) {working3.LastQForecast__c = Decimal.valueOf(string.valueOf(ar3.get('lasq'))); totalReg3.LastQForecast__c += Decimal.ValueOf(string.valueOf(ar3.get('lasq')));}
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
                                ForecastItemWrapper fiw3 = new ForecastItemWrapper(fi); 
                                toReturn3.add(fiw3);   
                            } 
                    }                           
                    toReturn3.sort();
                    
                    for(ForecastItemWrapper t : toReturn3)
                    {
                        TotalItems3.add(t.myTask);     
                        TotalItems3.clear();    
                    }       
                
            }
            catch(Exception e)
            {
            
            }
        }
                
        public void refreshData()
        {
            try
            {
                getUserResults();
            }
            catch(Exception e)
            {
                
            }
        }
        
        public void updateForecastSolutionsConsumables()
        {           
            try
            {
                update TheItemsSolutionsConsumables;
                getUserResults();
            }
            catch(Exception e)
            {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Record is in Approval Process. Can\'t Save'));
                   getUserResults();
            }
        }
        public void updateForecastJohnson()
        {
            try
            {
                  update TheItemsJohnson;
                  getUserResults();
            }
            catch(Exception e)
            {                
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Record is in Approval Process. Can\'t  Save'));
                 getUserResults();               
            }
         
        }
        public void updateForecastSolutionsCapital()
        {
            try
            {
                update TheItemsSolutionsCapital;
                getUserResults();
            }
            catch(Exception e)
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Record is in Approval Process. Can\'t  Save'));
                 getUserResults();
            }
        }
        public void updatethis()
        {
            try
            {
                Forecast__c f=new Forecast__c();
                if (selectedUser != null && selectedUser != '')
                f = [select id from Forecast__c where Name = :selectedQuarter and OwnerId = :selectedUser And Account_Forecast__c = false limit 1];
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
        
       public PageReference submit()
       {
           boolSuccess = true;
            try
            {
                if (selectedQuarter != null && selectedQuarter != '') {
                    lstForecast = [
                        SELECT Id, Name, Approval_Status__c FROM Forecast__c where OwnerId in:myUsers and Name = :selectedQuarter And Account_Forecast__c = false];
                }
                
                if (lstForecast  != null)
                {
                    for (Forecast__c f : lstForecast) {
                        if (f.Approval_Status__c != 'Approved') {
                            boolSuccess = false;
                            break;
                        }
                    }
                }

                if (boolSuccess == true) {
                    Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                    Messaging.SendEmailResult[] results;
                    User objUser=[Select u.Manager.Email,u.Manager.Name,u.Region__c,u.UserRole.Name from User u where u.Id=:UserInfo.getUserId()];
                    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName ='Notification_Email_To_VP'];
                    String strSubject=emailTemplate.Subject;
                    strSubject=strSubject.replace('{SELECTED_QUARTER}',selectedQuarter);
                    strSubject=strSubject.replace('{REGION}',String.valueof(objUser.Region__c));
                    String plainBody = emailTemplate.Body;
                    plainBody = plainBody.replace('{SELECTED_QUARTER}', selectedQuarter);
                    plainBody = plainBody.replace('{RSM_NAME}',UserInfo.getName());
                    plainBody = plainBody.replace('{REGION}',String.valueof(objUser.Region__c));
                    plainBody = plainBody.replace('{ROLE}',objUser.UserRole.Name);
                    email.setPlainTextBody(plainBody);
                    email.setSubject(strSubject);
                    email.setToAddresses(new String[]{objUser.Manager.Email});
                    email.setUseSignature(false);
                    email.setSaveAsActivity(false);
                    results=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                    boolSuccess = results[0].IsSuccess();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Forecast has been successfully sent to ' + objUser.Manager.Name + '.'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All forecasts have not yet been approved.'));
                }
            }   
            catch(Exception e)
            {
                boolSuccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email has not been sent.'));
            }
            return null;
       }
        public void getUserResults()
        {           
            try
            {
                clearthetotals();
                TheItemsSolutionsConsumables.clear();
                TheItemsJohnson.clear();
                TheItemsSolutionsCapital.clear();
                getDates();
                getTheQuarters();   
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
                                f.Forecast__r.LastModifiedDate,
                                f.Location__c, 
                                f.Forecast__r.Name, 
                                f.Forecast__r.OwnerId, 
                                f.Forecast__c,
                                f.Forecast_Category__c From Forecast_Item__c f   
                                where f.Forecast__r.Name = :selectedQuarter 
                                and f.Forecast__r.OwnerId=:selectedUser
                                order by Sort_Order__c];
                                
                  if(userItems.isEmpty())
                    flagApproval=true;
                  else 
                    flagApproval=false;
                                
                  for (Forecast_Item__c  fi : userItems)
                  {
                        if(fi.Location__c != null)
                        {
                                string compareLoc = fi.Location__c.ToUpperCase();
                                string compareCat = fi.Forecast_Category__c.ToUpperCase();
                                if(compareLoc == 'SOLUTIONS' && compareCat == 'CONSUMABLES')
                                {                       
                                        TheItemsSolutionsConsumables.add(fi);
                                        if(fi.Val1__c!=null)
                                            totalSolutionsConsumables.Val1__c += fi.Val1__c;
                                        if(fi.Val2__c!=null)
                                            totalSolutionsConsumables.Val2__c += fi.Val2__c;
                                        if(fi.Val3__c!=null)
                                            totalSolutionsConsumables.Val3__c += fi.Val3__c;
                                        if(fi.Val4__c!=null)
                                            totalSolutionsConsumables.Val4__c += fi.Val4__c;
                                        if(fi.Val5__c!=null)
                                            totalSolutionsConsumables.Val5__c += fi.Val5__c;
                                        if(fi.Val6__c!=null)
                                            totalSolutionsConsumables.Val6__c += fi.Val6__c;
                                        if(fi.Val7__c!=null)
                                            totalSolutionsConsumables.Val7__c += fi.Val7__c;
                                        if(fi.Val8__c!=null)
                                            totalSolutionsConsumables.Val8__c += fi.Val8__c;
                                        if(fi.Value_1__c!=null)
                                            totalSolutionsConsumables.Value_1__c += fi.Value_1__c;
                                        if(fi.Value_2__c!=null)
                                            totalSolutionsConsumables.Value_2__c += fi.Value_2__c;
                                        if(fi.Value_3__c!=null)
                                            totalSolutionsConsumables.Value_3__c += fi.Value_3__c;
                                        if(fi.Value_4__c!=null)
                                            totalSolutionsConsumables.Value_4__c += fi.Value_4__c;
                                        if(fi.LastQForecast__c!=null)
                                            totalSolutionsConsumables.LastQForecast__c += fi.LastQForecast__c;
                                                
                                        }
                                        else if (compareLoc == 'JOHNSON')
                                        {
                                                TheItemsJohnson.add(fi);
                                                if(fi.Val1__c!=null)
                                                    totalJohnson.Val1__c += fi.Val1__c;
                                                if(fi.Val2__c!=null)
                                                    totalJohnson.Val2__c += fi.Val2__c;
                                                if(fi.Val3__c!=null)
                                                    totalJohnson.Val3__c += fi.Val3__c;
                                                if(fi.Val4__c!=null)
                                                    totalJohnson.Val4__c += fi.Val4__c;
                                                if(fi.Val5__c!=null)
                                                    totalJohnson.Val5__c += fi.Val5__c;
                                                if(fi.Val6__c!=null)
                                                    totalJohnson.Val6__c += fi.Val6__c;
                                                if(fi.Val7__c!=null)
                                                    totalJohnson.Val7__c += fi.Val7__c;
                                                if(fi.Val8__c!=null)
                                                    totalJohnson.Val8__c += fi.Val8__c;
                                                if(fi.Value_1__c!=null)
                                                    totalJohnson.Value_1__c += fi.Value_1__c;
                                                if(fi.Value_2__c!=null)
                                                    totalJohnson.Value_2__c += fi.Value_2__c;
                                                if(fi.Value_3__c!=null)
                                                    totalJohnson.Value_3__c += fi.Value_3__c;
                                                if(fi.Value_4__c!=null)
                                                    totalJohnson.Value_4__c += fi.Value_4__c;
                                                if(fi.LastQForecast__c!=null)
                                                    totalJohnson.LastQForecast__c += fi.LastQForecast__c;
                                        }
                                        else if (compareLoc == 'SOLUTIONS' && compareCat == 'CAPITAL')
                                        {
                                                TheItemsSolutionsCapital.add(fi);
                                                if(fi.Val1__c!=null)
                                                    totalSolutionsCapital.Val1__c += fi.Val1__c;
                                                if(fi.Val2__c!=null)
                                                    totalSolutionsCapital.Val2__c += fi.Val2__c;
                                                if(fi.Val3__c!=null)
                                                    totalSolutionsCapital.Val3__c += fi.Val3__c;
                                                if(fi.Val4__c!=null)
                                                    totalSolutionsCapital.Val4__c += fi.Val4__c;
                                                if(fi.Val5__c!=null)
                                                    totalSolutionsCapital.Val5__c += fi.Val5__c;
                                                if(fi.Val6__c!=null)
                                                    totalSolutionsCapital.Val6__c += fi.Val6__c;
                                                if(fi.Val7__c!=null)
                                                    totalSolutionsCapital.Val7__c += fi.Val7__c;
                                                if(fi.Val8__c!=null)
                                                    totalSolutionsCapital.Val8__c += fi.Val8__c;
                                                if(fi.Value_1__c!=null)
                                                    totalSolutionsCapital.Value_1__c += fi.Value_1__c;
                                                if(fi.Value_2__c!=null)
                                                    totalSolutionsCapital.Value_2__c += fi.Value_2__c;
                                                if(fi.Value_3__c!=null)
                                                    totalSolutionsCapital.Value_3__c += fi.Value_3__c;
                                                if(fi.Value_4__c!=null)
                                                    totalSolutionsCapital.Value_4__c += fi.Value_4__c;
                                                if(fi.LastQForecast__c!=null)
                                                    totalSolutionsCapital.LastQForecast__c += fi.LastQForecast__c;
                                        }
                                        lastModified = string.valueOf(fi.Forecast__r.LastModifiedDate);
                                }
                            }
                        }
                        
                }  
                catch(Exception e)
                {
                }
        } 
        public list<Forecast_Item__c> getTheItemsSolutionsConsumables()
        {
            if(!TheItemsSolutionsConsumables.isEmpty())        
                return TheItemsSolutionsConsumables;
            return null;
        }   
        public list<Forecast_Item__c> getTheItemsJohnson()
        {
            if(!TheItemsJohnson.isEmpty())
                return TheItemsJohnson;
            return null;
        }   
        public list<Forecast_Item__c> getTheItemsSolutionsCapital()
        {
            if(!TheItemsSolutionsCapital.isEmpty())                
                return TheItemsSolutionsCapital;
            return null;
        }   
        public list<Forecast_Item__c> getTotalItems1()
        {
            if(!TotalItems1.isEmpty())
                return TotalItems1;
            return null;
        }
        
        public list<Forecast_Item__c> getTotalItems2()
        {
            if(!TotalItems2.isEmpty())
                return TotalItems2;
            return null;
        }
        
        public list<Forecast_Item__c> getTotalItems3()
        {
            if(!TotalItems3.isEmpty())
                return TotalItems3;
            return null;
        }
        
        public list<Forecast_Item__c> getTotalForecast()
        {
            if(!TotalForecast.isEmpty() && TotalForecast!=null)
                return TotalForecast;
            return null;
        }
        public Forecast_Item__c getTotalSolutionsConsumables()
        {
            return totalSolutionsConsumables;
        }
        public Forecast_Item__c getTotalJohnson()
        {
            return totalJohnson;
        }
        public Forecast_Item__c getTotalSolutionsCapital()
        {
            return totalSolutionsCapital;
        }
        
        public Forecast_Item__c getTotalReg()
        {
            return totalReg1;
        }
        
        public Forecast_Item__c getTotalReg2()
        {
            return totalReg2;
        }
        
        public Forecast_Item__c getTotalReg3()
        {
            return totalReg3;
        }
        
        public Forecast_Item__c getTotalf()
        {
            return totalf;
        }
        public List<SelectOption> getUsers()
        {
            List<SelectOption> opns = new List<SelectOption>();
            try
            {               
                SelectOption s = new SelectOption('', '--Select One--');
                    opns.Add(s); 
                for (User c : [
                        Select FirstName, LastName,Alias, Id from User 
                        where (ManagerId = :UserInfo.getUserId() and Quartely_Forecasting__c = true) 
                        OR (Id = :UserInfo.getUserId() and Quartely_Forecasting__c = true) 
                        order by LastName])
                {
                    SelectOption so = new SelectOption(c.Id, c.FirstName + ' ' + c.LastName);
                    opns.Add(so);  
                    myUsers.add(c.Id);   
                }
            }
            catch(Exception e)
            {
                
            }
            return opns;
        }
        
       public void getDates()
       {
            try
            {

                //determine which quarter is the current one
                if(curt == null)
                    curt = new Period();        
                integer limitQ = 0;
                string fyear;
                date fCastBaseDate;
                if (selectedQuarter != null && selectedQuarter != '')
                {
                        integer qNum = integer.valueOf(selectedQuarter.substring(1, 2));
                        fyear = selectedQuarter.substringAfter(' ');
                        qNum -= 1;
                        if (qNum == 0)
                        {
                            qNum = 4;
                            fyear = String.valueOf(integer.valueOf(fyear) - 1);
                        }
                        
                        for(period p : periods)
                        {
                             if(p.Number == qNum && p.FiscalYearSettings.Name == fyear)
                             {
                                    fCastBaseDate = p.StartDate;
                                    break;
                             }
                        }           
                }
                else
                {
                      fCastBaseDate = date.today();
                      fyear = string.valueOf(Date.today().year());
                }       
                //boolean onCurrent = false;          
                for (Period p : periods)
                { 
                    Date theChk = fCastBaseDate.addMonths(1);
                        
                    if (limitQ == 8)
                        break;
                    else if (p.StartDate <= theChk && p.EndDate >= theChk)
                        {
                            curt = p;
                            limitQ += 1;
                            h8 = 'Q' + p.Number + ' ' + p.FiscalYearSettings.Name + ' (Actual)';
                            //onCurrent = false;
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
                
                //for (integer i=0; i<3; i++) 
                //{
                    if (curt.Number == 1)
                    {fh1 = 'Q2 ' + fyear;fh2 = 'Q3 ' + fyear;fh3 = 'Q4 ' + fyear;fh4 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);}
                    //{fh1 = 'Q1 ' + fyear;fh2 = 'Q2 ' + fyear;fh3 = 'Q3 ' + fyear;fh4 = 'Q4 ' + fyear;}
                    else if (curt.Number == 2)
                    {fh1 = 'Q3 ' + fyear;fh2 = 'Q4 ' + fyear;fh3 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);fh4 = 'Q2 ' +string.valueOf(integer.valueOf(fyear)+1);}
                    //{fh1 = 'Q2 ' + fyear;fh2 = 'Q3 ' + fyear;fh3 = 'Q4 ' + fyear;fh4 = 'Q1 ' +string.valueOf(integer.valueOf(fyear)+1);}
                    else if (curt.Number == 3)
                    {fh1 = 'Q4 ' + fyear;fh2 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);fh3 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);fh4 = 'Q3 ' + string.valueOf(integer.valueOf(fyear)+1);}
                    //{fh1 = 'Q3 ' + fyear;fh2 = 'Q4 ' + fyear;fh3 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);fh4 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);}
                    else if (curt.Number == 4)
                    {fh1 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);fh2 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);fh3 = 'Q3 ' + string.valueOf(integer.valueOf(fyear)+1);fh4 = 'Q4 ' + string.valueOf(integer.valueOf(fyear)+1);}     
                    //{fh1 = 'Q4 ' + fyear;fh2 = 'Q1 ' + string.valueOf(integer.valueOf(fyear)+1);fh3 = 'Q2 ' + string.valueOf(integer.valueOf(fyear)+1);fh4 = 'Q3 ' + string.valueOf(integer.valueOf(fyear)+1);}     
                //}
           }
           catch(Exception e)
           {
        
           }
       }      
}