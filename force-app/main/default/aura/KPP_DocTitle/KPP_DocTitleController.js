({
	getDocumentDetail : function(component, message, helper) {
        
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        var param ='';
        var docid = '';
        var cusid = '';
        var page = '';
        
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
                	component.set("v.PageName", page);
            }  
        }

        if(docid!=''){        
            if(page=='opp') {var action = component.get('c.getOpp');}
            if(page=='cas') {var action = component.get('c.getCase');} 
            if(page=='ast') {var action = component.get('c.getAsset');} 
            if(page=='ord') {var action = component.get('c.getOrder');} 
            if(page=='quo') {var action = component.get('c.getQuote');} 
            if(page=='prd') {var action = component.get('c.getProduct');} 
            
            if(page!='') {
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
        
	}    
    
})