public class PartsOnHandCallOut {
    
    @AuraEnabled
    public static List<List<String>> getstockinfo (String recordId, String sObjectName){
        String strDivision = '';
        String apiKey = '';
        String apiCredentials = '';
        String requestEndPoint = '';
        if(Test.isRunningTest())
            strDivision = 'KL' ;
        String strPart = '';
        if(Test.isRunningTest())
            strPart = 'FILW991' ;
        String searchString = '';
        List<List<String>> PartDetails = new List<List<String>>();
        //List<String> prodDets = new List<String>();
        if(sObjectName == 'Product2'){searchString = 'select id, name, location__c from product2 where id = :recordId'; }
        if(sObjectName != 'Product2'){searchString = 'select id, Name, location__c from product2 where id in (select product2id from '+ sObjectName + ' where id = :recordId)';}
            List<sObject> prodDets = database.query(searchString);
                for(sObject a: prodDets){
                    strDivision = string.valueOf(a.get('Location__c'));
                    strPart = string.valueOf(a.get('Name'));
                system.debug(prodDets);
                }   
                
        if(strDivision == 'KJ'){strDivision = 'KJUS';}   

        String epicorEnv = '';
        List<Division__c> theDiv = [SELECT Epicor_Environment__c FROM Division__c WHERE Epicor_Company_ID__c = :strDivision LIMIT 1];
        if (!theDiv.isEmpty())
        {
            epicorEnv = theDiv[0].Epicor_Environment__c;
        }

        List<Epicor_Environment_Setting__mdt> theEnv = [SELECT API_Key__c, Credentials__c, Request_Endpoint__c FROM Epicor_Environment_Setting__mdt WHERE MasterLabel = :epicorEnv LIMIT 1];
        if (!theEnv.isEmpty())
        {
            apiKey = theEnv[0].API_Key__c;
            requestEndPoint = theEnv[0].Request_Endpoint__c;            
            apiCredentials = theEnv[0].Credentials__c;     
        }

        //only do callout for divisions live on both Epicor and Salesforce
        if(strDivision == 'KJUS' || strDivision == 'KL' || strDivision == 'KCD' || strDivision =='NML' || strDivision =='KJE'){
            requestEndPoint+= 'odata/' + strDivision + '/Erp.BO.PartOnHandWhseSvc/GetPartOnHandWhse';
            system.debug(requestEndPoint);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
    
            request.setEndPoint(requestEndPoint);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            Blob headerValue = Blob.valueOf(apiCredentials);
            String authHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
            request.setHeader('Authorization',authHeader);
            request.setHeader('X-API-Key', apiKey);
    
            String bodycontent = JSON.serialize(
                        new Map<String, Object> {
                            'cPlant' => null,
                            'cPartNum' => strPart                        
                        });
            request.setBody(bodycontent);
            system.debug(bodycontent);
            HttpResponse response = http.send(request);
            System.debug('request : ' + request);
            System.debug('response: ' + response);
            System.debug('responseBody: '+response.getBody());
            if(response.getStatusCode() == 200) {
                // Deserializing the JSON response using the wrapper class
                PartsOnHandWrapper responseWrapper = PartsOnHandWrapper.parse(response.getBody());
                system.debug(responseWrapper.ReturnObj.partonHandWhse);
                                    
                if(responseWrapper.ReturnObj!=null) {
                    for(Integer i=0; i<responseWrapper.ReturnObj.partOnHandWhse.size(); i++) {
                      PartsOnHandWrapper.PartOnHandWhse partinfo = responseWrapper.ReturnObj.partonHandWhse.get(i);
                        system.debug(responseWrapper.ReturnObj.partOnHandWhse.get(i));
                        PartDetails.add(new List<String>{
                            partinfo.WarehouseDesc, 
                            partinfo.QuantityOnHand,
                            partinfo.AllocQty,
                            partinfo.Plant
                            });
                    }
                }
                system.debug(PartDetails);
            }
        }
        return PartDetails;        
    }
}