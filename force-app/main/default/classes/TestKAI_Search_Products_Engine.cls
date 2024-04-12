@isTest(SeeAllData=True)
public class TestKAI_Search_Products_Engine {
    static testMethod void testKAI_SearchProducts_Engine_class()
    {
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
            
        //function 1
		KAI_Search_Products_Engine.GetCustomerPricing(quoteID, 'Quote', SelectedPartMap2);
  
        //function 2
		KAI_Search_Products_Engine.GetProductPricing(quoteID, 'Quote', SelectedPartMap2, SelectedPartMapQty2);

        //function 3
        KAI_Search_Products_Engine.AddQuoteLines(quoteID, priceBook, curr, recType, SelectedPartMap2, '[{"value":"4","key":"qty'+partID+'"}]','[{"value":"500","key":"up'+partID+'"}]','[{"value":"10","key":"disc'+partID+'"}]','[{"prodid":"'+partID+'","matid":"5sW0000000Aw2nIAC","material":"Abrasitek","width":"22","thickness":"1.9","bevel":""}]','[{"value":"25","key":"lt'+partID+'"}]','[{"value":"None","key":"ndo'+partID+'"}]','[{"value":"14.02","key":"sco'+partID+'"}]');

        //function 4
        KAI_Search_Products_Engine.AddOpportunityLines(OppId, SelectedPartMap2, '[{"value":"4","key":"qty'+partID+'"}]','[{"value":"500","key":"up'+partID+'"}]','[{"value":"10","key":"disc'+partID+'"}]');
        
		//function 5
        KAI_Search_Products_Engine.showBomParts(partID, SelectedPartMap);
        
        //function 6
        KAI_Search_Products_Engine.GetBladeDetails(String.valueOf(bl[0].Id));
        
        //function 7        
        KAI_Search_Products_Engine.searchForParts(quoteID, 'Quote', '', 'And IsActive=true', SelectedPartMap);
      	KAI_Search_Products_Engine.searchForParts(quoteID, 'Quote', '', 'HISTORY', SelectedPartMap);
		//function 8
        KAI_Search_Products_Engine.GetDefaultProductDivision();

        //function 9
        KAI_Search_Products_Engine.searchForPartsGeneric( '', 'And IsActive=true', SelectedPartMap);
        
        //function 10
        KAI_Search_Products_Engine.getselectOptions(myProduct, 'Location__c');
        
        //function 11
        KAI_Search_Products_Engine.getDrawingFileID('01t0z0000074VvQAAU');
    
        //function 12
        KAI_Search_Products_Engine.historicalBladePrices('Abrasitek','75','2', quoteID);
        
        //function 13
        KAI_Search_Products_Engine.historicalBladePricesCountry('Abrasitek','75','2', quoteID);
        

        //function 14
        //KAI_Search_Products_Engine.PDFprint();
        
    }
    
    
    /*
    private static testMethod void testAutoRun() {

   		PageReference pageRef = Page.yourPageName;
   		Test.setCurrentPage(pageRef);
   		pageRef.getParameters().put('pid','01t0z0000074VvQAAU');
   		ApexPages.StandardController sc = new ApexPages.standardController(testOppty);
   		Myclass  controller = new Myclass(sc);
   		System.assertNotEquals(null,controller.autoRun());

	}
	*/

}