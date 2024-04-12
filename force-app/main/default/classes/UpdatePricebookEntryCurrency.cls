global class UpdatePricebookEntryCurrency
{

    public void updateMe(string strProductId, string strPricebookId, string strRecordTypeName)
    {
        
        PricebookEntry [] pbe = new list<PricebookEntry>();

        PricebookEntry [] pbe1 = [SELECT Id, Product2Id, CurrencyIsoCode, UnitPrice, Currency_List_Price__c
            FROM PricebookEntry
            Where Product2Id = :strProductId And Primary_Currency__c = False And Product2.RecordType.Name = :strRecordTypeName];
        
        for (PricebookEntry pbe2 : pbe1)
        {
            pbe2.UnitPrice = pbe2.Currency_List_Price__c;
            pbe.add(pbe2);
        }

        if(!pbe.isEmpty())
            update pbe;

    }

}