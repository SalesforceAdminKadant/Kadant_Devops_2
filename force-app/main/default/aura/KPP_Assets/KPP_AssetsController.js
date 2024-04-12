({
	onLoad : function(component, event, helper) {
        
		//var userId = $A.get("$SObjectType.CurrentUser.Id");
        
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
            component.set("v.DocId",docid)
        	//component.set("v.ShowSpinner",true);
        	var action = component.get('c.getAssets');
        	action.setParams({sAccountID: docid});      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.DataSet", response.getReturnValue());                    
					//component.set("v.ShowSpinner",false);
					//
					console.log(docid);
        		}
      		});
      		$A.enqueueAction(action);
        }    
      
	}
})