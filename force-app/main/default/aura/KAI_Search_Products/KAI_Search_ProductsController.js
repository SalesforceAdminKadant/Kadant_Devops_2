({
    openPage1: function(component, event, helper) {            	
        var sPortal = window.location.host.search('kadantportal')
        if(sPortal>-1){ component.set("v.Portal","Y");}
        
        // 1=field in object  2=id in component
       	//helper.fetchPickListVal(component, 'Product_Code_Picklist__c', 'Product_Code_Picklist__c');
        helper.fetchPickListVal(component, 'Location__c', 'Location__c');
        helper.fetchPickListVal(component, 'Product_Type__c', 'Product_Type__c');
        //helper.fetchPickListVal(component, 'Joint_Media__c', 'Joint_Media__c');
        helper.fetchPickListVal(component, 'Joint_Flow__c', 'Joint_Flow__c');        
        
        var action = component.get('c.GetDefaultProductDivision');
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
                var DefUserDiv = response.getReturnValue();
          		component.set("v.DefaultProductDivision", DefUserDiv);
                
        		if(DefUserDiv=='PSGE'){component.set("v.divPSGE",true);}
                if(DefUserDiv=='KGT'){component.set("v.divKGT",true);}
                if(DefUserDiv=='KSD'){component.set("v.divKSD",true);}
                if(DefUserDiv=='KCC'){component.set("v.divKCC",true);}
                if(DefUserDiv=='KJ'){component.set("v.divKJ",true);}
                if(DefUserDiv=='KL'){component.set("v.divKL",true);}
                if(DefUserDiv=='KCD'){component.set("v.divKCD",true);}
                if(DefUserDiv=='NML'){component.set("v.divNML",true);}
                if(DefUserDiv=='KPG'){component.set("v.divKPG",true);}
                if(DefUserDiv=='VK'){component.set("v.divVK",true);}
                
                if(DefUserDiv!=''){
                	var CheckExist = 0;
       				var myMap = component.get("v.SelectedDivisionsContainer");
        
       				for (var key in myMap){ 
     					if(String(key) == String(DefUserDiv)){CheckExist = 1;}
    				}

        			if(CheckExist == 1){delete myMap[DefUserDiv];}
       				else{myMap[DefUserDiv] = DefUserDiv;}

       				component.set("v.SelectedDivisionsContainer",myMap);                    
                            
        			//launch search to populate default product list
       				var action2 = component.get("c.searchParts");
					$A.enqueueAction(action2);                    
                }
        	}
      	});
      	$A.enqueueAction(action);
    },
    
    toggleDivision: function(component, event, helper) {
        var ChkId = String(event.getSource().get("v.label"));
        
        var CheckExist = 0;
       	var myMap = component.get("v.SelectedDivisionsContainer");
        
       	//check if the current product id already selected
       	for (var key in myMap){ 
     		if(String(key) == String(ChkId)){
                CheckExist = 1;
            }
    	}

        //uncheck product in case it is already selected
        if(CheckExist == 1){
            delete myMap[ChkId];
       	}
       	else{
			myMap[ChkId] = ChkId;
       	}
       
		//add revised list to screen map		
       	component.set("v.SelectedDivisionsContainer",myMap);   
       
        /*
		//copy to screen map to screen list to support iteration       
       	var myMap2 = component.get("v.SelectedDivisionsContainer");
       	var optionsList = [];
       	for (var key2 in myMap2){
            optionsList.push({value:myMap2[key2], key:key2});
	   	}
	    component.set("v.SelectedDivisions",optionsList);
        */
        
		//launch search to populate default product list
       	var action = component.get("c.searchParts");
		$A.enqueueAction(action);
	},
    
    switchSubTab: function(component, event, helper) {        
    	var action = component.get("c.searchParts");
		$A.enqueueAction(action);
   	},
        
    clearSearch: function(component, event, helper) {        
        //clear filter
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	}        
        component.set("v.SearchFilterMAP", SearchFilterMap);
      	component.set("v.SearchFilterSQL", "");
        component.set("v.searchText", "");
        
        //var SearchFilter = component.get("v.SearchFilterSQL");
        //alert('search filter: '+SearchFilter);
        
        //joint fields
        //component.find("ProductCode").set("v.value", "--All--");
        component.find("Joint_Media__c").set("v.value", "--All--");
        component.find("Joint_Seal_Material__c").set("v.value", "--All--");
        component.find("Joint_Flow__c").set("v.value", "--All--");
        component.find("Joint_Nipple_Size__c").set("v.value", "");
        component.find("Joint_M_Size__c").set("v.value", "");
        component.find("Joint_P_Size__c").set("v.value", "");
        component.find("Joint_S_Size__c").set("v.value", "");
        component.find("Joint_N_Size__c").set("v.value", "");
        component.find("Joint_O_Size__c").set("v.value", "");        
        
        //component.find("BLD_Material__c").set("v.value", "--All--");
		//component.find("BLD_Width__c").set("v.value", "");
		//component.find("BLD_Length__c").set("v.value", "");
		//component.find("BLD_Thickness__c").set("v.value", "");
		//component.find("BLD_Bevel_Angle__c").set("v.value", "");
           
        var action = component.get("c.searchParts");
		$A.enqueueAction(action);
   	},

    clearSearchExceptGlobal: function(component, event, helper) {          
        //clear filter
        var SelectedTab = component.get("v.SelectedTab");
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	} 
        
        if (SelectedTab == 'tab-JOINTS') {
            component.set("v.SearchFilterMAP", SearchFilterMap);
            component.set("v.SearchFilterSQL", "");
            //component.set("v.searchText", "");        
            //joint fields
            //component.find("ProductCode").set("v.value", "--All--");
            component.find("Joint_Media__c").set("v.value", "--All--");
            component.find("Joint_Seal_Material__c").set("v.value", "--All--");
            component.find("Joint_Flow__c").set("v.value", "--All--");
            component.find("Joint_Nipple_Size__c").set("v.value", "");
            component.find("Joint_M_Size__c").set("v.value", "");
            component.find("Joint_P_Size__c").set("v.value", "");
            component.find("Joint_S_Size__c").set("v.value", "");
            component.find("Joint_N_Size__c").set("v.value", "");
            component.find("Joint_O_Size__c").set("v.value", "");
        }
        
        if (SelectedTab == 'tab-BLADES') {
            component.set("v.SearchFilterMAP", SearchFilterMap);
            component.set("v.SearchFilterSQL", "");
            component.find("BLD_Material__c").set("v.value", "--All--");
            component.find("BLD_Width__c").set("v.value", "");
            component.find("BLD_Length__c").set("v.value", "");
            component.find("BLD_Thickness__c").set("v.value", "");
            component.find("BLD_Bevel_Angle__c").set("v.value", "");
        }
           
        var action = component.get("c.searchParts");
		$A.enqueueAction(action);
   	},
   
   	searchOnEnter: function(component, event, helper) {
		if (event.getParams().keyCode == 13) {
            var action = component.get("c.searchParts");
			$A.enqueueAction(action);
        }
	},
    
   	searchParts: function(component, event, helper) {        
        var PSGEdummies = ' ';
        var myMap = component.get("v.SelectedDivisionsContainer");

      	for (var key in myMap){ 
     		if(String(key) == 'PSGE'){
                PSGEdummies = ' AND PSG_E_Dummy__c=True ';
            }
    	}
        
        var SearchFilter = component.get("v.SearchFilterSQL");
        var SelectedTab = component.get("v.SelectedTab");
        var SelectedSubTab = component.get("v.SelectedSubTab");
        //if(SelectedTab=='tab-HISTORY'){ SearchFilter = 'HISTORY'; }
        if(SelectedTab=='tab-DUMMIES'){ 
            	if(SelectedSubTab=='tab-SERVICES-GEN'){ SearchFilter = SearchFilter + ' AND Product_Family__c not in(\'DCF (Doctoring, Cleaning, Filtration)\',\'FH (Fluid Handling)\')'; }
            	if(SelectedSubTab=='tab-SERVICES-FH'){ SearchFilter = SearchFilter + ' AND Product_Family__c=\'FH (Fluid Handling)\''; }
            	if(SelectedSubTab=='tab-SERVICES-DCF'){ SearchFilter = SearchFilter + ' AND Product_Family__c=\'DCF (Doctoring, Cleaning, Filtration)\''; }
            	SearchFilter = SearchFilter + ' AND Miscellaneous_Item__c=True ' + PSGEdummies;
        }
        if(SelectedTab=='tab-JOINTS'){ SearchFilter = SearchFilter + ' AND (Product_Line__c in(\'FH - Joints\',\'Joints\') or ProductCode like \'RJ -%\')'; }
        //if(SelectedTab=='tab-PARTS'){ SearchFilter = SearchFilter + ' AND Product_Line__c=\'FH - Spare Parts\''; }
        if(SelectedTab=='tab-SYPHONS'){ SearchFilter = SearchFilter + ' AND Product_Line__c=\'FH - Syphons\''; }
        if(SelectedTab=='tab-BLADES'){ SearchFilter = SearchFilter + ' AND Product_Classification_Record_Type_Name__c=\'PSG-E Product - Blade\''; }
        
        //alert(SearchFilter);
        
      	var searchText = component.get('v.searchText');
		var SelectedDivisionMap = component.get("v.SelectedDivisionsContainer");

        var action = component.get('c.searchForPartsGeneric');
        action.setParams({searchText: searchText, searchFilter: SearchFilter, SelectedDivisionMap: SelectedDivisionMap});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.SearchResults", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);
   },
    
   addFiltersFromInput: function(component, event, helper) {
       var strFilter ="";
       var SelectListId = String(event.getSource().getLocalId());
       var SelectListValue = String(event.getSource().get("v.value"));
       SelectListValue = SelectListValue.replace(",","."); 
       var SearchFilterMap = component.get("v.SearchFilterMap");
       
       if(event.getParams().keyCode == 8 && SelectListValue != ""){
           SelectListValue = SelectListValue.substr(0,(SelectListValue.length-1));
       }
       
       component.set("v.TmpField",SelectListValue+"@"+event.getParams().keyCode);
       
       if(SelectListValue == ""){
           delete SearchFilterMap[SelectListId];
       }
       else{
           strFilter =" AND " + SelectListId + "=" + SelectListValue;
           strFilter = strFilter.replace("=<","<");
           strFilter = strFilter.replace("=>",">");
           SearchFilterMap[SelectListId] = strFilter;
       }
       
       var SearchFilter="";
       for (var key in SearchFilterMap){ SearchFilter = SearchFilter + SearchFilterMap[key]; }
       component.set("v.SearchFilterSQL", SearchFilter);
       
       var action = component.get("c.searchParts");
       $A.enqueueAction(action);
   	},

    addFiltersFromInputTXT: function(component, event, helper) {
        var strFilter ="";
        var SelectListId = String(event.getSource().getLocalId());
        var SelectListValue = String(event.getSource().get("v.value"));
        SelectListValue = SelectListValue.replace(",","."); 
        var SearchFilterMap = component.get("v.SearchFilterMap");
        
        if(event.getParams().keyCode == 8 && SelectListValue != ""){
            SelectListValue = SelectListValue.substr(0,(SelectListValue.length-1));
        }
        
        component.set("v.TmpField",SelectListValue+"@"+event.getParams().keyCode);
        
        if(SelectListValue == ""){
            delete SearchFilterMap[SelectListId];
        }
        else{
            strFilter =" AND " + SelectListId + "='" + SelectListValue + "'";
            strFilter = strFilter.replace("=<","<");
            strFilter = strFilter.replace("=>",">");
            SearchFilterMap[SelectListId] = strFilter;
        }
        
        var SearchFilter="";
        for (var key in SearchFilterMap){ SearchFilter = SearchFilter + SearchFilterMap[key]; }
        component.set("v.SearchFilterSQL", SearchFilter);
        
        var action = component.get("c.searchParts");
        $A.enqueueAction(action);
   	},
      
   addFilters: function(component, event, helper) {
       var SearchFilterMap = component.get("v.SearchFilterMap");
       var SelectListId = String(event.getSource().getLocalId());
       var SelectListValue = String(event.getSource().get("v.value"));
       
       if(SelectListValue == "--All--"){
           delete SearchFilterMap[SelectListId];
       }
       else{
           SearchFilterMap[SelectListId] = " AND " + SelectListId + "=" + "'" + SelectListValue + "'";
       }
       
       var SearchFilter="";
       for (var key in SearchFilterMap){ 
           SearchFilter = SearchFilter + SearchFilterMap[key];
       }
       component.set("v.SearchFilterSQL", SearchFilter);
       
       var action = component.get("c.searchParts");
       $A.enqueueAction(action);
   	},   
})