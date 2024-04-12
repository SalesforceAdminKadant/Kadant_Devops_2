@isTest (seeAllData=True)
public class TestKPP_Function_Library {
    @isTest static void testKPP_Function_Library_class()
    {
        User userTable = [SELECT Id FROM User where accountid <>'' LIMIT 1];
        Account accountTable = [SELECT Id FROM Account WHERE Id IN (SELECT ParentId FROM FeedItem WHERE Type = 'TextPost' AND IsDeleted = FALSE) LIMIT 1 ];
        OrderItem OrderAccountTable = [SELECT Id,OrderId,Order_Account__c FROM OrderItem WHERE OrderId <> '' AND Order.AccountId <> '' LIMIT 1];
        Product2 ProductTable = [SELECT Id FROM Product2 WHERE Drawing_Number__c <> '' AND product_classification__c <> '' LIMIT 1];
        Case caseTable = [SELECT Id, AccountId, AssetId FROM Case WHERE AccountId <>'' AND AssetId <> '' LIMIT 1];
        Case woTable = [SELECT Id FROM Case LIMIT 1];
        FeedItem feedTable = [SELECT Id FROM FeedItem LIMIT 1];
        Asset assetTable = [SELECT Id, AccountId FROM Asset WHERE AccountId <> '' LIMIT 1];
        //ContentVersion fileTable = [SELECT Id FROM ContentVersion WHERE islatest=true AND OwnerId <> '0035900000I7e4dAAB' LIMIT 1];
        //ContentDocumentLink CDLTable = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = '0035900000I7e4dAAB' LIMIT 1];
        Opportunity OppTable = [SELECT Id FROM Opportunity LIMIT 1];
        Quote QuoteTable = [SELECT Id FROM quote WHERE Sales_Office__c <> '' AND Id IN (SELECT QuoteId FROM QuoteLineItem) LIMIT 1];
        QuoteLineItem QouteAccountTable = [SELECT Id,QuoteId,Quote_AccountId__c FROM QuoteLineItem WHERE QuoteId <> '' AND Quote_AccountId__c <> '' LIMIT 1];
        Order OrderTable = [SELECT Id FROM Order WHERE Sales_Office__c <> '' AND AccountId <> '' LIMIT 1];
        OrderItem OrderItemTable = [SELECT Id,OrderId FROM OrderItem WHERE Product__c <> '' LIMIT 1];
        
 		String sUser = userTable.id;
		String sAccountId = accountTable.id;
        String sOrderAccountId = OrderAccountTable.Order_Account__c; 
        String sProductId = ProductTable.id;
        String sCaseId = caseTable.id;   
        String sCaseAccountId = caseTable.AccountId;
        String sCaseAssetId = caseTable.AssetId;  
        String sWoCaseId = woTable.id;  
        String sFeedId = feedTable.id; 
        String sAssetId = assetTable.id; 
        String sAssetAccountId = assetTable.AccountId;
        //String sFileId = fileTable.Id;
        //String sDeleteFileId = CDLTable.ContentDocumentId;
        String sOppId = OppTable.Id;
        String sQuoteId = QuoteTable.Id;
        String sQuoteAccountId = QouteAccountTable.Quote_AccountId__c;
        String sOrderId = OrderTable.Id;
        String sOrderItemId = OrderItemTable.OrderId;
               
        Test.startTest();   
        /*######################## CUSTOMER RELATED FUNCTIONS #################### */  
        KPP_Function_Library.searchCustomers('KJE',' ', '0124W000001AiswQAC');
        KPP_Function_Library.getCustomer(sAccountId);
        
        
        /*######################## ASSET RELATED FUNCTIONS #################### */ 
   		KPP_Function_Library.getAssets(sAssetAccountId);
        KPP_Function_Library.getAsset(sCaseAssetId, sCaseAccountId);

        
        /*######################## CONTACT RELATED FUNCTIONS #################### */
    	KPP_Function_Library.getContacts(sAccountId);
        
        
       	/*######################## WORKORDER RELATED FUNCTIONS #################### */
    	KPP_Function_Library.getWorkorders(sWoCaseId);

        
       	/*######################## CHAT RELATED FUNCTIONS #################### */
		//KPP_Function_Library.getHomeChat(sUser);
        KPP_Function_Library.getChat(sAccountId);
        KPP_Function_Library.createChat(sAccountId, '..');
        KPP_Function_Library.createComment(sFeedId, '..');
        
        
        /*######################## OPPORTUNITY RELATED FUNCTIONS #################### */
        KPP_Function_Library.getHomeOpps(sUser);
        KPP_Function_Library.getOpp(sOppId,sAccountId);
        
        
        /*######################## CASE RELATED FUNCTIONS #################### */ 
        KPP_Function_Library.getHomeCases(sUser);
        KPP_Function_Library.getCases(sCaseAccountId, 'cus');
        KPP_Function_Library.getCases(sAssetId, 'ast');
        KPP_Function_Library.createCase(sAccountId, '..', 'Complaint', '...', sUser);
        KPP_Function_Library.saveCase(sCaseId, '..', sAssetId, '..', sUser);
        KPP_Function_Library.getCase(sCaseId, sCaseAccountId);
        
         /*######################## QUOTE RELATED FUNCTIONS #################### */
 		 KPP_Function_Library.getQuoteHistory(sQuoteAccountId);
         KPP_Function_Library.getQuote(sQuoteId ,sAccountId);
         KPP_Function_Library.getQuoteLines(sQuoteId);
        
        /*######################## ORDER RELATED FUNCTIONS #################### */
        KPP_Function_Library.getHomeOrders(sUser);
        KPP_Function_Library.getOrderHistory(sOrderAccountId);
        KPP_Function_Library.getOrder(sOrderId,sAccountId);
        KPP_Function_Library.getOrderLines(sOrderItemId);
        //KPP_Function_Library.CopyOrder(sOrderItemId, sAccountId, sUser);
        
        
        /*######################## FILES RELATED FUNCTIONS #################### */
              KPP_Function_Library.ShowFiles(sProductId);
        
        
        /*
        KPP_Function_Library.AddFilePermission(sFileId);
        KPP_Function_Library.DeleteFilePermission(sDeleteFileId);
        */
                
        /*######################## NEARBY MAP RELATED FUNCTIONS #################### */
        KPP_Function_Library.getCenter(sAccountId);
        KPP_Function_Library.getNearbyCustomers(sAccountId, 50, True, true, false, false, false);
        KPP_Function_Library.getNearbyCustomers(sAccountId, 50, True, false, true, false, true);
        KPP_Function_Library.getNearbyCustomers(sAccountId, 50, false, false, false, false, false);
        KPP_Function_Library.getNearbyCustomers(sAccountId, 50, false, false, false, false, true);
        
        Test.stopTest();
    }

