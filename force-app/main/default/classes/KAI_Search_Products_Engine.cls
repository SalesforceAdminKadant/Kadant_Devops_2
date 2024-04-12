/* 
 * Author: Marcel Oudmaijer
 * Date: 01/01/2018
 * Date: 18-OCT-2023 Open Heart Surgery by Scott Moran!!!
 * 
 * Description: This class contains functions for the lightning components: "Quote add line" and general "Part search" .
 */

 public class KAI_Search_Products_Engine {

    @AuraEnabled
    public static List<List<String>> GetCustomerPricing(String strRecordID, String strObjectName, Map<String,String> SelectedPartMap){
        List<List<String>> CustomerPricingList = new List<List<String>>();
        String sSectionHasData = '0';

        String selectedParts = '@';
        for (String prod2ID:SelectedPartMap.keySet()) {            
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        selectedParts = selectedParts.Replace('@,','');
        
        //system.debug('SELECTED PARTS ---->' + selectedParts );
        
        String sSQL = 'SELECT accountId, account.ParentTextID__c, CurrencyIsoCode, account.Name, account.ParentTextName__c FROM ' 
                + strObjectName + ' WHERE Id =\'' + strRecordID +'\' LIMIT 1';
        List<sObject>  q = Database.query(sSQL);
        //system.debug(q);

        String sCustomerID = String.valueOf(q[0].get('accountId'));
        String sParentID = String.valueOf( q[0].getSobject('Account').get('ParentTextID__c') );
     
        String selectedAccountId = '\'' + sCustomerID + '\'';
        String selectedParentId = '';
        if(sParentID !='NA'){ selectedParentId = ',\'' + sParentID + '\''; }
        String selectedAccounts = selectedAccountId + selectedParentId;
           
        sSQL = 'select product__c, customer_item__c, price__c, price_agreement_header__r.Account__c  FROM Price_Agreement_detail__c WHERE ' 
                + ' CurrencyIsoCode=\'' + q[0].Get('CurrencyIsoCode') + '\'' 
                + ' AND Product__c in(' + selectedParts + ')' 
                + ' AND price_agreement_header__r.Account__c in(' + selectedAccounts + ') AND Status__c = \'Approved\''  
                + ' ORDER BY product__c';
        List<Price_Agreement_detail__c> pbe = Database.query(sSQL);
        
        for (Price_Agreement_detail__c sobj : pbe){            
            if(String.valueOf(sobj.price_agreement_header__r.Account__c) == sCustomerID){                      
                CustomerPricingList.add(new List<String>{
                    String.valueOf(sobj.get('product__c')),
                    'Account agreement: ',
                    String.valueOf(q[0].getSobject('Account').get('Name')),
                    String.valueOf(sobj.get('customer_item__c'))+' ',
                    'dummy',
                    String.valueOf(sobj.get('price__c')),
                    String.valueOf(q[0].get('CurrencyIsoCode'))
                });
                if(String.valueOf(sobj.get('price__c'))!=''){sSectionHasData = '1';}
            } else{
                CustomerPricingList.add(new List<String>{
                    String.valueOf(sobj.get('product__c')),
                    'Parent agreement: ',
                    String.valueOf(q[0].getSobject('Account').get('ParentTextName__c'))+' ',
                    String.valueOf(sobj.get('customer_item__c'))+' ',
                    'dummy',
                    String.valueOf(sobj.get('price__c')),
                    String.valueOf(q[0].get('CurrencyIsoCode'))
                });
                if(String.valueOf(sobj.get('price__c'))!=''){sSectionHasData = '1';}
            }
        }
        
        for (String prod2ID:SelectedPartMap.keySet()) {            
            String prod2IDsource = prod2ID;
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            
            QuoteLineItem[] ql = [SELECT Quote.Quote_number__c, Quote.Quote_Date__c, Quantity, UnitPrice, currencyisocode, internal_remarks__c, id FROM quotelineitem WHERE Quote.Opportunity.AccountId=:sCustomerID AND Product2Id=:prod2ID ORDER BY Quote.Quote_Date__c DESC LIMIT 5];
            for (QuoteLineItem sobj:ql) {
                CustomerPricingList.add(new List<String>{
                    String.valueOf(prod2IDsource),
                    'Quote history: ',
                    String.valueOf(sobj.Quote.Quote_number__c)+' ',
                    String.valueOf(sobj.Quote.Quote_Date__c),
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('currencyisocode')),
                    String.valueOf(sobj.get('internal_remarks__c')+ ' ').replace('null',''),
                    String.valueOf(sobj.get('id'))
                });
                if(String.valueOf(sobj.get('UnitPrice'))!=''){sSectionHasData = '1';}
            }
            
            OrderItem[] ol = [SELECT Order.Name, Order.effectivedate, Quantity, UnitPrice, currencyisocode FROM orderitem WHERE order.AccountId=:sCustomerID AND Product2Id=:prod2ID and order.Sale_Type__c in('D','ICO') ORDER BY order.effectivedate DESC LIMIT 5];
            for (OrderItem sobj:ol) {
                CustomerPricingList.add(new List<String>{
                    String.valueOf(prod2IDsource),
                    'Order history: ',
                    String.valueOf(sobj.Order.Name)+' ',
                    String.valueOf(sobj.Order.effectivedate),
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('currencyisocode'))
                });
                if(String.valueOf(sobj.get('UnitPrice'))!=''){sSectionHasData = '1';}
            }
        
            CustomerPricingList.add(new List<String>{
                String.valueOf(prod2IDsource),
                'Has content: ',
                'dummy',
                'dummy',
                'dummy',
                sSectionHasData,
                'dummy'
            });            
            sSectionHasData = '0';
        }                
        Return CustomerPricingList;
    }
    
    @AuraEnabled
    public static List<List<String>> GetProductPricing(String strRecordID, String strObjectName, Map<String,String> SelectedPartMap, Map<String,String> SelectedPartMapQty){
        //map of selected parts sorted by product ID
        Map<String,List<String>> DocLinesListMap = new Map<String,List<String>>();
        
        //maps containing divisional selling price by product ID 
        Map<String,String> DivisionPriceMap = new Map<String,String>();
        Map<String,String> DivisionPriceListMap = new Map<String,String>();
        Map<String,String> ParentDivisionPriceMap = new Map<String,String>();
        Map<String,String> ParentDivisionPriceListMap = new Map<String,String>(); 
        
        //map of selected parts sorted by order of selection
        List<List<String>> DocLinesList = new List<List<String>>();
        
        //---- get quote details
        String sSQL = 'SELECT Division__c, Pricebook2ID, CurrencyIsoCode, Account_Standard_Discount__c, accountid, Account_Number__c FROM ' + strObjectName + ' WHERE Id =\'' + strRecordID +'\' LIMIT 1';
        sObject[] MainRec = Database.query(sSQL); 
         
        //---- get account division record
        String strAccount = String.valueOf(MainRec[0].get('accountid'));
        String sAccountDiv = String.valueOf(MainRec[0].get('Division__c'));
        String sAccountNumber = String.valueOf(MainRec[0].get('Account_Number__c'));
        
        if(String.IsBlank(sAccountNumber))
            sSQL = 'SELECT Standard_Discount__c FROM Account_Division__c where name =\'' + sAccountDiv +'\' and account__c=\'' + strAccount +'\'  LIMIT 1';
        else
            sSQL = 'SELECT Standard_Discount__c FROM Account_Division__c where name =\'' + sAccountDiv +'\' and account__c=\'' + strAccount +'\' and Account_Number__c=\'' + sAccountNumber +'\'  LIMIT 1';
        sObject[] DivRec = Database.query(sSQL);         
        
        String DefaultDiscount = '0';
        if(!DivRec.isEmpty()){
          if(DivRec[0].get('Standard_Discount__c')!=null){
              DefaultDiscount = String.valueOf(DivRec[0].get('Standard_Discount__c')).replace('null','0');
          }
        }
                
        String selectedParts = '@';
        for (String prod2ID:SelectedPartMap.keySet()) {
            //remove -dup1, -dup2 etc. from the product2 ID. Max 50 duplicate parts
            for (Integer i = 0; i < 50; i++) {
                prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        selectedParts = selectedParts.Replace('@,',''); 
        
        //############## Get price from divisional price list 
                
        sSQL = 'SELECT Division_Price_List__r.name, Product__c, Product__r.name, Price__c, CurrencyIsoCode '+
              ' FROM Division_Price_List_Item__c where product__c in(' + selectedParts + ')'+
              ' AND currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\' and IsDeleted=false ' +
              ' and Division_Price_List__r.active__c=true and Division_Price_List__c in ' +
              ' (select Division_Price_List__c from account_division_price_list__c where account_division__r.account__c=\'' + MainRec[0].get('accountid') + '\')';
        List<Division_Price_List_Item__c> ppli = Database.query(sSQL);

        for (Division_Price_List_Item__c sobj2 : ppli){
            DivisionPriceMap.put(String.valueOf(sobj2.get('Product__c')), String.valueOf(sobj2.get('Price__c')) );
            DivisionPriceListMap.put(String.valueOf(sobj2.get('Product__c')), String.valueOf(sobj2.getSobject('Division_Price_List__r').get('name')) );
        }
        
        //############## Get price from parent divisional price list 

        String strParentAccount = '';
        List<Account> lParent = [SELECT ParentId from account where id = :strAccount];
        for (Account sobj4 : lParent){
            if(sobj4.get('ParentId')!=null){
                strParentAccount = String.valueOf(sobj4.get('ParentId'));
            }
        }
        
        if(strParentAccount != ''){
            sSQL = 'SELECT Division_Price_List__r.name, Product__c, Product__r.name, Price__c, CurrencyIsoCode '+
                    ' FROM Division_Price_List_Item__c where product__c in(' + selectedParts + ')'+
                    ' AND currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\' and IsDeleted=false ' +
                    ' and Division_Price_List__r.active__c=true and Division_Price_List__c in ' +
                    ' (select Division_Price_List__c from account_division_price_list__c where account_division__r.account__c=\'' + strParentAccount + '\')';
            List<Division_Price_List_Item__c> ppli2 = Database.query(sSQL);

            for (Division_Price_List_Item__c sobj3 : ppli2){
                ParentDivisionPriceMap.put(String.valueOf(sobj3.get('Product__c')), String.valueOf(sobj3.get('Price__c')) );
                ParentDivisionPriceListMap.put(String.valueOf(sobj3.get('Product__c')), String.valueOf(sobj3.getSobject('Division_Price_List__r').get('name')) );
            }
        }        
        
        //############ Get prices from standard price list         
        sSQL = 'SELECT Product2Id, Product2.Name, Product2.Description, unitprice, icp_price__c, Product2.No_Approval_Required__c, Product2.PSG_E_Dummy__c, Product2.Price_Reference_Document_ID__c, Product2.Product_Line__c, Product2.Strategic_Designation__c FROM PricebookEntry WHERE isactive=true  AND Product2Id in(' +
                selectedParts + ')'+
                ' AND currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\'' +
                ' AND Pricebook2ID=\''+ MainRec[0].get('Pricebook2ID') + '\'' +
                ' ORDER BY Product2.name';
        List<PricebookEntry> pbe = Database.query(sSQL);
      
        String ApplyDiscount = '0';
        String UnitPrice = '0';
        String IcpPrice = '0';
        String DivPriceList = 'None';
        for (PricebookEntry sobj : pbe){            
            if(sobj.Product2.No_Approval_Required__c==True){ ApplyDiscount='0'; } else { ApplyDiscount = DefaultDiscount;}

            if( sAccountDiv=='KJ' ) {
              if(sobj.Product2.Strategic_Designation__c=='L'){ ApplyDiscount='0'; }
            }
            
            if(DivisionPriceMap.containsKey( String.valueOf(sobj.get('Product2Id')) )) {
                UnitPrice = String.valueOf(DivisionPriceMap.get( String.valueOf(sobj.get('Product2Id')) ));
                DivPriceList = String.valueOf(DivisionPriceListMap.get( String.valueOf(sobj.get('Product2Id')) ));
            } else{
                if(ParentDivisionPriceMap.containsKey( String.valueOf(sobj.get('Product2Id')) )) {
                  UnitPrice = String.valueOf(ParentDivisionPriceMap.get( String.valueOf(sobj.get('Product2Id')) ));
                  DivPriceList = String.valueOf(ParentDivisionPriceListMap.get( String.valueOf(sobj.get('Product2Id')) ));
                }
                else {
                    UnitPrice = String.valueOf(sobj.get('unitprice'));
                    IcpPrice = String.valueOf(sobj.get('icp_price__c'));
                    DivPriceList = 'None';
                    //system.debug(IcpPrice);
                }
            }
 
            DocLinesListMap.put(String.valueOf(sobj.get('Product2Id')),new List<String>{
                String.valueOf(sobj.get('Product2Id')),
                String.valueOf(sobj.Product2.Name)+' ',
                String.valueOf(sobj.Product2.Description)+' ',
                UnitPrice,
                String.valueOf(MainRec[0].get('CurrencyIsoCode')),                
                String.valueOf(SelectedPartMapQty.get(String.valueOf(sobj.get('Product2Id')))),
                ApplyDiscount,
                DivPriceList,
                String.valueOf(sobj.Product2.PSG_E_Dummy__c),
                String.valueOf(sobj.Product2.Price_Reference_Document_ID__c),
                IcpPrice,
                String.valueOf(sobj.Product2.Product_Line__c)    
            });        
        }
        
        //system.debug('DOCLINELISTMAP-->'+DocLinesListMap);
        
        //re-sort DocLinesListMap in order of selection
        for (String prod2ID:SelectedPartMap.keySet()) {            
            String prod2IDsource = prod2ID;
            //system.debug('prod2IDsource-->'+prod2IDsource);
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            //DocLinesList.add(DocLinesListMap.get(String.valueOf(prod2IDclean)));
            
            //system.debug('prod2ID-->'+prod2ID);
            //system.debug('Map entry-->'+DocLinesListMap.get(String.valueOf(prod2ID)));
                    
            DocLinesList.add(new List<String>{
                String.valueOf(prod2IDsource),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[1]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[2]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[3]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[4]),               
                String.valueOf(SelectedPartMapQty.get(String.valueOf(prod2IDsource))),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[6]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[7]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[8]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[10]),
                String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[11])    
            });            
        }        
        //system.debug('DOCLINELIST-->'+DocLinesList);        
        Return DocLinesList;
    }    

 @AuraEnabled
    public static boolean AddQuoteLines(String strQuoteRecordID, String strQuotePB, String strQuoteCurr, String strQuoteRecType, Map<String,String> SelectedPartMap, String lineQTY, String lineUP, String lineDC, String lineSPEC, String lineLT, String lineNDO, String lineSCO)
    {   
        Decimal nLine_no = 0;
        Decimal nQuantity = 1;
        Decimal nUnitPrice = 0;
        String tmpKey ='';
        String tmpVal ='';
        List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();
        //system.debug(lineQTY);
        //system.debug(lineNDO); 
        //system.debug(lineSCO);
            
        //######### line quantities
        Map<string, Decimal> lineQTYlist = new Map<string, Decimal>();
        List<Object> lineQTYobjects = (List<Object>)System.JSON.deserializeUntyped(lineQTY);
        for (Object lineQTYobject : lineQTYobjects) {
            //system.debug(String.valueof(lineQTYobject));
            lineQTYlist.put(String.valueof(lineQTYobject).split(',')[0].replace('key=qty','').replace('{',''), Decimal.valueOf(String.valueof(lineQTYobject).split(',')[1].replace(' value=','').replace('}','')));
        }        
        
        //######### line prices
        Map<string, Decimal> lineUPlist = new Map<string, Decimal>();
        List<Object> lineUPobjects = (List<Object>)System.JSON.deserializeUntyped(lineUP);
        for (Object lineUPobject : lineUPobjects) {
            //system.debug(String.valueof(lineUPobject));
            lineUPlist.put(String.valueof(lineUPobject).split(',')[0].replace('key=up','').replace('{',''), Decimal.valueOf(String.valueof(lineUPobject).split(',')[1].replace(' value=','').replace('}','')));
        }      
        
        //######### line disc
        Map<string, Decimal> lineDClist = new Map<string, Decimal>();
        List<Object> lineDCobjects = (List<Object>)System.JSON.deserializeUntyped(lineDC);
        for (Object lineDCobject : lineDCobjects) {
            //system.debug(String.valueof(lineDCobject));
            lineDClist.put(String.valueof(lineDCobject).split(',')[0].replace('key=disc','').replace('{',''), Decimal.valueOf(String.valueof(lineDCobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        //######### line leadtimes
        Map<string, Decimal> lineLTlist = new Map<string, Decimal>();
        List<Object> lineLTobjects = (List<Object>)System.JSON.deserializeUntyped(lineLT);
        for (Object lineLTobject : lineLTobjects) {
            //system.debug(String.valueof(lineLTobject));
            lineLTlist.put(String.valueof(lineLTobject).split(',')[0].replace('key=lt','').replace('{',''), Decimal.valueOf(String.valueof(lineLTobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        //######### line Natureza de Operacao (KSA)
        Map<string, String> lineNDOlist = new Map<string, String>();
        List<Object> lineNDOobjects = (List<Object>)System.JSON.deserializeUntyped(lineNDO);
        for (Object lineNDOobject : lineNDOobjects) {
            //system.debug(String.valueof(lineNDOobject));
            lineNDOlist.put(String.valueof(lineNDOobject).split(',')[0].replace('key=ndo','').replace('{',''), String.valueOf(String.valueof(lineNDOobject).split(',')[1].replace(' value=','').replace('}','')));
        } 
        system.debug(lineNDOlist);
        //######### line Service Code (KSA)
        Map<string, String> lineSCOlist = new Map<string, String>();
        List<Object> lineSCOobjects = (List<Object>)System.JSON.deserializeUntyped(lineSCO);
        for (Object lineSCOobject : lineSCOobjects) {
            //system.debug(String.valueof(lineSCOobject));
            lineSCOlist.put(String.valueof(lineSCOobject).split(',')[0].replace('key=sco','').replace('{',''), String.valueOf(String.valueof(lineSCOobject).split(',')[1].replace(' value=','').replace('}','')));
        }   
        //######### get quote line specs
        String Specs='';
        String lineSpecs='';
        Map<String, Object> lineSPECobject = (Map<String, Object>) JSON.deserializeUntyped(lineSPEC.replace('[','').replace(']',''));
        
        String prodid = String.valueof(lineSPECobject.get('prodid'));
        //system.debug(prodid);
        
        Specs = 'Material: ' + String.valueof(lineSPECobject.get('material')) +'\n';
        Specs = Specs + 'Width: ' + String.valueof(lineSPECobject.get('width')) +' MM \n';
        Specs = Specs + 'Length: ' + String.valueof(lineSPECobject.get('length')) +' MM\n';
        Specs = Specs + 'Thickness: ' + String.valueof(lineSPECobject.get('thickness')) +' MM\n';
        Specs = Specs + 'Bevel angle: ' + String.valueof(lineSPECobject.get('bevel'));
        Specs = Specs + 'Finishing: ' + String.valueof(lineSPECobject.get('fin'));
        
        //system.debug(Specs);
        
        //######### get quote header and line details
        QuoteLineItem[] ql = [ SELECT Line_No__c FROM QuoteLineItem WHERE QuoteId=:strQuoteRecordID AND Line_No__c > 0 ORDER BY Line_No__c DESC LIMIT 1 ];
        if(!ql.isEmpty()){ 
            nLine_no = ql[0].Line_No__c;
        }
        
        //######### insert quote lines        
        for (String prod2ID:SelectedPartMap.keySet()) {            
            String prod2IDsource = prod2ID;
            //system.debug('prod2IDsource-->'+prod2IDsource);
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }

            lineSpecs='';
            if(String.valueof(prod2IDsource)==prodid){lineSpecs=Specs;} 
            //system.debug(String.valueof(prod2ID));
           
            nLine_no = nLine_no+1;
            PricebookEntry[] pb = [ SELECT Id FROM PricebookEntry WHERE Pricebook2Id=:strQuotePB AND Product2Id=:prod2ID AND CurrencyIsoCode=:strQuoteCurr LIMIT 1];
            //system.debug(lineSCOlist.get(prod2IDsource));
            if(!pb.isEmpty()){
                if(strQuoteRecType == 'KSA Quotes'){
                    if(lineSCOlist.get(prod2IDsource)!='None'){
                      lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2IDsource),
                            UnitPrice = lineUPlist.get(prod2IDsource), 
                            Discount = lineDClist.get(prod2IDsource),
                            Lead_Time__c = lineLTlist.get(prod2IDsource),
                            Nature_of_Transaction__c = lineNDOlist.get(prod2IDsource),                 
                            Service_Code__c = lineSCOlist.get(prod2IDsource),                  
                            Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );
                   }
                    else{
                      lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2IDsource),
                            UnitPrice = lineUPlist.get(prod2IDsource), 
                            Discount = lineDClist.get(prod2IDsource),
                            Lead_Time__c = lineLTlist.get(prod2IDsource),
                            Nature_of_Transaction__c = lineNDOlist.get(prod2IDsource),                 
                            Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );  
                    }
                }
                else{
                lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2IDsource),
                            UnitPrice = lineUPlist.get(prod2IDsource), 
                            Discount = lineDClist.get(prod2IDsource),
                            Lead_Time__c = lineLTlist.get(prod2IDsource),
                            Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );   
                }
            }
        }        
        if(!lstQLI.isEmpty()){
            insert lstQLI;
        }
        return true;
    }    
    
    @AuraEnabled
    public static boolean AddOpportunityLines(String strQuoteRecordID, Map<String,String> SelectedPartMap, String lineQTY, String lineUP, String lineDC){   
        Decimal nLine_no = 0;
        Decimal nQuantity = 1;
        Decimal nUnitPrice = 0;
        String tmpKey ='';
        String tmpVal ='';
        List<OpportunityLineItem> lstQLI = new List<OpportunityLineItem>();

        //######### line quantities
        Map<string, Decimal> lineQTYlist = new Map<string, Decimal>();
        List<Object> lineQTYobjects = (List<Object>)System.JSON.deserializeUntyped(lineQTY);
        for (Object lineQTYobject : lineQTYobjects) {
            //system.debug(String.valueof(lineQTYobject));
            lineQTYlist.put(String.valueof(lineQTYobject).split(',')[0].replace('key=qty','').replace('{',''), Decimal.valueOf(String.valueof(lineQTYobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        
        //######### line prices
        Map<string, Decimal> lineUPlist = new Map<string, Decimal>();
        List<Object> lineUPobjects = (List<Object>)System.JSON.deserializeUntyped(lineUP);
        for (Object lineUPobject : lineUPobjects) {
            //system.debug(String.valueof(lineUPobject));
            lineUPlist.put(String.valueof(lineUPobject).split(',')[0].replace('key=up','').replace('{',''), Decimal.valueOf(String.valueof(lineUPobject).split(',')[1].replace(' value=','').replace('}','')));
        }
      
        
        //######### line disc
        Map<string, Decimal> lineDClist = new Map<string, Decimal>();
        List<Object> lineDCobjects = (List<Object>)System.JSON.deserializeUntyped(lineDC);
        for (Object lineDCobject : lineDCobjects) {
            //system.debug(String.valueof(lineDCobject));
            lineDClist.put(String.valueof(lineDCobject).split(',')[0].replace('key=disc','').replace('{',''), Decimal.valueOf(String.valueof(lineDCobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        //######### get quote header and line details
        Opportunity[] q = [ SELECT Pricebook2ID, CurrencyIsoCode FROM Opportunity WHERE Id=:strQuoteRecordID LIMIT 1];
        OpportunityLineItem[] ql = [ SELECT Line_No__c FROM OpportunityLineItem WHERE OpportunityId=:strQuoteRecordID AND Line_No__c > 0 ORDER BY Line_No__c DESC LIMIT 1 ];
        if(!ql.isEmpty()){ 
            nLine_no = ql[0].Line_No__c;
        }
        
        //######### insert quote lines
        for (id prod2ID:SelectedPartMap.keySet()) {
            nLine_no = nLine_no+1;
            PricebookEntry[] pb = [ SELECT Id FROM PricebookEntry WHERE Pricebook2Id=:q[0].Pricebook2ID AND Product2Id=:prod2ID AND CurrencyIsoCode=:q[0].CurrencyIsoCode LIMIT 1];

            if(!pb.isEmpty()){
                lstQLI.add(new OpportunityLineItem(OpportunityId=strQuoteRecordID, 
                    Line_No__c = nLine_no,                       
                    PriceBookEntryID = pb[0].Id,
                    Quantity = lineQTYlist.get(prod2ID),
                    UnitPrice = lineUPlist.get(prod2ID), 
                    Discount = lineDClist.get(prod2ID),                                                    
                    Product2Id = prod2ID)
                    );
            }
        }
        
        if(!lstQLI.isEmpty()){
            insert lstQLI;
        }
        return true;
    }    

    @AuraEnabled
    public static List<List<String>> showBomParts(String PartID, Map<String,String> SelectedPartMap){        
        String searchQuery = '';
        String strPartSelected = null;
    
        List<List<String>> searchResultsString = new List<List<String>>();     
        List<Bill_of_Material__c> searchResults3 = new List<Bill_of_Material__c>(); 
    
        searchQuery = 'SELECT Child_Product__c, Sequence__c, Qty_Per__c, Child_Part_ID__c, Child_Part_Description__c, Drw_Ref_No__c '+
                ' FROM Bill_of_Material__c WHERE parent_product__c=\'' + PartID + '\' ORDER BY Sequence__c';

        searchResults3 = Database.query(searchQuery);
        
        for (Bill_of_Material__c sobj : searchResults3){                    
            
                if(SelectedPartMap.containsKey( String.valueOf(sobj.get('Child_Product__c')) )) {strPartSelected = 'PartSelected';} else {strPartSelected = null;}
                                
                searchResultsString.add(new List<String>{
                        String.valueOf(sobj.get('Child_Product__c')),
                        String.valueOf(sobj.get('Sequence__c'))+' ',
                        String.valueOf(sobj.get('Qty_Per__c'))+' ',
                        String.valueOf(sobj.get('Child_Part_ID__c'))+' ',
                        String.valueOf(sobj.get('Child_Part_Description__c'))+' ',
                        String.valueOf(sobj.get('Drw_Ref_No__c'))+' ',
                        strPartSelected
                });
        }
        return searchResultsString;
    }    
   
    @AuraEnabled
    public static String getDrawingFileID(String PartID){
        String sDrawingID = '';
        String sDrawingFileID = '';  
        List<ContentDocumentLink> dwgfile = new List<ContentDocumentLink>(); 
        
        //product2[] dwg = [SELECT id, drawing__r.id, drawing__r.name, drawing__r.status__c, drawing__r.title__c, drawing__r.type__c, drawing__r.drawing_type__c, drawing__r.current_rev_lvl__c  FROM product2 where id=:PartID];
        product2[] dwg = [SELECT drawing__r.id FROM product2 where id=:PartID];
        
        if(!dwg.isEmpty()){
            for (product2 sobj:dwg) {
                sDrawingID = String.valueOf(sobj.drawing__r.id);

                if(sDrawingID !=''){
                    if(sDrawingID !='null'){
                        String sSOQL = 'SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId=\'' + sDrawingID + '\' LIMIT 1';
                        dwgfile = Database.query(sSOQL);
                
                        for (ContentDocumentLink sobj2:dwgfile) {
                            sDrawingFileID = String.valueOf(sobj2.ContentDocument.LatestPublishedVersionId);
                        }
                    }
                }
                
            }
        }        
        Return sDrawingFileID;
    }    
    
    //public List<List<String>> PDFassyDetails { get; set; }
    public List<List<String>> PDFbomList { get; set; }
    public static String PDFdrawing { get; set; }
    public pageReference PDFprint()
    {
        Map<String,String> SelectedPartMap = New Map<String,String>{'e'=>'f', 'g'=> 'h'};            
        String PartID = ApexPages.CurrentPage().getparameters().get('pid');
        PDFbomList = showBomParts(PartID, SelectedPartMap); 
        PDFdrawing = getDrawingFileID(PartID); 
        return null;
    }        
  
    @AuraEnabled
    public static List<List<String>> historicalBladePrices(String Material, String Width, String Thickness, String QuoteID){        
        String sPricePerMeter = '0';        
        List<List<String>> bladeOrders = new List<List<String>>();     
        List<OrderItem> orderLines = new List<OrderItem>();         
        Integer nCounter=1;
        Map<String,String> UniquePartMap = new Map<String,String>();
        
        String sSOQL = 'SELECT id, product2.name, product2.BLD_Length__c, order.effectivedate, order.name, order.currencyisocode, quantity, unitprice, order.account.name, line_no__c, order.ShippingCountry, order.account_country__c, product2.id '+
                    ' FROM OrderItem WHERE ' +
                    ' product2.BLD_Material__c=\'' + Material + '\'' + 
                    ' and product2.BLD_Thickness__c=\'' + Thickness + '\'' + 
                    ' and product2.BLD_Width__c=\'' + Width + '\'' + 
                    ' and order.Sale_Type__c in(\'D\')' + 
                    ' and product2.BLD_Length__c<>\'100000\'' +
                    ' ORDER BY order.effectivedate desc LIMIT 150';
        orderLines = Database.query(sSOQL);
        
        for (OrderItem sobj : orderLines){                    
                                            
            if(Double.valueOf(sobj.getSobject('product2').get('BLD_Length__c'))>0){
                sPricePerMeter = String.valueOf( ( Double.valueOf(sobj.get('unitprice')) / Double.valueOf(sobj.getSobject('product2').get('BLD_Length__c')) ) * 1000);
            }
            
            if( !UniquePartMap.containsKey( String.valueOf(sobj.getSobject('product2').get('id')) ) ){
                if(nCounter<11){
                bladeOrders.add(new List<String>{
                        String.valueOf(sobj.get('id')),
                        String.valueOf(sobj.getSobject('product2').get('name')),
                        String.valueOf(sobj.getSobject('product2').get('BLD_Length__c'))+' ',
                        String.valueOf(sobj.getSobject('order').get('effectivedate')),
                        String.valueOf(sobj.getSobject('order').get('name')),
                        String.valueOf(sobj.getSobject('order').get('currencyisocode')),
                        String.valueOf(sobj.get('quantity')),
                        String.valueOf(sobj.get('unitprice')),
                        String.valueOf(sobj.getSobject('order').getSobject('account').get('name')),
                        sPricePerMeter,
                        String.valueOf(sobj.get('line_no__c')),
                        String.valueOf(sobj.getSobject('order').get('ShippingCountry')),
                        String.valueOf(sobj.getSobject('order').get('account_country__c'))                                
                    });
                    nCounter = nCounter+1;
                }
            }            
            UniquePartMap.put(String.valueOf(sobj.getSobject('product2').get('id')), String.valueOf(sobj.getSobject('product2').get('id')) );
        }
        return bladeOrders;
    } 
    
    @AuraEnabled
    public static List<List<String>> historicalBladePricesCountry(String Material, String Width, String Thickness, String QuoteID){        
        String sPricePerMeter = '0';
        String sCountry ='';
        String sSOQL='';
        Integer nCounter=1;
        Map<String,String> UniquePartMap = new Map<String,String>();
        
        if(QuoteID!=''){
            sSOQL = 'SELECT account.country_id__c FROM quote WHERE Id =\'' + QuoteID +'\' LIMIT 1';
            sObject[] quoterecord = Database.query(sSOQL); 
    
            if(quoterecord[0].getSobject('account').get('country_id__c')!=null){
                sCountry = String.valueOf(quoterecord[0].getSobject('account').get('country_id__c')).replace('null','0');
            }
        }
     
        List<List<String>> bladeOrders = new List<List<String>>();     
        List<OrderItem> orderLines = new List<OrderItem>(); 
    
        sSOQL = 'SELECT id, product2.name, product2.BLD_Length__c, order.effectivedate, order.name, order.currencyisocode, quantity, unitprice, order.account.name, line_no__c, order.ShippingCountry, order.account_country__c, product2.id '+
                    ' FROM OrderItem WHERE ' +
                    ' product2.BLD_Material__c=\'' + Material + '\'' + 
                    ' and product2.BLD_Thickness__c=\'' + Thickness + '\'' + 
                    ' and product2.BLD_Width__c=\'' + Width + '\'' + 
                    ' and order.Sale_Type__c in(\'D\')' + 
                    ' and order.account_country__c=\'' + sCountry + '\'' + 
                ' and product2.BLD_Length__c<>\'100000\'' +
                    ' ORDER BY order.effectivedate desc LIMIT 150';
        orderLines = Database.query(sSOQL);
        
        for (OrderItem sobj : orderLines){                    
                                            
            if(Double.valueOf(sobj.getSobject('product2').get('BLD_Length__c'))>0){
                sPricePerMeter = String.valueOf( ( Double.valueOf(sobj.get('unitprice')) / Double.valueOf(sobj.getSobject('product2').get('BLD_Length__c')) ) * 1000);
            }
            
            if( !UniquePartMap.containsKey( String.valueOf(sobj.getSobject('product2').get('id')) ) ){
                if(nCounter<11){
                bladeOrders.add(new List<String>{
                        String.valueOf(sobj.get('id')),
                        String.valueOf(sobj.getSobject('product2').get('name')),
                        String.valueOf(sobj.getSobject('product2').get('BLD_Length__c'))+' ',
                        String.valueOf(sobj.getSobject('order').get('effectivedate')),
                        String.valueOf(sobj.getSobject('order').get('name')),
                        String.valueOf(sobj.getSobject('order').get('currencyisocode')),
                        String.valueOf(sobj.get('quantity')),
                        String.valueOf(sobj.get('unitprice')),
                        String.valueOf(sobj.getSobject('order').getSobject('account').get('name')),
                        sPricePerMeter,
                        String.valueOf(sobj.get('line_no__c')),
                        String.valueOf(sobj.getSobject('order').get('ShippingCountry')),
                        String.valueOf(sobj.getSobject('order').get('account_country__c'))
                    });
                    nCounter = nCounter+1;
                }                    
            }            
            UniquePartMap.put(String.valueOf(sobj.getSobject('product2').get('id')), String.valueOf(sobj.getSobject('product2').get('id')) );
        }
        return bladeOrders;
    }
    
    @AuraEnabled
    public static List<List<String>> GetBladeDetails(String sRecordTypeId){        
        String searchQuery = '';
        String strPartSelected = null;
    
        List<List<String>> searchResultsString = new List<List<String>>();     
        List<Blade_Details__c> searchResults = new List<Blade_Details__c>();         
        
        searchQuery = 'SELECT Blade_Name__r.id, Blade_Name__r.name, id, width__c, thickness__c,'
                + ' ICP_Per_Unit__c, Price_Per_Unit__c, CurrencyIsoCode, unit_of_measure__c,' 
                + 'Blade_Name__r.Finishing_Surcharge_Full__c,  Blade_Name__r.Finishing_Surcharge_Plain__c,'
                + 'Blade_Name__r.Packaging_Surcharge__c, Blade_Name__r.Material_Group__c, Blade_Name__r.GBPtoEUR__c, Blade_Name__r.GBPtoSEK__c, Blade_Name__r.GBPtoUSD__c,bevel_angle__c'
                + ' FROM Blade_details__c '
                + ' WHERE Blade_Name__r.RecordTypeId=\'' + sRecordTypeId + '\' and Blade_Name__r.standard__c=True '
                + ' and Blade_Name__r.active__c=True and ICP_Per_Unit__c > 0 ORDER BY Blade_Name__r.name, width__c, thickness__c';
        
        searchResults = Database.query(searchQuery);
        
        for (Blade_Details__c sobj : searchResults){                                                  
            searchResultsString.add(new List<String>{
                String.valueOf(sobj.getSobject('Blade_Name__r').get('id')),
                String.valueOf(sobj.getSobject('Blade_Name__r').get('name')),
                String.valueOf(sobj.get('id')),
                String.valueOf(Double.valueOf(sobj.get('width__c'))),
                String.valueOf(Double.valueOf(sobj.get('thickness__c'))),
                String.valueOf(Double.valueOf(sobj.get('ICP_Per_Unit__c'))),
                String.valueOf(Double.valueOf(sobj.get('Price_Per_Unit__c'))),
                String.valueOf(sobj.get('CurrencyIsoCode')),
                String.valueOf(sobj.get('unit_of_measure__c')),
                String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('Finishing_Surcharge_Full__c'))).replace('null','0'),
                String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('Finishing_Surcharge_Plain__c'))).replace('null','0'), 
                String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('Packaging_Surcharge__c'))).replace('null','0'),
                String.valueOf(sobj.getSobject('Blade_Name__r').get('Material_Group__c')),
                String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('GBPtoEUR__c'))).replace('null','1'),
                String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('GBPtoSEK__c'))).replace('null','1'),
                String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('GBPtoUSD__c'))).replace('null','1'),
                String.valueOf(sobj.get('bevel_angle__c')).replace('null',' ')
            });
        }    
        //system.debug(searchResultsString);
        return searchResultsString;
    }    

    @AuraEnabled
    public static List<List<String>> searchForParts(String strRecordID, String strObjectName, String searchText, String searchFilter, Map<String,String> SelectedPartMap){   
       String searchQuery = '';
       String strPartSelected = null;
       String strSubPart = 'None';
       String strPreviouslyOrdered = 'N';
       String PreviousPart ='';
       String listPrice = '';
       List<Product2> searchResults = new List<Product2>();                   
       List<OrderItem> searchResults3 = new List<OrderItem>(); 
       List<List<String>> searchResultsString = new List<List<String>>();
       Map<String,String> PrevOrderedMap = new Map<String,String>();    
       
       String userDivision = GetDefaultProductDivision();
       //system.debug('User Division value: ' + userDivision);
       
       String sSQL = 'SELECT CurrencyIsoCode, AccountID, pricebook2id FROM ' + strObjectName + ' WHERE Id =\'' + strRecordID +'\'';
       sObject[] MainRec = Database.query(sSQL);
        
       String strJointFields = ' Joint_M_Size__c, Joint_M_Size_UOM__c,Joint_M_Type__c, Joint_M_Thread_Direction__c, ' +
                                ' Joint_N_Size__c, Joint_N_Size_UOM__c, Joint_O_Size__c, Joint_O_Size_UOM__c, ' +
                                ' Joint_P_Size__c, Joint_P_Size_UOM__c,Joint_P_Type__c, Joint_P_Thread_Direction__c, ' +
                                ' Joint_S_Size__c, Joint_S_Size_UOM__c,Joint_S_Type__c, Joint_S_Thread_Direction__c, ' +
                                ' Joint_Nipple_Size__c, Joint_Nipple_Size_UOM__c, Joint_Nipple_Type__c, Joint_Nipple_Thread_Direction__c, ' +
                                ' Joint_Seal_Material__c, ' +
                                ' Joint_Temperature__c, Joint_Temperature_UOM__c, ' +
                                ' Joint_Pressure__c, Joint_Pressure_UOM__c, ';
       
       String strBladeFields = ' BLD_Application__c, BLD_Bevel_Angle__c, BLD_CTL_Machine_Index__c, BLD_Holder_Type__c, ' +
                                ' BLD_KUK_Reference_Code__c, BLD_Length__c, BLD_Machine_No__c, BLD_Material__c, ' +
                                ' BLD_Thickness__c, BLD_Width__c, ';
        
       if(searchFilter.left(7) !='HISTORY'){
            //######### if the search bar is empty, default with database query ############
            if(searchText ==''){
                searchQuery = 'SELECT Id, Name, Description, ProductCode, Drawing_Number__c, Part_Of_Kit__c, Part_Of_Kit_Remarks__c, Unit_of_Measure__c, X80_20_Rank__c, On_Hold__c, List_Price__c, ' +
                    ' Substitute_Part__c, Specifications__c, '+
                    strJointFields +
                    strBladeFields +
                    ' IsActive FROM Product2 WHERE IsActive=true AND Product_Division__c = \'' + userDivision + '\'' + searchFilter +                
                    ' AND Id IN(SELECT Product2Id FROM PricebookEntry WHERE pricebook2id=\'' + MainRec[0].get('pricebook2id') + '\' and currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\')' +
                    ' ORDER BY name LIMIT 150';
                searchResults = Database.query(searchQuery);
            }

            //######### if the search bar is has a value, use the salesforce find function ############
            if(searchText !=''){
                searchQuery = 'FIND \'' + searchText + '\' IN ALL FIELDS RETURNING ' +
                    ' Product2(Id, Name, Description, ProductCode, Drawing_Number__c, Part_Of_Kit__c, Part_Of_Kit_Remarks__c, Unit_of_Measure__c, X80_20_Rank__c, On_Hold__c, List_Price__c, Substitute_Part__c, ' +
                    ' Specifications__c, ' +
                    strJointFields +
                    strBladeFields +
                    ' IsActive WHERE IsActive=true AND Product_Division__c = \'' + userDivision + '\'' + searchFilter +
                    ' AND Id IN(SELECT Product2Id FROM PricebookEntry WHERE pricebook2id=\'' + MainRec[0].get('pricebook2id') + '\' and currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\')' +
                    ' ORDER BY name LIMIT 150)';
                List<List<sObject>> searchResults2 = search.query(searchQuery);
               
                for (List<SObject> sobjs : searchResults2) {
                    for (SObject sobj : sobjs) { searchResults.add((Product2) sobj); }
                }
            }

            //######### collect selling history to highlight previously ordered parts #############            
            searchQuery = 'SELECT product2.Id FROM orderitem WHERE product2.IsActive=true ' +  
                    ' AND order.accountid=\'' + MainRec[0].get('AccountID') + '\' ' +
                    ' ORDER BY product2.Name, order.effectivedate DESC';
            // add include
            searchResults3 = Database.query(searchQuery);
            
            PreviousPart ='';
            for (OrderItem sobj3 : searchResults3){                                                                 
                if(PreviousPart != String.valueOf(sobj3.getSobject('Product2').get('Id')) ){
                        PrevOrderedMap.put(String.valueOf(sobj3.getSobject('Product2').get('Id')), String.valueOf(sobj3.getSobject('Product2').get('Id')));
                }                
                PreviousPart = String.valueOf(sobj3.getSobject('Product2').get('Id'));
            }

            //######### prepare array for return value ############
            for (Product2 sobj : searchResults){
                if(SelectedPartMap.containsKey(sobj.Id)) {strPartSelected = 'PartSelected';} else {strPartSelected = null;}
                if(PrevOrderedMap.containsKey(sobj.Id)) {strPreviouslyOrdered = 'Y';} else {strPreviouslyOrdered = 'N';}

                if (sobj.get('List_Price__c') == null) {
                    listPrice = '0.00';
                } else {
                    listPrice = String.valueOf(Decimal.valueOf(Double.valueOf(sobj.get('List_Price__c'))).setScale(2));
                }

                searchResultsString.add(new List<String>{
                    sobj.Id,
                    String.valueOf(sobj.get('Name')),
                    String.valueOf(sobj.get('Description')),
                    String.valueOf(sobj.get('ProductCode')+' ').replace('null',''),
                    String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null',''),
                    String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null',''),
                    String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null',''),
                    String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null',''),
                    String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' ').replace('null',''),
                    String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Material__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null',''),
                    String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_Nipple_Size__c')))+sobj.get('Joint_Nipple_Size_UOM__c')+' '+sobj.get('Joint_Nipple_Type__c')+' '+sobj.get('Joint_Nipple_Thread_Direction__c')).replace('null',''),
                    String.valueOf(sobj.get('Drawing_Number__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('Part_Of_Kit__c')+' ').replace('null',''), 
                    String.valueOf(sobj.get('Part_Of_Kit_Remarks__c')+' ').replace('null',''),   
                    String.valueOf(sobj.get('Unit_of_Measure__c')+' ').replace('null',''),
                    strPreviouslyOrdered,
                    listPrice,
                    String.valueOf(sobj.get('Substitute_Part__c')+' '),
                    String.valueOf(sobj.get('X80_20_Rank__c')+' ').replace('null',''),
                    String.valueOf(sobj.get('On_Hold__c')+' ').replace('null',''), 
                    String.valueOf(sobj.get('Specifications__c')+' ').replace('null',''),
                    String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_N_Size__c')))+sobj.get('Joint_N_Size_UOM__c')).replace('null',''),
                    String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_O_Size__c')))+sobj.get('Joint_O_Size_UOM__c')).replace('null',''),
                    strPartSelected
                });
                // Please note strPartSelected must be the last item in the string!!!
                // Add new fields before this and reference by the Index number in the Component!!
                //---the strPerviouslyOrdered,strPartSelected booleans are !item[21] and !item[22] in resultset of the component
            }
       } else {
            //######### collect customer selling history ###########
            //
            //
            String searchTextSQL = searchFilter.replace('HISTORY','');            
            String saleType = 'ICI';
            String acctId = String.valueOf(MainRec[0].get('AccountID'));
            String custNum = '';
            if (searchTextSQL.indexOf('Customer_Item_Number__c ') > 1)
            {
                custNum = searchFilter.replace('HISTORY AND Customer_Item_Number__c like \'','');      
                custNum = custNum.removeEnd('\'');   
                custNum = '%' + custNum + '%'; 
            }

            //system.debug('custNum Query: ' + custNum);

            if (String.isEmpty(searchText))
            {
                searchText = '%%';
            }
            else 
            {
                searchText = '%' + searchText + '%';
            }

            //system.debug('searchText Query: ' + searchText);
            //system.debug('acctId: ' + acctId);
            //system.debug('userDivision: ' + userDivision);

            OrderItem[] oiItems = null;
            if (String.isBlank(custNum)) {
                oiItems = [SELECT Product__r.Id, Product__r.Name, Product__r.Description, Product__r.ProductCode, Product__r.Drawing_Number__c, order.name, order.effectivedate, UnitPrice, Customer_Item_Number__c, Unit_of_Measure__c, 
                    product2.Joint_M_Size__c, product2.Joint_M_Size_UOM__c, product2.Joint_M_Type__c, product2.Joint_M_Thread_Direction__c, 
                    product2.Joint_N_Size__c, product2.Joint_N_Size_UOM__c, product2.Joint_O_Size__c, product2.Joint_O_Size_UOM__c, 
                    product2.Joint_P_Size__c, product2.Joint_P_Size_UOM__c, product2.Joint_P_Type__c, product2.Joint_P_Thread_Direction__c, 
                    product2.Joint_S_Size__c, product2.Joint_S_Size_UOM__c, product2.Joint_S_Type__c, product2.Joint_S_Thread_Direction__c, 
                    product2.Joint_Nipple_Size__c, product2.Joint_Nipple_Size_UOM__c, product2.Joint_Nipple_Type__c, product2.Joint_Nipple_Thread_Direction__c, 
                    product2.Joint_Seal_Material__c, product2.Joint_Temperature__c, product2.Joint_Temperature_UOM__c, product2.Joint_Pressure__c, product2.Joint_Pressure_UOM__c, 
                    product2.BLD_Application__c, product2.BLD_Bevel_Angle__c, product2.BLD_CTL_Machine_Index__c, product2.BLD_Holder_Type__c, product2.BLD_KUK_Reference_Code__c, product2.BLD_Length__c, 
                    product2.BLD_Machine_No__c, product2.BLD_Material__c, product2.BLD_Thickness__c, product2.BLD_Width__c,
                    order.currencyisocode, Product__r.IsActive, Product__r.X80_20_Rank__c, Product__r.On_Hold__c, Product__r.Part_of_Kit__c, Product__r.List_Price__c, Product__r.Substitute_Part__c, Product__r.Specifications__c 
                    FROM OrderItem WHERE Product__r.IsActive=true AND order.sale_type__c != :saleType AND order.accountid = :acctId AND Product__r.Product_Division__c = :userDivision 
                    AND (Product__r.Name like :searchText OR Product__r.Description like :searchText) ORDER BY Product__r.Name, order.EffectiveDate DESC LIMIT 100]; 
             }
             else {
                 oiItems = [SELECT Product__r.Id, Product__r.Name, Product__r.Description, Product__r.ProductCode, Product__r.Drawing_Number__c, order.name, order.effectivedate, UnitPrice, Customer_Item_Number__c, Unit_of_Measure__c, 
                    product2.Joint_M_Size__c, product2.Joint_M_Size_UOM__c, product2.Joint_M_Type__c, product2.Joint_M_Thread_Direction__c, 
                    product2.Joint_N_Size__c, product2.Joint_N_Size_UOM__c, product2.Joint_O_Size__c, product2.Joint_O_Size_UOM__c, 
                    product2.Joint_P_Size__c, product2.Joint_P_Size_UOM__c, product2.Joint_P_Type__c, product2.Joint_P_Thread_Direction__c, 
                    product2.Joint_S_Size__c, product2.Joint_S_Size_UOM__c, product2.Joint_S_Type__c, product2.Joint_S_Thread_Direction__c, 
                    product2.Joint_Nipple_Size__c, product2.Joint_Nipple_Size_UOM__c, product2.Joint_Nipple_Type__c, product2.Joint_Nipple_Thread_Direction__c, 
                    product2.Joint_Seal_Material__c, product2.Joint_Temperature__c, product2.Joint_Temperature_UOM__c, product2.Joint_Pressure__c, product2.Joint_Pressure_UOM__c, 
                    product2.BLD_Application__c, product2.BLD_Bevel_Angle__c, product2.BLD_CTL_Machine_Index__c, product2.BLD_Holder_Type__c, product2.BLD_KUK_Reference_Code__c, product2.BLD_Length__c, 
                    product2.BLD_Machine_No__c, product2.BLD_Material__c, product2.BLD_Thickness__c, product2.BLD_Width__c,
                    order.currencyisocode, Product__r.IsActive, Product__r.X80_20_Rank__c, Product__r.On_Hold__c, Product__r.Part_of_Kit__c, Product__r.List_Price__c, Product__r.Substitute_Part__c, Product__r.Specifications__c 
                    FROM OrderItem WHERE Product__r.IsActive=true AND order.sale_type__c != :saleType AND order.accountid = :acctId AND Product__r.Product_Division__c = :userDivision 
                    AND (Product__r.Name like :searchText OR Product__r.Description like :searchText) AND Customer_Item_Number__c like :custNum ORDER BY Product__r.Name, order.EffectiveDate DESC LIMIT 100]; 
             }
             
            
            //system.debug('Search Query: ' + searchTextSQL);
            //searchResults3 = Database.query(searchQuery);
            //system.debug('Search Query 3: ' + searchResults3);

            PreviousPart = '';
            if (!oiItems.isEmpty())
            { 
                for (OrderItem oi : oiItems)
                {
                    if(SelectedPartMap.containsKey(String.valueOf(oi.Product__r.Id))) {
                        strPartSelected = 'PartSelected';
                    } else {
                        strPartSelected = null;
                    }

                    if (oi.Product__r.List_Price__c == null) {
                        listPrice = '0.00';
                    } else {
                        listPrice = String.valueOf(Decimal.valueOf(Double.valueOf(oi.Product__r.List_Price__c)).setScale(2));
                    }

                    String drawingNum = oi.Product__r.Drawing_Number__c;
                    if (!String.isEmpty(drawingNum))
                    {
                        drawingNum = drawingNum.replace('null','');
                    }

                    String unit = oi.Unit_of_Measure__c;
                    if (!String.isEmpty(unit))
                    {
                        unit = unit.replace('null','');
                    }

                    if(PreviousPart != String.valueOf(oi.Product__r.Id))
                    {
                        searchResultsString.add(new List<String>{
                            String.valueOf(oi.Product__r.Id),
                            String.valueOf(oi.Product__r.Name)+' ',
                            String.valueOf(oi.Product__r.Description)+' ',
                            String.valueOf(oi.Product__r.ProductCode)+' '.replace('null',''),
                            String.valueOf(oi.Order.Name),
                            String.valueOf(oi.Order.EffectiveDate).left(10),
                            String.valueOf(String.valueOf(Decimal.valueOf(Double.valueOf(oi.UnitPrice)).setScale(2))+' '+oi.Order.CurrencyIsoCode.replace('null','')),
                            String.valueOf(String.valueOf(Double.valueOf(oi.Product2.Joint_M_Size__c))+oi.Product2.Joint_M_Size_UOM__c+' '+oi.Product2.Joint_M_Type__c+' '+oi.Product2.Joint_M_Thread_Direction__c).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(oi.Product2.Joint_P_Size__c))+oi.Product2.Joint_P_Size_UOM__c+' '+oi.Product2.Joint_P_Type__c+' '+oi.Product2.Joint_P_Thread_Direction__c).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(oi.Product2.Joint_S_Size__c))+oi.Product2.Joint_S_Size_UOM__c+' '+oi.Product2.Joint_S_Type__c+' '+oi.Product2.Joint_S_Thread_Direction__c).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(oi.Product2.Joint_Nipple_Size__c))+oi.Product2.Joint_Nipple_Size_UOM__c+' '+oi.Product2.Joint_Nipple_Type__c+' '+oi.Product2.Joint_Nipple_Thread_Direction__c),
                            String.valueOf(oi.Product2.Joint_Seal_Material__c+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(oi.Product2.Joint_Temperature__c))+oi.Product2.Joint_Temperature_UOM__c+' ').replace('null',''),
                            String.valueOf(oi.Product2.BLD_Bevel_Angle__c+' ').replace('null',''),
                            String.valueOf(oi.Product2.BLD_Length__c+' ').replace('null',''),
                            String.valueOf(oi.Product2.BLD_Material__c+' ').replace('null',''),
                            String.valueOf(oi.Product2.BLD_Thickness__c+' ').replace('null',''),
                            String.valueOf(oi.Product2.BLD_Width__c+' ').replace('null',''),
                            String.valueOf(drawingNum+' '),
                            String.valueOf(oi.Customer_Item_Number__c+' ').replace('null',''),
                            String.valueOf(' '),    
                            String.valueOf(unit+' '),
                            strPreviouslyOrdered,
                            listPrice,
                            String.valueOf(oi.Product__r.Substitute_Part__c+' '),
                            String.valueOf(oi.Product__r.X80_20_Rank__c+' ').replace('null',''),
                            String.valueOf(oi.Product__r.On_Hold__c+' ').replace('null',''),
                            String.valueOf(oi.Product__r.Specifications__c+' ').replace('null',''),    
                            String.valueOf(String.valueOf(Double.valueOf(oi.Product2.Joint_N_Size__c))+oi.Product2.Joint_N_Size_UOM__c).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(oi.Product2.Joint_O_Size__c))+oi.Product2.Joint_O_Size_UOM__c).replace('null',''),
                            strPartSelected
                        });
                    }
                    PreviousPart = String.valueOf(oi.Product__r.Id);
                }
            }
            else {
                //system.debug('No records found!!');
            }
         }
        return searchResultsString;
    }    
    
    @AuraEnabled
    public static String GetDefaultProductDivision() {
        String productDivision = '';
        String userId = UserInfo.getUserId();
        List<User> sDefaultProductDivision = New List<User>();
        sDefaultProductDivision = [SELECT Default_Product_Division__c FROM User WHERE Id = :userId];
        productDivision = String.valueOf(sDefaultProductDivision[0].get('Default_Product_Division__c'));
        return productDivision;
    }
    
    @AuraEnabled
    public static List<SearchResult> searchForPartsGeneric(String searchText, String searchFilter, Map<String,String> SelectedDivisionMap){
       String searchQuery = '';
       String listPrice = '';
        
       String SelectedDivisionSQL ='@';
       for (string prod2ID:SelectedDivisionMap.keySet()) {
            SelectedDivisionSQL = SelectedDivisionSQL + ',\''+ prod2ID + '\'';
       }

       SelectedDivisionSQL = SelectedDivisionSQL.Replace('@,','');
       if(SelectedDivisionSQL=='@'){
            SelectedDivisionSQL = '\'na\'';
       }
        
       List<Product2> searchResults = new List<Product2>();
       List<List<String>> searchResultsString = new List<List<String>>();
       Map<String,String> PrevOrderedMap = new Map<String,String>();       
        
       String strJointFields = ' Joint_M_Size__c, Joint_M_Size_UOM__c,Joint_M_Type__c, Joint_M_Thread_Direction__c, ' +
                                ' Joint_N_Size__c, Joint_N_Size_UOM__c, Joint_O_Size__c, Joint_O_Size_UOM__c, ' +
                                ' Joint_P_Size__c, Joint_P_Size_UOM__c,Joint_P_Type__c, Joint_P_Thread_Direction__c, ' +
                                ' Joint_S_Size__c, Joint_S_Size_UOM__c,Joint_S_Type__c, Joint_S_Thread_Direction__c, ' +                                
                                ' Joint_Seal_Material__c, Joint_Temperature__c, Joint_Temperature_UOM__c, ' +
                                ' Joint_Pressure__c, Joint_Pressure_UOM__c, ';
       
       String strBladeFields = ' BLD_Application__c, BLD_Bevel_Angle__c, BLD_CTL_Machine_Index__c, BLD_Holder_Type__c, ' +
                                ' BLD_KUK_Reference_Code__c, BLD_Length__c, BLD_Machine_No__c, BLD_Material__c, ' +
                                ' BLD_Thickness__c, BLD_Width__c, ';
       
        //######### if the search bar is empty, default with database query ############
        if(searchText ==''){
            searchQuery = 'SELECT Id, Name, Description, ProductCode, Unit_of_Measure__c, '+
                strJointFields +
                strBladeFields +
                ' Product_Division__c, List_Price__c, ' +
                ' IsActive FROM Product2 WHERE IsActive=true ' + searchFilter +                
                ' AND Product_Division__c IN(' + SelectedDivisionSQL  + ') ' +
                ' ORDER BY name LIMIT 100';
            searchResults = Database.query(searchQuery);
        }

        //######### if the search bar is has a value, use the salesforce find function ############
        if(searchText !=''){
            searchQuery = 'FIND \'' + searchText + '\' IN ALL FIELDS RETURNING ' +
                ' Product2(Id, Name, Description, ProductCode, Unit_of_Measure__c, ' +
                strJointFields +
                strBladeFields +
                ' Product_Division__c, List_Price__c, ' +
                ' IsActive WHERE IsActive=true ' + searchFilter +
                ' AND Product_Division__c IN(' + SelectedDivisionSQL  + ') ' +
                ' ORDER BY name LIMIT 100)';
            List<List<sObject>> searchResults2 = search.query(searchQuery);
            
            for (List<SObject> sobjs : searchResults2) {
                for (SObject sobj : sobjs) { searchResults.add((Product2) sobj); }
            }
        }

        List<SearchResult> results = new List<SearchResult>();
        //######### prepare array for return value ############
        for (Product2 sobj : searchResults){
            if (sobj.get('List_Price__c') == null) {
                listPrice = '';
            } else {
                listPrice = String.valueOf(Decimal.valueOf(Double.valueOf(sobj.get('List_Price__c'))).setScale(2));
            }
            if (listPrice == '0.00') {
                listPrice = '';
            }
            SearchResult result = new SearchResult();
            result.id = sobj.Id;
            result.listPrice = listPrice;
            result.productDivision = String.valueOf(sobj.get('Product_Division__c')).replace('null','');
            result.name = String.valueOf(sobj.get('Name'));
            result.description = sobj.get('Description') +' ';
            result.productCode = String.valueOf(sobj.get('ProductCode')+' ').replace('null','');
            result.jointM = String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null','');
            result.jointN = String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_N_Size__c')))+sobj.get('Joint_N_Size_UOM__c')).replace('null','');
            result.jointO = String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_O_Size__c')))+sobj.get('Joint_O_Size_UOM__c')).replace('null','');
            result.jointP = String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null','');
            result.jointS = String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null','');
            result.jointSeal = String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null','');
            result.jointTemperature = String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' ').replace('null','');
            result.jointPressure = String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null','');
            result.bladeApplication = String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null','');
            result.bladeBevel = String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null','');
            result.bladeHolder = String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null','');
            result.bladeLength = String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null','');
            result.bladeThickness = String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null','');
            result.bladeWidth = String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null','');
            results.add(result);
            /*
            searchResultsString.add(new List<String>{
                sobj.Id,
                String.valueOf(sobj.get('Name')),
                String.valueOf(sobj.get('Description'))+' ',
                String.valueOf(sobj.get('ProductCode')+' ').replace('null',''),
                String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null',''),
                String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null',''),
                String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null',''),
                String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null',''),
                String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' ').replace('null',''),
                String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Material__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null',''),
                String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null',''),
                String.valueOf(sobj.get('Product_Division__c')).replace('null',''),
                String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_N_Size__c')))+sobj.get('Joint_N_Size_UOM__c')).replace('null',''),
                String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_O_Size__c')))+sobj.get('Joint_O_Size_UOM__c')).replace('null',''),
                listPrice
            });
            */
        }
        //return searchResultsString;
        return results;
    }    

    @AuraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        //system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
        List<String> allOpts = new list<String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
    public static List<PicklistOption> GetAccountAssets(String recordId)
    {
        //system.debug('recordId in GetAccountAssets: ' + recordId);
        List<PicklistOption> options = new List<PicklistOption>();
        for (Quote sfQuote: [SELECT Account__c From Quote Where Id = :recordId LIMIT 1]) {        
            String acctId = sfQuote.Account__c;        
            Asset[] acctAssets = [SELECT Id, SerialNumber FROM Asset Where AccountId = :acctId];
            if (!acctAssets.isEmpty())
            {
                options.add(new PicklistOption('Choose Asset', '0'));
                for (Asset asset:acctAssets) {
                    options.add(new PicklistOption(asset.SerialNumber, asset.Id));            
                }
            }
            else {
                options.add(new PicklistOption('No Assets Found', '0'));
            }
        }
        return options;
    }
    
    public class SearchResult {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String productCode;
        @AuraEnabled
        public String jointM;
        @AuraEnabled
        public String jointN;
        @AuraEnabled
        public String jointO;
        @AuraEnabled
        public String jointP;
        @AuraEnabled
        public String jointS;
        @AuraEnabled
        public String jointSeal;
        @AuraEnabled
        public String jointTemperature;
        @AuraEnabled
        public String jointPressure;
        @AuraEnabled
        public String bladeApplication;
        @AuraEnabled
        public String bladeBevel;
        @AuraEnabled
        public String bladeHolder;
        @AuraEnabled
        public String bladeLength;
        @AuraEnabled
        public String bladeMaterial;
        @AuraEnabled
        public String bladeThickness;
        @AuraEnabled
        public String bladeWidth;
        @AuraEnabled
        public String productDivision;
        @AuraEnabled
        public String listPrice;
    }
    
    public class PicklistOption {        
        @AuraEnabled
        public String label { get; set; }        
        @AuraEnabled
        public String value { get; set; }        
        public PicklistOption( String label, String value ) {
            this.label = label;
            this.value = value;
        }        
    }
}