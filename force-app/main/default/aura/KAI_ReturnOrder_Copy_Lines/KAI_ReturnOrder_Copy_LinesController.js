({
    
     GetOrderLines : function(component, event, helper) {
        var DocRecordId = component.get("v.DocRecordId"); 
       
        var action = component.get('c.getSourceOrderLines');
        action.setParams({strRecordID: DocRecordId});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
				component.set("v.SourceOrderLines", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);
        
    },
    
    CopyLines : function(component, event, helper) {
        var DocRecordId = component.get("v.DocRecordId"); 
		var DocObjectName = component.get("v.DocObjectName");
        
        //alert(DocRecordId);
        /*
        var action = component.get('c.GetProductPricing');
        action.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, SelectedPartMap: SelectedPartMap, SelectedPartMapQty: SelectedPartMapQty});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
				component.set("v.QuoteLineList", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);
        */
        
    },
     
    selectLine: function(component, event, helper) {
       	var ChkId = String(event.getSource().get("v.label"));
        var ChkName = String(event.getSource().get("v.name"));
        var ChkQty = String(event.getSource().get("v.title")).replace('.00','').replace(' ','');
    
        var CheckExist = 0;
       	var myMap = component.get("v.SelectedPartListContainer");
        var myMapQty = component.get("v.SelectedPartListContainerQty");
        
       	//check if the current product id already selected
       	for (var key in myMap){ 
     		if(String(key) == String(ChkId)){
                CheckExist = 1;
            }
    	}

       //uncheck product in case it is already selected
        if(CheckExist == 1){
            delete myMap[ChkId];
            delete myMapQty[ChkId];
       	}
       	else{
			myMap[ChkId] = ChkName;
            myMapQty[ChkId] = String(ChkQty);
       	}
       
		//add revised list to screen map       
       	component.set("v.SelectedPartListContainer",myMap);       
        component.set("v.SelectedPartListContainerQty",myMapQty);  
       
		//copy to screen map to screen list to support iteration       
       	var myMap2 = component.get("v.SelectedPartListContainer");
        var myMapQty2 = component.get("v.SelectedPartListContainerQty");
       	var optionsList = [];
       	for (var key2 in myMap2){
            optionsList.push({value:myMap2[key2], key:key2, qty:myMapQty2[key2]});
	   	}
	   component.set("v.SelectedPartList",optionsList);
    },  

    
    ChangeQty : function(component, event, helper){
        var ChkId = String(event.getSource().get("v.name"));
        var ChkQty = String(event.getSource().get("v.value")).replace('.00','').replace(' ','');
        
        //alert(ChkId);
        //alert(ChkQty);
        
        var CheckExist = 0;
       	var myMap = component.get("v.SelectedPartListContainer");
        var myMapQty = component.get("v.SelectedPartListContainerQty");
        
        //check if the current product id already selected
       	for (var key in myMap){ 
     		if(String(key) == String(ChkId)){
                CheckExist = 1;
            }
    	}

        //uncheck product in case it is already selected
        if(CheckExist == 1){
			myMapQty[ChkId] = String(ChkQty);
       	}
 
        //add revised list to screen map       
        component.set("v.SelectedPartListContainerQty",myMapQty);
        
        //copy to screen map to screen list to support iteration       
       	var myMap2 = component.get("v.SelectedPartListContainer");
        var myMapQty2 = component.get("v.SelectedPartListContainerQty");
       	var optionsList = [];
       	for (var key2 in myMap2){
            optionsList.push({value:myMap2[key2], key:key2, qty:myMapQty2[key2]});
	   	}
	    component.set("v.SelectedPartList",optionsList);
        
    },

    
    CloseDialog : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    }
})