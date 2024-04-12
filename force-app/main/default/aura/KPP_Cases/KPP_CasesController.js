({
	onLoad : function(component, event, helper) {
        
		//var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(window.location.search.substring(0));
		var query = window.location.search.substring(1);
       	var vars = query.split("&");
       	var param ='';
        var docid = '';
        var cusid = '';
        var page = 'cus';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
            }
            
            if(param.substring(0,6)=='cusid='){
            	   cusid = param.replace('cusid=','');
            }  
            
            if(param.substring(0,5)=='page='){
            	   page = param.replace('page=','');
            } 
        }

        if(docid!=''){ 
            
            component.set("v.DocId",docid)
        	//component.set("v.ShowSpinner",true);
        	var action = component.get('c.getCases');
            action.setParams({sDocumentID: docid, sPage:page });      		
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