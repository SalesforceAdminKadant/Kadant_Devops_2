({   
    getAccountList : function(component, rectypename,ownerID,budgetID) {
    	var action = component.get("c.getAccounts");
       var self = this;
        action.setParams({"recordtype" : rectypename,"ownerID" : ownerID, "budgetID" : budgetID});
        console.log(rectypename + 'and here' + ownerID + 'budget' + budgetID);
        action.setCallback(this, function(actionResult){
            component.set("v.account",actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
   },
    deleteSelected : function(component,event,selctedRec){
        var action = component.get("c.delSlctRec");
        action.setParams({
            "slctRec": selctedRec,
            "BudgetId": component.get("v.DocRecordId")
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state == "SUCCESS")
            {
                component.set("v.account",response.getReturnValue());
                $A.get('e.force:refreshView').fire();
                console.log("Successfully Created..");
            }else if (state=="ERROR") {
                console.log(action.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})