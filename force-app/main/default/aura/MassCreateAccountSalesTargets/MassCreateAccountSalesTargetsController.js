({
        handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            console.log("You loaded a record in " + 
                        component.get("v.BudgetRecord.RecordType.Name"));
		        var rectypename = component.get("v.BudgetRecord.RecordType.Name");
            	var ownerID = component.get("v.BudgetRecord.OwnerId");
                var budgetID = component.get("v.recordId");
        console.log(rectypename + 'whats this' + ownerID + 'budget' + budgetID);
        helper.getAccountList(component, rectypename, ownerID, budgetID);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
        accountList : function(component, event, helper) {
        var rectypename = component.get("v.BudgetRecord.RecordType.Name");
        console.log(rectypename + 'whats this');
        helper.getAccountList(component);
    },
    selectAll: function(component,event, helper){
        var slctCheck = event.getSource().get("v.value");
        var getCheckAllId = component.find("cboxRow");
       if ($A.util.isArray(getCheckAllId)) { 
        	if (slctCheck == true) {
            	for (var i = 0; i < getCheckAllId.length; i++) {
                component.find("cboxRow")[i].set("v.value", true);             
            	}
        	}else {
            	for (var i = 0; i < getCheckAllId.length; i++) {
                component.find("cboxRow")[i].set("v.value", false);
            	}
        	}
       }else{
                if (slctCheck == true) {
                component.find("cboxRow").set("v.value", true);             
            	}
        		else {
     		component.find("cboxRow").set("v.value", false);
            	}
        }   
       
    },
    changeSelectAll:function(component,event, helper){
        var slctCheckRow = event.getSource().get("v.value");
        var getCheckAllId = component.find("cbox");
        if(slctCheckRow == false) {
            component.find("cbox").set("v.value", false);
        }
    },
    deleteSlctd : function(component,event,helper) {
        var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        if ($A.util.isArray(getCheckAllId)) {
        	for (var i = 0; i < getCheckAllId.length; i++) {
            
           	 if(getCheckAllId[i].get("v.value") == true )
          	  {
           	     selctedRec.push(getCheckAllId[i].get("v.text")); 
          	  }
        	}
        }
        else{
                       	 if(getCheckAllId.get("v.value") == true )
          	  {
           	     selctedRec.push(getCheckAllId.get("v.text")); 
          	  }
            
        }
        
        helper.deleteSelected(component,event,selctedRec);
    }
})