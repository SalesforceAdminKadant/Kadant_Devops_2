({
    
    handleChanged: function(component, message, helper) {
        // Read the message argument to get the values in the message payload
    	if (message != null && message.getParam("recordData") != null) {
        	component.set("v.recordValue", message.getParam("recordData").value);
	    }
        
        //launch search to populate default product list
       	var action = component.get("c.srcCustomers");
		$A.enqueueAction(action);
    },
    
    srcCustomers : function(component, message, helper) {
        var searchFilter = component.get("v.recordValue");
    	var action = component.get('c.searchCustomers');
        
        //var recordType = '012600000009eR7AAI'; //KSD
        //var recordType = '0124W000001AiswQAC'; //VK
        var recordType = '0120z000000UOouAAG'; //PSGE
       
        
        action.setParams({productDiv: 'PSGE',  searchFilter: searchFilter, recordType: recordType});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.SearchResults", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);
	}
})