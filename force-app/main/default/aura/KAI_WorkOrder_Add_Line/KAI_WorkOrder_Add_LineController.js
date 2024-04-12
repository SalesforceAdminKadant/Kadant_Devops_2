({
    doInit: function (component, event, helper) {
        var action  = component.get('c.IsAssetShipToOk');
        action.setParams({        
        	strRecordID: component.get("v.DocRecordId")       
    	});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){                
                var result = response.getReturnValue();
                //console.log('result: ' + result);
                if (result === 'false')
                {
                	component.find("btnAddLines").set('v.disabled', true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: 'Error with Account Set-up!',
                        message: 'The Account(ship-to) needs to be a child of the Billing Account.',
                        type: 'error'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);        
    },    
	openPage1: function(component, event, helper) {
      	component.set("v.isOpen", true);
       	component.set("v.isOpen2", false);        
 
        //launch search to get services
       	var action = component.get("c.searchServiceRates");
		$A.enqueueAction(action);
    },
    openPage2: function(component, event, helper){
        var DocRecordId = component.get("v.DocRecordId");  
        var DocObjectName = component.get("v.DocObjectName"); 
        var DocDivision = component.get("v.WorkOrderDivision");
        var DocCurrency = component.get("v.WorkOrderCurrency");
        var DocAsset = component.get("v.WorkOrderAsset");
        var DocAccount = component.get("v.WorkOrderAccount");
        var DocPriceBook = component.get("v.WorkOrderPriceBook");
     	var SelectedPartMap = component.get("v.SelectedPartListContainer");
        var SelectedPartMapQty = component.get("v.SelectedPartListContainerQty");
        var SelectedPartMapUP = component.get("v.SelectedPartListContainerUP");
        
        //console.log('SelectedPartMap:');
        //console.log(SelectedPartMap);
        
        var action = component.get('c.GetProductPricing');
        action.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, SelectedPartMap: SelectedPartMap, SelectedPartMapQty: SelectedPartMapQty, strPBId: DocPriceBook, strCurrency: DocCurrency, strAccount: DocAccount});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
				var TempVar = response.getReturnValue(); 
                //console.log('This is before adding the leadtime first');
                //console.log(TempVar);
               	//	for (var key in TempVar){
           		//	TempVar[key][11]=StandardLeadTime;
	   			//	}
               	// console.log('This is after adding the leadtime');
                //console.log('result from productpricing:');
              	//console.log(TempVar);
				component.set("v.WorkOrderLineList", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);       
        
        component.set("v.isOpen", false);
      	component.set("v.isOpen2", true); 
    },
    
	searchServiceRates: function(component, event, helper) { 
        var DocRecordId = component.get("v.DocRecordId");  
        var DocObjectName = component.get("v.DocObjectName"); 
        var DocDivision = component.get("v.WorkOrderDivision");
        var DocCurrency = component.get("v.WorkOrderCurrency");
        var DocAsset = component.get("v.WorkOrderAsset");
        var DocPriceBook = component.get("v.WorkOrderPriceBook");
        var SearchFilter = component.get("v.SearchFilterSQL");
        var SelectedTab = component.get("v.SelectedTab");
		//console.log(DocRecordId);
        //console.log(DocObjectName);
        //console.log(DocPriceBook);
        if(SelectedTab=='tab-HISTORY'){ 
            SearchFilter = SearchFilter + 'HISTORY = ';
        }
      	if(SelectedTab=='tab-SVCS'){ 
        	SearchFilter = SearchFilter + ' and product2.Service_Item__c = true';
        }
        if(SelectedTab=='tab-SERVCONS'){ 
        	SearchFilter = SearchFilter + 'SERVCONS = ';
        }
        console.log('SearchFilter = ' + SearchFilter);
       	var searchText = component.get('v.searchText');
		var SelectedPartMap = component.get("v.SelectedPartListContainer");
      	var SelectedPartMapQty = component.get("v.SelectedPartListContainerQty");
        
        //alert(DocRecordId+'--'+DocObjectName);       
        
        var action = component.get('c.searchForRates');
        action.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, strRecordDivision: DocDivision, strRecordCurrency: DocCurrency, strRecordAsset: DocAsset, strRecordPB: DocPriceBook, searchText: searchText, searchFilter: SearchFilter, SelectedPartMap: SelectedPartMap});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.SearchResults", response.getReturnValue());
                //alert(response.getReturnValue());
                
                var action2 = component.get("c.highlightSelectedParts");
				$A.enqueueAction(action2);
        	}
      	});
      	$A.enqueueAction(action);
        
      	//scroll to table top
      	document.getElementById('anchor_ScrollTo').scrollIntoView();        
   },   
   openPreviousPage: function(component, event, helper) {
      	component.set("v.isOpen", true);
       	component.set("v.isOpen2", false);          	    
   }, 
   changeQty: function(component, event, helper) {
        var ChkId = String(event.getSource().get("v.title"));
        ChkId = ChkId.replace('pil','');
        
        //clean up associative array with selected part numbers
       	var myMapQty = component.get("v.SelectedPartListContainerQty");
        var ChkQty = myMapQty[ChkId];
        do{
    	var selection = parseInt(window.prompt("Please enter a qty ", ChkQty), 10);
		}while(isNaN(selection) || selection < 1);
        myMapQty[ChkId] = String(selection);
       	component.set("v.SelectedPartListContainerQty",myMapQty);       
       
		//copy to screen map to screen list to support iteration       
       	var myMap2 = component.get("v.SelectedPartListContainer");
        var myMapQty2 = component.get("v.SelectedPartListContainerQty");
        var myMapUP2 = component.get("v.SelectedPartListContainerUP");
        var myMapSPEC2 = component.get("v.SelectedPartListContainerSPEC");
       	var optionsList = [];
       	for (var key2 in myMap2){
           optionsList.push({value:myMap2[key2], key:key2, qty:myMapQty2[key2], up:myMapUP2[key2], spec:myMapSPEC2[key2]});
	   	}
	    component.set("v.SelectedPartList",optionsList);
        
        var action = component.get("c.searchServiceRates");
		$A.enqueueAction(action);
    },
    deselectPart: function(component, event, helper) {
        var ChkId = String(event.getSource().get("v.title"));
        ChkId = ChkId.replace('pil','');
       
        //clean up associative array with selected part numbers
       	var myMap = component.get("v.SelectedPartListContainer");
        delete myMap[ChkId];
        component.set("v.SelectedPartListContainer",myMap); 
        
        //clean up associative array with selected part quantities
        var myMapQty = component.get("v.SelectedPartListContainerQty");
        delete myMapQty[ChkId];
       	component.set("v.SelectedPartListContainerQty",myMapQty);    
        
        //clean up associative array with selected part prices
        var myMapUP = component.get("v.SelectedPartListContainerUP");
        delete myMapUP[ChkId];
       	component.set("v.SelectedPartListContainerUP",myMapUP);  
        
        //clean up associative array with selected part specs
        //var myMapSPEC = component.get("v.SelectedPartListContainerSPEC");
        //delete myMapSPEC[ChkId];
       	//component.set("v.SelectedPartListContainerSPEC",myMapSPEC);  
       
		//copy to screen map to screen list to support iteration       
       	var myMap2 = component.get("v.SelectedPartListContainer");
        var myMapQty2 = component.get("v.SelectedPartListContainerQty");
        var myMapUP2 = component.get("v.SelectedPartListContainerUP");
        //var myMapSPEC2 = component.get("v.SelectedPartListContainerSPEC");
       	var optionsList = [];
       	for (var key2 in myMap2){
           optionsList.push({value:myMap2[key2], key:key2, qty:myMapQty2[key2], up:myMapUP2[key2], spec:""});
	   	}
	    component.set("v.SelectedPartList",optionsList);
        
        var action = component.get("c.searchServiceRates");
		$A.enqueueAction(action);
    },    
    selectPart: function(component, event, helper) {
        var ChkId = '';
        var ChkName = '';
        var ChkQty = '';
        var ChkUP = '';
        var ChkSPEC = '';
        
       	ChkId = String(event.getSource().get("v.label"));
        ChkName = String(event.getSource().get("v.name"));
        ChkQty = String(event.getSource().get("v.title")).replace('.00','').replace(' ','');
        ChkUP = '';
        ChkSPEC = '';
        
        console.log('After Select Part Check ID: ' + ChkId);
        
        var action = component.get('c.ProductOnHoldOrRunOut');
        action.setParams({prodId: ChkId});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
				var tempVar = response.getReturnValue(); 
                //console.log('Return of BOOL in TempVar: ' + tempVar);
                if (tempVar)
                {
                    alert('This part is either On Hold or Run Out please try to use another part!');
                }
        	}
      	});
      	$A.enqueueAction(action);
        
        var CheckExist = 0;
       	var myMap = component.get("v.SelectedPartListContainer");
        var myMapQty = component.get("v.SelectedPartListContainerQty");
        var myMapUP = component.get("v.SelectedPartListContainerUP");
        var myMapSPEC = component.get("v.SelectedPartListContainerSPEC");

       	//check if the current product id already selected
       	for (var key in myMap){ 
     		if(String(key) == String(ChkId)){
                CheckExist = 1;
            }
    	}
		//console.log(CheckExist);
       	//uncheck product in case it is already selected
        if(CheckExist == 1){
            delete myMap[ChkId];
            delete myMapQty[ChkId];
            delete myMapUP[ChkId];
            delete myMapSPEC[ChkId];
       	}
       	else{
			myMap[ChkId] = ChkName;
            myMapQty[ChkId] = String(ChkQty);
            myMapUP[ChkId] = String(ChkUP);
            myMapSPEC[ChkId] = ChkSPEC;
       	}
       	//console.log('MyMap 2nd time: ')
       	//console.log('My Map: ' + myMap);
		//add revised list to screen map       
       	component.set("v.SelectedPartListContainer",myMap);       
        component.set("v.SelectedPartListContainerQty",myMapQty); 
        component.set("v.SelectedPartListContainerUP",myMapUP);  
        component.set("v.SelectedPartListContainerSPEC",myMapSPEC);  
       
		//copy to screen map to screen list to support iteration       
       	var myMap2 = component.get("v.SelectedPartListContainer");
        var myMapQty2 = component.get("v.SelectedPartListContainerQty");
        var myMapUP2 = component.get("v.SelectedPartListContainerUP");
        var myMapSPEC2 = component.get("v.SelectedPartListContainerSPEC");
       	var optionsList = [];
       	for (var key2 in myMap2){
            optionsList.push({value:myMap2[key2], key:key2, qty:myMapQty2[key2], up:myMapUP2[key2], spec:myMapSPEC2[key2]});
	   	}
	   	component.set("v.SelectedPartList",optionsList);
        //console.log('Options List: ' + optionsList);
    },
    closePages: function(component, event, helper) {       
     	var DocRecordId = component.get("v.DocRecordId"); 
        var DocObjectName = component.get("v.DocObjectName"); 
     	var SelectedPartMap = component.get("v.SelectedPartListContainer");
		//var SelectedPartMapQty = component.get("v.SelectedPartListContainerQty");
        
       	var woQTY = [];
        var lineQty = component.find("lineQty");
		if ($A.util.isArray(lineQty)) {
    		lineQty.forEach(cmpQTY => { 
                woQTY.push({value:cmpQTY.get("v.value"), key:cmpQTY.get("v.name")});
            })
		} else {
    			woQTY.push({value:lineQty.get("v.value"), key:lineQty.get("v.name")});
		}

 		var woUP = [];
    	var lineUP = component.find("lineUP");
		var woUnitPrice = 0;
		if ($A.util.isArray(lineUP)) {
    		lineUP.forEach(cmpUP => { 
                woUnitPrice = cmpUP.get("v.value");
                if(String(woUnitPrice)==''){ woUnitPrice=0; }
            	woUP.push({value:woUnitPrice, key:cmpUP.get("v.name")});
            })
		} else {
            	woUnitPrice = lineUP.get("v.value");
            	if(String(woUnitPrice)==''){ woUnitPrice=0; }
    			woUP.push({value:woUnitPrice, key:lineUP.get("v.name")});
		}

 		var woDC = [];
		var woDiscount = 0;
    	var lineDC = component.find("lineDisc");
		if ($A.util.isArray(lineDC)) {
    		lineDC.forEach(cmpDC => { 
                woDiscount = cmpDC.get("v.value");
                if(woDiscount==''){ woDiscount='test'; }
            	woDC.push({value:cmpDC.get("v.value"), key:cmpDC.get("v.name")});
            })
		} else {
            	woDiscount = lineDC.get("v.value");
                if(woDiscount==''){ woDiscount='test'; }
    			woDC.push({value:lineDC.get("v.value"), key:lineDC.get("v.name")});
		}
		        console.log('Disc info: ');
                console.log(woDC);
		var woSPEC = [];
        var lineSPEC = component.find("lineSPEC");
		if ($A.util.isArray(lineSPEC)) {
    		lineSPEC.forEach(cmpSPEC => { 
                woSPEC.push({value:cmpSPEC.get("v.value"), key:cmpSPEC.get("v.name")});
            })
		} else {
    			woSPEC.push({value:lineSPEC.get("v.value"), key:lineSPEC.get("v.name")});
		}

        var action = component.get('c.AddWOLines');
 
      	action.setParams({strWORecordID: DocRecordId, SelectedPartMap: SelectedPartMap, lineQTY: JSON.stringify(woQTY), lineUP: JSON.stringify(woUP), lineDC: JSON.stringify(woDC), lineSP: JSON.stringify(woSPEC)});
		
		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
				//$A.get('e.force:refreshView').fire();
        	}
      	});
      	$A.enqueueAction(action);
		
		$A.get('e.force:refreshView').fire();

		component.set("v.SelectedPartListContainer","{}");
		component.set("v.SelectedPartListContainerQty","{}");
		component.set("v.SelectedPartListContainerUP","{}");
		component.set("v.SelectedPartListContainerSPEC","{}");
      	component.set("v.SelectedPartList","");
		component.set("v.SelectedPartListUP","");
		component.set("v.SelectedPartListQty","");
		component.set("v.SelectedPartListSPEC","");
      	component.set("v.SearchFilterSQL", "");
      	component.set("v.isOpen", false);
      	component.set("v.isOpen2", false);

        var ReloadPageUrl = $A.get("e.force:navigateToURL");
        ReloadPageUrl.setParams({"url": "/one/one.app#/sObject/"+ DocRecordId +"/view"});
       	ReloadPageUrl.fire();
    },
        
    cancelPages: function(component, event, helper) {
        /*
        console.log("step 1");
        var DocRecordId = component.get("v.DocRecordId"); 
        var DocObjectName = component.get("v.DocObjectName"); 
        var DocDivision = component.get("v.WorkOrderDivision");
        var DocCurrency = component.get("v.WorkOrderCurrency");
        var DocAsset = component.get("v.WorkOrderAsset");
        var DocPriceBook = component.get("v.WorkOrderPriceBook");
        var SearchFilter = ' and product2.Service_Item__c = true ';
        var searchText = '';
        //var SelectedPartMap = "";
      	//close all screens and reset fields   
      	
      	//$A.get('e.force:refreshView').fire();
        console.log("step 2");
       
        component.clearReference("v.SelectedPartListContainer");
        component.clearReference("v.SelectedPartListContainerQty");
        component.clearReference("v.SelectedPartListContainerUP");
		component.clearReference("v.SelectedPartListContainerSPEC");
 		*/

        component.set("v.SelectedPartListContainer","{}");
        component.set("v.SelectedPartListContainerQty","{}");
        component.set("v.SelectedPartListContainerUP","{}");
		component.set("v.SelectedPartListContainerSPEC","{}");
        
        var SelectedPartMap = {};
        //map['SelectedPartMap'] = SelectedPartMap;

        /*
        component.clearReference("v.SelectedPartList");
        component.clearReference("v.SelectedPartListUP");
		component.clearReference("v.SelectedPartListQty");
		component.clearReference("v.SelectedPartListSPEC");
        component.clearReference("v.SearchFilterMap");
      	component.clearReference("v.SearchFilterSQL");
        component.clearReference("v.searchText");
        */
        
        var SelectedPartList = [];
        var SelectedPartListUP = [];
        var SelectedPartListQty = [];
        var SelectedPartListSPEC = [];
      	component.set("v.SelectedPartList",SelectedPartList);
        component.set("v.SelectedPartListUP",SelectedPartListUP);
		component.set("v.SelectedPartListQty",SelectedPartListQty);
		component.set("v.SelectedPartListSPEC",SelectedPartListSPEC);
        component.set("v.SearchFilterMap", "{}");
      	component.set("v.SearchFilterSQL", "");
        component.set("v.searchText","");
        
        location.reload();
 
        //var action = component.get("c.searchServiceRates");
		//$A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
        //$A.get("e.force:closeQuickAction").fire();
        
        //var ReloadPageUrl = $A.get("e.force:navigateToURL");
        //ReloadPageUrl.setParams({"url": "/one/one.app#/sObject/"+ DocRecordId +"/view"});
        //ReloadPageUrl.setParams({"url": "/lightning/r/"+DocObjectName+"/"+ DocRecordId +"/view"});
        //ReloadPageUrl.fire();
    
        /*
        var action = component.get('c.searchForRates');
        action.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, strRecordDivision: DocDivision, strRecordCurrency: DocCurrency, strRecordAsset: DocAsset, strRecordPB: DocPriceBook, searchText: searchText, searchFilter: SearchFilter, SelectedPartMap: SelectedPartMap});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
                console.log("step 3");
          		component.set("v.SearchResults", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action);


        var workspaceAPI = component.find("workspaceWO");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                      tabId: focusedTabId,
                      includeAllSubtabs: true
             });
        });

        
        //var action = component.get("c.searchServiceRates");
		//$A.enqueueAction(action);
        
        component.set("v.isOpen", false);
      	component.set("v.isOpen2", false);
        */
   	}, 
    clearSearch: function(component, event, helper) {  
        
        var SelectedTab = component.get("v.SelectedTab");
        var SelectedSubTab = component.get("v.SelectedSubTab");
        
        //clear general filters
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	}        
        component.set("v.SearchFilterMAP", SearchFilterMap);
      	component.set("v.SearchFilterSQL", "");
        component.set("v.searchText", "");
        
        //var SearchFilter = component.get("v.SearchFilterSQL");
        //alert('search filter: '+SearchFilter);
         
        var action = component.get("c.searchServiceRates");
		$A.enqueueAction(action);
   	},
    switchMainTab: function(component, event, helper) {        
        //clear filter
        var SelectedTab = component.get("v.SelectedTab");
        console.log('SelectedTab: ');
        console.log(SelectedTab);
        
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	}        
        component.set("v.SearchFilterMAP", SearchFilterMap);
      	component.set("v.SearchFilterSQL", "");
        //component.set("v.searchText", "");
        console.log('SearchFilterMap:');
        console.log(SearchFilterMap);
        
        var action = component.get("c.searchServiceRates");
		$A.enqueueAction(action);
   	},
    searchOnEnter: function(component, event, helper) {
		if (event.getParams().keyCode == 13) {
            var action = component.get("c.searchServiceRates");
			$A.enqueueAction(action);
            console.log('searchonenter');
            //console.log(action);
        }
	},
    highlightSelectedParts: function(component, event, helper) {
        
        var SelectedPartMap = component.get("v.SelectedPartListContainer");
        var SelectedTab = component.get("v.SelectedTab");
        var SelectedSubTab = component.get("v.SelectedSubTab");
        
        if(SelectedTab=='tab-DUMMIES'){ 
        	if(SelectedSubTab=='tab-SERVICES-DEV'){ 
       			var SelectedPart = "";
                var SelectedPartDups = "";
                
       			for (var key in SelectedPartMap){
                    SelectedPart = key.substr(0, 18)+"-dup";
                    SelectedPartDups = key.substr(-5).replace('dup','').replace('-','');
                    let button = component.find('dummyPartButton2');
                    
                    for(var x=0; x < button.length; x++){
                        //console.log(x + "=>" + button[x].get("v.name") + "=>" + SelectedPart);
                        
                        if(button[x].get("v.name")==SelectedPart){
                        	button[x].set("v.label",SelectedPartDups);
        					button[x].set("v.variant","brand");  
                        }
                    }      
    			}
        	} 
        }
    },  
    addFiltersFromInputTXT: function(component, event, helper) {
       //keycode 13 is enter and keycode 8 is backspace
       //if (event.getParams().keyCode == 13 || event.getParams().keyCode == 8) { 
      		var strFilter ="";
      		var SelectListId = String(event.getSource().getLocalId());
      		var SelectListValue = String(event.getSource().get("v.value"));
      		//var SelectListValue = component.get("v."+SelectListId);
      		SelectListValue = SelectListValue.replace(",","."); 
      		var SearchFilterMap = component.get("v.SearchFilterMap");

           if(event.getParams().keyCode == 8 && SelectListValue != ""){
               //alert(SelectListValue.substr(0,(SelectListValue.length-1)));
               SelectListValue = SelectListValue.substr(0,(SelectListValue.length-1));
           }
           
            //alert(SelectListValue);
            component.set("v.TmpField",SelectListValue+"@"+event.getParams().keyCode);
           
			if(SelectListValue == ""){
            	delete SearchFilterMap[SelectListId];
       		}
       		else{
                strFilter =" AND " + SelectListId + "='" + SelectListValue + "'";
                strFilter = strFilter.replace("=<","<");
                strFilter = strFilter.replace("=>",">");
                
                //############ exceptions
                if(SelectListId=='Drawing_Number__c'){ strFilter =" AND " + SelectListId + " like '" + SelectListValue + "%'"; }
                if(SelectListId=='Customer_Item_Number__c'){ strFilter =" AND " + SelectListId + " like '" + SelectListValue + "%'"; }
                if(SelectListId=='SearchWord__c'){ strFilter =" AND " + SelectListId + " like '" + SelectListValue + "%'"; }               
				SearchFilterMap[SelectListId] = strFilter;           
       		}
       
       		var SearchFilter="";
       		for (var key in SearchFilterMap){ SearchFilter = SearchFilter + SearchFilterMap[key]; }
       		component.set("v.SearchFilterSQL", SearchFilter);
       
       		var action = component.get("c.searchServiceRates");
			$A.enqueueAction(action);
      //}
   	},
    addFiltersFromInput: function(component, event, helper) {
       //keycode 13 is enter and keycode 8 is backspace
       //if (event.getParams().keyCode == 13 || event.getParams().keyCode == 8) { 
      		var strFilter ="";
      		var SelectListId = String(event.getSource().getLocalId());
      		var SelectListValue = String(event.getSource().get("v.value"));
      		//var SelectListValue = component.get("v."+SelectListId);
      		SelectListValue = SelectListValue.replace(",","."); 
      		var SearchFilterMap = component.get("v.SearchFilterMap");

           if(event.getParams().keyCode == 8 && SelectListValue != ""){
               //alert(SelectListValue.substr(0,(SelectListValue.length-1)));
               SelectListValue = SelectListValue.substr(0,(SelectListValue.length-1));
           }
           
            //alert(SelectListValue);
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
       
       		var action = component.get("c.searchServiceRates");
			$A.enqueueAction(action);
      //}
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
       
       		var action = component.get("c.searchServiceRates");
			$A.enqueueAction(action);
   	}
})