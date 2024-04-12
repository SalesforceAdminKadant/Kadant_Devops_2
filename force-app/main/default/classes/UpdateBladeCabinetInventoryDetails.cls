global class UpdateBladeCabinetInventoryDetails
{
    public void updateMe(string strCabinetID, string strAccountID, string strBCIMId, string partNumber)
    {
        //string strProduct;
        string strStatus;
        List<Blade_Cabinet_Inventory_Detail__c> bciDetails = new List<Blade_Cabinet_Inventory_Detail__c>();
        
        //Add detail records
        if (partNumber != null)
        {
            // Get Order Items for this order and part number                      
            OrderItem[] orderProducts = [Select Id, Order.Name, Ship_Date__c, Quantity, Resolved__c From OrderItem Where Order.AccountId = :strAccountID And Our_Item_Number__c = :partNumber And Status__c != 'Canceled' And Order.EffectiveDate = LAST_N_DAYS:730 And Quantity >= 0 Order By Order.EffectiveDate DESC];
            if (orderProducts.size() > 0)
            {
                for (OrderItem op : orderProducts)
                {
                    strStatus = 'Missing';
                    Blade_Cabinet_Inventory__c[] bcis = [Select Id From Blade_Cabinet_Inventory__c Where Order_Product__c = :op.Id];
                    if(bcis.size() > 0)
                    {
                        strStatus = 'In Cabinet';
                    }
                    else
                    {
                        if(op.Resolved__c == true)
                            strStatus = 'Resolved';
                        if(op.Ship_Date__c == null)
                            strStatus = 'On Order';
                        if(op.Resolved__c != true && op.Ship_Date__c != null && op.Ship_Date__c < Datetime.Now().Date().AddDays(7))
                            strStatus = 'Missing';
                        if(op.Ship_Date__c != null && op.Ship_Date__c >= Datetime.Now().Date().AddDays(7))
                            strStatus = 'In Transit';
                    }
                    Blade_Cabinet_Inventory_Detail__c bcid = new Blade_Cabinet_Inventory_Detail__c (
                        Blade_Cabinet__c = strCabinetID,
                        Blade_Cabinet_Inventory_Minimum__c = strBCIMId,
                        Order_Number__c = op.Order.Name,
                        Order_Product__c = op.Id,
                        Quantity__c = op.Quantity,
                        Status__c = strStatus
                    );
                    bciDetails.add(bcid);
                }
                if(!bciDetails.isEmpty())
                    insert bciDetails;
            }
        }
    }
}