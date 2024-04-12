({
	doInit : function(component, event, helper) {
        console.log('IN THE AURA COMP!!!');
		let ref = component.get("v.pageReference");
        let recordIdIn = ref.state.c__recordId;        
        var action = component.get("c.GetAssets"); 
        action.setParams({ id: recordIdIn });
        action.setCallback(this, function(response){ 
            component.set("v.assets", response.getReturnValue());             
        }); 
     $A.enqueueAction(action); 
	},
    
    printClick : function(component, event, helper) {
        window.print();
    }
})