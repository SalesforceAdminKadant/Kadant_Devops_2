public without sharing class KadantPortalClasses {
    
    /* Developer: Emma Oudmaijer / Marcel Oudmaijer
    * Purpose: Function to retrieve customer order history 
    * Used id: Lightning component "CommunityOrderHistory"
    */
    
    @AuraEnabled
    public static List<List<String>> getOrderHistory(String strUserID, Integer strYear) {
        
        List<List<String>> CustomerOrderList = new List<List<String>>();
        String sPrevOrderId = '';
        String sAgentId = '';
        String sAgentName = '';
       	String sSQL ='';
        
        //sSQL = 'SELECT contactid, name, accountid, account.name FROM user WHERE Id =\'' + strUserID +'\' LIMIT 1';
        //List<sObject> accountLink = Database.query(sSQL);
        //String sCustomerID = String.valueOf(accountLink[0].get('accountId'));
        
        if(strUserID=='0050z0000080jIqAAI'){ sAgentId='0010z00001WngJVAAZ'; sAgentName ='EU ESC Romania';}
        if(strUserID=='0050z0000080jIbAAI'){ sAgentId='0010z00001ax5eZAAQ'; sAgentName ='The Nippon Joint, Ltd.';}
        if(strUserID=='0050z000006zvCoAAI'){ sAgentId='0010z00001WngImAAJ'; sAgentName ='Brain Box';}
        if(strUserID=='0050z0000080VHjAAM'){ sAgentId='0010z00001WngI8AAJ'; sAgentName ='Gentech Engineering Plastics';}
        	
        if(sAgentName!=''){
        
        	sSQL = 'SELECT Order.id, Order.effectivedate, product2.name, Quantity, UnitPrice, TotalPrice, Order.TotalAmount, Order.Status, ' +
                			' Order.OrderNumber, Line_no__c, Order.Tracking_Number__c, Order.Tracking__c, product2.description, Order.account.name, ' +
                			' order.name, Order.account.ShippingCountry, Order.Sales_Office__r.name, product2.productcode ' + 
                			' FROM orderitem WHERE order.agent__r.name =\'' + sAgentName +'\' and CALENDAR_YEAR(Order.effectivedate)=' + strYear + 
                			' ORDER BY order.effectivedate DESC, Order.id, Line_no__c';
        	List<sObject>  ol = Database.query(sSQL);

        
        	for (sObject sobj:ol) {
                
                if(String.valueOf(sobj.getSobject('Order').get('id')) <> sPrevOrderId){
                    	CustomerOrderList.add(new List<String>{
                    		String.valueOf(sobj.getSobject('Order').get('id')),
                    		String.valueOf(sobj.getSobject('Order').get('effectivedate')),
                    		String.valueOf(sobj.getSobject('Order').get('Status')),
                    		String.valueOf(sobj.getSobject('Order').get('OrderNumber')),
                        	String.valueOf(sobj.getSobject('Order').getSobject('account').get('name')),
                    		'H',
                            String.valueOf(sobj.getSobject('Order').get('TotalAmount')),
                            String.valueOf(sobj.getSobject('Order').get('Tracking_Number__c'))+' ',
                            String.valueOf(sobj.getSobject('Order').get('Tracking__c'))+' ',
                            String.valueOf(sobj.getSobject('Order').get('name')),
                            String.valueOf(sobj.getSobject('Order').getSobject('Sales_Office__r').get('name')),
                            String.valueOf(sobj.getSobject('Order').getSobject('account').get('ShippingCountry'))+' '                            
                		});
                    sPrevOrderId  = String.valueOf(sobj.getSobject('Order').get('id'));
                }
                
                CustomerOrderList.add(new List<String>{
                    String.valueOf(sobj.getSobject('Order').get('id')),
                    String.valueOf(sobj.getSobject('Order').get('effectivedate')),
                    String.valueOf(sobj.getSobject('product2').get('name')),    
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    'L',
                    String.valueOf(sobj.get('TotalPrice')),
                    String.valueOf(sobj.get('Line_No__c')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.getSobject('product2').get('productcode'))+' ',
                    ' ',
                    ' '
                });                
                                
            }        
        
        }
        return CustomerOrderList;
   }
    
    
    
    @AuraEnabled
    public static List<List<String>> getFilteredPriceList(String strSite,String strPL, String strPC, String strSize, String strPlating) {
        
        	List<List<String>> FilteredPriceList = new List<List<String>>();
        
        	String sProductCode = '';
        	if(strPL=='Joints'){
            	sProductCode = 'RJ -' + strPC;
        	}
        
			String sSQL = 'select product2.name, product2.description, unitprice from pricebookentry where '+
                			' product2.productcode=\''+sProductCode+'\''+
                			' and currencyisocode=\'EUR\' and product2.location__c=\''+strSite+'\' order by product2.name';
        	List<sObject>  priceBookEntries = Database.query(sSQL);       
        
           for (sObject sobj:priceBookEntries) {
                
                
                FilteredPriceList.add(new List<String>{
                    String.valueOf(sobj.getSobject('product2').get('name')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.get('unitprice'))
                });                
                                
            }        
        
        	return FilteredPriceList;
   }

}