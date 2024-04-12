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
        	var action = component.get('c.getQuoteLines');
        	action.setParams({sDocumentID: docid});      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.DataSet", response.getReturnValue()); 
					console.log(docid);
        		}
      		});
      		$A.enqueueAction(action);
        }    
      
	}
})