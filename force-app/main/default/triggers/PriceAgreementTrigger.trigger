trigger PriceAgreementTrigger on Price_Agreement__c (before insert, before update, after insert, after update, before delete) {

    //Before trigger
    if(trigger.isBefore){
        if(trigger.isInsert){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }
        if(trigger.isUpdate){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }
        if(trigger.isDelete){
            doAfterStuff(trigger.old, trigger.oldMap, trigger.oldMap, 'Delete');
        }
    }

    //After trigger
    if(trigger.isAfter){
        if(trigger.isInsert){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }
        if(trigger.isUpdate){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
        }
    }


    //Helper methods follow

    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<Price_Agreement__c> lstPriceAgreementsNew, map<Id,Price_Agreement__c> mapPriceAgreementsNew, Map<Id,Price_Agreement__c> mapPriceAgreementsOld){
    
        for(Price_Agreement__c pa : lstPriceAgreementsNew){
            pa.CurrencyISOCode = pa.Account_Currency__c;
            if(trigger.isInsert || (trigger.isUpdate && (pa.Sales_Office_Manager__c == Null || pa.Managing_Director__c == Null || pa.Division__c != mapPriceAgreementsOld.get(pa.Id).Division__c)))
            {
                Division__c[] div = [select Id, Managing_Director__c, Sales_Office_Manager__c, Sales_Office_Approver_Paper__c, Sales_Office_Approver_Industrial__c from Division__c where Division_Picklist__c = :pa.Division__c LIMIT 1];
                if(!div.isEmpty())
                {
                    //pa.Sales_Office_Manager__c = div[0].Sales_Office_Manager__c;
                    if(pa.Account_Industry__c == 'Paper')
                    {
                        pa.Sales_Office_Manager__c = div[0].Sales_Office_Approver_Paper__c;
                    }else{
                        pa.Sales_Office_Manager__c = div[0].Sales_Office_Approver_Industrial__c;
                    }
                    pa.Managing_Director__c = div[0].Managing_Director__c;
                }
            }
       
            if(trigger.isInsert && pa.Price_Book__c == Null) {
                pa.Price_Book__c = [select Id, Default_Pricebook_Id__c from User where Id = :Userinfo.getUserId()].Default_Pricebook_Id__c;
            }

            if((trigger.isInsert || trigger.isUpdate) && pa.Status__c == 'Approved' &&
                (pa.Start_Date__c != mapPriceAgreementsOld.get(pa.Id).Start_Date__c ||
                pa.Expiration_Date__c != mapPriceAgreementsOld.get(pa.Id).Expiration_Date__c))
            {
                pa.Status__c = 'Draft';
            }
        }
        
    }

    //Following method is to do "after" stuff
    private static void doAfterStuff(list<Price_Agreement__c> lstPriceAgreementsNew, map<Id,Price_Agreement__c> mapPriceAgreementsNew, map<Id,Price_Agreement__c> mapPriceAgreementsOld, String strOperation){

        Integer intCount = 0;
        String strCustomerPartID;
        List<Price_Agreement_Detail__c> lstPAD1 = new List<Price_Agreement_Detail__c>();
        Object_Activity_Log__c[] oal = new List<Object_Activity_Log__c>();
        List<Mfg_Cost_Price__c> lstMCP = new List<Mfg_Cost_Price__c>();//List of Mfg. Cost Price
        for(Price_Agreement__c objPA : lstPriceAgreementsNew)
        {

            if(trigger.isInsert || (trigger.isUpdate && objPA.Management_Info__c == null))
            {
                Mfg_Cost_Price__c objMCP = new Mfg_Cost_Price__c(RecordTypeId = Schema.SObjectType.Mfg_Cost_Price__c.getRecordTypeInfosByName().get('Price Agreements').getRecordTypeId(), Price_Agreement__c = objPA.id, OwnerId = objPA.OwnerId);
                lstMCP.Add(objMCP);
            }

            for(Price_Agreement_Detail__c objPAD1 : [SELECT Id, Name, CurrencyISOCode, Division__c
                FROM Price_Agreement_Detail__c
                WHERE Price_Agreement_Header__c = :objPA.Id])
            {
                if(trigger.isUpdate && objPA.CurrencyISOCode != mapPriceAgreementsOld.get(objPA.Id).CurrencyISOCode) {
                    objPAD1.CurrencyISOCode = objPA.CurrencyISOCode;
                    lstPAD1.add(objPAD1);
                }
                if((trigger.isInsert && objPA.Status__c == 'Approved') || (trigger.isUpdate && objPA.Status__c == 'Approved' && mapPriceAgreementsOld.get(objPA.Id).Status__C != 'Approved')) {
                    Object_Activity_Log__c q = new Object_Activity_Log__c(Name='PriceAgreement',
                        Division__c = objPAD1.Division__c,
                        Object_Id__c = objPAD1.Id,
                        Operation__c = strOperation,
                        Processed__c = False,
                        Date_Processed__c = Null,
                        Key_Value__c = objPAD1.Name);
                    oal.add(q);
                    if(intCount >= (Limits.getLimitCallouts() - 1)){
                        intCount = 0;
                        if(!oal.isEmpty()){
                            insert oal;
                            oal.clear();
                        }
                    }else{
                        intCount = intCount + 1;
                    }
                }
            }
            //Update Price Agreement Detail records.
            if(!lstPAD1.isEmpty()) {
                update lstPAD1;
            }
            if(!oal.isEmpty()){
                insert oal;
            }

            if(trigger.isInsert && objPA.Cloned_From_Id__c != null) {
                List<Price_Agreement_Detail__c> lstPADNew = new List<Price_Agreement_Detail__c>();
                List<Price_Agreement_Detail__c> lstPAD2 = [SELECT CurrencyISOCode, Line_No__c, Product__c, Customer_Item__c, Price__c, Previous_Price__c, Leadtime_days__c, Tier_1_Price__c, Tier_1_Quantity__c, Tier_2_Price__c, Tier_2_Quantity__c, Tier_3_Price__c, Tier_3_Quantity__c, Tier_4_Price__c, Tier_4_Quantity__c, Tier_5_Price__c, Tier_5_Quantity__c, Target_Quantity__c
                    FROM Price_Agreement_Detail__c
                    WHERE Price_Agreement_Header__c = :objPA.Cloned_From_Id__c];
                for(Price_Agreement_Detail__c pad : lstPAD2){
                    if(String.isBlank(pad.Customer_Item__c))
                        strCustomerPartID = null;
                    else
                    {
                        if(pad.Customer_Item__c.length() > 30)
                            strCustomerPartID = pad.Customer_Item__c.substring(0,30);
                        else
                            strCustomerPartID = pad.Customer_Item__c;
                    }
                    Price_Agreement_Detail__c objPAD = new Price_Agreement_Detail__c(
                        Price_Agreement_Header__c = objPA.Id,
                        CurrencyISOCode = pad.CurrencyISOCode,
                        Line_No__c = pad.Line_No__c,
                        Product__c = pad.Product__c,
                        Customer_Item__c = strCustomerPartID);
                    if(objPA.Cloned_Price_Increase__c == null)
                    {
                        if(pad.Price__c != Null)
                        {
                            objPAD.Price__c = Null;
                            objPAD.Previous_Price__c = pad.Price__c;
                        }else{
                            objPAD.Previous_Price__c = null;
                        }
                    }else{
                        if(pad.Price__c != Null)
                        {
                            objPAD.Price__c = pad.Price__c + (pad.Price__c * (objPA.Cloned_Price_Increase__c/100)).setScale(2, RoundingMode.HALF_UP);
                            objPAD.Previous_Price__c = pad.Price__c;
                        }else{
                            objPAD.Previous_Price__c = null;
                        }
                        if(pad.Tier_1_Price__c != Null)
                            objPAD.Tier_1_Price__c = pad.Tier_1_Price__c + (pad.Tier_1_Price__c * (objPA.Cloned_Price_Increase__c/100)).setScale(2, RoundingMode.HALF_UP);
                        if(pad.Tier_2_Price__c != Null)
                            objPAD.Tier_2_Price__c = pad.Tier_2_Price__c + (pad.Tier_2_Price__c * (objPA.Cloned_Price_Increase__c/100)).setScale(2, RoundingMode.HALF_UP);
                        if(pad.Tier_3_Price__c != Null)
                            objPAD.Tier_3_Price__c = pad.Tier_3_Price__c + (pad.Tier_3_Price__c * (objPA.Cloned_Price_Increase__c/100)).setScale(2, RoundingMode.HALF_UP);
                        if(pad.Tier_4_Price__c != Null)
                            objPAD.Tier_4_Price__c = pad.Tier_4_Price__c + (pad.Tier_4_Price__c * (objPA.Cloned_Price_Increase__c/100)).setScale(2, RoundingMode.HALF_UP);
                        if(pad.Tier_5_Price__c != Null)
                            objPAD.Tier_5_Price__c = pad.Tier_5_Price__c + (pad.Tier_5_Price__c * (objPA.Cloned_Price_Increase__c/100)).setScale(2, RoundingMode.HALF_UP);
                    }
                    lstPADNew.Add(objPAD);
                }

                //Insert Price Agreement Detail records.
                if(!lstPADNew.isEmpty())
                    insert lstPADNew;

            }
        }
        if(!lstMCP.isEmpty())
            insert lstMCP;
    }
        
}