    @isTest static void AdvancedSearchScreen() {
        //Product Search related Variables
        list<quotelineitem> q = [select product2.id, product2.Name, quote.id, quote.opportunity.id, quote.pricebook2id, quote.currencyisocode, quote.recordtype.name from quotelineitem WHERE product2.IsActive=True And product2id IN(SELECT Product2Id FROM PricebookEntry WHERE currencyisocode='USD') limit 1];
		ReturnOrder[] ro = [select id from ReturnOrder limit 1];
		sObject myProduct = Database.query('select Location__c from product2 limit 1'); 

		String quoteID = q[0].quote.id;
		String partID = q[0].product2.id;
		String partName = q[0].product2.name;
        String priceBook = q[0].quote.pricebook2id;
        String curr = q[0].quote.currencyisocode;
        String recType = q[0].quote.recordtype.name;
        String OppId = q[0].quote.opportunity.id;
        String natureOfTransaction = 'None';
        String serviceCode = 'None';
		Map<String,String> SelectedPartMap = New Map<String,String>{'e'=>'f', 'g'=> 'h'}; 
		Map<String,String> SelectedPartMap2 = New Map<String,String>{ partID => partName };
		Map<String,String> SelectedPartMapQty2 = New Map<String,String>{ partID =>'1'};
		Blade__c[] bl = [select recordtypeid from blade__c limit 1];

        Quote QuoteTable = [SELECT Id FROM quote WHERE Sales_Office__c <> '' LIMIT 1];
        String sQuoteId = QuoteTable.Id;

        ContentVersion fileTable = [SELECT Id FROM ContentVersion WHERE islatest=true AND OwnerId <> '0035900000I7e4dAAB' LIMIT 1];
        String sFileId = fileTable.Id;

        Bill_of_Material__c BomTable = [SELECT parent_product__c FROM Bill_of_Material__c WHERE parent_product__c <> '' AND Child_Part_ID__c <> '' LIMIT 1];
        String BomPartId = BomTable.Id;        

        Test.startTest();
        /*#################### ADVANCED SEARCH SCREEN RELATED FUNCTIONS ################ */
        KPP_Function_Library.searchForParts(sQuoteId, 'Quote', '995', 'And IsActive=true', SelectedPartMap);
        KPP_Function_Library.searchForParts(sQuoteId, 'Quote', '', 'And IsActive=true', SelectedPartMap);
        KPP_Function_Library.searchForParts(quoteID, 'Quote', '', 'HISTORY', SelectedPartMap);
        KPP_Function_Library.getselectOptions(myProduct, 'Location__c');
        KPP_Function_Library.showBomParts(BomPartId);
        KPP_Function_Library.GetBladeDetails(String.valueOf(bl[0].Id));
        KPP_Function_Library.getQuoteDetailsPage2(sFileId);
        KPP_Function_Library.GetCustomerPricing(quoteID, 'Quote', SelectedPartMap2);
        KPP_Function_Library.GetProductPricing(quoteID, 'Quote', SelectedPartMap2, SelectedPartMapQty2);
        KPP_Function_Library.AddQuoteLines(quoteID, priceBook, curr, recType, SelectedPartMap2, '[{"value":"4","key":"qty'+partID+'"}]','[{"value":"500","key":"up'+partID+'"}]','[{"value":"10","key":"disc'+partID+'"}]','[{"prodid":"'+partID+'","matid":"5sW0000000Aw2nIAC","material":"Abrasitek","width":"22","thickness":"1.9","bevel":""}]','[{"value":"25","key":"lt'+partID+'"}]','[{"value":"None","key":"ndo'+partID+'"}]','[{"value":"14.02","key":"sco'+partID+'"}]');
        Test.stopTest();        
    }

