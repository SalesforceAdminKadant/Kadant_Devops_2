@isTest (SeeAllData = true)
private class testForecastController 
{
    static testMethod void myUnitTest() 
    {
        //Get standard pricebook ID
        Id spId = test.getStandardPricebookId();

        //Inserting User
        Profile p = [SELECT Id FROM Profile WHERE Name='KJ RSMs']; 
         
        User objUser = new User(Alias = 'standt', 
                    Email='standarduser@kadant.com',
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing',   
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    ManagerId = UserInfo.getUserId(),
                    UserName='standarduser@kadant.com'); 
                    
        insert objUser;
          
        User u = [select id from User where IsActive = true and ManagerId = :UserInfo.getUserId() limit 1];
        
        // Insert Account
        Account objAccount = new Account();
        objAccount.Name = 'Test Account 1';
        objAccount.Phone = '1234567890';
        objAccount.OwnerId = u.Id;
        insert objAccount;
          
        // Insert Opportunity
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opportunity 1';
        objOpportunity.StageName = 'Closed-Won - 100%';
        objOpportunity.CloseDate = date.today() + 10;
        objOpportunity.AccountId = objAccount.Id;
        objOpportunity.Amount = 100;
        objOpportunity.Created_By__c = 'Human';
        objOpportunity.KL_Probability__c = 1;
        objOpportunity.Pricebook2ID = spId;
        insert objOpportunity;
        
        List<Product2> lstProducts = new List<Product2>{
                                                         new Product2( Name = 'testProduct', ProductCode = 'pc-01', 
                                                         Location__c = 'WEB', Family = 'Blades', 
                                                         Comission_Category__c = 'Established' ),
                                                         
                                                         new Product2( Name = 'testProduct', ProductCode = 'pc-02', 
                                                         Location__c = 'JOHNSON', Family = 'CLEANING', 
                                                         Comission_Category__c = 'AES' ),  
                                                         
                                                         new Product2( Name = 'testProduct', ProductCode = 'pc-03', 
                                                         Location__c = 'AES', Family = 'JOINTS', 
                                                         Comission_Category__c = 'JOHNSON' ),
                                                         
                                                         new Product2( Name = 'testProduct', ProductCode = 'pc-04', 
                                                         Location__c = 'M-CLEAN', Family = 'CLEANING', 
                                                         Comission_Category__c = 'M-CLEAN' )
                                                         
                                                       };
        
        insert lstProducts;

        // Insert PricebookEntry
        List<PricebookEntry> lstPBE = new List<PricebookEntry>{ 
                                                                new PricebookEntry( Pricebook2Id = spId, UnitPrice=15, 
                                                                Product2Id=lstProducts[0].Id, UseStandardPrice = false, isActive=true),
                                                                
                                                                new PricebookEntry( Pricebook2Id = spId, UnitPrice=15, 
                                                                Product2Id=lstProducts[1].Id, UseStandardPrice = false, isActive=true),
                                                                
                                                                new PricebookEntry( Pricebook2Id = spId, UnitPrice=15, 
                                                                Product2Id=lstProducts[2].Id, UseStandardPrice = false, isActive=true),
                                                                
                                                                new PricebookEntry( Pricebook2Id = spId, UnitPrice=15, 
                                                                Product2Id=lstProducts[3].Id, UseStandardPrice = false, isActive=true)
                                                              };
        
        insert lstPBE;
         
        // Insert OLIs
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>{ 
                                                                            new OpportunityLineItem(OpportunityId=objOpportunity.Id, 
                                                                            PricebookEntryId=lstPBE[0].Id, Quantity = 10, TotalPrice = 100, 
                                                                            ServiceDate = date.newinstance(2011, 10, 02)),
                                                                            
                                                                            new OpportunityLineItem(OpportunityId=objOpportunity.Id, 
                                                                            PricebookEntryId=lstPBE[1].Id, Quantity = 10, TotalPrice = 100, 
                                                                            ServiceDate = date.newinstance(2012, 01, 02)),
                                                                            
                                                                            new OpportunityLineItem(OpportunityId=objOpportunity.Id, 
                                                                            PricebookEntryId=lstPBE[2].Id, Quantity = 10, TotalPrice = 100, 
                                                                            ServiceDate = date.newinstance(2012, 04, 02)),
                                                                            
                                                                            new OpportunityLineItem(OpportunityId=objOpportunity.Id, 
                                                                            PricebookEntryId=lstPBE[3].Id, Quantity = 10, TotalPrice = 100,
                                                                            ServiceDate = date.newinstance(2012, 09, 02))
                                                                        };
            
            insert lstOLI;
        
        //Insert Forecast
        Forecast_Category__c fb = new Forecast_Category__c(Forecast_Category__c = 'ESTABLISHED', Major_Category__c ='BLADES', 
                                                            Location__c = 'WEB' );
        insert fb;
        
        Forecast__c f = new Forecast__c(Name = 'Q2 2012', OwnerId = u.Id);
        insert f;  
        
        PageReference pageRef = Page.ForecastTabbed;      
        pageRef.getParameters().put('id', f.Id);
        
        List<Forecast_Item__c> lstFIforQ2 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = f.Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES', Value_2__c = 100, Value_3__c = 100, 
                                    Value_4__c = 100, Val1__c = 100, Val2__c = 100, Val3__c = 100, Val4__c = 100, 
                                    Val5__c = 100, Val6__c = 100, Val7__c = 100, Val8__c = 100), 
                                        
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = f.Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'JOHNSON', Value_2__c = 100, Value_3__c = 100, 
                                    Value_4__c = 100, Val1__c = 100, Val2__c = 100, Val3__c = 100, Val4__c = 100, 
                                    Val5__c = 100, Val6__c = 100, Val7__c = 100, Val8__c = 100),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = f.Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'Web', Value_2__c = 100, Value_3__c = 100, 
                                    Value_4__c = 100, Val1__c = 100, Val2__c = 100, Val3__c = 100, Val4__c = 100, 
                                    Val5__c = 100, Val6__c = 100, Val7__c = 100, Val8__c = 100),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = f.Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN', Value_2__c = 100, Value_3__c = 100, 
                                    Value_4__c = 100, Val1__c = 100, Val2__c = 100, Val3__c = 100, Val4__c = 100, 
                                    Val5__c = 100, Val6__c = 100, Val7__c = 100, Val8__c = 100)
                                                                      };
                                                                 
        insert lstFIforQ2;
       
        Test.setCurrentPage(pageRef);
        
        test.startTest();
        forecastCtrl controller = new forecastCtrl();
        test.stopTest();
        
        controller.getDates();
       
        controller.e1 = controller.e2 = controller.e3 = controller.e4 = 
        controller.e5 = controller.e6 = controller.e7 = controller.e8 = date.newinstance(2014, 10, 02) + 30;
        controller.getForecast();
        controller.getLastQuarterForecast();
        controller.mapTheTotals();
        controller.getTheTotalsSolutionsConsumables();
        controller.getTheTotalsJohnson();
        controller.getTheTotalsSolutionsCapital();
        controller.getTotalCo();
        controller.getTheTotalItems();
        controller.submit();
        controller.updateForecastSolutionsConsumables();
        controller.updateForecastJohnson();
        //controller.updateForecastSolutionsCapital();
        controller.cancel(); 
    }
    
    static testMethod void testManagerController() 
    {      
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='KJ RSMs']; 
        
        User objUser = new User(Alias = 'standt', 
                    Email='standarduser@kadant.com',
                    EmailEncodingKey='UTF-8', 
                    LastName='Testing',   
                    LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', 
                    ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', 
                    ManagerId = UserInfo.getUserId(),
                    Quartely_Forecasting__c = true,
                    UserName='standarduser@kadant.com');  
         
        insert objUser;
                  
        List<User> lstManager = new List<User>{
                                                new User(Alias = 'standt1', Email='standarduser1@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser.Id,
                                                UserName='standarduser1@kadant.com', Region__c=4),
                                                
                                                new User(Alias = 'standt2', Email='standarduser2@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing2', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser.Id,
                                                UserName='standarduser2@kadant.com', Region__c=4),
                                                
                                                new User(Alias = 'standt3', Email='standarduser3@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing3', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser.Id,
                                                UserName='standarduser3@kadant.com', Region__c=NULL),
                                                
                                                new User(Alias = 'standt4', Email='standarduser4@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing4', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser.Id,
                                                UserName='standarduser4@kadant.com', Region__c=4)
                                            };
        insert lstManager;
            
        User u = [select id from User where IsActive = true and ManagerId =: UserInfo.getUserId() limit 1];
        
        List<Forecast_Category__c> lstFC = new List<Forecast_Category__c>{
                            new Forecast_Category__c(Forecast_Category__c = 'ESTABLISHED', Major_Category__c ='BLADES', Location__c='WEB'),
                            new Forecast_Category__c(Forecast_Category__c = 'AES', Major_Category__c ='CLEANING', Location__c='AES'),
                            new Forecast_Category__c(Forecast_Category__c = 'M-CLEAN', Major_Category__c ='CLEANING', Location__c='M-CLEAN'),
                            new Forecast_Category__c(Forecast_Category__c = 'JOHNSON', Major_Category__c ='JOINTS', Location__c='JOHNSON')
                                                                         };
        insert lstFC;
        
        List<Forecast__c> lstF = new List<Forecast__c>{
                                                        new Forecast__c(Name = 'Q3 2013', OwnerId = objUser.Id),
                                                        new Forecast__c(Name = 'Q2 2013', OwnerId = objUser.Id),
                                                        new Forecast__c(Name = 'Q1 2013', OwnerId = objUser.Id)
                                                      };
    
        insert lstF;  
        
        PageReference pageRef = Page.managerTabbed; 
        
        List<Forecast_Item__c> lstFIforQ3 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'BLADES-JOHNSON', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = lstF[0].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = lstF[0].Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'JOHNSON' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = lstF[0].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=null, 
                                    Value_2__c=null, Value_3__c=null, Value_4__c=null, Val1__c=null, Val2__c=null, 
                                    Val3__c=null, Val4__c=null, Val5__c=null, Val6__c=null, Val7__c=null, Val8__c=null, 
                                    LastQForecast__c=null ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=0, Value_2__c=0,
                                    Value_3__c=0, Value_4__c=0, Val1__c=0, Val2__c=0, Val3__c=0, Val4__c=0, Val5__c=0,
                                    Val6__c=0, Val7__c=0, Val8__c=0, LastQForecast__c=0 )
                                                                      };
                                                                 
        insert lstFIforQ3;
        
        List<Forecast_Item__c> lstFIforQ2 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'BLADES-JOHNSON', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = lstF[1].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = lstF[1].Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'JOHNSON' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = lstF[1].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=null, 
                                    Value_2__c=null, Value_3__c=null, Value_4__c=null, Val1__c=null, Val2__c=null, 
                                    Val3__c=null, Val4__c=null, Val5__c=null, Val6__c=null, Val7__c=null, Val8__c=null, 
                                    LastQForecast__c=null ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=0, Value_2__c=0,
                                    Value_3__c=0, Value_4__c=0, Val1__c=0, Val2__c=0, Val3__c=0, Val4__c=0, Val5__c=0,
                                    Val6__c=0, Val7__c=0, Val8__c=0, LastQForecast__c=0 )
                                                                      };
                                                                 
        insert lstFIforQ2;
        
        List<Forecast_Item__c> lstFIforQ1 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = lstF[2].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = lstF[2].Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[2].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = lstF[2].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 )
                                                                      };
                                                                 
        insert lstFIforQ1;
        
        Test.setCurrentPage(pageRef);
        managerForecastCtrl controller = new managerForecastCtrl();
        
        controller.getUsers();
        controller.getDates();
        controller.getTheQuarters();
        controller.selectedQuarter = 'Q3 2013';
        controller.selectedUser = u.Id; 
        controller.getAggResults();
        controller.getTotalIndividualForecast();
        controller.getUserResults();
        controller.updateForecastSolutionsConsumables();
        controller.updateForecastJohnson();
        controller.updateForecastSolutionsCapital();
        controller.updatethis();
        controller.getTheItemsSolutionsConsumables();
        controller.getTheItemsJohnson();
        controller.getTheItemsSolutionsCapital();
        controller.getTotalItems1();
        controller.getTotalItems2();
        controller.getTotalItems3();
        controller.getTotalForecast();
        controller.getTotalSolutionsConsumables();
        controller.getTotalJohnson();
        controller.getTotalSolutionsCapital();
        controller.getTotalReg();
        controller.getTotalReg2();
        controller.getTotalReg3();
        controller.getTotalf();    
        controller.refreshData();
        controller.selectedQuarter = NULL;
        controller.selectedUser = NULL;
        controller.getDates();
        
        controller.selectedQuarter = 'Q2 2013';
        controller.selectedUser = u.Id;
        controller.getDates();
        
        controller.selectedQuarter = 'Q1 2013';
        controller.selectedUser = u.Id;
        controller.getDates();
        
        test.stopTest();
    }
    
    static testMethod void testVpController() 
    {
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='KJ RSMs']; 
         
        User objUser2;
        User objUser;

        system.runAs (new User(Id = UserInfo.getUserId()))
        {
            objUser2 = new User(Alias = 'standtM', 
                               Email='standarduserM@kadant.com',
                               EmailEncodingKey='UTF-8', 
                               LastName='TestingM',   
                               LanguageLocaleKey='en_US',
                               LocaleSidKey='en_US', 
                               ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', 
                               UserName='standarduserM@kadant.com'); 
                           
            insert objUser2;

            objUser = new User(Alias = 'standt', 
                               Email='standarduser@kadant.com',
                               EmailEncodingKey='UTF-8', 
                               LastName='Testing',   
                               LanguageLocaleKey='en_US',
                               LocaleSidKey='en_US', 
                               ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', 
                               ManagerId = objUser2.Id,
                               UserName='standarduser@kadant.com'); 

            insert objUser;
        }

        List<User> lstManager = new List<User>{
                                                new User(Alias = 'standt1', Email='standarduser1@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser2.Id,
                                                UserName='standarduser1@kadant.com', Region__c=4),
                                                
                                                new User(Alias = 'standt2', Email='standarduser2@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing2', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser2.Id,
                                                UserName='standarduser2@kadant.com', Region__c=4),
                                                
                                                new User(Alias = 'standt3', Email='standarduser3@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing3', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser2.Id,
                                                UserName='standarduser3@kadant.com', Region__c=NULL),
                                                
                                                new User(Alias = 'standt4', Email='standarduser4@kadant.com',EmailEncodingKey='UTF-8', 
                                                LastName='Testing4', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                                                TimeZoneSidKey='America/Los_Angeles', ManagerId = objUser2.Id,
                                                UserName='standarduser4@kadant.com', Region__c=4)
                                            };
        insert lstManager;
            
        User u = [select id from User where IsActive = true and ManagerId =: objUser2.Id limit 1];
        
        List<Forecast_Category__c> lstFC = new List<Forecast_Category__c>{
                            new Forecast_Category__c(Forecast_Category__c = 'ESTABLISHED', Major_Category__c ='BLADES', Location__c='WEB'),
                            new Forecast_Category__c(Forecast_Category__c = 'AES', Major_Category__c ='CLEANING', Location__c='AES'),
                            new Forecast_Category__c(Forecast_Category__c = 'M-CLEAN', Major_Category__c ='CLEANING', Location__c='M-CLEAN'),
                            new Forecast_Category__c(Forecast_Category__c = 'JOHNSON', Major_Category__c ='JOINTS', Location__c='JOHNSON')
                                                                         };
        insert lstFC;
        
        List<Forecast__c> lstF = new List<Forecast__c>{
                                                        new Forecast__c(Name = 'Q3 2013', OwnerId = objUser.Id),
                                                        new Forecast__c(Name = 'Q2 2013', OwnerId = objUser.Id),
                                                        new Forecast__c(Name = 'Q1 2013', OwnerId = objUser.Id) 
                                                      };
    
        insert lstF;  
        
        PageReference pageRef = Page.vpTabbed; 
        
        List<Forecast_Item__c> lstFIforQ3 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'BLADES-JOHNSON', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = lstF[0].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = lstF[0].Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'JOHNSON' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = lstF[0].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=null, 
                                    Value_2__c=null, Value_3__c=null, Value_4__c=null, Val1__c=null, Val2__c=null, 
                                    Val3__c=null, Val4__c=null, Val5__c=null, Val6__c=null, Val7__c=null, Val8__c=null, 
                                    LastQForecast__c=null ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[0].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=0, Value_2__c=0,
                                    Value_3__c=0, Value_4__c=0, Val1__c=0, Val2__c=0, Val3__c=0, Val4__c=0, Val5__c=0,
                                    Val6__c=0, Val7__c=0, Val8__c=0, LastQForecast__c=0 )
                                                                      };
                                                                 
        insert lstFIforQ3;
        
        List<Forecast_Item__c> lstFIforQ2 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'BLADES-JOHNSON', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = lstF[1].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = lstF[1].Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'JOHNSON' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = lstF[1].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=null, 
                                    Value_2__c=null, Value_3__c=null, Value_4__c=null, Val1__c=null, Val2__c=null, 
                                    Val3__c=null, Val4__c=null, Val5__c=null, Val6__c=null, Val7__c=null, Val8__c=null, 
                                    LastQForecast__c=null ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[1].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=0, Value_2__c=0,
                                    Value_3__c=0, Value_4__c=0, Val1__c=0, Val2__c=0, Val3__c=0, Val4__c=0, Val5__c=0,
                                    Val6__c=0, Val7__c=0, Val8__c=0, LastQForecast__c=0 )
                                                                      };
                                                                 
        insert lstFIforQ2;
        
        List<Forecast_Item__c> lstFIforQ1 = new List<Forecast_Item__c>{
            new Forecast_Item__c(   Name = 'CLEANING-AES', Forecast__c = lstF[2].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'AES', Location__c = 'AES' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'JOINTS-JOHNSON', Forecast__c = lstF[2].Id, Product_Category__c = 'JOINTS', 
                                    Forecast_Category__c = 'JOHNSON', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'BLADES-ESTABLISHED', Forecast__c = lstF[2].Id, Product_Category__c = 'BLADES', 
                                    Forecast_Category__c = 'ESTABLISHED', Location__c = 'WEB' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 ),
                                    
            new Forecast_Item__c(   Name = 'CLEANING-M-CLEAN', Forecast__c = lstF[2].Id, Product_Category__c = 'CLEANING', 
                                    Forecast_Category__c = 'M-CLEAN', Location__c = 'M-CLEAN' , Value_1__c=77, Value_2__c=43,
                                    Value_3__c=76, Value_4__c=8, Val1__c=7, Val2__c=9, Val3__c=88, Val4__c=55, Val5__c=99,
                                    Val6__c=8, Val7__c=9, Val8__c=8, LastQForecast__c=9 )
                                                                      };
                                                                 
        insert lstFIforQ1;
        
        Test.setCurrentPage(pageRef);
        vpForecasting controller = new vpForecasting();
          
        controller.selectedQuarter = 'Q3 2013';
        controller.selectedUser = u.Id;
        controller.selectedManager = objUser2.Id; 
        controller.getAggResults();
        controller.getUsers();
        controller.getAllUsers();
        controller.getManagerUsers(); 
        controller.getTheQuarters(); 
        controller.getDates();
        controller.updateForecast();
        controller.getTheItemsW();
        controller.getTheItemsJ();
        controller.getTheItemsM();
        controller.getTotalItems();
        controller.getTotalItems2();
        controller.getTotalItems3();
        controller.getTotalItemsRegional();
        controller.getTotalItemsRegional2();
        controller.getTotalItemsRegional3();
        controller.getTotalWeb();
        controller.getTotalJ();
        controller.getTotalM();
        controller.getTotalReg();
        controller.getTotalReg2();
        controller.getTotalReg3();
        controller.getTotalCo();
        controller.getTotalCo2();
        controller.getTotalCo3();
        controller.updatethis();
        controller.selectedQuarter = NULL;
        controller.selectedUser = NULL;
        controller.selectedManager = NULL;
        controller.getDates();
        
        controller.selectedQuarter = 'Q2 2013';
        controller.selectedUser = u.Id;
        controller.selectedManager = objUser2.Id;
        controller.getDates();
        
        controller.selectedQuarter = 'Q1 2013';
        controller.selectedUser = u.Id;
        controller.selectedManager = objUser2.Id;
        controller.getDates();
        
        test.stopTest();
    }
}