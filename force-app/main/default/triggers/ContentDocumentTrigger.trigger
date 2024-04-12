trigger ContentDocumentTrigger on ContentDocument (before delete) {

    //Before trigger
    if(trigger.isBefore)
    {
        //Delete
        if(trigger.isDelete)
        {
            doDeleteStuff(trigger.old);
        }
    }

    //Following method is to Delete stuff
    private static void doDeleteStuff(list<ContentDocument> lstCDsOld){
    
        List<Quote_Request__c> lstQR = new List<Quote_Request__c>();
        List<Drawing__c> lstDrawing = new List<Drawing__c>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<Account> lstAcct = new List<Account>();
        List<Quote> lstQuote = new List<Quote>();
        List<Order> lstOrder = new List<Order>();
        List<Case> lstCase = new List<Case>();
        List<Request_for_Test__c> lstRFT = new List<Request_for_Test__c>();
        Map<Id, Id> mapRFTs = new Map<Id, Id>();
        string strObject;

        for(ContentDocument objCD : lstCDsOld)
        {
            for(ContentDocumentLink objCDL : [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :objCD.Id])
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
                        if(mapRFTs.containsKey(objRFT.Id)==false)
                        {
                            objRFT.No_of_Files__c -= 1;
                            mapRFTs.put(objRFT.Id, objRFT.Id);
                            lstRFT.add(objRFT);
                        }
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