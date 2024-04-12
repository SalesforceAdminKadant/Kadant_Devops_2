@isTest(SeeAllData=True)
public without sharing class TestKadantHelperClasses
{
    static testMethod void testSearchForParts()
    {
        Quote[] q = [select id, opportunityid from quote where currencyisocode='USD' limit 1];
        ReturnOrder[] ro = [select id from ReturnOrder where orderid != null limit 1];
        
        String quoteID = q[0].Id;
        Opportunity[] o = [select id from opportunity where id = :q[0].OpportunityId limit 1];
        Product2[] p = [select id, Name from product2 WHERE IsActive=True And Id IN(SELECT Product2Id FROM PricebookEntry WHERE currencyisocode='USD') limit 1];
        Map<String,String> SelectedPartMap = New Map<String,String>{'e'=>'f', 'g'=> 'h'}; 
        Map<Id,String> SelectedPartMap2 = New Map<Id,String>{p[0].Id=>p[0].Name};
        Map<Id,String> SelectedPartMapQty2 = New Map<Id,String>{p[0].Id=>'1'};
        Blade__c[] bl = [select recordtypeid from blade__c limit 1];
            
        //function 1
        KadantHelperClasses.searchForParts(q[0].Id, 'Quote', '', 'And IsActive=true', SelectedPartMap);
      
        //function 2
        KadantHelperClasses.AddQuoteLines(q[0].Id, SelectedPartMap2, '[{"value":"4","key":"qty'+p[0].Id+'"}]','[{"value":"500","key":"up'+p[0].Id+'"}]','[{"value":"10","key":"disc'+p[0].Id+'"}]','[{"prodid":"'+p[0].Id+'","matid":"5sW0000000Aw2nIAC","material":"Abrasitek","width":"22","thickness":"1.9","bevel":""}]');
   
        //function 3
        KadantHelperClasses.GetProductPricing(q[0].Id, 'Quote', SelectedPartMap2, SelectedPartMapQty2);
            
        //function 4        
        //KadantHelperClasses.GetCustomerPricing(q[0].Id, 'Quote', SelectedPartMap2);
        
        //function 5
        //KadantHelperClasses.AddOpportunityLines(o[0].Id, SelectedPartMap2, '[{"value":"4","key":"qty'+p[0].Id+'"}]','[{"value":"500","key":"up'+p[0].Id+'"}]','[{"value":"10","key":"disc'+p[0].Id+'"}]');

        //function 6
        KadantHelperClasses.showBomParts(String.valueOf(p[0].Id), SelectedPartMap);
        
        //function 6
        KadantHelperClasses.getSourceOrderLines(String.valueOf(ro[0].Id));
        
        //function 7
        KadantHelperClasses.searchForPartsGeneric( '', 'And IsActive=true', SelectedPartMap);
        
        //function 8
        KadantHelperClasses.GetDefaultProductDivision();
        
        //function 6
        KadantHelperClasses.GetBladeDetails(String.valueOf(bl[0].Id));

    }
}