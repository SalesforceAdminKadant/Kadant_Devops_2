({
	getStockInfo : function(component, event, helper) {
    var DocRecordId = component.get("v.DocRecordId");
    var DocObjectName = component.get("v.DocObjectName")
        console.log('in controller recordid: ' + DocRecordId)
        console.log('in controller objectname: ' + DocObjectName)
    helper.getStockInfo(component,DocRecordId,DocObjectName);
   },
   doInit : function(component, event, helper) {
		component.set("v.oninit",true); 
        }
    
})