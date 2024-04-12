public without sharing class BomController {
    @AuraEnabled(cacheable=true)
    public static string GetAssetBomData(String assetId){  
        String json = '';                 
        Asset[] asset = [SELECT JSON__c FROM Asset Where id = :assetId LIMIT 1];
        if (!asset.isEmpty())
        {
            json = asset[0].JSON__c;
        }        
        return json;
    }

    @AuraEnabled(cacheable=true)
    public static string GetBomData(String productId){  
        String result = '[{"result":"No BOM found for this part"}';        
        list<String> pids = new list<String>(); 
        pids.add(productId);
        List<Bill_of_Material__c> boms = null;
                        
        boms = GetBoms(pids);            
        
        if (!boms.isEmpty())
        {
            // Get a unique list of BOM Child Ids for this Product                
            list<String> ids = new list<String>(); 
            for(Bill_of_Material__c bom : boms)
            {
                ids.add(bom.Child_Product__r.Id);
            }

            // Now see if there are child records for these IDs
            List<Bill_of_Material__c> childBoms = GetBoms(ids);                                
            
            result = '';

            // Now loop through all of the results to create a JSON string and assign it to the results!!
            result = '[';
            Integer i = 1;
            for(Bill_of_Material__c fbom : boms)
            {
                result += '{"Id":"' + i + '","QTY":' + fbom.Qty_Per__c + ',';  
                result += '"PID":"' + fbom.Child_Product__r.Id + '",';  
                String tmpName = FixJsonString(fbom.Child_Product__r.Name);  
                result += '"PN":"' + tmpName + '",';
                String tmpDesc = FixJsonString(fbom.Child_Part_Description__c);                    
                result += '"DN":"' + tmpDesc + '",';                    
                //system.debug('Quote in string: ' + tmpDesc);
                String tmpDraw = fbom.Child_Product__r.Drawing_Number__c;
                if (String.isBlank(tmpDraw) || String.isEmpty(tmpDraw))
                {
                    tmpDraw = 'No Drawing';
                }                
                result += '"DRG":"' + tmpDraw + '",';
                result += '"DID":"' + fbom.Child_Product__r.Drawing__c + '",';
                result += '"FAB":"' + fbom.Child_Product__r.Fabricated__c + '",';
                String tmpPos = fbom.Drw_Ref_No__c;
                if (String.isBlank(tmpPos) || String.isEmpty(tmpPos))
                {
                    tmpPos = '';
                }                
                result += '"POS":"' + tmpPos + '",';
                result += '"SEQ":' + fbom.Sequence__c + ',';
                result += '"CP":' + fbom.Child_Product__r.Mfg_Cost__c + '},';
                // Is there a Child Id in the ChildBoms?
                Boolean childExists = false;
                childExists = ChildIsInThere(fbom.Child_Product__r.Id, childBoms);
                if (!childBoms.isEmpty() && childExists)
                {
                    result = result.removeEnd('},');
                    result = result + ',';
                    String childJson = GetChildRecord(fbom.Child_Product__r.Id, childBoms, i);
                    result += childJson;
                }
                i++;
            }
            result = result.removeEnd(',');    
        }
        return result;
    }

    private static List<Bill_of_Material__c> GetBoms(list<String> ids)
    {
        List<Bill_of_Material__c> boms = new List<Bill_of_Material__c>();        
        boms = [Select Id, Parent_Product__c, Qty_Per__c, Parent_Product__r.Name, Child_Product__r.Name, Child_Part_Description__c, 
        Child_Product__r.Drawing_Number__c, Drw_Ref_No__c, Child_Product__r.Id, Child_Product__r.Fabricated__c, Child_Product__r.Drawing__c,
        Child_Product__r.Mfg_Cost__c, Sequence__c
        From Bill_of_Material__c Where Parent_Product__c IN :ids
        Order By Sequence__c];            
        return boms;        
    }

    private static String GetChildRecord(String childId, List<Bill_of_Material__c> boms, Integer id)
    {
        list<id> childIds = new list<id>();                                  
        for(Bill_of_Material__c cb : boms)
        {                 
            childIds.add(cb.Child_Product__r.Id);
        }
                
        // Now see if there are Grand Kid records for these IDs
        List<Bill_of_Material__c> grandKidBoms = GetBoms(childIds);        

        String json = '"_children":[';
        Integer j = 1;
        for(Bill_of_Material__c bom : boms)
        {
            if (childId == bom.Parent_Product__c)
            {
                String level = id + '-' + j;
                json += GetJsonRow(level, bom.Qty_Per__c, bom.Child_Product__r.Name, bom.Child_Part_Description__c, bom.Child_Product__r.Drawing_Number__c, bom.Child_Product__r.Id, bom.Child_Product__r.Fabricated__c, bom.Child_Product__r.Drawing__c, bom.Drw_Ref_No__c, bom.Child_Product__r.Mfg_Cost__c, bom.Sequence__c);
                Boolean grandKidExists = false;
                grandKidExists = ChildIsInThere(bom.Child_Product__r.Id, grandKidBoms);
                if (!grandKidBoms.isEmpty() && grandKidExists)
                {     
                    json = json.removeEnd('},');               
                    json = json + ',';
                    String grandKidJson = GetGrandChildRecord(bom.Child_Product__r.Id, grandKidBoms, level);
                    json += grandKidJson;
                }                
                j++;
            }
        }
        json = json.removeEnd(',');
        json += ']},';        
        return json;
    }

    private static String GetGrandChildRecord(String childId, List<Bill_of_Material__c> boms, String level)
    {        
        list<id> childIds = new list<id>();                                  
        for(Bill_of_Material__c cb : boms)
        {                 
            childIds.add(cb.Child_Product__r.Id);
        }
                
        // Now see if there are Grand Kid records for these IDs
        List<Bill_of_Material__c> greatGrandKidBoms = GetBoms(childIds);

        String json = '"_children":[';
        Integer k = 1;

        for(Bill_of_Material__c bom : boms)
        {            
            if (childId == bom.Parent_Product__c)
            {
                if (k == 1)
                {
                    level = level + '-' + k; 
                }
                else 
                {
                    level = level.substring(0, level.length()-1);  
                    level = level + k;
                }                
                json += GetJsonRow(level, bom.Qty_Per__c, bom.Child_Product__r.Name, bom.Child_Part_Description__c, bom.Child_Product__r.Drawing_Number__c, bom.Child_Product__r.Id, bom.Child_Product__r.Fabricated__c, bom.Child_Product__r.Drawing__c, bom.Drw_Ref_No__c, bom.Child_Product__r.Mfg_Cost__c, bom.Sequence__c);
                Boolean greatGrandKidExists = false;
                
                greatGrandKidExists = ChildIsInThere(bom.Child_Product__r.Id, greatGrandKidBoms);
                if (!greatGrandKidBoms.isEmpty() && greatGrandKidExists)
                {     
                    json = json.removeEnd('},');               
                    json = json + ',';
                    String grandKidJson = GetGreatGrandChildRecord(bom.Child_Product__r.Id, greatGrandKidBoms, level);
                    json += grandKidJson;
                }                  
                k++;
            }
        }
        json = json.removeEnd(',');
        json += ']},';        
        return json;
    }

    private static String GetGreatGrandChildRecord(String childId, List<Bill_of_Material__c> boms, String level)
    {
        String json = '"_children":[';
        Integer l = 1;

        for(Bill_of_Material__c bom : boms)
        {            
            if (childId == bom.Parent_Product__c)
            {
                if (l == 1)
                {
                    level = level + '-' + l; 
                }
                else 
                {
                    level = level.substring(0, level.length()-1);  
                    level = level + l;
                }                
                json += GetJsonRow(level, bom.Qty_Per__c, bom.Child_Product__r.Name, bom.Child_Part_Description__c, bom.Child_Product__r.Drawing_Number__c, bom.Child_Product__r.Id, bom.Child_Product__r.Fabricated__c, bom.Child_Product__r.Drawing__c, bom.Drw_Ref_No__c, bom.Child_Product__r.Mfg_Cost__c, bom.Sequence__c);
                l++;
            }
        }
        json = json.removeEnd(',');
        json += ']},';        
        return json;
    }

    private static Boolean ChildIsInThere(String childId, List<Bill_of_Material__c> boms)
    {
        Boolean exists = false;
        for(Bill_of_Material__c bom : boms)
        {
            if (childId == bom.Parent_Product__c)
            {
                return true;
            }
        }
        return exists;
    }

    private static String GetJsonRow(String level, Decimal qty, String name, String description, String drawing, String childId, String fabricated, String drawingId, String pos, Decimal cp, Decimal seq)
    {
        String json = '';
        json += '{"Id":"' + level + '","QTY":' + qty + ',';  
        json += '"PID":"' + childId + '",'; 
        String tmpName = FixJsonString(name);  
        json += '"PN":"' + tmpName + '",';
        String tmpDesc = FixJsonString(description);                    
        json += '"DN":"' + tmpDesc + '",';                    
        //system.debug('Quote in string: ' + tmpDesc);
        if (String.isBlank(drawing) || String.isEmpty(drawing))
        {
            drawing = 'No Drawing';
        }                
        json += '"DRG":"' + drawing + '",';
        json += '"DID":"' + drawingId + '",';
        json += '"FAB":"' + fabricated + '",';
        String tmpPos = pos;
        if (String.isBlank(tmpPos) || String.isEmpty(tmpPos))
        {
            tmpPos = '';
        }                
        json += '"POS":"' + tmpPos + '",';
        json += '"SEQ":' + seq + ',';
        json += '"CP":' + cp + '},';
        return json;
    }
 
    private static string FixJsonString(String fixJsonString)
    {
        String tmpStr = fixJsonString.replace('"', '');
        tmpStr = tmpStr.replace('\\', '');
        tmpStr = tmpStr.replace('\r', ' ');
        tmpStr = tmpStr.replace('\n', ' ');
        tmpStr = tmpStr.replace('\r\n', ' ');
        return tmpStr;
    }

    @AuraEnabled (cacheable=true)
    public static Product2 GetProduct(String id){
        return [SELECT Id, Name, Description, Product_Code_Description__c, ProductCode, Product_Family__c, Product_Line__c, Product_Type__c, Product_Classification__r.Name, Location__c FROM Product2 WHERE Id = :id LIMIT 1];                        
    }

    @AuraEnabled (cacheable=true)
    public static List<Asset> GetAssets(String id){
        List<Asset> allAssets = new List<Asset>();
        List<Account> assetAccounts = [Select Id, Name From Account Where ParentId = :id];
        // Get a unique list of Account Ids to search for all Assets        
        list<String> ids = new list<String>(); 
        ids.add(id);

        for(Account acct : assetAccounts)
        {
            ids.add(acct.Id);
        }  
        
        system.debug('Account IdS: ' + ids);

        if (ids != null)
        {
            allAssets = [Select Id, Name, SerialNumber, InstallDate, Account.Name, Product2.Name From Asset Where AccountId IN :ids];
        }        
        return allAssets;
    }
}