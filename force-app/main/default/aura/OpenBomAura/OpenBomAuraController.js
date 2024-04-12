({
	doInit : function(component, event, helper) {
		let ref = component.get("v.pageReference");
        let recordIdIn = ref.state.c__recordId;
        console.log('IN THE AURA COMP!!!');
        component.set("v.theRecordId", recordIdIn);
	},
    
    printClick : function(component, event, helper) {
        window.print();
    }
})