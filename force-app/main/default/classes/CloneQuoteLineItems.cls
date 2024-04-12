global class CloneQuoteLineItems
{

    public void updateMe(String qliID, String quoteID)
    {
    
    String NewQuoteCurrency = '';
    String NewQuotePB = '';
    String strProductID = '';
    //string selectedprod2ids = '@';
    String OldQuoteCurrency = '';
        
    List<Quote> OldQuoteInfo = [select currencyisocode, pricebook2id from quote where id=:quoteID limit 1];
    
    for (Quote q : OldQuoteInfo){
        NewQuoteCurrency = q.CurrencyIsoCode;
        NewQuotePB = q.Pricebook2Id;
    }
  
    List<QuoteLineItem> QuoteLinesToGet = [Select Id, QuoteId, Quote.Quote_Date__c, Quantity, UnitPrice, Discount, Description, Product2Id, Quote.Pricebook2Id,
        Quote.CurrencyIsoCode, Customer_Item_Number__c, ICP_Price__c, Line_No__c, Our_Item_Number__c, Specifications__c, Assembly__c, Comments__c, Quote_Division__c,
        Lead_Time__c, Include_If_Quote_is_Won__c, Nature_of_Transaction__c, No_Approval_Required__c, Print_Part_Specifications__c, Service_Code__c, Internal_Remarks__c
        FROM QuoteLineItem where Id = :qliID And PriceBookEntry.IsActive = True Order By Line_No__c];

    for (QuoteLineItem ql : QuoteLinesToGet) {
        strProductID = ql.Product2Id;  
        OldQuoteCurrency = ql.Quote.CurrencyIsoCode;
    }

    if(strProductID == '')
        return;
        
    system.debug(OldQuoteCurrency);
    //selectedprod2ids = selectedprod2ids.Replace('@,','');
    //system.debug(selectedprod2ids);

    //String sPbeSoql = 'select id, product2id from pricebookentry where pricebook2id=\'' + NewQuotePB + '\' and currencyisocode = \'' + NewQuoteCurrency + '\' and product2id in (' + selectedprod2ids + ')';
    String sPbeSoql = 'select id, product2id from pricebookentry where pricebook2id = \'' + NewQuotePB + '\' and currencyisocode = \'' + NewQuoteCurrency + '\' and product2id = \'' + strProductID + '\' LIMIT 1';
    system.debug(sPbeSoql);

    List<PriceBookEntry> NewPbeIds = Database.query(sPbeSoql);
    system.debug(NewPbeIds);

    Map<String, String> PbeIdMap = New Map<String, String>();
        
    for (PriceBookentry pb : NewPbeIds){
            PbeIdMap.put(string.valueof(pb.get('Product2Id')),string.valueof(pb.get('Id')));
    }

    List<QuoteLineItem> lstQLIforInsert = new List<QuoteLineItem>();
        
    for(QuoteLineItem objOI : QuoteLinesToGet)
        {
            if(NewQuoteCurrency != OldQuoteCurrency)
            {
                objOI.UnitPrice = 0;
            }
            
            QuoteLineItem objQLI = new QuoteLineItem(QuoteId=quoteID, ServiceDate=objOI.Quote.Quote_Date__c, Description=objOI.Description, Product2Id=objOI.Product2Id,
                Quantity=objOI.Quantity, UnitPrice=objOI.UnitPrice, Customer_Item_Number__c=objOI.Customer_Item_Number__c, ICP_Price__c=objOI.ICP_Price__c,
                Line_No__c=objOI.Line_No__c, Our_Item_Number__c=objOI.Our_Item_Number__c, Specifications__c=objOI.Specifications__c, Assembly__c=objOI.Assembly__c,
                Comments__c=objOI.Comments__c, Quote_Division__c=objOI.Quote_Division__c, Lead_Time__c=objOI.Lead_Time__c, PriceBookEntryId=PbeIdMap.get(String.valueof(objOI.Product2Id)),
                Discount=objOI.Discount, Include_If_Quote_is_Won__c=objOI.Include_If_Quote_is_Won__c, Nature_of_Transaction__c=objOI.Nature_of_Transaction__c,
                No_Approval_Required__c=objOI.No_Approval_Required__c, Print_Part_Specifications__c=objOI.Print_Part_Specifications__c, Service_Code__c=objOI.Service_Code__c, 
                Internal_Remarks__c=objOI.Internal_Remarks__c);
          
            lstQLIforInsert.Add(objQLI);
        }
            
        if(!lstQLIforInsert.isEmpty())
            insert lstQLIforInsert;
        
      }

}