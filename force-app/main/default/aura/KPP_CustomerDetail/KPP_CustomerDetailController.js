({
	getDocumentDetail : function(component, message, helper) {
        
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
        	var action = component.get('c.getCustomer');
        	action.setParams({DocumentID: docid});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
          		component.set("v.DocumentDetail", response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action);
        }
        
	}    
    
})