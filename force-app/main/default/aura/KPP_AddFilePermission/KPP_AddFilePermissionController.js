({
   AddFileAccess : function(component, event, helper) {

            var action = component.get("c.AddFilePermission");  
        	action.setParams({
            	ContentId: component.get("v.recordId")
        	});

        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {                 
					//console.log(response.getReturnValue());
         		}
      		});
      		$A.enqueueAction(action);
       		$A.get('e.force:refreshView').fire();

    },  
    
    DeleteFileAccess : function(component, event, helper) {

            var action = component.get("c.DeleteFilePermission");  
        	action.setParams({
            	ContentId: component.get("v.recordId")
        	});

        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {                 
					//console.log(response.getReturnValue());
         		}
      		});
      		$A.enqueueAction(action);
        	$A.get('e.force:refreshView').fire();

    }  
    
})