({
	getDocumentDetail : function(component, message, helper) {
        
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

        if(docid!='' && cusid!=''){ 
            component.set("v.DocId", docid);   
            component.set("v.CusId", cusid);  
        	var action = component.get('c.getOpp');
        	action.setParams({sDocumentID: docid, sAccountID: cusid});
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