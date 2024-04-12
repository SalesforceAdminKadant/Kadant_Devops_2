({
    
    handleChanged: function(component, message, helper) {
        // Read the message argument to get the values in the message payload
    	if (message != null && message.getParam("recordData") != null) {
        	component.set("v.recordValue", message.getParam("recordData").value);
	    }
        
        //launch search to populate default product list
       	var action = component.get("c.srcProducts");
		$A.enqueueAction(action);
    },
    
    srcProducts : function(component, message, helper) {
        var searchFilter = component.get("v.recordValue");
    	var action = component.get('c.searchProducts');
        action.setParams({productDiv: 'PSGE',  searchFilter: searchFilter});
        //alert(searchFilter);
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.SearchResults", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);
	}
})