trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, before delete, after insert) {

    //Before trigger
    if(trigger.isBefore){

        //Insert
        if(trigger.isInsert){
            doBeforeInsertStuff(trigger.new);
        }

        //Delete
        if(trigger.isDelete){
            doDeleteStuff(trigger.old);
        }
    }

    //After trigger
    if(trigger.isAfter){

        //Insert
        if(trigger.isInsert){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }

    }


    //Following method is to Before Insert stuff
    private static void doBeforeInsertStuff(list<ContentDocumentLink> lstQRsNew){
    
        for(ContentDocumentLink objCDL : lstQRsNew)
        {
            objCDL.Visibility = 'AllUsers';
        }

    }

    //Following method is to Delete stuff
    private static void doDeleteStuff(list<ContentDocumentLink> lstQRsOld){
    
        List<Quote_Request__c> lstQR = new List<Quote_Request__c>();
        List<Drawing__c> lstDrawing = new List<Drawing__c>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<Account> lstAcct = new List<Account>();
        List<Quote> lstQuote = new List<Quote>();
        List<Order> lstOrder = new List<Order>();
        List<Case> lstCase = new List<Case>();
        List<Request_for_Test__c> lstRFT = new List<Request_for_Test__c>();
        string strObject;

        for(ContentDocumentLink objCDL : lstQRsOld)
        {
            strObject = findObjectNameFromRecordIdPrefix(objCDL.LinkedEntityId);

            if(strObject == 'Quote_Request__c')
            {
                for(Quote_Request__c objQR : [SELECT Id, Number_Of_Attachments__c
                    FROM Quote_Request__c
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objQR.Number_Of_Attachments__c -= 1;
                    lstQR.add(objQR);
                }
            }
            if(strObject == 'Request_for_Test__c')
            {
                for(Request_for_Test__c objRFT : [SELECT Id, No_of_Files__c
                    FROM Request_for_Test__c
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objRFT.No_of_Files__c -= 1;
                    lstRFT.add(objRFT);
                }
            }
            if(strObject == 'Drawing__c')
            {
                for(Drawing__c objDrawing : [SELECT Id, Number_Of_Files__c
                    FROM Drawing__c
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objDrawing.Number_Of_Files__c -= 1;
                    lstDrawing.add(objDrawing);
                }
            }
            if(strObject == 'Opportunity')
            {
                for(Opportunity objOpp : [SELECT Id, No_of_Files__c
                    FROM Opportunity
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objOpp.No_of_Files__c -= 1;
                    if(!lstOpp.Contains(objOpp))
                        lstOpp.add(objOpp);
                }
            }
            if(strObject == 'Account')
            {
                for(Account objAcct : [SELECT Id, No_of_Files__c
                    FROM Account
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objAcct.No_of_Files__c -= 1;
                    lstAcct.add(objAcct);
                }
            }
            if(strObject == 'Quote')
            {
                for(Quote objQuote : [SELECT Id, No_of_Files__c
                    FROM Quote
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objQuote.No_of_Files__c -= 1;
                    lstQuote.add(objQuote);
                }
            }
            if(strObject == 'Order')
            {
                for(Order objOrder : [SELECT Id, No_of_Files__c
                    FROM Order
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objOrder.No_of_Files__c -= 1;
                    lstOrder.add(objOrder);
                }
            }
            if(strObject == 'Case')
            {
                for(Case objCase : [SELECT Id, No_of_Files__c
                    FROM Case
                    WHERE Id = :objCDL.LinkedEntityId])
                {
                    objCase.No_of_Files__c -= 1;
                    lstCase.add(ObjCase);
                }
            }

        }

        if(!lstQR.isEmpty())
            update lstQR;
        if(!lstDrawing.isEmpty())
            update lstDrawing;
        if(!lstOpp.isEmpty())
            update lstOpp;
        if(!lstAcct.isEmpty())
            update lstAcct;
        if(!lstQuote.isEmpty())
            update lstQuote;
        if(!lstOrder.isEmpty())
            update lstOrder;
        if(!lstCase.isEmpty())
            update lstCase;
        if(!lstRFT.isEmpty())
            update lstRFT;

    }

    //Following method is to do "after" stuff
    private static void doAfterStuff(list<ContentDocumentLink> lstQRsNew, map<Id,ContentDocumentLink> mapQRsNew, map<Id,ContentDocumentLink> mapQRsOld, String strOperation){

        List<Quote_Request__c> lstQR = new List<Quote_Request__c>();
        List<Drawing__c> lstDrawing = new List<Drawing__c>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<Account> lstAcct = new List<Account>();
        List<Quote> lstQuote = new List<Quote>();
        List<Order> lstOrder = new List<Order>();
        List<Case> lstCase = new List<Case>();
        List<Request_for_Test__c> lstRFT = new List<Request_for_Test__c>();
        String strObject;
        Map<Id, Id> accountCDLinkId = new Map<Id, Id>();
        Map<String, String> checkForDupMap = new Map<String, String>();
        String strKey;
        String strProfileId = UserInfo.getProfileId();

        for(ContentDocumentLink objCDL : lstQRsNew)
        {
            //Don't allow adding file to locked record, except for Pricing Requests
            string s1 = objCDL.LinkedEntityId;
            if(Approval.isLocked(objCDL.LinkedEntityId) && s1.left(3) != 'a7q' && s1.left(3) != 'a3C' && strProfileId != '00e0z0000016CREAA2' && strProfileId != '00e30000000mKuxAAE' && strProfileId != '00e60000001BgSxAAK' && strProfileId != '00e0z000001BhVOAA0')
            {
                objCDL.addError('Record is locked. File attachments are not allowed.');
            }
            else
            {
                strObject = findObjectNameFromRecordIdPrefix(objCDL.LinkedEntityId);

                if(strObject == 'Quote_Request__c')
                {
                    for(Quote_Request__c objQR : [SELECT Id, Number_Of_Attachments__c
                        FROM Quote_Request__c
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objQR.Number_Of_Attachments__c == null)
                            objQR.Number_Of_Attachments__c = 0;
                        objQR.Number_Of_Attachments__c += 1;
                        if (!lstQR.contains(objQR))
                            lstQR.add(objQR);
                    }
                }
                if(strObject == 'Request_for_Test__c')
                {
                    for(Request_for_Test__c objRFT : [SELECT Id, No_of_Files__c
                        FROM Request_for_Test__c
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objRFT.No_of_Files__c == null)
                            objRFT.No_of_Files__c = 0;
                        objRFT.No_of_Files__c += 1;
                        if (!lstRFT.contains(objRFT))
                            lstRFT.add(objRFT);
                    }
                }
                if(strObject == 'Drawing__c')
                {
                    for(Drawing__c objDrawing : [SELECT Id, Number_Of_Files__c
                        FROM Drawing__c
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objDrawing.Number_Of_Files__c == null)
                            objDrawing.Number_Of_Files__c = 0;
                        objDrawing.Number_Of_Files__c += 1;
                        if (!lstDrawing.contains(objDrawing))
                            lstDrawing.add(objDrawing);
                    }
                }
                if(strObject == 'Opportunity')
                {
                    for(Opportunity objOpp : [SELECT Id, No_of_Files__c, AccountId
                        FROM Opportunity
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objOpp.No_of_Files__c == null)
                            objOpp.No_of_Files__c = 0;
                        objOpp.No_of_Files__c += 1;
                        if (!lstOpp.contains(objOpp))
                            lstOpp.add(objOpp);
                        strKey = String.valueOf(objOpp.AccountId) + String.valueOf(objOpp.AccountId);
                        if (!checkForDupMap.ContainsKey(strKey))
                        {
                            checkForDupMap.put(strKey, strKey);
                            accountCDLinkId.put(objOpp.AccountId, objCDL.ContentDocumentId);
                        }
                    }
                }
                if(strObject == 'Account')
                {
                    for(Account objAcct : [SELECT Id, No_of_Files__c
                        FROM Account
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objAcct.No_of_Files__c == null)
                            objAcct.No_of_Files__c = 0;
                        objAcct.No_of_Files__c += 1;
                        if (!lstAcct.contains(objAcct))
                            lstAcct.add(objAcct);
                    }
                }
                if(strObject == 'Quote')
                {
                    for(Quote objQuote : [SELECT Id, No_of_Files__c
                        FROM Quote
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objQuote.No_of_Files__c == null)
                            objQuote.No_of_Files__c = 0;
                        objQuote.No_of_Files__c += 1;
                        if (!lstQuote.contains(objQuote))
                            lstQuote.add(objQuote);
                    }
                }
                if(strObject == 'Order')
                {
                    for(Order objOrder : [SELECT Id, No_of_Files__c
                        FROM Order
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objOrder.No_of_Files__c == null)
                            objOrder.No_of_Files__c = 0;
                        objOrder.No_of_Files__c += 1;
                        if (!lstOrder.contains(objOrder))
                            lstOrder.add(objOrder);
                    }
                }
                if(strObject == 'Case')
                {
                    for(Case objCase : [SELECT Id, No_of_Files__c
                        FROM Case
                        WHERE Id = :objCDL.LinkedEntityId])
                    {
                        if (objCase.No_of_Files__c == null)
                            objCase.No_of_Files__c = 0;
                        objCase.No_of_Files__c += 1;
                        if (!lstCase.contains(objCase))
                            lstCase.add(objCase);
                    }
                }

                //Added to set permission based on record for files uploaded via the FSM App.
                if(strObject == 'WorkOrder')
                {
                    ContentDocumentLink cDocLink = new ContentDocumentLink();
                    cDocLink.Id = objCDL.Id;
                    cDoclink.ShareType = 'I';
                    update cDocLink;
                }
                //Added to set permission based on record for files uploaded via the FSM App.
                if(strObject == 'Asset')
                {
                    ContentDocumentLink cDocLink = new ContentDocumentLink();
                    cDocLink.Id = objCDL.Id;
                    cDoclink.ShareType = 'I';
                    update cDocLink;
                }
            }
        }

        if(!lstQR.isEmpty())
            update lstQR;
        if(!lstDrawing.isEmpty())
            update lstDrawing;
        if(!lstOpp.isEmpty())
            update lstOpp;
        if(!lstAcct.isEmpty())
            update lstAcct;
        if(!lstQuote.isEmpty())
            update lstQuote;
        if(!lstOrder.isEmpty())
            update lstOrder;
        if(!lstCase.isEmpty())
            update lstCase;
        if(!lstRFT.isEmpty())
            update lstRFT;

        if(accountCDLinkId.isEmpty()) return;
        ContentDocumentLinkHelper.attachToOpportunityFileShare(accountCDLinkId);
    }
    
    
    private static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){

                //if (!sObj.contains('__')) to exclude managed package objects

                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }


}