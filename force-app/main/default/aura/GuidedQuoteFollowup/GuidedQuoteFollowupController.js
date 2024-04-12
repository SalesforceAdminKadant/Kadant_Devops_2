({
	
   doInit : function(component, event, helper) {
    var ownerID = $A.get("$SObjectType.CurrentUser.Id");
    helper.getQuoteList(component, ownerID);
    helper.getQuoteList2(component, ownerID);  
   },
    selectAll: function(component,event, helper){
        var slctCheck = event.getSource().get("v.value");
        var firstOrSecond = event.getSource().get("v.name");
        console.log(firstOrSecond + 'which checkboxrow');
        if(firstOrSecond=='second'){
        	var getCheckAllId = component.find("cboxRow2");
            }
        else{
            var getCheckAllId = component.find("cboxRow");
        }
              
       if ($A.util.isArray(getCheckAllId)) { 
        	if (slctCheck == true) {
                for (var i = 0; i < getCheckAllId.length; i++) {
                    if(firstOrSecond=='second'){
                	component.find("cboxRow2")[i].set("v.value", true); 
                    }
                    else{
                    component.find("cboxRow")[i].set("v.value", true);    
                    }
            	}
        	}else {
            	for (var i = 0; i < getCheckAllId.length; i++) {
                	if(firstOrSecond=='second'){
                	component.find("cboxRow2")[i].set("v.value", false);
                    }
                    else{
                    component.find("cboxRow")[i].set("v.value", false);    
                    }
            	}
        	}
       }else{
                if (slctCheck == true) {
                	if(firstOrSecond=='second'){
                	component.find("cboxRow2").set("v.value", true); 
                    }
                    else{
                    component.find("cboxRow").set("v.value", true);    
                    }          
            	}
        		else {
     				if(firstOrSecond=='second'){
                	component.find("cbox2").set("v.value", false); 
                    }
                    else{
                    component.find("cbox").set("v.value", false);    
                    }
            	}
        }   
       
    },
    changeSelectAll:function(component,event, helper){
        var slctCheckRow = event.getSource().get("v.value");
        var firstOrSecond = event.getSource().get("v.name");
            if(firstOrSecond=='first'){
        	var getCheckAllId = component.find("cbox");
            }
        	else{
            var getCheckAllId = component.find("cbox2");
        	}
        if(slctCheckRow == false) {
            if(firstOrSecond=='first'){
                if(component.find("cbox").length > 0 ) {component.find("cbox")[0].set("v.value")}
             // component.find("cbox").set("v.value", false); 
            }
            else{
                if(component.find("cbox2").length > 0 ) {component.find("cbox")[0].set("v.value")}
               // component.find("cbox2").set("v.value", false);    
            }
            	
        }
    },
    emailSlctd : function(component,event,helper) {
        var selctedRec = [];
        var selctedRec2 = [];
        var buttonName = event.getSource().get("v.name");
        console.log(buttonName);
                if(buttonName=='FirstButton'){
        var getCheckAllId = component.find("cboxRow");
            }
        else{
            var getCheckAllId = component.find("cboxRow2");
        }
        if ($A.util.isArray(getCheckAllId)) {
        	for (var i = 0; i < getCheckAllId.length; i++) {
            
           	 if(getCheckAllId[i].get("v.value") == true )
          	  {
                  if(buttonName=='FirstButton'){
           	     selctedRec.push(getCheckAllId[i].get("v.text")); 
                      console.log(selctedRec);
                  }else{
                 selctedRec2.push(getCheckAllId[i].get("v.text"));   
                      console.log(selctedRec);
                  }
          	  }
        	}
        }   
        else{
               if(getCheckAllId.get("v.value") == true )
          	  {
           	     if(buttonName=='FirstButton'){
           	     selctedRec.push(getCheckAllId.get("v.text")); 
                  }else{
                 selctedRec2.push(getCheckAllId.get("v.text"));     
                  } 
          	  }
            
        }
        console.log(selctedRec2);
        
        if(!$A.util.isEmpty(selctedRec) || !$A.util.isEmpty(selctedRec2)){
        helper.emailSelected(component,event,selctedRec,selctedRec2);
    	} 
    	else
    	{
    	             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'No items selected',
            duration:' 5000',
            type: 'warning',
            mode: 'dismissible'
        });
        toastEvent.fire();
		}
    },
    removeSlctd : function(component,event,helper) {
        var selctedRec = [];
        var selctedRec2 = [];
        var buttonName = event.getSource().get("v.name");
        console.log(buttonName);
                if(buttonName=='FirstButton'){
        var getCheckAllId = component.find("cboxRow");
            }
        else{
            var getCheckAllId = component.find("cboxRow2");
        }
        if ($A.util.isArray(getCheckAllId)) {
        	for (var i = 0; i < getCheckAllId.length; i++) {
            
           	 if(getCheckAllId[i].get("v.value") == true )
          	  {
                  if(buttonName=='FirstButton'){
           	     selctedRec.push(getCheckAllId[i].get("v.text")); 
                      console.log(selctedRec);
                  }else{
                 selctedRec2.push(getCheckAllId[i].get("v.text"));   
                      console.log(selctedRec);
                  }
          	  }
        	}
        }   
        else{
               if(getCheckAllId.get("v.value") == true )
          	  {
           	     if(buttonName=='FirstButton'){
           	     selctedRec.push(getCheckAllId.get("v.text")); 
                  }else{
                 selctedRec2.push(getCheckAllId.get("v.text"));     
                  } 
          	  }
            
        }
        console.log(selctedRec2);
        
        if(!$A.util.isEmpty(selctedRec) || !$A.util.isEmpty(selctedRec2)){
        helper.removeSelected(component,event,selctedRec,selctedRec2);
    	} 
    	else
    	{
    	             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'No items selected',
            duration:' 5000',
            type: 'warning',
            mode: 'dismissible'
        });
        toastEvent.fire();
		}
    },
    openPopup: function(component, event, helper) {
      	component.set("v.isOpen", true);     
    },
    openPopup2: function(component, event, helper) {
      	component.set("v.isOpen2", true);     
    },
    closePopup: function(component, event, helper){
    	component.set("v.isOpen", false); 
        component.set("v.isOpen2", false);
        $A.get('e.force:refreshView').fire();
    }
})