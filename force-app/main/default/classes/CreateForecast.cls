global with sharing class CreateForecast
{
    static public void main(string strType, integer intCurrentQuarter)
    {
        string prevNum = '';
        string fh1, fh2, fh3, fh4;
        //get the current quarter
        //Period curt = [Select p.Type, p.StartDate, p.Number, p.Id, p.FiscalYearSettingsId, p.FiscalYearSettings.Name, p.EndDate
            //From Period p
            //Where type = 'Quarter' and p.StartDate <= :Date.Today() and p.EndDate >= :Date.Today() limit 1];
        //determine which quarter is the current one
        for (integer i=0; i<3; i++) 
        {
            //if (curt.Number == 1)
            if (intCurrentQuarter == 1)
            {
                fh1 = 'Q2 ' + Date.today().year();
                        fh2 = 'Q3 ' + Date.today().year();
                        fh3 = 'Q4 ' + Date.today().year();
                        fh4 = 'Q1 ' + Date.today().addYears(1).year();
                        prevNum = 'Q1 ' + Date.today().year();
                }
                else if (intCurrentQuarter == 2)
                {
                        fh1 = 'Q3 ' + Date.today().year();
                        fh2 = 'Q4 ' + Date.today().year();
                        fh3 = 'Q1 ' + Date.today().addYears(1).year();                  
                        fh4 = 'Q2 ' + Date.today().addYears(1).year();
                        prevNum = 'Q2 ' + Date.today().year();
                }
                else if (intCurrentQuarter == 3)
                {
                        
                        fh1 = 'Q4 ' + Date.today().year();
                        fh2 = 'Q1 ' + Date.today().addYears(1).year();  
                        fh3 = 'Q2 ' + Date.today().addYears(1).year();                  
                        fh4 = 'Q3 ' + Date.today().addYears(1).year();
                        prevNum = 'Q3 ' + Date.today().year();
                }
                else if (intCurrentQuarter == 4)
                {                       
                        fh1 = 'Q1 ' + Date.today().addYears(1).year();
                        fh2 = 'Q2 ' + Date.today().addYears(1).year();  
                        fh3 = 'Q3 ' + Date.today().addYears(1).year();                  
                        fh4 = 'Q4 ' + Date.today().addYears(1).year();
                        prevNum = 'Q4 ' + Date.today().year();
                }
                
        }    

        List<User> users;
        List<Account> accts;

        if(strType == null || strType.ToUpperCase() == 'JOHNSON')
        {
            users = [select Id from User where Quartely_Forecasting__c = true and IsActive = true And Division = 'KJ'];
            createUserForecasts(users, 'Johnson', intCurrentQuarter, prevNum, fh1, fh2, fh3, fh4);
        }

        if(strType == null || strType.ToUpperCase() == 'KSD')
        {
            users = [select Id from User where Quartely_Forecasting__c = true and IsActive = true And Division = 'KSD'];
            createUserForecasts(users, 'Solutions', intCurrentQuarter, prevNum, fh1, fh2, fh3, fh4);
        }

        if(strType == null || strType.ToUpperCase() == 'CANADA')
        {
            users = [select Id from User where Quartely_Forecasting__c = true and IsActive = true And Division = 'KCC'];
            createUserForecasts(users, 'Canada', intCurrentQuarter, prevNum, fh1, fh2, fh3, fh4);
        }
    }
    
    public static void createUserForecasts(List<User> userIds, string strLocation, decimal currentNum, string prevNum, string fh1, string fh2, string fh3, string fh4) {

        List<Forecast_Item__c> fis = new List<Forecast_Item__c>();
        List<Forecast_Item__c> previousQuartersItems = [select  Name, Value_2__c, Value_3__c, Value_4__c, Sum1__c, Sum2__c, Sum3__c, Sum4__c,
            Q1_Plus_Minus__c, Q2_Plus_Minus__c, Q3_Plus_Minus__c, Q4_Plus_Minus__c, Forecast__c, Forecast__r.OwnerId
            From Forecast_Item__c
            Where Forecast__r.Name = :prevNum and Location__c = :strLocation And Forecast__r.Account_Forecast__c = false];
        map<string, Forecast_Item__c> pqiMap = new map<string, Forecast_Item__c>();
        for(Forecast_Item__c f : previousQuartersItems)
        {
            pqiMap.put(f.Forecast__r.OwnerId + f.Name, f);
        }
        
        List<Forecast_Category__c> theBlanks = [select id, Forecast_Category__c, 
            Sort_Order__c,    
            Location__c,         
            Major_Category__c from Forecast_Category__c Where Location__c = :strLocation];
            
        string forName = 'Q'+ currentNum + ' ' + Date.Today().Year();
        
        Forecast__c[] forecastsToDelete = [SELECT Id FROM Forecast__c WHERE OwnerId IN :userIds AND Name = :fh1 And Account_Forecast__c = false];
        delete forecastsToDelete;
        
        List<Forecast__c> insertForecasts = new List<Forecast__c>();
        for (User u : userIds)
        {
            Forecast__c f = new Forecast__c(Name=fh1, RecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('DSM/RSM Forecast').getRecordTypeId(), P1_Name__c = fh1, P2_Name__c = fh2, P3_Name__c = fh3, P4_Name__c = fh4, OwnerId = u.Id, Forecast_Period__c = forName, Account__c = null);
            insertForecasts.add(f);
        }
        insert insertForecasts;
        for (Forecast__c f : insertForecasts)
        {
            for (Forecast_Category__c fb : theBlanks)
            {
                    if(pqiMap.containsKey(f.OwnerId+fb.Major_Category__c+'-'+fb.Forecast_Category__c))
                    {
                        Forecast_Item__c fiOld = pqiMap.get(f.OwnerId+fb.Major_Category__c+'-'+fb.Forecast_Category__c);
                        
                        Forecast_Item__c fi = new Forecast_Item__c(Name = fb.Major_Category__c + '-' + fb.Forecast_Category__c,
                            Forecast__c = f.Id,
                            Value_1__c = fiOld.Value_2__c,
                            Value_2__c = fiOld.Value_3__c,
                            Value_3__c = fiOld.Value_4__c,
                            Value_1_Bkp__c = fiOld.Value_2__c,
                            Value_2_Bkp__c = fiOld.Value_3__c,
                            Value_3_Bkp__c = fiOld.Value_4__c,
                            Sum1__c = fiOld.Sum2__c,
                            Sum2__c = fiOld.Sum3__c,
                            Sum3__c = fiOld.Sum4__c,
                            Sum4__c = 0,
                            Q1_Plus_Minus__c = fiOld.Q2_Plus_Minus__c,
                            Q2_Plus_Minus__c = fiOld.Q3_Plus_Minus__c,
                            Q3_Plus_Minus__c = fiOld.Q4_Plus_Minus__c,
                            Q4_Plus_Minus__c = 0,
                            Sort_Order__c = fb.Sort_Order__c,
                            Forecast_Category__c = fb.Forecast_Category__c,
                            Location__c = fb.Location__c,
                            Product_Category__c = fb.Major_Category__c);
                            fis.add(fi);
                        
                    }
                    else
                    {
                        Forecast_Item__c fi = new Forecast_Item__c(Name = fb.Major_Category__c + '-' + fb.Forecast_Category__c,
                            Forecast__c = f.Id, 
                            Sort_Order__c = fb.Sort_Order__c,
                            Forecast_Category__c = fb.Forecast_Category__c,
                            Location__c = fb.Location__c,
                            Product_Category__c = fb.Major_Category__c);
                            fis.add(fi);
                        
                    }                         
            }
        }       
        insert fis;
    }

}