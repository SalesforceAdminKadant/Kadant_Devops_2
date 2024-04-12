({
		fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
            
        //var opts = [];
        var currentList = component.get("v.PicklistValueCollection");
        var opts = currentList;
            
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        key : elementId,
                        label: "--All--",
                        class: "optionClass",                        
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        key : elementId,
                        label: allValues[i],
                        class: "optionClass",                        
                        value: allValues[i]
                    });
                }

                component.set("v.PicklistValueCollection",opts);
            }
        });
        $A.enqueueAction(action);
	}    
})