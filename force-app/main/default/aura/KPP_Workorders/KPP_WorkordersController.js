({
	onLoad : function(component, message, helper) {
        
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        var param ='';
        var docid = '';
        var cusid = '';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
            } 
            if(param.substring(0,6)=='cusid='){
            	   cusid = param.replace('cusid=','');
            }  
        }

        if(docid!=''){        
        	var action = component.get('c.getWorkorders');
        	action.setParams({sDocumentID: docid, sAccountID: cusid});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
          		component.set("v.DataSet", response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action);
        }
        
	}    
    
})