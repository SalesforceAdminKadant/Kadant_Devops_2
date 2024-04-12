({
	getStockInfo : function(component, DocRecordId,DocObjectName) {
    var action = component.get("c.getstockinfo");
       var self = this;
        action.setParams({recordId : DocRecordId, sObjectName : DocObjectName});
        console.log('recordID: ' + DocRecordId);
        console.log('object in helper: ' + DocObjectName);
        var TempVar = '' ;
        var currentTime = new Date();
        console.log(TempVar);
        console.log(currentTime);
       action.setCallback(this, function(actionResult){
            var state = actionResult.getState();
        		if (state === 'SUCCESS') {
                    var TempVar = actionResult.getReturnValue(); 
                    component.set("v.productinfo",TempVar);
                    component.set("v.hasinfo",true);
                    component.set("v.lastrefreshed",currentTime);
                    component.set("v.oninit",false);
                    if($A.util.isEmpty(TempVar)){
                        console.log('TempVar is empty!!');
                        component.set("v.hasinfo",false);
                        component.set("v.noinfo",true);
                        component.set("v.oninit",false);
                    }
                }
            	else{
                var TempVar = 'empty';
                component.set("v.hasinfo",false);
                component.set("v.noinfo",true);
                component.set("v.oninit",false);
                console.log('no success');
                }
        });
       $A.enqueueAction(action); 
   }
})