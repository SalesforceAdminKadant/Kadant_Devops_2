trigger OrderItemTrigger on OrderItem (before insert, before update, after insert, after update) {

    //Before trigger
    if(trigger.isBefore)
    {
        initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
    }


    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<OrderItem> lstOrderItemsNew, map<Id,OrderItem> mapOrderItemsNew, map<Id,OrderItem> mapOrderItemsOld){

        DatedConversionRate[] objDCRAcct;
        DatedConversionRate[] objDCRProd;
        DatedConversionRate[] objDCREUR;
        DatedConversionRate[] objDCRCAD;
        DatedConversionRate[] objDCROrder;

            for (OrderItem oli : Trigger.new)
            {
                if(oli.Total_Cost__c != 0 && (oli.Mfg_Cost__c == null || oli.Mfg_Cost__c == 0))
                {
                    oli.Mfg_Cost__c = oli.Total_Cost__c;
                }

                oli.Business_Category_Text__c = oli.Business_Category__c;
                oli.Calculated_Extended_ICP__c = oli.ICP__c*oli.Quantity;
                oli.KSD_Product_Family_don_t_use__c = oli.KSD_Product_Family__c;

                //if(oli.Order_Division__c != 'KSD')
                    //oli.Product__c = oli.Product2Id;

                //if(oli.ServiceDate == null)
                    //oli.ServiceDate = oli.Order_Date__c;

                //Update Exchange Rates for Sales
                if(trigger.isInsert || (trigger.isUpdate && oli.Incorrect_Exchange_Rate__c == true))
                {
                    objDCRAcct = [SELECT Id, ConversionRate FROM DatedConversionRate WHERE StartDate <= :oli.Order_Date__c And IsoCode = :oli.Account_Currency__c Order By StartDate DESC LIMIT 1];
                    if(objDCRAcct.Size() > 0)
                    {
                        objDCREUR = [SELECT Id, ConversionRate FROM DatedConversionRate WHERE StartDate <= :oli.Order_Date__c And IsoCode = 'EUR' Order By StartDate DESC LIMIT 1];
                        if(objDCREUR.Size() > 0)
                        {
                            objDCRCAD = [SELECT Id, ConversionRate FROM DatedConversionRate WHERE StartDate <= :oli.Order_Date__c And IsoCode = 'CAD' Order By StartDate DESC LIMIT 1];
                            if(objDCRCAD.Size() > 0)
                            {
                                objDCROrder = [SELECT Id, ConversionRate FROM DatedConversionRate WHERE StartDate <= :oli.Order_Date__c And IsoCode = :oli.Order_Currency__c Order By StartDate DESC LIMIT 1];
                                if(objDCROrder.Size() > 0)
                                {
                                    objDCRProd = [SELECT Id, ConversionRate FROM DatedConversionRate WHERE StartDate <= :oli.Order_Date__c And IsoCode = :oli.Product_Currency__c Order By StartDate DESC LIMIT 1];
                                    if(objDCRProd.Size() > 0)
                                    {
                                        if(oli.Order_Currency__c == 'USD')
                                            oli.Exchange_Rate_STD__c = 1;
                                        else
                                            oli.Exchange_Rate_STD__c = objDCROrder[0].ConversionRate;
                                        if(oli.Order_Currency__c == 'EUR')
                                            oli.Exchange_Rate_STE__c = 1;
                                        else
                                            oli.Exchange_Rate_STE__c = objDCROrder[0].ConversionRate/objDCREUR[0].ConversionRate;
                                        if(oli.Order_Currency__c == 'CAD')
                                            oli.Exchange_Rate_STC__c = 1;
                                        else
                                            oli.Exchange_Rate_STC__c = objDCROrder[0].ConversionRate/objDCRCAD[0].ConversionRate;
                                        if(oli.Account_Currency__c == oli.Order_Currency__c)
                                            oli.Exchange_Rate_STA__c = 1;
                                        else
                                            oli.Exchange_Rate_STA__c = objDCROrder[0].ConversionRate/objDCRAcct[0].ConversionRate;
                                        if(oli.Order_Currency__c == 'USD')
                                            oli.Exchange_Rate_CTD__c = 1;
                                        else
                                            oli.Exchange_Rate_CTD__c = objDCROrder[0].ConversionRate;
                                        if(oli.Order_Currency__c == 'EUR')
                                            oli.Exchange_Rate_CTE__c = 1;
                                        else
                                            oli.Exchange_Rate_CTE__c = objDCROrder[0].ConversionRate/objDCREUR[0].ConversionRate;
                                        if(oli.Order_Currency__c == 'CAD')
                                            oli.Exchange_Rate_CTC__c = 1;
                                        else
                                            oli.Exchange_Rate_CTC__c = objDCROrder[0].ConversionRate/objDCRCAD[0].ConversionRate;
                                        if(oli.Product_Currency__c == oli.Order_Currency__c)
                                            oli.Exchange_Rate_CTP__c = 1;
                                        else
                                            oli.Exchange_Rate_CTP__c = objDCROrder[0].ConversionRate/objDCRProd[0].ConversionRate;
                                    }
                                }
                            }
                        }
                    }
                }

            }

    
    }
        
}