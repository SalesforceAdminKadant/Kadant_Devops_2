public class KAI_WorkOrder_Add_Line {

    @AuraEnabled
    public static String IsAssetShipToOk(String strRecordID){
        String assetOk = 'true';
        WorkOrder[] currentWO = [SELECT Id, Division__c, Asset.Account_Number__c, Asset.Billing_Account_Number__c FROM WorkOrder WHERE Id =:strRecordID  AND Division__c IN ('KPGER', 'KPGBR', 'KPESP', 'KPFRA') LIMIT 1];
        if (!currentWO.isEmpty())
        {
            String acctSiteNum = '';
            if (String.isNotBlank(currentWO[0].Asset.Account_Number__c)) {
                acctSiteNum = currentWO[0].Asset.Account_Number__c;
            }
            String acctBillNum = '';
            if (String.isNotBlank(currentWO[0].Asset.Billing_Account_Number__c)) {            
                acctBillNum = currentWO[0].Asset.Billing_Account_Number__c;
            }
            if (acctSiteNum.Left(7) != acctBillNum)
            {
                assetOk = 'false';
            }
        }        
        return assetOk;
    }
    
    @AuraEnabled
    public static List<SearchResult> searchForRates(String strRecordID, String strObjectName, String strRecordDivision, String strRecordAsset, String strRecordCurrency, String strRecordPB, String searchText, String searchFilter, Map<String,String> SelectedPartMap){
        system.debug('record: ' + strRecordID + ' object: ' + strObjectName + ' division: ' + strRecordDivision + ' asset: ' + strRecordAsset + ' PB: ' + strRecordPB + 
            ' currency: ' + strRecordCurrency + ' searchText: ' + searchText + ' searchFilter: ' + searchFilter);
        String searchQuery = '';
        String strPartSelected = null;
        String strPreviouslyOrdered = 'N';
        String PreviousPart ='';
        List<SearchResult> results = new List<SearchResult>();
        List<List<String>> searchResultsString = new List<List<String>>();
        List<WorkOrderLineItem> searchResults3 = new List<WorkOrderLineItem>(); 
        List<ContractLineItem > searchResults4 = new List<ContractLineItem >(); 
        Map<String,String> PrevOrderedMap = new Map<String,String>();
        List<PriceBookEntry> searchResults = new List<PriceBookEntry>();
        
        if (searchFilter.left(7) == 'HISTORY') {
            //######### collect history ###########
            system.debug(searchFilter);
            WorkOrder sfWO = [SELECT AssetId FROM WorkOrder where id = :strRecordID LIMIT 1];
            String assetId = sfWO.assetId;
            system.debug('Asset ID: ' + assetId);

            //String searchTextSQL = searchFilter.replace('HISTORY = ','');           
            searchQuery = 'SELECT PricebookEntry.Id, product2.Name, product2.Description, Currencyisocode, UnitPrice, product2.Unit_of_Measure__c, product2.On_Hold__c, product2.Run_Out__c ' +                
                ' FROM WorkOrderLineItem ' + 
                ' WHERE PricebookEntry.product2.IsActive=true AND WorkOrder.AssetId =  \'' + assetId + '\' AND PricebookEntry.product2.location__c = \'' + strRecordDivision + '\'' +
                ' ORDER BY PricebookEntry.product2.Name LIMIT 150';
            system.debug(searchQuery);
           
            searchResults3 = Database.query(searchQuery);
            PreviousPart ='';
            for (WorkOrderLineItem sobj : searchResults3) {
                if(SelectedPartMap.containsKey(String.valueOf(sobj.getSobject('PricebookEntry').get('Id')))) {
                    strPartSelected = 'PartSelected';
                } 
                else {
                    strPartSelected = null;
                }
                if(PrevOrderedMap.containsKey(String.valueOf(sobj.getSobject('PricebookEntry').get('Id')))) {
                    strPreviouslyOrdered = 'Y';
                } 
                else {
                    strPreviouslyOrdered = 'N';
                }
                                
                if(PreviousPart != String.valueOf(sobj.getSobject('PricebookEntry').get('Id')))
                {
                    SearchResult result = new SearchResult();
                    result.id = String.valueOf(sobj.getSobject('PricebookEntry').get('Id'));
                    result.name = String.valueOf(sobj.getSobject('product2').get('Name'))+' ';
                    result.description = String.valueOf(sobj.getSobject('product2').get('Description'))+' ';
                    result.uom = String.valueOf(sobj.getSobject('product2').get('Unit_of_Measure__c'));
                    result.serviceRate = String.valueOf(String.valueOf(Decimal.valueOf(Double.valueOf(sobj.get('UnitPrice'))).setScale(2))+' '+ sobj.get('Currencyisocode'));
                    result.previouslyOrdered = strPreviouslyOrdered;
                    result.previouslySelected = strPartSelected;
                    result.onHold = String.valueOf(sobj.getSobject('product2').get('On_Hold__c'))+' ';
                    result.runOut = String.valueOf(sobj.getSobject('product2').get('Run_Out__c'))+' ';
                    results.add(result);                 
                }
                PreviousPart = String.valueOf(sobj.getSobject('PricebookEntry').get('Id'));
            } 
       } else if(searchFilter.left(8) == 'SERVCONS') {
            //######### collect history ###########
            //system.debug(searchFilter);
            WorkOrder sfWO = [SELECT AssetId FROM WorkOrder where id = :strRecordID LIMIT 1];
            String assetId = sfWO.assetId;
            //String searchTextSQL = searchFilter.replace('SERVCONS = ','');           
            searchQuery = 'SELECT PricebookEntry.Id, product2.Name, product2.Description, Currencyisocode, UnitPrice, product2.Unit_of_Measure__c, product2.On_Hold__c, product2.Run_Out__c ' +                
                ' FROM ContractLineItem ' + 
                ' WHERE AssetId = \''+ assetId + '\' AND ServiceContract.Status = \'Active\' AND PricebookEntry.product2.IsActive = true AND PricebookEntry.product2.location__c = \'' + strRecordDivision + '\'' +
                ' ORDER BY PricebookEntry.product2.Name LIMIT 150';
            //system.debug(searchQuery);
           
            searchResults4 = Database.query(searchQuery);
            PreviousPart ='';
            for (ContractLineItem sobj : searchResults4) {
                if(SelectedPartMap.containsKey(String.valueOf(sobj.getSobject('PricebookEntry').get('Id')))) {
                    strPartSelected = 'PartSelected';
                } 
                else {
                    strPartSelected = null;
                }
                if(PrevOrderedMap.containsKey(String.valueOf(sobj.getSobject('PricebookEntry').get('Id')))) {
                    strPreviouslyOrdered = 'Y';
                } 
                else {
                    strPreviouslyOrdered = 'N';
                }
                                
                if(PreviousPart != String.valueOf(sobj.getSobject('PricebookEntry').get('Id')))
                {
                    SearchResult result = new SearchResult();
                    result.id = String.valueOf(sobj.getSobject('PricebookEntry').get('Id'));
                    result.name = String.valueOf(sobj.getSobject('product2').get('Name'))+' ';
                    result.description = String.valueOf(sobj.getSobject('product2').get('Description'))+' ';
                    result.uom = String.valueOf(sobj.getSobject('product2').get('Unit_of_Measure__c'));
                    result.serviceRate = String.valueOf(String.valueOf(Decimal.valueOf(Double.valueOf(sobj.get('UnitPrice'))).setScale(2))+' '+ sobj.get('Currencyisocode'));
                    result.previouslyOrdered = strPreviouslyOrdered;
                    result.previouslySelected = strPartSelected;
                    result.onHold = String.valueOf(sobj.getSobject('product2').get('On_Hold__c'))+' ';
                    result.runOut = String.valueOf(sobj.getSobject('product2').get('Run_Out__c'))+' ';
                    results.add(result);
                }
                PreviousPart = String.valueOf(sobj.getSobject('PricebookEntry').get('Id'));
            } 
       }
       else {
             //######### if the search bar is empty, default with database query ############
            //system.debug(searchFilter);
            searchQuery = 'SELECT Id, product2.Name, product2.Description, Currencyisocode, UnitPrice, product2.Unit_of_Measure__c, product2.On_Hold__c, product2.Run_Out__c'+
                ' FROM PriceBookEntry WHERE (product2.Name like \'%'+searchText+'%\' OR product2.Description like \'%'+searchText+'%\')' +
                ' AND pricebook2id=\'' + strRecordPB + '\' AND product2.location__c=\'' + strRecordDivision + '\'  and currencyisocode=\'' +strRecordCurrency + '\'' + searchFilter +
                ' ORDER BY product2.name LIMIT 150';
        
            system.debug(searchQuery);
            searchResults = Database.query(searchQuery);       

            //######### prepare array for return value ############
            for (PriceBookEntry sobj : searchResults){
                if(SelectedPartMap.containsKey(sobj.Id)) {
                    strPartSelected = 'PartSelected';
                } 
                else {
                    strPartSelected = null;}
                if(PrevOrderedMap.containsKey(sobj.Id)) {
                    strPreviouslyOrdered = 'Y';
                } 
                else {
                    strPreviouslyOrdered = 'N';
                }
                SearchResult result = new SearchResult();
                result.id = sobj.Id;
                result.name = String.valueOf(sobj.Product2.Name);
                result.description = String.valueOf(sobj.Product2.Description)+' ';
                result.uom = String.valueOf(sobj.Product2.Unit_of_Measure__c)+' ';
                result.serviceRate = String.valueOf(sobj.get('UnitPrice')+' ' + sobj.get('CurrencyIsoCode'));
                result.previouslyOrdered = String.valueOf(sobj.Product2.Unit_of_Measure__c);
                result.previouslySelected = String.valueOf(sobj.Product2.Unit_of_Measure__c);
                result.onHold = String.valueOf(sobj.Product2.On_Hold__c)+' ';
                result.runOut = String.valueOf(sobj.Product2.Run_Out__c)+' ';
                results.add(result);
            }            
       }
      return results;
    }
    
    @AuraEnabled
    public static List<List<String>> GetProductPricing(String strRecordID, String strObjectName, Map<String,String> SelectedPartMap, Map<String,String> SelectedPartMapQty,String strPBId, String strCurrency, String strAccount){

        //map of selected parts sorted by product ID
        Map<String,List<String>> DocLinesListMap = new Map<String,List<String>>();
        
        //maps containing divisional selling price by product ID 
        Map<String,String> DivisionPriceMap = new Map<String,String>();
        Map<String,String> DivisionPriceListMap = new Map<String,String>();
        Map<String,String> ParentDivisionPriceMap = new Map<String,String>();
        Map<String,String> ParentDivisionPriceListMap = new Map<String,String>();       
        //map of selected parts sorted by order of selection
        List<List<String>> DocLinesList = new List<List<String>>();
        
        String strParentAccount = '';
        
        String selectedParts = '@';
               
        for (String prod2ID:SelectedPartMap.keySet()) {
            //remove -dup1, -dup2 etc. from the product2 ID. Max 50 duplicate parts
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        selectedParts = selectedParts.Replace('@,','');
        system.debug('Selectedparts');
        system.debug(selectedParts);
        
        List<String> selectedProd2s = new List<String>();
        
       String sSQL = 'select product2id from pricebookentry where id in (' + selectedParts + ')';
       List<PricebookEntry> prod2ids = Database.query(sSQL);
        system.debug(prod2ids);
        for(PricebookEntry p2id: prod2ids){
            selectedProd2s.add(p2id.product2id);
        }
        system.debug('prod2ids: ');
        system.debug(selectedProd2s);
        
        //############## Get price from divisional price list 
        /*
        sSQL = 'SELECT Division_Price_List__r.name, Product__c, Product__r.name, Price__c, CurrencyIsoCode '+
                ' FROM Division_Price_List_Item__c where product__c in' + selectedProd2s + ''+
                ' AND currencyisocode=\'' + strCurrency + '\' and IsDeleted=false ' +
                ' and Division_Price_List__r.active__c=true and Division_Price_List__c in ' +
                ' (select Division_Price_List__c from account_division_price_list__c)';
        system.debug(sSQL);
        List<Division_Price_List_Item__c> ppli = Database.query(sSQL); */
        
        List<Division_Price_List_Item__c> ppli = [SELECT Division_Price_List__r.name, Product__c, Product__r.name, Price__c, CurrencyIsoCode 
                 FROM Division_Price_List_Item__c where product__c in :selectedProd2s  
                 AND currencyisocode= :strCurrency and IsDeleted=false  
                 and Division_Price_List__r.active__c=true and Division_Price_List__c in  
                 (select Division_Price_List__c from account_division_price_list__c where account_division__r.account__c = :strAccount)];
        
        for (Division_Price_List_Item__c sobj2 : ppli){
                DivisionPriceMap.put(String.valueOf(sobj2.get('Product__c')), String.valueOf(sobj2.get('Price__c')) );
                DivisionPriceListMap.put(String.valueOf(sobj2.get('Product__c')), String.valueOf(sobj2.getSobject('Division_Price_List__r').get('name')) );
        }
        

        //############## Get prices from parent divisional price list
        
        List<Account> lParent = [SELECT ParentId from account where id = :strAccount];
        for (Account sobj4 : lParent){
                    strParentAccount = String.valueOf(sobj4.get('ParentId'));
        }

        
        List<Division_Price_List_Item__c> ppli2 = [SELECT Division_Price_List__r.name, Product__c, Product__r.name, Price__c, CurrencyIsoCode 
                 FROM Division_Price_List_Item__c where product__c in :selectedProd2s  
                 AND currencyisocode= :strCurrency and IsDeleted=false  
                 and Division_Price_List__r.active__c=true and Division_Price_List__c in  
                 (select Division_Price_List__c from account_division_price_list__c where account_division__r.account__c = :strParentAccount)];
            
        for (Division_Price_List_Item__c sobj3 : ppli2){
                    ParentDivisionPriceMap.put(String.valueOf(sobj3.get('Product__c')), String.valueOf(sobj3.get('Price__c')) );
                    ParentDivisionPriceListMap.put(String.valueOf(sobj3.get('Product__c')), String.valueOf(sobj3.getSobject('Division_Price_List__r').get('name')) );
        }

        
        //############ Get prices from standard price list
        
        sSQL = 'SELECT Product2Id, Product2.Name, Product2.Description, unitprice, icp_price__c, Product2.No_Approval_Required__c, Product2.PSG_E_Dummy__c, Product2.Price_Reference_Document_ID__c, Product2.Product_Line__c FROM PricebookEntry WHERE isactive=true AND Id in(' +
                selectedParts + ')'+
                ' AND currencyisocode=\'' + strCurrency + '\'' +
                ' AND Pricebook2ID=\''+ strPBId + '\'' +
                ' ORDER BY Product2.name';
        List<PricebookEntry> pbe = Database.query(sSQL);
        system.debug(pbe);
        String UnitPrice = '0';
        String IcpPrice = '0';
        String DivPriceList = 'None';
        
        //######## Get assigned resources 
        String serviceTech = 'Performed by: ';
        
        sSQL = 'SELECT serviceresource.name from assignedresource where serviceappointmentid in (select id from serviceappointment where parentrecordid = '+ strRecordId +')';
        system.debug(sSQL);
        List<AssignedResource> resourceList = [SELECT serviceresource.name from assignedresource where serviceappointmentid in (select id from serviceappointment where parentrecordid = :strRecordId)];
        for(AssignedResource ar: resourceList){
            serviceTech = serviceTech + ' ' + ar.serviceresource.name;
        }
        for (PricebookEntry sobj : pbe){
            
            if(DivisionPriceMap.containsKey( String.valueOf(sobj.get('Product2Id')) )) {
                UnitPrice = String.valueOf(DivisionPriceMap.get( String.valueOf(sobj.get('Product2Id')) ));
                DivPriceList = String.valueOf(DivisionPriceListMap.get( String.valueOf(sobj.get('Product2Id')) ));
            } 
            else {
                if(ParentDivisionPriceMap.containsKey( String.valueOf(sobj.get('Product2Id')) )) {
                    UnitPrice = String.valueOf(ParentDivisionPriceMap.get( String.valueOf(sobj.get('Product2Id')) ));
                    DivPriceList = String.valueOf(ParentDivisionPriceListMap.get( String.valueOf(sobj.get('Product2Id')) ));
                } 
                else{
                    UnitPrice = String.valueOf(sobj.get('unitprice'));
                    IcpPrice = String.valueOf(sobj.get('icp_price__c'));
                    DivPriceList = 'None';
                }
            }
                
            DocLinesListMap.put(String.valueOf(sobj.get('Id')),new List<String>{
                String.valueOf(sobj.get('Product2Id')),
                String.valueOf(sobj.Product2.Name)+' ',
                String.valueOf(sobj.Product2.Description)+' ',
                UnitPrice,
                strCurrency,                
                String.valueOf(SelectedPartMapQty.get(String.valueOf(sobj.get('Product2Id')))),
                serviceTech,
                DivPriceList,
                String.valueOf(sobj.Product2.PSG_E_Dummy__c),
                String.valueOf(sobj.Product2.Price_Reference_Document_ID__c),
                IcpPrice,
                String.valueOf(sobj.Product2.Product_Line__c),
                '0'
            });      
        
        }
        
        system.debug('DOCLINELISTMAP-->'+DocLinesListMap);
        
        //re-sort DocLinesListMap in order of selection
        for (String prod2ID:SelectedPartMap.keySet()) {
            
            String prod2IDsource = prod2ID;
            system.debug('prod2IDsource-->'+prod2IDsource);
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            //DocLinesList.add(DocLinesListMap.get(String.valueOf(prod2IDclean)));
            
            system.debug('prod2ID-->'+prod2ID);
            system.debug('Map entry-->'+DocLinesListMap.get(String.valueOf(prod2ID)));
                    
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
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[11]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[12])    
              });
            
        }
        
        system.debug('DOCLINELIST-->'+DocLinesList);
        
        Return DocLinesList;
    }
    
    @AuraEnabled
    public static boolean AddWOLines(String strWORecordID, Map<String,String> SelectedPartMap, String lineQTY, String lineUP, String lineDC, String lineSP){   
        // String nLine_no = '';
        Decimal nQuantity = 1;
        Decimal nUnitPrice = 0;
        String tmpKey ='';
        String tmpVal ='';
        List<WorkOrderLineItem> lstWLI = new List<WorkOrderLineItem>();
        //system.debug(lineQTY);
        //system.debug(lineDC);
            
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
        SYSTEM.DEBUG(lineDCobjects);
        for (Object lineDCobject : lineDCobjects) {
            //system.debug(String.valueof(lineDCobject));
            String discount = String.valueof(lineDCobject).split(',')[1].replace(' value=','').replace('}','');
            if (discount == ''){discount='0.00';}
            //system.debug(discount);
            lineDClist.put(String.valueof(lineDCobject).split(',')[0].replace('key=disc','').replace('{',''), Decimal.valueOf(discount));
        }
        
        //######### line specs
        Map<string, String> lineSPEClist = new Map<string, String>();
        List<Object> lineSPECobjects = (List<Object>)System.JSON.deserializeUntyped(lineSP);
        for (Object lineSPECobject : lineSPECobjects) {
            //system.debug(String.valueof(lineSPECobject));
            String specs = String.valueof(lineSPECobject).split(',')[1].replace(' value=','').replace('}','');
            //system.debug('Specs: ' + specs);
        lineSPEClist.put(String.valueof(lineSPECobject).split(',')[0].replace('key=spec','').replace('{',''), String.valueof(lineSPECobject).split(',',2)[1].replace(' value=','').replace('}',''));
        }
        //system.debug(lineSPEClist);     
        //######### insert wo lines       
        
        for (String prod2ID:SelectedPartMap.keySet()) {            
            String prod2IDsource = prod2ID;
            //system.debug('prod2IDsource-->'+prod2IDsource);
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            //system.debug('line no before: ' + nLine_no);
            //nLine_no = decimal.valueof(nLine_no)+1;
            //system.debug('line no after: ' + nLine_no);
            string xescription = lineSPEClist.get(prod2IDsource);
            //system.debug(xescription);
            lstWLI.add(new WorkOrderLineItem(WorkOrderId=strWORecordID,                 
                PriceBookEntryID = prod2ID,
                Quantity = lineQTYlist.get(prod2IDsource),
                UnitPrice = lineUPlist.get(prod2IDsource), 
                Discount = lineDClist.get(prod2IDsource), 
                Description = lineSPEClist.get(prod2IDsource))
                );               
        }
        //system.debug(lstWLI);
        if(!lstWLI.isEmpty()){
            insert lstWLI;
        }
        return true;
    }

    @AuraEnabled
    public static Boolean ProductOnHoldOrRunOut(String prodId)
    {
        Boolean exists = false;
        PriceBookEntry[] prod = [SELECT product2.On_Hold__c, product2.Run_Out__c FROM PriceBookEntry Where id = :prodId LIMIT 1];
        if (!prod.isEmpty())
        {
            Boolean onHold = prod[0].product2.On_Hold__c;
            Boolean runOut = prod[0].product2.Run_Out__c;
            if (onHold || runOut)
            {
                exists = true;
            }
        }
        return exists;
    }

    public class SearchResult {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String uom;
        @AuraEnabled
        public String serviceRate;
        @AuraEnabled
        public String previouslyOrdered;
        @AuraEnabled
        public String previouslySelected;
        @AuraEnabled
        public String onHold;
        @AuraEnabled
        public String runOut;
    }
}