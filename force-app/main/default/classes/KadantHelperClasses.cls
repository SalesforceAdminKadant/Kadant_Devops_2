/* 
 * Author: David Leland
 * Date: 02/06/2017
 * 
 * Description: This class contains generalized helper classes.
 */

global class KadantHelperClasses{

    /*********************************/
    /* Send a Notification To Kadant */
    /*********************************/
    public static void sendNotification(String strId, String strRequest, String strDivision, String strKeyValue)
    {
        if(System.isBatch() || System.isFuture())
        {
            sendNotificationNotFuture(strId, strRequest, strDivision, strKeyValue);
        }else{
            sendNotificationFuture(strId, strRequest, strDivision, strKeyValue);
        }
    }
    @future (callout=true)
    public static void sendNotificationFuture(String strId, String strRequest, String strDivision, String strKeyValue) {

        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if(!org.IsSandbox || (org.IsSandbox && UserInfo.getUserName().endsWithIgnoreCase('.full') == true))
        {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            string strEndPoint;

            if(strKeyValue != null)
                strKeyValue = EncodingUtil.urlEncode(strKeyValue, 'UTF-8');

            if(!org.IsSandbox)
                strEndPoint = 'https://sfdc.kadant.work';
            else
                strEndPoint = 'https://sfdctest.kadant.work';

            req.setEndpoint(strEndPoint + '/api/v1/Salesforce?information=' + strId + '&todo=' + strRequest + '&division=' + strDivision + '&source=Salesforce' + '&keyvalue=' + strKeyValue);
            req.setTimeout(60000); // Set for 60 seconds
            req.setMethod('GET');
            res = http.send(req);
            if (Test.isRunningTest() == True)
                res.setStatusCode(400);
            if (res.getStatusCode() != 200) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendNotification error has occurred.', 'The following error has occurred when sending a notification: ' + res.toString() + '.');
            }
        }
    }

    public static void sendNotificationNotFuture(String strId, String strRequest, String strDivision, String strKeyValue) {

        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if(!org.IsSandbox || (org.IsSandbox && UserInfo.getUserName().endsWithIgnoreCase('.full') == true))
        {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            string strEndPoint;

            if(strKeyValue != null)
                strKeyValue = EncodingUtil.urlEncode(strKeyValue, 'UTF-8');

            if(!org.IsSandbox)
                strEndPoint = 'https://sfdc.kadant.work';
            else
                strEndPoint = 'https://sfdctest.kadant.work';

            req.setEndpoint(strEndPoint + '/api/v1/Salesforce?information=' + strId + '&todo=' + strRequest + '&division=' + strDivision + '&source=Salesforce' + '&keyvalue=' + strKeyValue);
            req.setTimeout(60000); // Set for 60 seconds
            req.setMethod('GET');
            res = http.send(req);
            if (Test.isRunningTest() == True)
                res.setStatusCode(400);
            if (res.getStatusCode() != 200) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendNotification error has occurred.', 'The following error has occurred when sending a notification: ' + res.toString() + '.');
            }
        }
    }

    /****************************************/
    /* Send Notifications in bulk To Kadant */
    /****************************************/
    @future (callout=true)
    public static void sendNotificationBulk(Set<Id> oalIds)
    {
        //if(System.isBatch() || System.isFuture())
        //{
        //    sendNotificationBulkNotFuture(oalIds);
        //}
        //else
        //{
        //    sendNotificationBulkFuture(oalIds);
        //}

        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if(!org.IsSandbox || (org.IsSandbox && UserInfo.getUserName().endsWithIgnoreCase('.full') == true))
        {
            List<Object_Activity_Log__c> oals = [select Id, Name, Division__c, Key_Value__c, Processed__c From Object_Activity_Log__c Where Id IN :oalIds];
            string strEndPoint;
 
            if(!org.IsSandbox)
                strEndPoint = 'https://sfdc.kadant.work';
            else
                strEndPoint = 'https://sfdctest.kadant.work';

            for(Object_Activity_Log__c o: oals){
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();

                if(o.Key_Value__c != null)
                    o.Key_Value__c = EncodingUtil.urlEncode(o.Key_Value__c, 'UTF-8');
                req.setEndpoint(strEndPoint + '/api/v1/Salesforce?information=' + o.Id + '&todo=' + o.Name + '&division=' + o.Division__c + '&source=Salesforce' + '&keyvalue=' + o.Key_Value__c);
                req.setTimeout(60000); // Set for 60 seconds
                req.setMethod('GET');
                res = http.send(req);
                if (Test.isRunningTest() == True)
                    res.setStatusCode(400);
                if (res.getStatusCode() != 200) {
                    KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendNotification error has occurred.', 'The following error has occurred when sending a notification: ' + res.toString() + '.');
                }
            }
        }
    }

    @future (callout=true)
    public static void sendNotificationBulkFuture(Set<Id> oalIds) {

        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if(!org.IsSandbox || (org.IsSandbox && UserInfo.getUserName().endsWithIgnoreCase('.full') == true))
        {
            List<Object_Activity_Log__c> oals = [select Id, Name, Division__c, Key_Value__c, Processed__c From Object_Activity_Log__c Where Id IN :oalIds];
            string strEndPoint;
 
            if(!org.IsSandbox)
                strEndPoint = 'https://sfdc.kadant.work';
            else
                strEndPoint = 'https://sfdctest.kadant.work';

            for(Object_Activity_Log__c o: oals){
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();

                if(o.Key_Value__c != null)
                    o.Key_Value__c = EncodingUtil.urlEncode(o.Key_Value__c, 'UTF-8');
                req.setEndpoint(strEndPoint + '/api/v1/Salesforce?information=' + o.Id + '&todo=' + o.Name + '&division=' + o.Division__c + '&source=Salesforce' + '&keyvalue=' + o.Key_Value__c);
                req.setTimeout(60000); // Set for 60 seconds
                req.setMethod('GET');
                res = http.send(req);
                if (Test.isRunningTest() == True)
                    res.setStatusCode(400);
                if (res.getStatusCode() != 200) {
                    KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendNotification error has occurred.', 'The following error has occurred when sending a notification: ' + res.toString() + '.');
                }
            }
        }
    }

    public static void sendNotificationBulkNotFuture(Set<Id> oalIds) {

        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if(!org.IsSandbox || (org.IsSandbox && UserInfo.getUserName().endsWithIgnoreCase('.full') == true))
        {
            List<Object_Activity_Log__c> oals = [select Id, Name, Division__c, Key_Value__c, Processed__c From Object_Activity_Log__c Where Id IN :oalIds];
            string strEndPoint;
 
            if(!org.IsSandbox)
                strEndPoint = 'https://sfdc.kadant.work';
            else
                strEndPoint = 'https://sfdctest.kadant.work';

            for(Object_Activity_Log__c o: oals){
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();

                if(o.Key_Value__c != null)
                    o.Key_Value__c = EncodingUtil.urlEncode(o.Key_Value__c, 'UTF-8');
                req.setEndpoint(strEndPoint + '/api/v1/Salesforce?information=' + o.Id + '&todo=' + o.Name + '&division=' + o.Division__c + '&source=Salesforce' + '&keyvalue=' + o.Key_Value__c);
                req.setTimeout(60000); // Set for 60 seconds
                req.setMethod('GET');
                res = http.send(req);
                if (Test.isRunningTest() == True)
                    res.setStatusCode(400);
                if (res.getStatusCode() != 200) {
                    KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendNotification error has occurred.', 'The following error has occurred when sending a notification: ' + res.toString() + '.');
                }
            }
        }
    }

    /*************************************/
    /* Send a plain text email to a user */
    /*************************************/
    public static boolean sendPlainTextEmailToUser(Id idUser, String strSubject, String strBody) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        User[] u1 = [SELECT Id, Email, FirstName FROM User Where Id = :idUser Limit 1];
        if(u1.size() > 0){
            String[] toAddresses = new String[] {u1[0].Email};
            mail.setToAddresses(toAddresses);    // Set the TO addresses
            mail.setSubject(strSubject);    // Set the subject
            mail.setPlainTextBody(strBody);
            if(!Test.isRunningTest()) {
                Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
            }            
            return True;
        }else{
            return False;
        }
    }
    
    /****************************************/
    /* Send a plain text email to a Contact */
    /****************************************/
    public static boolean sendPlainTextEmailToContact(Id idContact, String strSubject, String strBody) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Contact[] cnt = [SELECT Id, Email, FirstName FROM Contact Where Id = :idContact Limit 1];
        if(cnt.size() > 0){
            String[] toAddresses = new String[] {cnt[0].Email};
            mail.setToAddresses(toAddresses);    // Set the TO addresses
            mail.setSubject(strSubject);    // Set the subject
            mail.setPlainTextBody(strBody);
            if(!Test.isRunningTest()) {
                Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
            }            
            return True;
        }else{
            return False;
        }
    }
    
    /***************************/
    /* Send a plain text email */
    /***************************/
    public static boolean sendPlainTextEmail(String strEmail, String strSubject, String strBody){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {strEmail};
        mail.setToAddresses(toAddresses);    // Set the TO addresses
        mail.setSubject(strSubject);    // Set the subject
        mail.setPlainTextBody(strBody);
        if(!Test.isRunningTest()) {
            Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
        return True;
    }

    /*********************************/
    /* Send an SMS text message      */
    /*********************************/
    /* @future (callout=true) */
    Public static void sendSMSTextMessage(String strToPhoneNumber, String strMessage) {
       
        try {
            //Insert Send SMS record
            Send_SMS__c ss = new Send_SMS__c(Phone_Number__c = strToPhoneNumber, Message__c = strMessage);
            insert ss;
        }
            catch (DmlException e) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendSMSTextMessage error has occurred.', 'The following error has occurred when sending an SMS text message: ' + e.getMessage() + '.');
        }
 
        /* HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
 
        req.setEndpoint('https://sfdc.kadant.work/api/v1/Salesforce?phonenumber=' + EncodingUtil.urlEncode(strToPhoneNumber,'UTF-8') + '&message=' + EncodingUtil.urlEncode(strMessage,'UTF-8') + '&sender=Salesforce');
        req.setTimeout(60000); // Set for 60 seconds
        req.setMethod('GET');
        res = http.send(req);
        if (Test.isRunningTest() == True)
            res.setStatusCode(400);
        if (res.getStatusCode() != 200) {
            KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'A sendSMSTextMessage error has occurred.', 'The following error has occurred when sending an SMS text message: ' + res.toString() + '.');
        } */
    }

    /************************************/
    /* Send an email template to a User */
    /************************************/
    public static boolean sendEmailTemplate(String strTemplateName, Id userId, Id whatId){
    
        EmailTemplate[] emailTemplate = [select Id from EmailTemplate where Name = :strTemplateName Or DeveloperName = :strTemplateName Limit 1];
        if(emailTemplate.size() > 0){
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate[0].Id, userId, whatId);

            String emailSubject = email.getSubject();
            String emailTextBody = email.getPlainTextBody();

            email.setTargetObjectId(userId);
            email.setSubject(emailSubject);
            email.setPlainTextBody(emailTextBody);
            email.saveAsActivity = false;

            if(!Test.isRunningTest()) {
                Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        
            return True;
        }else{
            return False;
        }
    }

    /*******************************************************/
    /* Submit a request for approval as a future execution */
    /*******************************************************/
    @future
    public static void SubmitForApproval(Id idInc, String strComments)
    {   
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        //req.setComments(strComments);
        req.setObjectId(idInc);
        // submiting the approval request for processing
        Approval.ProcessResult result = Approval.process(req);
    }    

    // class method to re-upload a given opportunity
    // returns a string that indicates success or failure
    webservice static String reuploadOpportunity(Id oppId) {

        try {
            Opportunity opp = [Select Id, Division__c, External_Order_Number__c From Opportunity Where Id = :oppId LIMIT 1];
            //Insert object activity log record
            Object_Activity_Log__c oal = new Object_Activity_Log__c(Name='RefreshOpportunity',
                            Division__c = opp.Division__c,
                            Object_Id__c = opp.Id,
                            Operation__c = 'Insert',
                            Processed__c = False,
                            Date_Processed__c = Null,
                            Key_Value__c = opp.External_Order_Number__c);
            insert oal;
        }
            catch (DmlException e) {
                return e.getMessage();
        }

        // on success, return a message to the calling program
        return 'Opportunity refresh successfully requested.'; 
    }

    /*********************************************/
    /* Write a record to the Object Activity Log */
    /*********************************************/
    public static void WriteObjectActivityLog(String strName, String strDivision, Id objId, String strOperation, String strKeyValue)
    {
        if(System.isBatch() || System.isFuture())
        {
            WriteObjectActivityLogNotFuture(strName, strDivision, objId, strOperation, strKeyValue);
        }else{
            WriteObjectActivityLogFuture(strName, strDivision, objId, strOperation, strKeyValue);
        }
    }
    webservice static boolean WriteObjectActivityLogFuture(String strName, String strDivision, Id objId, String strOperation, String strKeyValue){
    
        try {
            //Insert object activity log record
            if(strKeyValue != null && strKeyValue.Length() > 100)
                strKeyValue = strKeyValue.Substring(0, 100);
            Object_Activity_Log__c oal = new Object_Activity_Log__c(Name=strName,
                Division__c = strDivision,
                Object_Id__c = objId,
                Operation__c = strOperation,
                Processed__c = False,
                Date_Processed__c = Null,
                Key_Value__c = strKeyValue);
            insert oal;
            return true;
        }
            catch (Exception e) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'An error has occurred in WriteObjectActivityLog.', 'The following error has occurred in the WriteObjectActivityLog function: ' + e.getMessage() + '.');
                return false;
        }
    }
    static boolean WriteObjectActivityLogNotFuture(String strName, String strDivision, Id objId, String strOperation, String strKeyValue){
    
        try {
            //Insert object activity log record
            if(strKeyValue != null && strKeyValue.Length() > 100)
                strKeyValue = strKeyValue.Substring(0, 100);
            Object_Activity_Log__c oal = new Object_Activity_Log__c(Name=strName,
                Division__c = strDivision,
                Object_Id__c = objId,
                Operation__c = strOperation,
                Processed__c = False,
                Date_Processed__c = Null,
                Key_Value__c = strKeyValue);
            insert oal;
            return true;
        }
            catch (Exception e) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'An error has occurred in WriteObjectActivityLog.', 'The following error has occurred in the WriteObjectActivityLog function: ' + e.getMessage() + '.');
                return false;
        }
    }

    /***********************************************/
    /* Remove all files from a given Object Record */
    /***********************************************/
    public static boolean RemoveFiles(String strId){
 
        try {
            List<ContentDocument> lstCD = new List<ContentDocument>();
            for(ContentDocumentLink objCDL : [SELECT Id, ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :strId])
            {
                for(ContentDocument objCD : [SELECT Id
                    FROM ContentDocument
                    WHERE Id = :objCDL.ContentDocumentId])
                {
                    lstCD.add(objCD);
                }
            }
            if(!lstCD.isEmpty())
                delete lstCD;
            return true;
        }
            catch (Exception e) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'An error has occurred in RemoveFiles.', 'The following error has occurred in the RemoveFiles function: ' + e.getMessage() + '.');
                return false;
        }
    }

    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static List<List<String>> GetCustomerPricing(String strRecordID, String strObjectName, Map<Id,String> SelectedPartMap){

        List<List<String>> CustomerPricingList = new List<List<String>>();
        String sSectionHasData = '0';

        String selectedParts = '@';
        for (id prod2ID:SelectedPartMap.keySet()) {
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        selectedParts = selectedParts.Replace('@,','');           
        
        String sSQL = 'SELECT accountId, account.ParentTextID__c, CurrencyIsoCode, account.Name, account.ParentTextName__c FROM ' 
                + strObjectName + ' WHERE Id =\'' + strRecordID +'\' LIMIT 1';
        List<sObject>  q = Database.query(sSQL);
        //system.debug(q);

        String sCustomerID = String.valueOf(q[0].get('accountId'));
        String sParentID = String.valueOf( q[0].getSobject('Account').get('ParentTextID__c') );
     
        String selectedAccountId = '\'' + sCustomerID + '\'';
        String selectedParentId ='';
        if(sParentID !='NA'){ selectedParentId = ',\'' + sParentID + '\''; }
        String selectedAccounts = selectedAccountId + selectedParentId;
           
        sSQL = 'select product__c, customer_item__c, price__c, price_agreement_header__r.Account__c  FROM Price_Agreement_detail__c WHERE ' 
                + ' CurrencyIsoCode=\'' + q[0].Get('CurrencyIsoCode') + '\'' 
                + ' AND Product__c in(' + selectedParts + ')' 
                + ' AND price_agreement_header__r.Account__c in(' + selectedAccounts + ') ' 
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
        
        for (id prod2ID:SelectedPartMap.keySet()) {
        
            QuoteLineItem[] ql = [SELECT Quote.Quotenumber, Quote.Quote_Date__c, Quantity, UnitPrice, currencyisocode FROM quotelineitem WHERE Quote.Opportunity.AccountId=:sCustomerID AND Product2Id=:prod2ID ORDER BY Quote.Quote_Date__c DESC LIMIT 5];
            for (QuoteLineItem sobj:ql) {
                CustomerPricingList.add(new List<String>{
                    String.valueOf(prod2ID),
                    'Quote history: ',
                    String.valueOf(sobj.Quote.Quotenumber)+' ',
                    String.valueOf(sobj.Quote.Quote_Date__c),
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('currencyisocode'))
                });
                if(String.valueOf(sobj.get('UnitPrice'))!=''){sSectionHasData = '1';}
            }
            
            OrderItem[] ol = [SELECT Order.Name, Order.effectivedate, Quantity, UnitPrice, currencyisocode FROM orderitem WHERE order.AccountId=:sCustomerID AND Product2Id=:prod2ID and order.Sale_Type__c in('D','ICO') ORDER BY order.effectivedate DESC LIMIT 5];
            for (OrderItem sobj:ol) {
                CustomerPricingList.add(new List<String>{
                    String.valueOf(prod2ID),
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
                String.valueOf(prod2ID),
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
    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static List<List<String>> GetProductPricing(String strRecordID, String strObjectName, Map<Id,String> SelectedPartMap, Map<Id,String> SelectedPartMapQty){

        //map of selected parts sorted by product ID
        Map<String,List<String>> DocLinesListMap = new Map<String,List<String>>();
        
        //map of selected parts re-sorted by order of selection
        List<List<String>> DocLinesList = new List<List<String>>();
        
        String sSQL = 'SELECT Pricebook2ID, CurrencyIsoCode, Account_Standard_Discount__c FROM ' + strObjectName + ' WHERE Id =\'' + strRecordID +'\' LIMIT 1';
        sObject[] MainRec = Database.query(sSQL); 

        String DefaultDiscount = '0';        
        if(MainRec[0].get('Account_Standard_Discount__c')!=null){
            DefaultDiscount = String.valueOf(MainRec[0].get('Account_Standard_Discount__c')).replace('null','0');
        }
         
        String selectedParts = '@';
        for (id prod2ID:SelectedPartMap.keySet()) {
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        
        selectedParts = selectedParts.Replace('@,','');
            
        sSQL = 'SELECT Product2Id, Product2.Name, Product2.Description, unitprice, Product2.No_Approval_Required__c FROM PricebookEntry WHERE isactive=true  AND Product2Id in(' +
                selectedParts + ')'+
                ' AND currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\'' +
                ' AND Pricebook2ID=\''+ MainRec[0].get('Pricebook2ID') + '\'' +
                ' ORDER BY Product2.name';
        List<PricebookEntry> pbe = Database.query(sSQL);
        
        String ApplyDiscount = '0';
        for (PricebookEntry sobj : pbe){
            
            if(sobj.Product2.No_Approval_Required__c==True){ ApplyDiscount='0'; } else { ApplyDiscount = DefaultDiscount;}
            
            DocLinesListMap.put(String.valueOf(sobj.get('Product2Id')),new List<String>{
                String.valueOf(sobj.get('Product2Id')),
                String.valueOf(sobj.Product2.Name)+' ',
                String.valueOf(sobj.Product2.Description)+' ',
                String.valueOf(sobj.get('unitprice')),
                String.valueOf(MainRec[0].get('CurrencyIsoCode')),                
                String.valueOf(SelectedPartMapQty.get(String.valueOf(sobj.get('Product2Id')))),
                ApplyDiscount    
            });      
        
        }
        
        //re-sort DocLinesListMap in order of selection
        for (id prod2ID:SelectedPartMap.keySet()) {
            DocLinesList.add(DocLinesListMap.get(String.valueOf(prod2ID)));
        }
        
        system.debug(DocLinesList);
        
        Return DocLinesList;
    }
    
    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static boolean AddQuoteLines(String strQuoteRecordID, Map<Id,String> SelectedPartMap, String lineQTY, String lineUP, String lineDC, String lineSPEC){
   
        Decimal nLine_no = 0;
        Decimal nQuantity = 1;
        Decimal nUnitPrice = 0;
        String tmpKey ='';
        String tmpVal ='';
        List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();

        //######### line quantities
        Map<string, Decimal> lineQTYlist = new Map<string, Decimal>();
        List<Object> lineQTYobjects = (List<Object>)System.JSON.deserializeUntyped(lineQTY);
        for (Object lineQTYobject : lineQTYobjects) {
            system.debug(String.valueof(lineQTYobject));
            lineQTYlist.put(String.valueof(lineQTYobject).split(',')[0].replace('key=qty','').replace('{',''), Decimal.valueOf(String.valueof(lineQTYobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        
        //######### line prices
        Map<string, Decimal> lineUPlist = new Map<string, Decimal>();
        List<Object> lineUPobjects = (List<Object>)System.JSON.deserializeUntyped(lineUP);
        for (Object lineUPobject : lineUPobjects) {
            system.debug(String.valueof(lineUPobject));
            lineUPlist.put(String.valueof(lineUPobject).split(',')[0].replace('key=up','').replace('{',''), Decimal.valueOf(String.valueof(lineUPobject).split(',')[1].replace(' value=','').replace('}','')));
        }
      
        
        //######### line disc
        Map<string, Decimal> lineDClist = new Map<string, Decimal>();
        List<Object> lineDCobjects = (List<Object>)System.JSON.deserializeUntyped(lineDC);
        for (Object lineDCobject : lineDCobjects) {
            system.debug(String.valueof(lineDCobject));
            lineDClist.put(String.valueof(lineDCobject).split(',')[0].replace('key=disc','').replace('{',''), Decimal.valueOf(String.valueof(lineDCobject).split(',')[1].replace(' value=','').replace('}','')));
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
        
        system.debug(Specs);
        
        //######### get quote header and line details
        Quote[] q = [ SELECT Pricebook2ID, CurrencyIsoCode FROM Quote WHERE Id=:strQuoteRecordID LIMIT 1];
        QuoteLineItem[] ql = [ SELECT Line_No__c FROM QuoteLineItem WHERE QuoteId=:strQuoteRecordID AND Line_No__c > 0 ORDER BY Line_No__c DESC LIMIT 1 ];
        if(!ql.isEmpty()){ 
            nLine_no = ql[0].Line_No__c;
        }
        
        //######### insert quote lines       
        
        for (id prod2ID:SelectedPartMap.keySet()) {

            lineSpecs='';
            if(String.valueof(prod2ID)==prodid){lineSpecs=Specs;} 
            //system.debug(String.valueof(prod2ID));
           
            nLine_no = nLine_no+1;
            PricebookEntry[] pb = [ SELECT Id FROM PricebookEntry WHERE Pricebook2Id=:q[0].Pricebook2ID AND Product2Id=:prod2ID AND CurrencyIsoCode=:q[0].CurrencyIsoCode LIMIT 1];

            if(!pb.isEmpty()){

                lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2ID),
                            UnitPrice = lineUPlist.get(prod2ID), 
                            Discount = lineDClist.get(prod2ID),
                            Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );
            }

        }
        
        if(!lstQLI.isEmpty()){
            insert lstQLI;
        }

        return true;
    }    

    
    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static boolean AddOpportunityLines(String strQuoteRecordID, Map<Id,String> SelectedPartMap, String lineQTY, String lineUP, String lineDC){
   
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
            system.debug(String.valueof(lineQTYobject));
            lineQTYlist.put(String.valueof(lineQTYobject).split(',')[0].replace('key=qty','').replace('{',''), Decimal.valueOf(String.valueof(lineQTYobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        
        //######### line prices
        Map<string, Decimal> lineUPlist = new Map<string, Decimal>();
        List<Object> lineUPobjects = (List<Object>)System.JSON.deserializeUntyped(lineUP);
        for (Object lineUPobject : lineUPobjects) {
            system.debug(String.valueof(lineUPobject));
            lineUPlist.put(String.valueof(lineUPobject).split(',')[0].replace('key=up','').replace('{',''), Decimal.valueOf(String.valueof(lineUPobject).split(',')[1].replace(' value=','').replace('}','')));
        }
      
        
        //######### line disc
        Map<string, Decimal> lineDClist = new Map<string, Decimal>();
        List<Object> lineDCobjects = (List<Object>)System.JSON.deserializeUntyped(lineDC);
        for (Object lineDCobject : lineDCobjects) {
            system.debug(String.valueof(lineDCobject));
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
    

    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
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
    
   
    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static List<List<String>> GetBladeDetails(String sRecordTypeId){
        
            String searchQuery = '';
            String strPartSelected = null;
        
            List<List<String>> searchResultsString = new List<List<String>>();     
            List<Blade_Details__c> searchResults = new List<Blade_Details__c>(); 
            
            
            searchQuery = 'SELECT Blade_Name__r.id, Blade_Name__r.name, id, width__c, thickness__c,'
                    + ' ICP_Per_Unit__c, Price_Per_Unit__c, CurrencyIsoCode, unit_of_measure__c'
                    + ' FROM Blade_details__c '
                    + ' WHERE blade_Name__r.RecordTypeId=\'' + sRecordTypeId + '\' and blade_Name__r.standard__c=True '
                    + ' and blade_Name__r.active__c=True ORDER BY blade_Name__r.name, width__c, thickness__c';
            
            searchResults = Database.query(searchQuery);
           
            for (Blade_Details__c sobj : searchResults){                    
                                                  
                    searchResultsString.add(new List<String>{
                            String.valueOf(sobj.getSobject('Blade_Name__r').get('id')),
                            String.valueOf(sobj.getSobject('Blade_Name__r').get('name')),
                            String.valueOf(sobj.get('id')),
                            String.valueOf(Double.valueOf(sobj.get('width__c'))),
                            String.valueOf(Double.valueOf(sobj.get('thickness__c'))),
                            String.valueOf(Double.valueOf(sobj.get('Price_Per_Unit__c'))),
                            String.valueOf(sobj.get('CurrencyIsoCode')),
                            String.valueOf(sobj.get('unit_of_measure__c'))
                    });

            }

            /*
              ,

                            String.valueOf(Double.valueOf(sobj.get('Price_Per_Unit__c'))).replace('null','0'),

             */
        
            system.debug(searchResultsString);
            return searchResultsString;
    }
    
    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static List<List<String>> searchForParts(String strRecordID, String strObjectName, String searchText, String searchFilter, Map<String,String> SelectedPartMap){
   
       String searchQuery = '';
       String strPartSelected = null;
       String strPreviouslyOrdered = 'N';
       String PreviousPart ='';
       List<Product2> searchResults = new List<Product2>();                   
       List<OrderItem> searchResults3 = new List<OrderItem>(); 
       List<List<String>> searchResultsString = new List<List<String>>();
       Map<String,String> PrevOrderedMap = new Map<String,String>();
       
       
       String sSQL = 'SELECT CurrencyIsoCode, AccountID FROM ' + strObjectName + ' WHERE Id =\'' + strRecordID +'\'';
       sObject[] MainRec = Database.query(sSQL);
        
       String strJointFields = ' Joint_M_Size__c, Joint_M_Size_UOM__c,Joint_M_Type__c, Joint_M_Thread_Direction__c, ' +
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
                searchQuery = 'SELECT Id, Name, Description, ProductCode, '+
                    strJointFields +
                    strBladeFields +
                    ' IsActive FROM Product2 WHERE IsActive=true ' + searchFilter +                
                    ' AND Id IN(SELECT Product2Id FROM PricebookEntry WHERE currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\')' +
                    ' ORDER BY name LIMIT 100';
                searchResults = Database.query(searchQuery);
            }


            //######### if the search bar is has a value, use the salesforce find function ############
            if(searchText !=''){
                searchQuery = 'FIND \'' + searchText + '\' IN ALL FIELDS RETURNING ' +
                    ' Product2(Id, Name, Description, ProductCode, ' +
                    strJointFields +
                    strBladeFields +
                    ' IsActive WHERE IsActive=true ' + searchFilter +
                    ' AND Id IN(SELECT Product2Id FROM PricebookEntry WHERE currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\')' +
                    ' ORDER BY name LIMIT 100)';
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
                
                    searchResultsString.add(new List<String>{
                            sobj.Id,
                            String.valueOf(sobj.get('Name')),
                            String.valueOf(sobj.get('Description'))+' ',
                            String.valueOf(sobj.get('ProductCode')),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null',''),
                            String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' '   ).replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Material__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_Nipple_Size__c')))+sobj.get('Joint_Nipple_Size_UOM__c')+' '+sobj.get('Joint_Nipple_Type__c')+' '+sobj.get('Joint_Nipple_Thread_Direction__c')).replace('null',''),                       
                            strPreviouslyOrdered,  
                            strPartSelected
                    });      
            }
       } else {
           //######### collect customer selling history ###########
           //
           //
           String searchTextSQL = searchFilter.replace('HISTORY','');
           
           String strJointFldExplicit = ' product2.Joint_M_Size__c, product2.Joint_M_Size_UOM__c, product2.Joint_M_Type__c, product2.Joint_M_Thread_Direction__c, ' +
                                ' product2.Joint_P_Size__c, product2.Joint_P_Size_UOM__c, product2.Joint_P_Type__c, product2.Joint_P_Thread_Direction__c, ' +
                                ' product2.Joint_S_Size__c, product2.Joint_S_Size_UOM__c, product2.Joint_S_Type__c, product2.Joint_S_Thread_Direction__c, ' +
                                ' product2.Joint_Nipple_Size__c, product2.Joint_Nipple_Size_UOM__c, product2.Joint_Nipple_Type__c, product2.Joint_Nipple_Thread_Direction__c, ' +
                                ' product2.Joint_Seal_Material__c, product2.Joint_Temperature__c, product2.Joint_Temperature_UOM__c, ' +
                                ' product2.Joint_Pressure__c, product2.Joint_Pressure_UOM__c, ';
       
            String strBladeFldExplicit = ' product2.BLD_Application__c, product2.BLD_Bevel_Angle__c, product2.BLD_CTL_Machine_Index__c, ' +
                                ' product2.BLD_Holder_Type__c, product2.BLD_KUK_Reference_Code__c, product2.BLD_Length__c, ' + 
                                ' product2.BLD_Machine_No__c, product2.BLD_Material__c, product2.BLD_Thickness__c, product2.BLD_Width__c, ';
           
           If(searchText !=''){
               //for multiple words we can split the field by spaces into an array and add AND filters sequential...
               //version 1 just support one word
               searchTextSQL = searchTextSQL + ' AND (product2.Name like \'%'+searchText+'%\' OR product2.Description like \'%'+searchText+'%\')';
           }
           
            searchQuery = 'SELECT product2.Id, product2.Name, product2.Description, product2.ProductCode, order.name, order.effectivedate, UnitPrice, '+
                    strJointFldExplicit +
                    strBladeFldExplicit +
                    ' order.currencyisocode, product2.IsActive FROM orderitem WHERE product2.IsActive=true ' +  
                    ' AND order.sale_type__c!=\'ICI\'' +
                    ' AND order.accountid=\'' + MainRec[0].get('AccountID') + '\' ' +
                    searchTextSQL + 
                    ' ORDER BY product2.Name, order.effectivedate DESC';
            
           searchResults3 = Database.query(searchQuery);
           
            PreviousPart ='';
            for (OrderItem sobj : searchResults3){                  
                
                    if(SelectedPartMap.containsKey( String.valueOf(sobj.getSobject('Product2').get('Id')) )) {strPartSelected = 'PartSelected';} else {strPartSelected = null;}
                                    
                    if(PreviousPart != String.valueOf(sobj.getSobject('Product2').get('Id')) )
                    {
                        searchResultsString.add(new List<String>{
                            String.valueOf(sobj.getSobject('Product2').get('Id')),
                            String.valueOf(sobj.getSobject('Product2').get('Name'))+' ',
                            String.valueOf(sobj.getSobject('Product2').get('Description'))+' ',
                            String.valueOf(sobj.getSobject('Product2').get('ProductCode')),
                            String.valueOf(sobj.getSobject('order').get('name')),
                            String.valueOf(sobj.getSobject('order').get('effectivedate')).left(10),
                            String.valueOf( String.valueOf(Decimal.valueOf(Double.valueOf(sobj.get('UnitPrice'))).setScale(2))+' '+sobj.getSobject('order').get('currencyisocode')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_M_Size__c')))+sobj.getSobject('Product2').get('Joint_M_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_M_Type__c')+' '+sobj.getSobject('Product2').get('Joint_M_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_P_Size__c')))+sobj.getSobject('Product2').get('Joint_P_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_P_Type__c')+' '+sobj.getSobject('Product2').get('Joint_P_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_S_Size__c')))+sobj.getSobject('Product2').get('Joint_S_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_S_Type__c')+' '+sobj.getSobject('Product2').get('Joint_S_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_Nipple_Size__c')))+sobj.getSobject('Product2').get('Joint_Nipple_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_Nipple_Type__c')+' '+sobj.getSobject('Product2').get('Joint_Nipple_Thread_Direction__c')).replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('Joint_Seal_Material__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.getSobject('Product2').get('Joint_Temperature__c')))+sobj.getSobject('Product2').get('Joint_Temperature_UOM__c')+' '   ).replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Length__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Material__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Thickness__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Width__c')+' ').replace('null',''),
                            strPreviouslyOrdered,
                            strPartSelected
                        });
                    }
                
                    PreviousPart = String.valueOf(sobj.getSobject('Product2').get('Id'));
                }
       }
        return searchResultsString;
    }
    
    
     /**********************************************************************************/
    /* The following function is used in the Generic Product Search custom application */
    /***********************************************************************************/
    @AuraEnabled
    public static String GetDefaultProductDivision() {
        Id userId = UserInfo.getUserId();
        List<User> sDefaultProductDivision = New List<User>();
        sDefaultProductDivision = [SELECT Default_Product_Division__c FROM User WHERE Id = :userId];
        //return sDefaultProductDivision[0];
        return String.valueOf(sDefaultProductDivision[0].get('Default_Product_Division__c'));
    }

    
    /******************************************************************************************/
    /* The following function is used in the Generic Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static List<List<String>> searchForPartsGeneric( String searchText, String searchFilter, Map<String,String> SelectedDivisionMap){

       String searchQuery = '';
        
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
                                ' Joint_P_Size__c, Joint_P_Size_UOM__c,Joint_P_Type__c, Joint_P_Thread_Direction__c, ' +
                                ' Joint_S_Size__c, Joint_S_Size_UOM__c,Joint_S_Type__c, Joint_S_Thread_Direction__c, ' +
                                ' Joint_Seal_Material__c, ' +
                                ' Joint_Temperature__c, Joint_Temperature_UOM__c, ' +
                                ' Joint_Pressure__c, Joint_Pressure_UOM__c, ';
       
       String strBladeFields = ' BLD_Application__c, BLD_Bevel_Angle__c, BLD_CTL_Machine_Index__c, BLD_Holder_Type__c, ' +
                                ' BLD_KUK_Reference_Code__c, BLD_Length__c, BLD_Machine_No__c, BLD_Material__c, ' +
                                ' BLD_Thickness__c, BLD_Width__c, ';
        

       
        //######### if the search bar is empty, default with database query ############
        if(searchText ==''){
                searchQuery = 'SELECT Id, Name, Description, ProductCode, '+
                    strJointFields +
                    strBladeFields +
                    ' Product_Division__c, ' +
                    ' IsActive FROM Product2 WHERE IsActive=true ' + searchFilter +                
                    ' AND Product_Division__c IN(' + SelectedDivisionSQL  + ') ' +
                    ' ORDER BY name LIMIT 200';
                searchResults = Database.query(searchQuery);
        }


        //######### if the search bar is has a value, use the salesforce find function ############
        if(searchText !=''){
                searchQuery = 'FIND \'' + searchText + '\' IN ALL FIELDS RETURNING ' +
                    ' Product2(Id, Name, Description, ProductCode, ' +
                    strJointFields +
                    strBladeFields +
                    ' Product_Division__c, ' +
                    ' IsActive WHERE IsActive=true ' + searchFilter +
                    ' AND Product_Division__c IN(' + SelectedDivisionSQL  + ') ' +
                    ' ORDER BY name LIMIT 200)';
                List<List<sObject>> searchResults2 = search.query(searchQuery);
               
                for (List<SObject> sobjs : searchResults2) {
                    for (SObject sobj : sobjs) { searchResults.add((Product2) sobj); }
                }
        }



        //######### prepare array for return value ############
        for (Product2 sobj : searchResults){
                
                    searchResultsString.add(new List<String>{
                            sobj.Id,
                            String.valueOf(sobj.get('Name')),
                            String.valueOf(sobj.get('Description'))+' ',
                            String.valueOf(sobj.get('ProductCode')),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null',''),
                            String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' '   ).replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Material__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('Product_Division__c')).replace('null','')
                    });

        }
        return searchResultsString;

    }
    
    /******************************************************************************************/
    /* The following function is used in the customer PSG-E Product Search custom application */
    /******************************************************************************************/
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        //system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
        fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
               
    /*****************************************************************************/
    /* Get the actual character from the integer representation of the character */
    /*****************************************************************************/
    public static String chr( integer x ) {
        return String.fromCharArray( new integer[] { x } );
    }

    /******************************************************************************************/
    /* The following function is used in KAI-ReturnOrder_Copy_Lines - get source order lines  */
    /******************************************************************************************/
    @AuraEnabled
    public static List<List<String>> getSourceOrderLines(String strRecordID){
        
            String searchQuery = '';
            String OrderId = '';
            List<List<String>> TargetOrderLines = new List<List<String>>();

            List<ReturnOrder> ListReturnOrder = new List<ReturnOrder>();      
            searchQuery = 'SELECT OrderId FROM ReturnOrder WHERE Id=\'' + strRecordID + '\'';
            ListReturnOrder = Database.query(searchQuery);
        

            List<Order> SourceOrder = new List<Order>();
            searchQuery = 'SELECT name, account.name from order where id=\'' + ListReturnOrder[0].get('OrderId') + '\'';
            SourceOrder = Database.query(searchQuery);  
                
        
            List<OrderItem> SourceOrderLines = new List<orderItem>();
            searchQuery = 'SELECT id, line_no__c, quantity, product2.id, product2.name, product2.description from orderitem '
                +' where orderid=\'' + ListReturnOrder[0].get('OrderId') + '\' order by line_no__c';
            SourceOrderLines = Database.query(searchQuery);  
        

            For (OrderItem sobj : SourceOrderLines){                    
                                    
                    TargetOrderLines.add(new List<String>{
                            String.valueOf(SourceOrder[0].get('name')),
                            String.valueOf(SourceOrder[0].getSobject('account').get('name')),                                
                            String.valueOf(sobj.get('line_no__c')),
                            String.valueOf(sobj.get('quantity')),
                            String.valueOf(sobj.getSobject('product2').get('id')),
                            String.valueOf(sobj.getSobject('product2').get('name')),
                            String.valueOf(sobj.getSobject('product2').get('description'))
                    });

            }
    
            return TargetOrderLines;
    }

}