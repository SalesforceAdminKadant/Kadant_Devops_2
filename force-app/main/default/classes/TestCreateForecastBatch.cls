@isTest(SeeAllData=true)
public class TestCreateForecastBatch {

    static testMethod void TestBatchProcess() {

        //Get standard pricebook ID
        Id spId = test.getStandardPricebookId();

        //Inserting User
        Profile p = [SELECT Id FROM Profile WHERE Name = 'KJ RSMs' LIMIT 1]; 
         
        User objUser2;
        User objUser;

        system.runAs (new User(Id = UserInfo.getUserId()))
        {
            objUser2 = new User(Alias = 'standtM',
                                Quartely_Forecasting__c = true,
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

        User u = [select id from User where IsActive = true and ManagerId =: objUser2.Id limit 1];
        
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
        
        Forecast__c f = new Forecast__c(Name = 'Q1 2023', OwnerId = u.Id);
        insert f;
        
        Test.startTest();
        CreateForecastBatch cfb = new CreateForecastBatch();
        cfb.main();
        Test.stopTest();
    }
    
}