trigger QuoteLineItemTrigger on QuoteLineItem (before insert, before update, after insert, after update) {

    //Before trigger
    if(trigger.isBefore)
    {
        initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
    }

    //After trigger
    if(trigger.isAfter)
    {
        doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap);
    }

    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<QuoteLineItem> lstQLINew, map<Id,QuoteLineItem> mapQLINew, Map<Id,QuoteLineItem> mapQLIOld){
    
        String strUniqueID;
        integer intLength;
        
        //Set<Id> quoteitemIds1 = new Set<Id>();    
        Set<Id> quoteitemIds2 = new Set<Id>();    
        Set<String> quoteitemIds3 = new Set<String>();    
        Set<String> quoteitemIds4 = new Set<String>();    
        Set<String> quoteitemIds5 = new Set<String>();    

        for(QuoteLineItem qli : lstQLINew){
            
            qli.Account__c = qli.Account_ID_Formula__c;
            qli.KJ_Part_Checkbox__c = qli.KJ_Part_Formula__c;
            qli.KL_Part_Checkbox__c = qli.KL_Part_Formula__c;
            qli.JF_Part_Checkbox__c = qli.JF_Part_Formula__c;
            qli.KJE_Part_Checkbox__c = qli.KJE_Part_Formula__c;
            qli.KN_Part_Checkbox__c = qli.KN_Part_Formula__c;
            qli.KUK_Part_Checkbox__c = qli.KUK_Part_Formula__c;
            qli.NML_Part_Checkbox__c = qli.NML_Part_Formula__c;
            qli.Quote_Product__c = qli.Product2Id;
            qli.No_Approval_Required__c = qli.No_Approval_Required_Formula__c;
            qli.Quote_Division__c = qli.Quote_Division_Formula__c;
            qli.Product_Name_Text__c = qli.Product_Name__c;
            if(qli.Our_Item_Number__c == null)
                qli.Our_Item_Number__c = qli.Product_Name__c;
            qli.Part_Class__c = qli.Product_Part_Class__c;
            qli.Part_Class_Text__c = qli.Product_Part_Class__c;
            qli.Calculated_ICP__c = qli.Calculated_ICP_Formula__c;
            if(qli.Comments__c != null)
                qli.Comments__c = qli.Comments__c.replace('rgb(68, 68, 68);', 'rgb(0, 0, 0);');
                
            //Sync these 4 fields from Opportunity Line Item to this Quote Line Item
            if(qli.OpportunityLineItemId != null)
            {
                if(qli.Asset__c == null && qli.Opp_Asset__c != null)
                    qli.Asset__c = qli.Opp_Asset__c;
                if(qli.ICP_Price__c == null && qli.Opp_ICP_Price__c != null)
                    qli.ICP_Price__c = qli.Opp_ICP_Price__c;
                if(qli.Mfg_Cost__c == null && qli.Opp_MCP__c != null)
                    qli.Mfg_Cost__c = qli.Opp_MCP__c;
                if(qli.Line_No__c == null && qli.Opp_Line_No__c != null)
                    qli.Line_No__c = qli.Opp_Line_No__c;
            }
                
            if(qli.Product_Code__c==null || qli.Product_Code__c == '' || qli.Product_Code__c == 'MP00' || qli.Product_Code__c == 'NK00')
            {
                qli.No_ProductCode__c = 1;
            }

            if(qli.Specifications__c != null)
                qli.Part_Specifications_Length__c = qli.Specifications__c.Length();
            else
                qli.Part_Specifications_Length__c = 0;

            if(trigger.isInsert) {
                if(qli.PriceBookEntryId != null)
                {
                    qli.List_Price__c = qli.PBE_Unit_Price__c;
                    qli.Mfg_Cost__c = qli.Current_Mfg_Cost__c;
                    if(qli.ICP_Price__c == null)
                        qli.ICP_Price__c = qli.PBE_ICP__c;
                }else{
                    qli.List_Price__c = qli.Current_List_Price__c;
                    qli.Mfg_Cost__c = qli.Current_Mfg_Cost__c;
                    if(qli.ICP_Price__c == null)
                        qli.ICP_Price__c = qli.Current_ICP_Price__c;
                }

                /* Populate Discount from Account Standard Discount, if appropriate */
                if(qli.Discount == Null && qli.Account_Standard_Discount__c > 0)
                {
                    qli.Discount = qli.Account_Standard_Discount__c;
                }

                /* Automatically populate the Customer Item Number field, if possible */
                if(qli.Customer_Item_Number__c == null)
                {
                    Account_Product__c[] lstAP = [SELECT Id, Name, CreatedDate FROM Account_Product__c WHERE Account__c = :qli.Quote_AccountId__c And Product__c = :qli.Product2Id Order By CreatedDate DESC LIMIT 1];
                    if(lstAP.size() > 0)
                    {
                        qli.Customer_Item_Number__c = lstAP[0].Name;
                    }
                }
            }

            if((trigger.isInsert && qli.Attach_Drawing__c == True) || (trigger.isUpdate && qli.Attach_Drawing__c == True && mapQLIOld.get(qli.Id).Attach_Drawing__c != True)) {
                KadantHelperClasses.WriteObjectActivityLog('QuoteLineItem', qli.Product_Division__c, qli.Id, qli.QuoteId, 'UploadDrawing');
            }
            if((trigger.isInsert && qli.Assembly__c != null) || (trigger.isUpdate && qli.Assembly__c != mapQLIOld.get(qli.Id).Assembly__c)) {
                KadantHelperClasses.WriteObjectActivityLog('QuoteLineItem', qli.Product_Division__c, qli.Id, qli.QuoteId, 'UploadAssemblyDrawing');
            }
            if((trigger.isInsert && qli.Attach_BOM__c == True) || (trigger.isUpdate && qli.Attach_BOM__c == True && mapQLIOld.get(qli.Id).Attach_BOM__c != True)) {
                KadantHelperClasses.WriteObjectActivityLog('QuoteLineItem', qli.Product_Division__c, qli.Id, qli.QuoteId, 'UploadBOM');
            }
            if((trigger.isInsert && qli.Assembly__c != null) || (trigger.isUpdate && qli.Assembly__c != mapQLIOld.get(qli.Id).Assembly__c)) {
                KadantHelperClasses.WriteObjectActivityLog('QuoteLineItem', qli.Product_Division__c, qli.Id, qli.QuoteId, 'UploadAssemblyBOM');
            }

            if(qli.Uploaded__c == False && ((trigger.isInsert && qli.Description == Null) || (trigger.isUpdate && (qli.Product2Id != mapQLIOld.get(qli.Id).Product2Id || qli.Quote_Language__c != mapQLIOld.get(qli.Id).Quote_Language__c || qli.Description == Null))))
            {
                if(qli.Product_Description__c != null)
                {
                    if(qli.Product_Description__c.Length() > 255)
                        qli.Description = qli.Product_Description__c.mid(0, 255);
                    else
                        qli.Description = qli.Product_Description__c;
                }

                if(qli.Quote_Language__c != null) {
                    strUniqueID = qli.Product2Id + qli.Quote_Language__c;
                    quoteitemIds3.add(strUniqueId);
                }
            }

            if(qli.Uploaded__c == False && qli.Comments__c == Null && qli.Product2Id != null)
            {
                quoteitemIds5.add(qli.Product2Id);
            }

            if(qli.Uploaded__c == False && ((trigger.isInsert && qli.Specifications__c == Null) || (trigger.isUpdate && (qli.Product2Id != mapQLIOld.get(qli.Id).Product2Id || qli.Quote_Language__c != mapQLIOld.get(qli.Id).Quote_Language__c || qli.Specifications__c == Null))))
            {

                if (qli.Product2Id != null) {
                    quoteitemIds2.add(qli.Product2Id);
                }

                if(qli.Quote_Language__c != null) {
                    strUniqueID = qli.Product2Id + qli.Quote_Language__c;
                    quoteitemIds4.add(strUniqueId);
                }
            }

        }

        //The following 4 sections are for bulkifying the process of copying the Description and Specifications from
        //either the Product2 object or the Product Description object
        if(!quoteitemIds3.isEmpty())
        {
            Map<String, Product_Description__c> productDescriptionEntries = new Map<String, Product_Description__c>();
            for(Product_Description__c objPD : [Select Id, Description__c, Unique_ID__c From Product_Description__c Where Unique_Id__c in :quoteitemIds3])
                productDescriptionEntries.put(objPD.Unique_ID__c, objPD);
            for (QuoteLineItem qli : lstQLINew) {
                strUniqueID = qli.Product2Id + qli.Quote_Language__c;
                Product_Description__c prodDesc = productDescriptionEntries.get(strUniqueId);
                if (prodDesc != null) {
                    qli.Description = prodDesc.Description__c;
                }
            }
        }
        if(!quoteitemIds2.isEmpty())
        {
            Map<Id, Product2> productEntries = new Map<Id, Product2>(
                [select Specifications__c from Product2 Where Id in :quoteitemIds2]
            );
            for (QuoteLineItem qli : lstQLINew) {
                Product2 prod = productEntries.get(qli.Product2Id);
                if (prod != null && prod.Specifications__c != null) {
                    qli.Specifications__c = prod.Specifications__c;
                }
            }
        }
        if(!quoteitemIds5.isEmpty())
        {
            Map<Id, Product2> productEntries = new Map<Id, Product2>(
                [select Part_CO_Specifications__c from Product2 Where Id in :quoteitemIds5 And Location__c != 'KJ' And Location__c != 'BM']
            );
            for (QuoteLineItem qli : lstQLINew) {
                Product2 prod = productEntries.get(qli.Product2Id);
                if (prod != null && prod.Part_CO_Specifications__c != null) {
                    qli.Comments__c = prod.Part_CO_Specifications__c;
                }
            }
        }
        if(!quoteitemIds4.isEmpty())
        {
            Map<String, Product_Description__c> productDescriptionEntries = new Map<String, Product_Description__c>();
            for(Product_Description__c objPD : [Select Id, Specifications__c, Unique_ID__c, Web_Shop_Link__c From Product_Description__c Where Unique_Id__c in :quoteitemIds4])
                productDescriptionEntries.put(objPD.Unique_ID__c, objPD);
            for (QuoteLineItem qli : lstQLINew) {
                strUniqueID = qli.Product2Id + qli.Quote_Language__c;
                Product_Description__c prodDesc = productDescriptionEntries.get(strUniqueId);
                if (prodDesc != null) {
                    qli.Specifications__c = prodDesc.Specifications__c;
                        if(prodDesc.Web_Shop_Link__c != null){
                        qli.Web_Shop_Link__c = prodDesc.Web_Shop_Link__c;    
                        }
                }
            }
        }
        
    }
    
    private static void doAfterStuff(list<QuoteLineItem> lstQLINew, map<Id,QuoteLineItem> mapQLINew, Map<Id,QuoteLineItem> mapQLIOld) {

        List<Quote> lstQ = new List<Quote>();
        //List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();

        for(QuoteLineItem qli : lstQLINew){

            if(qli.Uploaded__c == False && qli.Quote_Status__c == 'Approved' && (trigger.isInsert || (trigger.isUpdate && (qli.Quantity != mapQLIOld.get(qli.Id).Quantity || qli.UnitPrice != mapQLIOld.get(qli.Id).UnitPrice || qli.Discount != mapQLIOld.get(qli.Id).Discount || qli.ICP_Price__c != mapQLIOld.get(qli.Id).ICP_Price__c))))
            {
                for(Quote objQ : [SELECT Id, Status, Approved__c
                    FROM Quote
                    WHERE Id = :qli.QuoteId])
                {
                    objQ.Status = 'Draft';
                    objQ.Approved__c = False;
                    if(!lstQ.contains(objQ))
                        lstQ.add(objQ);
                }
            }

        }
        if(!lstQ.isEmpty())
            update lstQ;

    }
    
}