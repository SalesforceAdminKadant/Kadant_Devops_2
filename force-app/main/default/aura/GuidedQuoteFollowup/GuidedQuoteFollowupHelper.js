({
    getQuoteList : function(component, ownerID) {
    	var action = component.get("c.getQuotes");
       var self = this;
        action.setParams({"ownerID" : ownerID});
        console.log('ownerid getquotelist' + ownerID);
        action.setCallback(this, function(actionResult){
            component.set("v.quote",actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
   },
        getQuoteList2 : function(component, ownerID) {
    	var action = component.get("c.getQuotes2");
       var self = this;
        action.setParams({"ownerID" : ownerID});
        console.log('owneridgetquotelist no2' + ownerID);
        action.setCallback(this, function(actionResult){
            component.set("v.quote2",actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
   },
    emailSelected : function(component,event,selctedRec,selctedRec2){
        var action = component.get("c.emailSlctRec");
        action.setParams({
            "slctRec": selctedRec,
            "slctRec2" : selctedRec2
         });
        console.log('selctedrec1 :' + selctedRec + 'slectedRec2 :' + selctedRec2);
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state == "SUCCESS")
            {
                component.set("v.quote",response.getReturnValue());
                console.log("Successfully Created..");
             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Email(s) successfully queued. Sending will take a couple of minutes.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
            }else if (state=="ERROR") {
                console.log(action.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },
        removeSelected : function(component,event,selctedRec,selctedRec2){
        var action = component.get("c.removeSlctRec");
        action.setParams({
            "slctRec": selctedRec,
            "slctRec2" : selctedRec2
         });
        console.log(selctedRec2);
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state == "SUCCESS")
            {
                component.set("v.quote",response.getReturnValue());
                console.log("Successfully Removed..");
             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Items removed from Guided Quote Followup list. You can re-add them by setting the Guided Quote? checkbox on the quote',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
            }else if (state=="ERROR") {
                console.log(action.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})