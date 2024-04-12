({
onLoad : function(component, event, helper) {
        
    /*
     SELECT Id, Name, Child_Product__c, Sequence__c, Qty_Per__c, Parent_Product__c,Parent_Product__r.name, Description__c, Drw_Ref_No__c FROM Bill_of_Material__c where Parent_Product__r.name like '99%/0%' LIMIT 100
     */

		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var page = 'prd';  
    
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        var param ='';
        var docid = '';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
            }        
        }
   
        if(docid!=''){ 
            
            var nCount=0;
            
        	var action = component.get('c.showBomParts');
            action.setParams({PartID:docid });      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
                
        		if (state === 'SUCCESS') {
                    component.set("v.DataSet", response.getReturnValue());
    
					var DataSet = component.get("v.DataSet");
                    for (var key in DataSet){                        
                        nCount++;
                    }

                    component.set("v.DataSet", DataSet);
                } 
                               
      		});
      		$A.enqueueAction(action);

        }    
      
	}
})