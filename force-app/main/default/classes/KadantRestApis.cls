@RestResource(urlMapping = '/BladeCabinet/*')
global without sharing class KadantRestApis {
    @HTTPGet    
    Global static String TestGet () {       
        RestRequest Req = RestContext.request;
        string test = Req.requestURI.substring(Req.requestURI.lastIndexOf('/')+1);
        String param1Var = RestContext.request.params.get('var');

        if (param1Var == 'terms')
        {
            StaticResource sr = [SELECT body FROM StaticResource WHERE Name = 'SmartConnectedProducts'];
            JSONGenerator jsonGen = JSON.createGenerator(true);
            jsonGen.writeStartObject();
            jsonGen.writeStringField('published', '1658361600');
            jsonGen.writeStringField('content', sr.body.toString());
            jsonGen.writeEndObject();
            String jsonData = jsonGen.getAsString();
            //System.debug('jsonMaterials: '+ jsonData);
            return jsonData;
        }
        else 
        {
            Blade_Cabinet__c[] bc = [SELECT Id, Name FROM Blade_Cabinet__c WHERE Id = 'a9L4W000001LzEpUAK'];
            String bc1 = bc[0].Name;
            String echoBack = 'Received: ' + test + ' Blade Cabinet Name: ' + bc1;
            return echoBack;
        }        
    }
    
    @HTTPPut
    Global static string UpsertBladeCabinetData () {
        boolean success = false; 
        String testStr = 'Request Processed';
        try {
            Map<String, Object> cust = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            string custName = (String)cust.get('customerName');
            string custId = (String)cust.get('customerKadantId');    
            
            List<Object> cabs = (List<Object>)cust.get('cabinets');
            for(Object cab : cabs) {
                Map<String, Object> c = (Map<String, Object>)cab;                
                string cabinetId = (String)c.get('cabinetKadantId');
                string cabName = (String)c.get('cabinetName');
                string strAccountID;
                Blade_Cabinet__c[] bc = [SELECT Id, Account__c FROM Blade_Cabinet__c WHERE Id = :cabinetId];
                
                if (bc.size() > 0)
                {
                    strAccountID = bc[0].Account__c;
                    // Delete the previous Inventory
                    Blade_Cabinet_Inventory__c[] bladeInv = [SELECT Id, Name FROM Blade_Cabinet_Inventory__c WHERE Blade_Cabinet__c = :cabinetId];
                    if (bladeInv.size() > 0)
                    {
                        delete bladeInv;
                    }

                    List<Object> blades = (List<Object>)c.get('blades');
                    List<CabinetDetail> bciDetails = new List<CabinetDetail>();
                    for(Object blade : blades) {
                        Map<String, Object> b = (Map<String, Object>)blade;
                        string bladePN = (String)b.get('partNumber');
                        string trimBladePN = bladePN.trim();
                        string bladeDescription = 'No description found!';
                        string customerPN = 'No number found';
                        string quickIdentifier = '';
                        string strProduct = null;
                        string bladeSN = (String)b.get('serial');
                        bladeSN = bladeSN.replaceFirst('^0+','');
                        string orderNum = (String)b.get('orderNumber');
                        Integer qty = (Integer)b.get('quantity');

                        Blade_Cabinet_Inventory__c bcl = new Blade_Cabinet_Inventory__c (
                            Blade_Cabinet__c = cabinetId,
                            Part_Number__c = trimBladePN,
                            Serial_No__c = bladeSN,
                            Order_Number__c = orderNum,
                            Quantity__c = qty,
                            Part_Description__c = bladeDescription,
                            //Customer_Item_Number__c = customerPN,
                            Product__c = strProduct,
                            Quick_Identifier__c = quickIdentifier
                        );
                        insert bcl;   
                        
                        bciDetails.add(new CabinetDetail(orderNum, bcl.Id, bladePN));                  
                    }
                    //Sort bciDetails
                    bciDetails.Sort();

                    //Insert/Update Blade Cabinet Inventory Minimum records
                    Blade_Cabinet_Inventory_Minimum__c[] lstBCMIL = new Blade_Cabinet_Inventory_Minimum__c[]{};
                    for(Blade_Cabinet_Inventory_Minimum__c l : [SELECT Id, Current_Inventory_Level__c
                        FROM Blade_Cabinet_Inventory_Minimum__c
                        WHERE Blade_Cabinet__c = :cabinetId])
                    {
                        l.Current_Inventory_Level__c = 0;
                        lstBCMIL.add(l);
                    }
                    if(!lstBCMIL.isEmpty())
                        update lstBCMIL;

                    UpdateBladeCabinetInventory bci = new UpdateBladeCabinetInventory(cabinetId, strAccountID);
                    database.executebatch(bci, 1);
                }
                else
                {
                    testStr = 'Error: Couldn\'t find Blade Cabinet Name: ' + cabName;
                }
            }    
        } catch (Exception e) {
            testStr = e.getMessage();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'salesforce.admin@kadant.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('KadantRestApi Error in ProcessCabinetDetails: ');
            mail.setPlainTextBody('ProcessCabinetDetails: ' + e);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('KadantRestApi Apex Class function UpsertBladeCabinetData Error: ' + e.getMessage());        
        }        
        return testStr;
    } 
    
}