({
    init: function(component, event, helper) {
 		var DocRecordId = component.get("v.DocRecordId"); 
		var DocObjectName = 'Quote';
        
        var eventParams = event.getParams();
 
        if(eventParams.changeType === "LOADED") {
        	var DocParentRecordId = component.get("v.simpleRecord").QuoteId;
            var DocProductId = component.get("v.simpleRecord").Product2Id;
            var DocProductLP = component.get("v.simpleRecord").List_Price__c;
            //alert(DocProductLP);
            component.set("v.DocProductLP",DocProductLP);
			var SelectedPartMap = component.get("v.SelectedPartListContainer");
        	SelectedPartMap[DocProductId] = 'DUMMY';
        	component.set("v.SelectedPartListContainer",SelectedPartMap); 

        	var action = component.get('c.GetCustomerPricing');
       		action.setParams({strRecordID: DocParentRecordId, strObjectName: DocObjectName, SelectedPartMap: SelectedPartMap});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.QuotePricingList", response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action);
        }
    },
})