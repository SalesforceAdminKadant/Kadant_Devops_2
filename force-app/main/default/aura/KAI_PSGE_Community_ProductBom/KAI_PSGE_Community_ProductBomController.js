({
	loadScreen : function(component, event, helper) {
		var query = window.location.search.substring(1);
 
        var Pid = "";
		var Pnum = "";
        
        if(query.substring(0,5)=='pnum='){ 
			var vars = query.split("&");
			Pid = vars[1].split("=")[1];
			Pnum = vars[0].split("=")[1].replace('%2F','/').replace('+','');   
        }
        
        if(query.substring(0,4)=='pid='){ 
			var vars = query.split("&");
			Pid = vars[0].split("=")[1];
			Pnum = vars[1].split("=")[1].replace('%2F','/').replace('+','');   
        }

        if(Pid!='' && Pnum!=''){
        	component.set("v.ProductId",Pid);
          	component.set("v.ProductNum",Pnum);
        	var PartID = Pid;
        	//var PartCode = event.srcElement.title;    
        	var SelectedPartMap = component.get("v.SelectedPartListContainer");
        
        	var action = component.get('c.showBomParts');
        	action.setParams({PartID: PartID, SelectedPartMap: SelectedPartMap});
      		action.setCallback(this, function(response) {
        	var state = response.getState();
        		if (state === 'SUCCESS') {
          			component.set("v.ProductBom", response.getReturnValue());
                	//alert(response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action); 
    	}

    }

        
 
})