    @isTest static void ProductRelatedFunctions() {
        ContentDocumentLink LinkedEntityTable = [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN ( SELECT Drawing__c FROM Product2 WHERE Drawing__c <> '' AND Drawing__r.Type__c = 'Assembly' AND product_classification__c <> '') Limit 1];       
        String sLinkedEntityId = LinkedEntityTable.LinkedEntityId;
        String sContentDocumentId = LinkedEntityTable.ContentDocumentId;
        Product2 ProductTable = [SELECT Id FROM Product2 WHERE Drawing__c =:sLinkedEntityId LIMIT 1];
        
        User userTable = [SELECT Id FROM User WHERE accountid <>'' LIMIT 1];

        
        String sUser = userTable.id;
        String sProductId = ProductTable.id;

        Test.startTest();
        /*######################## PART RELATED FUNCTIONS #################### */
        KPP_Function_Library.searchProducts('PSGE','AND name like \'%995.%\' ');
        KPP_Function_Library.getProduct(sProductId,'');
        KPP_Function_Library.getDrawingFileID(sProductId, sUser);
        Test.stopTest();    
    }
/*
    @isTest static void CreateQuote() {
        User userTable = [SELECT Id FROM User WHERE account.RecordType.Name = 'PSG-E Agent' LIMIT 1];
        OrderItem OrderAccountTable = [SELECT Id,OrderId,Order_Account__c FROM OrderItem WHERE OrderId <> '' AND Order.AccountId <> '' LIMIT 1];
        
        String sUser = userTable.Id;
        String sOrderAccountId = OrderAccountTable.Order_Account__c;
        String sOrderId = OrderAccountTable.OrderId;

        KPP_Function_Library.CopyOrder(sOrderId, sOrderAccountId, sUser);
    }
*/
    @isTest static void FilesRelatedFunctions() {
        /*######################## FILES RELATED FUNCTIONS #################### */
        Account accountTable = [SELECT Id FROM Account WHERE Id IN (SELECT ParentId FROM FeedItem WHERE Type = 'TextPost' AND IsDeleted = FALSE) LIMIT 1 ];
        String sAccountId = accountTable.id;
        blob bfile = blob.toPdf('Test Text');
        String sfile = EncodingUtil.base64Encode(bfile);
       
        KPP_Function_Library.UploadFile(sAccountId, 'Test Files',sfile, 'pdf');
        KPP_Function_Library.ShowFiles(sAccountId);

        /* #### Has been made dynamic ### 
        KPP_Function_Library.AddFilePermission(sFileId);
        KPP_Function_Library.DeleteFilePermission(sDeleteFileId);
        */

    }
}