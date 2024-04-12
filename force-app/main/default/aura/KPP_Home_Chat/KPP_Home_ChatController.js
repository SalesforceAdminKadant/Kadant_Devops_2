({
	onLoad : function(component, event, helper) {
        
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var page = 'home'; 
        
        if(userId!=''){ 
  
        	var action = component.get('c.getHomeChat');
        	action.setParams({sUser: userId});      		
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