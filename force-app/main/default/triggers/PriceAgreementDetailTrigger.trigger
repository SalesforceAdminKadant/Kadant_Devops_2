trigger PriceAgreementDetailTrigger on Price_Agreement_Detail__c (before insert, before update, after insert, after update, after delete) {

    //Before trigger
    if(trigger.isBefore){
        //Insert
        if(trigger.isInsert){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }
        if(trigger.isUpdate){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }

    }

    //After trigger
    if(trigger.isAfter){
        /******************************************************/
        /* Call method to do after stuff                      */
        /******************************************************/
        if(trigger.isInsert){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }
        if(trigger.isUpdate){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
        }
        if(trigger.isDelete){
            doAfterStuff(trigger.old, trigger.oldMap, trigger.oldMap, 'Delete');
        }
        
    }


    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<Price_Agreement_Detail__c> lstPADNew, map<Id,Price_Agreement_Detail__c> mapPADNew, Map<Id,Price_Agreement_Detail__c> mapPADOld){

        List<Price_Agreement__c> lstPA = new List<Price_Agreement__c>();
        Map<Id, Id> mapPADs = new Map<Id, Id>();
        
        for(Price_Agreement_Detail__c PAD : lstPADNew){
            if(trigger.isInsert || trigger.isUpdate)
            {
                PAD.JF_Part_Checkbox__c = PAD.JF_Part_Formula__c;
            }

            if(trigger.isInsert) {
                PAD.List_Price__c = PAD.Current_List_Price__c;
                PAD.Override_ICP__c = PAD.Current_ICP_Price__c;
                PAD.Mfg_Cost__c = PAD.Current_Mfg_cost__c;
            }

            if(trigger.isUpdate && PAD.Discount__c != Null && PAD.List_Price__c != Null && PAD.List_Price__c != 0 && PAD.Discount__c != PAD.Discount_Pct__c && PAD.Discount__c != mapPADOld.get(PAD.Id).Discount__c)
            {
                PAD.Price__c = PAD.List_Price__c - (PAD.List_Price__c * (PAD.Discount__c/100));
            }else{
                if(trigger.isInsert || trigger.isUpdate)
                {
                    PAD.Discount__c = PAD.Discount_Pct__c;
                }
            }

            if(PAD.Division__c != 'JF' && PAD.JF_Part_Formula__c == True && PAD.Price__c != Null && PAD.Mfg_Cost__c != Null)
            {
                PAD.ICP_Price__c = (((PAD.Price__c - PAD.Mfg_Cost__c) * 0.4) + PAD.Mfg_Cost__c);
            }else{
                PAD.ICP_Price__c = PAD.Override_ICP__c;
            }

            PAD.CurrencyIsoCode = PAD.Currency__c;

            if(trigger.isUpdate && PAD.Status__c == 'Approved')
            {
                if((PAD.Price__c == Null && mapPADOld.get(PAD.Id).Price__c != Null) || (PAD.Price__c != Null && mapPADOld.get(PAD.Id).Price__c == Null) || (PAD.Price__c != Null && mapPADOld.get(PAD.Id).Price__c != Null && PAD.Price__c != mapPADOld.get(PAD.Id).Price__c) ||
                    (PAD.ICP_Price__c == Null && mapPADOld.get(PAD.Id).ICP_Price__c != Null) || (PAD.ICP_Price__c != Null && mapPADOld.get(PAD.Id).ICP_Price__c == Null) || (PAD.ICP_Price__c != Null && mapPADOld.get(PAD.Id).ICP_Price__c != Null && PAD.ICP_Price__c != mapPADOld.get(PAD.Id).ICP_Price__c) ||
                    (PAD.List_Price__c == Null && mapPADOld.get(PAD.Id).List_Price__c != Null) || (PAD.List_Price__c != Null && mapPADOld.get(PAD.Id).List_Price__c == Null) || (PAD.List_Price__c != Null && mapPADOld.get(PAD.Id).List_Price__c != Null && PAD.List_Price__c != mapPADOld.get(PAD.Id).List_Price__c) ||
                    (PAD.Mfg_Cost__c == Null && mapPADOld.get(PAD.Id).Mfg_Cost__c != Null) || (PAD.Mfg_Cost__c != Null && mapPADOld.get(PAD.Id).Mfg_Cost__c == Null) || (PAD.Mfg_Cost__c != Null && mapPADOld.get(PAD.Id).Mfg_Cost__c != Null && PAD.Mfg_Cost__c != mapPADOld.get(PAD.Id).Mfg_Cost__c) ||
                    (PAD.Override_ICP__c == Null && mapPADOld.get(PAD.Id).Override_ICP__c != Null) || (PAD.Override_ICP__c != Null && mapPADOld.get(PAD.Id).Override_ICP__c == Null) || (PAD.Override_ICP__c != Null && mapPADOld.get(PAD.Id).Override_ICP__c != Null && PAD.Override_ICP__c != mapPADOld.get(PAD.Id).Override_ICP__c) ||
                    (PAD.Product__c != mapPADOld.get(PAD.Id).Product__c) ||
                    (PAD.Tier_1_Price__c == Null && mapPADOld.get(PAD.Id).Tier_1_Price__c != Null) || (PAD.Tier_1_Price__c != Null && mapPADOld.get(PAD.Id).Tier_1_Price__c == Null) || (PAD.Tier_1_Price__c != Null && mapPADOld.get(PAD.Id).Tier_1_Price__c != Null && PAD.Tier_1_Price__c != mapPADOld.get(PAD.Id).Tier_1_Price__c) ||
                    (PAD.Tier_1_Quantity__c == Null && mapPADOld.get(PAD.Id).Tier_1_Quantity__c != Null) || (PAD.Tier_1_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_1_Quantity__c == Null) || (PAD.Tier_1_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_1_Quantity__c != Null && PAD.Tier_1_Quantity__c != mapPADOld.get(PAD.Id).Tier_1_Quantity__c) ||
                    (PAD.Tier_2_Price__c == Null && mapPADOld.get(PAD.Id).Tier_2_Price__c != Null) || (PAD.Tier_2_Price__c != Null && mapPADOld.get(PAD.Id).Tier_2_Price__c == Null) || (PAD.Tier_2_Price__c != Null && mapPADOld.get(PAD.Id).Tier_2_Price__c != Null && PAD.Tier_2_Price__c != mapPADOld.get(PAD.Id).Tier_2_Price__c) ||
                    (PAD.Tier_2_Quantity__c == Null && mapPADOld.get(PAD.Id).Tier_2_Quantity__c != Null) || (PAD.Tier_2_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_2_Quantity__c == Null) || (PAD.Tier_2_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_2_Quantity__c != Null && PAD.Tier_2_Quantity__c != mapPADOld.get(PAD.Id).Tier_2_Quantity__c) ||
                    (PAD.Tier_3_Price__c == Null && mapPADOld.get(PAD.Id).Tier_3_Price__c != Null) || (PAD.Tier_3_Price__c != Null && mapPADOld.get(PAD.Id).Tier_3_Price__c == Null) || (PAD.Tier_3_Price__c != Null && mapPADOld.get(PAD.Id).Tier_3_Price__c != Null && PAD.Tier_3_Price__c != mapPADOld.get(PAD.Id).Tier_3_Price__c) ||
                    (PAD.Tier_3_Quantity__c == Null && mapPADOld.get(PAD.Id).Tier_3_Quantity__c != Null) || (PAD.Tier_3_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_3_Quantity__c == Null) || (PAD.Tier_3_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_3_Quantity__c != Null && PAD.Tier_3_Quantity__c != mapPADOld.get(PAD.Id).Tier_3_Quantity__c) ||
                    (PAD.Tier_4_Price__c == Null && mapPADOld.get(PAD.Id).Tier_4_Price__c != Null) || (PAD.Tier_4_Price__c != Null && mapPADOld.get(PAD.Id).Tier_4_Price__c == Null) || (PAD.Tier_4_Price__c != Null && mapPADOld.get(PAD.Id).Tier_4_Price__c != Null && PAD.Tier_4_Price__c != mapPADOld.get(PAD.Id).Tier_4_Price__c) ||
                    (PAD.Tier_4_Quantity__c == Null && mapPADOld.get(PAD.Id).Tier_4_Quantity__c != Null) || (PAD.Tier_4_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_4_Quantity__c == Null) || (PAD.Tier_4_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_4_Quantity__c != Null && PAD.Tier_4_Quantity__c != mapPADOld.get(PAD.Id).Tier_4_Quantity__c) ||
                    (PAD.Tier_5_Price__c == Null && mapPADOld.get(PAD.Id).Tier_5_Price__c != Null) || (PAD.Tier_5_Price__c != Null && mapPADOld.get(PAD.Id).Tier_5_Price__c == Null) || (PAD.Tier_5_Price__c != Null && mapPADOld.get(PAD.Id).Tier_5_Price__c != Null && PAD.Tier_5_Price__c != mapPADOld.get(PAD.Id).Tier_5_Price__c) ||
                    (PAD.Tier_5_Quantity__c == Null && mapPADOld.get(PAD.Id).Tier_5_Quantity__c != Null) || (PAD.Tier_5_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_5_Quantity__c == Null) || (PAD.Tier_5_Quantity__c != Null && mapPADOld.get(PAD.Id).Tier_5_Quantity__c != Null && PAD.Tier_5_Quantity__c != mapPADOld.get(PAD.Id).Tier_5_Quantity__c) ||
                    (PAD.Discount__c == Null && mapPADOld.get(PAD.Id).Discount__c != Null) || (PAD.Discount__c != Null && mapPADOld.get(PAD.Id).Discount__c == Null) || (PAD.Discount__c != Null && mapPADOld.get(PAD.Id).Discount__c != Null && PAD.Discount__c != mapPADOld.get(PAD.Id).Discount__c))
                {
                    for(Price_Agreement__c objPA : [SELECT Id, Status__c FROM Price_Agreement__c WHERE Id = :PAD.Price_Agreement_Header__c And Status__c = 'Approved' LIMIT 1])
                    {
                        if(mapPADs.containsKey(objPA.Id)==false)
                        {
                            mapPADs.put(objPA.Id, objPA.Id);
                            objPA.Status__c = 'Draft';
                            lstPA.add(objPA);
                        }
                    }
                }
            }
 
        }
        
        if(!lstPA.isEmpty())
            update lstPA;

    }
    
    private static void doAfterStuff(list<Price_Agreement_Detail__c> lstPADNew, map<Id,Price_Agreement_Detail__c> mapPADNew, Map<Id,Price_Agreement_Detail__c> mapPADOld, String strOperation) {
        
        Object_Activity_Log__c[] oal = new List<Object_Activity_Log__c>();
        for(Price_Agreement_Detail__c pad : lstPADNew){
            if(strOperation == 'Delete' && pad.Status__c == 'Approved') {
                Object_Activity_Log__c q = new Object_Activity_Log__c(Name='PriceAgreement',
                    Division__c = pad.Division__c,
                    Object_Id__c = pad.Id,
                    Operation__c = strOperation,
                    Processed__c = False,
                    Date_Processed__c = Null,
                    Key_Value__c = pad.Name);
                oal.add(q);
            }
            
        }
        if(!oal.isEmpty()){
            insert oal;
        }

    }
    
}