({	
    openPage1: function(component, event, helper) {
      	component.set("v.isOpen", true);
       	component.set("v.isOpen2", false);
        
        //Get recordtype id to determine tabs to render (because of limitation in aura:if)
        var recordTypeId = component.get("v.quoteRecord.RecordTypeId");
        
        //Set tabset to minimal for KCD, KSA, NML, KJ, VK, SMH, KBC, KSD, BM
        if (recordTypeId=='0120z000000UQ3gAAG'||recordTypeId=='0124W0000015fSfQAI'||recordTypeId=='0124W0000016T0IQAU'||recordTypeId=='0120z000000UQ5wAAG'||recordTypeId=='0124W000001AitLQAS'||recordTypeId=='0124W0000011e27QAA'||recordTypeId=='0124W000001AjeXQAS'||recordTypeId=='0124W0000011dYzQAI'||recordTypeId=='0124W000001AjieQAC'){
            component.set("v.showExtendedTabset",false);
        }
                
        // 1=field in object  2=id in component
       	//helper.fetchPickListVal(component, 'Product_Code_Picklist__c', 'Product_Code_Picklist__c');
        helper.fetchPickListVal(component, 'Location__c', 'Location__c');
        helper.fetchPickListVal(component, 'Product_Type__c', 'Product_Type__c');
        //helper.fetchPickListVal(component, 'Product_Line__c', 'Product_Line__c');
        //helper.fetchPickListVal(component, 'Joint_Media__c', 'Joint_Media__c');
        helper.fetchPickListVal(component, 'Joint_Flow__c', 'Joint_Flow__c');
        
        //Get blade details
        var bldRecordTypeId = component.get("v.BladeDetailsRecordType");
        var action = component.get('c.GetBladeDetails');
        //console.log('Blade record type ID: ' + bldRecordTypeId);
        //console.log(action);
        action.setParams({sRecordTypeId: bldRecordTypeId});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {                
				component.set("v.BladeDetails", response.getReturnValue());                
                var bldMAPwithICP = [];
                var bldMap = component.get("v.BladeDetails");
                
                //console.log('Blade map content: ');
                //console.log(bldMap);
                
       			var matList = [];
                var prevMat = "";
       			for (var key in bldMap){
                    if(prevMat != String(bldMap[key][0]) ){
           				matList.push({key:String(bldMap[key][0]), value:String(bldMap[key][1])});
                	}
                    prevMat=String(bldMap[key][0]);
	   			}
               
                //console.log('Material list content: ');
                //console.log(matList);
	    		component.set("v.BladeMaterialsList",matList);
                
                /*
                    var widthList = [];
                    var prevWidth = "";
                    //var bldMapSize = bldMap;
                    
                    //bldMapSize.sort(function (element_a, element_b) {
                    //	 return element_a[3] - element_b[3];
                    //});
                    
                    //bldMapSize.sort();
                    //alert(bldMap);                
                    
                    for (var key in bldMap){
                        console.log('mat:'+ String(bldMap[key][1]) + ' js:'+prevWidth + ' db:' +String(bldMap[key][3]));
    
                        if(prevWidth != String(bldMap[key][3]) ){
                            widthList.push({key:String(bldMap[key][0]), value:String(bldMap[key][3])});
                        }
                        prevWidth=String(bldMap[key][3]);
                    }
                    console.log('Width list content: ');
                    console.log(widthList);
                    component.set("v.BladeWidthList",widthList);                
                */
        	}
      	});
      	$A.enqueueAction(action);
        
        //launch search to populate default product list
       	var action3 = component.get("c.searchParts");
		$A.enqueueAction(action3);
    },
        
    configBlade: function(component, event, helper) {
        var SelectListId = String(event.getSource().getLocalId());
      	var SelectListValue = String(event.getSource().get("v.value"));
        var bldMap = component.get("v.BladeDetails");

		//console.log('listid='+SelectListId);
        //console.log('listvalue='+SelectListValue);
        //console.log('bladetable='+JSON.stringify(bldMap));
        
    	if (SelectListId=='BldCFGmaterialList'){  
            component.set("v.BldConfigMATID", SelectListValue);
            component.set("v.BldConfigMAT", "");
            component.set("v.BladePriceCountry", "");
            component.set("v.BladePriceAll", "");
            component.set("v.BladeWidthList","");
            component.set("v.BladeThicknessList","");
            
            var SelectListText = component.get("v.BladeMaterialsList");
            for (var key in SelectListText){
                if(SelectListValue == String(SelectListText[key].key) ){
						component.set("v.BldConfigMAT", SelectListText[key].value);
                }
	   		}
            //reset other values on material change
            component.set("v.BldConfigWIDTH", "");
            component.set("v.BldConfigTHICK", "");
            component.set("v.BldConfigBEVEL", "");
            component.set("v.BldConfigUP", "");
			component.set("v.BldConfigICP", "");
            component.set("v.BldLineUP", "");
            component.set("v.BldLineUPpm", "");
            component.set("v.BldLineCOST", "");
            component.set("v.BldLineCOSTpm", "");
            component.set("v.BldLineMARGIN", "");
            component.set("v.BldLineMARGINPCT", "");
            component.set("v.BldLineSPEC","");
			component.set("v.BldConfigLEN", "");
			component.set("v.BldConfigSURFIN", "");
			component.set("v.BldConfigSURFINcost", "");
			component.set("v.BldConfigSURPACKcost", "");
            
            component.find("BldCFGbevelList").set("v.value","");
            component.find("BldCFGlengthInput").set("v.value","");
            component.find("BldFinishingList").set("v.value","");
            
            //populate dynamic width list
            var widthList = [];
            for (var key in bldMap){
                if(String(bldMap[key][0])==SelectListValue){
                    if(widthList.some(item => item.key === SelectListValue+String(bldMap[key][3]))==false){
                		widthList.push({key:SelectListValue+String(bldMap[key][3]), value:String(bldMap[key][3])});
                    }
                }
			}
            component.set("v.BladeWidthList",widthList);
        }
        
        if (SelectListId=='BldCFGwidthList'){
            var currentMat = String(component.get("v.BldConfigMATID"));
            //console.log('current mat:'+currentMat);            
            component.set("v.BladeThicknessList","");            
            component.set("v.BldConfigWIDTH", SelectListValue.replace(currentMat,''));
            component.set("v.BldConfigTHICK", "");
            component.set("v.BldConfigBEVEL", "");
            component.set("v.BldConfigUP", "");
			component.set("v.BldConfigICP", "");
            component.set("v.BldLineUP", "");
            component.set("v.BldLineUPpm", "");
            component.set("v.BldLineCOST", "");
            component.set("v.BldLineCOSTpm", "");
            component.set("v.BldLineMARGIN", "");
            component.set("v.BldLineMARGINPCT", "");
            component.set("v.BldLineSPEC","");
            
            //populate dynamic thickness list

            var thickList = [];
            for (var key in bldMap){
                if(String(bldMap[key][0])==currentMat){
                    //console.log("size db:"+String(bldMap[key][3])+";size picked:"+SelectListValue.replace(currentMat,'')+";");
                    if(String(bldMap[key][3])==SelectListValue.replace(currentMat,'')){
                        //console.log('Added:'+String(bldMap[key][4]));
                    	//if(thickList.some(item => item.key === String(bldMap[key][3]))==false){
                			thickList.push({key:String(bldMap[key][4]), value:String(bldMap[key][4])});
                    	//}
                    }
                }
			}
            component.set("v.BladeThicknessList",thickList);
            component.find("BldCFGlengthInput").set("v.value","");
            component.find("BldFinishingList").set("v.value","");
        }
        
        if (SelectListId=='BldCFGthicknessList'){
            component.set("v.BldConfigTHICK", SelectListValue);          
        }
        
        //if (SelectListId=='BldCFGbevelList'){
        //    component.set("v.BldConfigBEVEL", SelectListValue);
        //}
        
        if (SelectListId=='BldFinishingList'){
            component.set("v.BldConfigSURFIN", SelectListValue);
        }
        
        if (SelectListId=='BldCFGrateInput'){
            component.set("v.BldConfigRATE", SelectListValue);
        }
        
        if (SelectListId=='BldCFGlengthInput'){
            component.set("v.BldConfigLEN", SelectListValue);
            if(SelectListValue==''){
                component.set("v.BldConfigICP", "");
				component.set("v.BldLineUP", "");
                component.set("v.BldLineUPpm", "");
                component.set("v.BldLineCOST", "");
                component.set("v.BldLineCOSTpm", "");
            	component.set("v.BldLineMARGIN", "");
            	component.set("v.BldLineMARGINPCT", "");
            	component.set("v.BldLineSPEC","");
            }
        }
        
        //########### CREATE LINE SPECS
        var prodid = component.get("v.BldLineID");
        var matid = component.get("v.BldConfigMATID");
        var mat = component.get("v.BldConfigMAT");
        var wid = component.get("v.BldConfigWIDTH");
        var thick = component.get("v.BldConfigTHICK");
        var bevel = component.get("v.BldConfigBEVEL");
        var len = component.get("v.BldConfigLEN");
        
        var finishing = component.get("v.BldConfigSURFIN");
        let finishingCost = 0;
        let packagingCost = 0;
        let exchangerate = Number.parseFloat(component.get("v.BldConfigRATE"));
        
        var specs = [];
        specs.push({prodid:prodid, matid:matid, material:mat, width:wid, thickness: thick, bevel: bevel, length:len, fin:finishing});
        component.set("v.BldLineSPEC",specs);
        //alert(JSON.stringify(component.get("v.BldLineSPEC")));
        
        //########### CREATE LINE PRICING
        var quotecurrency = component.get("v.QuoteCurrency");
        let exchangeratecost = Number.parseFloat(component.get("v.BldConfigRATECOST"));
        
        
        //var bldMap = component.get("v.BladeDetails"); 
        //console.log(JSON.stringify(bldMap));
        
       	for (var key in bldMap){
          	if(matid == String(bldMap[key][0]) ){
                component.set("v.BldConfigMATGROUP", bldMap[key][12]);
                
                if(wid == String(bldMap[key][3]) ){
                	if(thick == String(bldMap[key][4]) ){
                        
                        component.set("v.BldConfigBEVEL", bldMap[key][16]);
                        bevel = bldMap[key][16]
                        
                        if(finishing=='Plain'){
                			component.set("v.BldConfigSURFINcost", bldMap[key][10]);
                            finishingCost = Number(bldMap[key][10]);
            			}
            			if(finishing=='Full'){
                			component.set("v.BldConfigSURFINcost", bldMap[key][9]);
                            finishingCost = Number(bldMap[key][9]);
            			}
                             
						component.set("v.BldConfigSURPACKcost", bldMap[key][11]);
                        packagingCost = Number(bldMap[key][11]);
                                				
                        component.set("v.BldConfigICP",String(bldMap[key][5]));
                        component.set("v.BldConfigUP",String(bldMap[key][6]));
                        component.set("v.BldConfigCURR",String(bldMap[key][7]));
                        
                        if(len>0){
                            if (quotecurrency=='EUR'){exchangeratecost = Number.parseFloat(bldMap[key][13]); }
                            if (quotecurrency=='SEK'){exchangeratecost = Number.parseFloat(bldMap[key][14]); }
                            if (quotecurrency=='USD'){exchangeratecost = Number.parseFloat(bldMap[key][15]); }
                            component.set("v.BldConfigRATECOST",exchangeratecost);
                            
                            let meterICP = Number.parseFloat(bldMap[key][5])+Number.parseFloat(finishingCost)+Number.parseFloat(packagingCost);
                            let mmICP = meterICP / Number.parseFloat("1000");
                            let totalICP = Number.parseFloat(len) * mmICP;
                            let totalICPmarkup = Number.parseFloat(len) * mmICP * 1.25; // KL markup
                            let lineCOST = Math.round(totalICPmarkup * exchangeratecost * 100) / Number.parseFloat("100");
                            let lineUP = Math.round(totalICP * exchangerate * 2 * 100) / Number.parseFloat("100");
                            
                            component.set("v.BldLineCOST", lineCOST);
                            component.set("v.BldLineCOSTpm", Math.round(( totalICPmarkup * exchangeratecost)/Number.parseFloat(len) * 1000 * 100) / Number.parseFloat("100"));
                            component.set("v.BldLineUP", lineUP);
                            component.set("v.BldLineUPpm", Math.round( (totalICP * exchangerate * 2)/Number.parseFloat(len) * 1000 * 100) / Number.parseFloat("100"));
                            
                            if(lineUP!=0){
                            	component.set("v.BldLineMARGINPCT", Math.round( (((lineUP-lineCOST)/lineUP)*100)*100) / Number.parseFloat("100"));
                            }else{
                                component.set("v.BldLineMARGINPCT",0);
                            }
                            //console.log("meterICP= "+mmICP);
                            //console.log("mmICP= "+mmICP);
                            //console.log("icp="+totalICP);
                        }
                	}
                }
            }
	   	}        
        
        //########### AVG BLADE PRICE PER METER BY COUNTRY
        
        if(mat!='' && wid!='' && thick!=''){
            var DocRecordId = component.get("v.DocRecordId");
            
            var action = component.get('c.historicalBladePricesCountry');
        	action.setParams({Material: mat.replace('™',''), Width: Number(wid), Thickness: Number(thick), QuoteID: DocRecordId});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.BladePriceCountry", response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action);
            
            var action2 = component.get('c.historicalBladePrices');
        	action2.setParams({Material: mat.replace('™',''), Width: Number(wid), Thickness: Number(thick), QuoteID: DocRecordId});
      		action2.setCallback(this, function(response2) {
        		var state2 = response2.getState();
        		if (state2 === 'SUCCESS') {
					component.set("v.BladePriceAll", response2.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action2);
        }
    },

    openPage2: function(component, event, helper) {
        var DocRecordId = component.get("v.DocRecordId"); 
		var DocObjectName = component.get("v.DocObjectName");
     	var SelectedPartMap = component.get("v.SelectedPartListContainer");
        var SelectedPartMapQty = component.get("v.SelectedPartListContainerQty");
        var SelectedPartMapUP = component.get("v.SelectedPartListContainerUP");
        var StandardLeadTime = component.get("v.quoteRecord.Lead_Time__c");
        var CountryId = component.get("v.QuoteCountryID");
        var SalesOffice = component.get("v.QuoteSalesOffice");
        //var SelectedPartMapSPEC = component.get("v.SelectedPartListContainerSPEC");
        //alert(JSON.stringify(SelectedPartMap));
        console.log('SelectedPartMap:');
        console.log(SelectedPartMap);
        //console.log(Object.keys(SelectedPartMap).length); 
        let savebutton = component.find("SaveButtonid");
        //console.log('button: ' + savebutton);
        
        var action = component.get('c.GetProductPricing');
        action.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, SelectedPartMap: SelectedPartMap, SelectedPartMapQty: SelectedPartMapQty});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
				var TempVar = response.getReturnValue(); 
               //console.log('This is before adding the leadtime first');
               //console.log(TempVar);
 				for (var key in TempVar){
           			TempVar[key][11]=StandardLeadTime;
                    var ProdLine = TempVar[key][10];
                    //console.log(SalesOffice + ' ' + CountryId + ' ' + ProdLine + ' ' + TempVar[key][2]);
                    
                    // if there is a negative account discount (surcharge), apply this immediately
                    	if(TempVar[key][6]<0){
                        TempVar[key][3]= TempVar[key][3]*((100-TempVar[key][6])/100);
                        TempVar[key][7]='Discount: ' + TempVar[key][6] + '%' ;
                        TempVar[key][6]=0;
                      	}
                	// if KN is selling FH into Norway and Denmark, calculate separate UP
                		if(SalesOffice == 'KN' && ProdLine.substr(0, 2) =='FH' && (CountryId == 'NO' || CountryId == 'DK'))
                    	{
                        
                       //console.log('Old UP1: ' + TempVar[key][3]);
                       if(ProdLine=='FH - Joints'){
                			var NewUP = 2.27 * TempVar[key][9];
                            //console.log('joints:' + NewUP + ' prodline: ' + ProdLine);
            				TempVar[key][3] = NewUP.toFixed(1);
                           	TempVar[key][7]='KN FH NO/DK Joint Pricing';
                		}
                		
                        if(ProdLine=='FH - Spare Parts'){
                		var NewUP = 2.68 * TempVar[key][9]; 
                            //console.log('parts: ' + NewUP + ' prodline: ' + ProdLine);
                		TempVar[key][3] = NewUP.toFixed(1);
                        TempVar[key][7]='KN FH NO/DK Part Pricing';
                		}
                        
                        //console.log('New UP: ' + NewUP);  
                    	}
                } 
               //console.log('This is after adding the leadtime');
               //console.log(TempVar);
				component.set("v.QuoteLineList", TempVar);
        	}
      	});
      	$A.enqueueAction(action);
        
        var action2 = component.get('c.GetCustomerPricing');
        action2.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, SelectedPartMap: SelectedPartMap});
      	action2.setCallback(this, function(response2) {
        	var state2 = response2.getState();
            
        	if (state2 === 'SUCCESS') {
                var TempVar2 = response2.getReturnValue();
               // console.log(TempVar2);
				component.set("v.QuotePricingList", response2.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action2);
 
       	//toggle between false and true to show a screen
      	component.set("v.isOpen", false);
      	component.set("v.isOpen2", true);        
    },

    openPreviousPage: function(component, event, helper) {
      	component.set("v.isOpen", true);
       	component.set("v.isOpen2", false);
            	
        // 1=field in object  2=id in component
       	helper.fetchPickListVal(component, 'Product_Code_Picklist__c', 'Product_Code_Picklist__c');
        helper.fetchPickListVal(component, 'Location__c', 'Location__c');
        helper.fetchPickListVal(component, 'Product_Type__c', 'Product_Type__c');
        //helper.fetchPickListVal(component, 'Joint_Media__c', 'Joint_Media__c');
        helper.fetchPickListVal(component, 'Joint_Flow__c', 'Joint_Flow__c');        
    },
    
    openBomDialog: function(component, event, helper) {
        component.set("v.ShowBomDialog", true);
        var PartID = String(event.srcElement.id);
        var PartCode = event.srcElement.title;    
        var SelectedPartMap = component.get("v.SelectedPartListContainer");
        
        var action = component.get('c.showBomParts');
        action.setParams({PartID: PartID, SelectedPartMap: SelectedPartMap});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.BomParts", response.getReturnValue());
        	}
      	});
      	$A.enqueueAction(action); 
        component.set("v.BomAssembly", PartCode);
    },
    
    closeBomDialog: function(component, event, helper) {
        component.set("v.ShowBomDialog", false);
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
        
        var action = component.get("c.searchParts");
		$A.enqueueAction(action);
    },  
    
    deselectPart: function(component, event, helper) {
        var ChkId = String(event.getSource().get("v.title"));
        ChkId = ChkId.replace('pil','');

        var BldId = component.get("v.BldLineID");
        if(ChkId == BldId){
			component.set("v.BldLineQTY","1");
			component.set("v.BldLineUP","");
			component.set("v.BldLineSPEC","");
            component.set("v.BldLineADDED",false);            
        }
        
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
        //console.log('Optionslist bij verwijderen:');
        //console.log(optionsList);
        
        if (Object.keys(optionsList).length > 35) {
		   window.alert('You have more than 35 parts.  Please be sure to delete the last entry and save this to the quote.');            
           component.set("v.ShowQtyWarning", true);		   
        };
        if (Object.keys(optionsList).length <= 35) {
            component.set("v.ShowQtyWarning", false);
        };
        
        var action = component.get("c.searchParts");
		$A.enqueueAction(action);
    },  
    
    selectPart: function(component, event, helper) {
        var ChkId = '';
        var ChkName = '';
        var ChkQty = '';
        var ChkUP = '';
        var ChkSPEC = '';
        
        if (String(event.getSource().get("v.label"))=='Add blade to quote')
        {
            ChkId = component.get("v.BldLineID");
        	ChkName = 'Doctor Blade';
        	ChkQty = component.get("v.BldLineQTY");
            ChkUP = component.get("v.BldLineUP");
            ChkSPEC = component.get("v.BldLineSPEC");
            component.set("v.BldLineADDED",true);
        }        
        else{
       		ChkId = String(event.getSource().get("v.label"));
        	ChkName = String(event.getSource().get("v.name"));
        	ChkQty = String(event.getSource().get("v.title")).replace('.00','').replace(' ','');
            ChkUP = '';
            ChkSPEC = '';
        }
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
        
            //console.log('isArray optionslist: ');
            //console.log($A.util.isArray(optionsList));
            //console.log('isEmpty optionslist: ');
            //console.log($A.util.isEmpty(optionsList));
            //console.log('count optionslist: ');
            //console.log(Object.keys(optionsList).length);
       		if (Object.keys(optionsList).length > 35) {
             window.alert('You have more than 35 parts.  Please be to sure delete the last entry and save this to the quote.');
          	 component.set("v.ShowQtyWarning", true);  
       		 };

      		if (Object.keys(optionsList).length <= 35) {
           	 component.set("v.ShowQtyWarning", false);
       		 };

    },  

    selectDummyPart: function(component, event, helper) {
       var ChkId = '';
        var ChkName = '';
        var ChkQty = '';
        var ChkUP = '';
        var ChkSPEC = '';

        //.replace('-dup','');
        
		ChkId = String(event.getSource().get("v.name"));
		ChkName = String(event.getSource().get("v.title")).replace('-dup','');
		ChkQty = '1';
		ChkUP = '';
		ChkSPEC = '';

        var CheckExist = 0;
       	var myMap = component.get("v.SelectedPartListContainer");
        var myMapQty = component.get("v.SelectedPartListContainerQty");
        var myMapUP = component.get("v.SelectedPartListContainerUP");
        var myMapSPEC = component.get("v.SelectedPartListContainerSPEC");
        
       	//check if the current product id already selected
       	var lastDummyNr = 0;
       	for (var key in myMap){
            //maximum 
            for(var x=1;x<50;x++){
     			if(String(key) == String(ChkId)+String(x)){
                	CheckExist = 1;
                	lastDummyNr = x;
            	}
            }
    	}

        let button = event.getSource();
    	button.set('v.label',String(lastDummyNr+1));
        button.set('v.variant','brand');
        
        ChkId = String(ChkId)+ String(lastDummyNr+1); 
        
		myMap[ChkId] = ChkName;
        myMapQty[ChkId] = String(ChkQty);
        myMapUP[ChkId] = String(ChkUP);
        myMapSPEC[ChkId] = ChkSPEC;
       
        //console.log(myMap);
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
        //console.log('Optionslist: ');
        //console.log(optionsList);
    }, 
    
    closePages: function(component, event, helper) {       
     	var DocRecordId = component.get("v.DocRecordId"); 
        var DocObjectName = component.get("v.DocObjectName"); 
     	var SelectedPartMap = component.get("v.SelectedPartListContainer");
        var DocRecordType = component.get("v.QuoteRecordType");
        var DocCurrency = component.get("v.QuoteCurrency");
        var DocPriceBook = component.get("v.QuotePriceBook");
		//var SelectedPartMapQty = component.get("v.SelectedPartListContainerQty");
        //console.log('recordtype: ' + DocRecordType + ' currency: ' + DocCurrency + ' pricebook: ' + DocPriceBook);
       	var quoteQTY = [];
        var lineQty = component.find("lineQty");
		if ($A.util.isArray(lineQty)) {
    		lineQty.forEach(cmpQTY => { 
                quoteQTY.push({value:cmpQTY.get("v.value"), key:cmpQTY.get("v.name")});
            })
		} else {
    			quoteQTY.push({value:lineQty.get("v.value"), key:lineQty.get("v.name")});
		}

 		var quoteUP = [];
    	var lineUP = component.find("lineUP");
		var quoteUnitPrice = 0;
		if ($A.util.isArray(lineUP)) {
    		lineUP.forEach(cmpUP => { 
                quoteUnitPrice = cmpUP.get("v.value");
                if(String(quoteUnitPrice)==''){ quoteUnitPrice=0; }
            	quoteUP.push({value:quoteUnitPrice, key:cmpUP.get("v.name")});
            })
		} else {
            quoteUnitPrice = lineUP.get("v.value");
            if(String(quoteUnitPrice)==''){ quoteUnitPrice=0; }
            	quoteUP.push({value:quoteUnitPrice, key:lineUP.get("v.name")});
		}

 		var quoteDC = [];
    	var lineDC = component.find("lineDisc");
		if ($A.util.isArray(lineDC)) {
    		lineDC.forEach(cmpDC => { 
            	quoteDC.push({value:cmpDC.get("v.value"), key:cmpDC.get("v.name")});
            })
		} else {
    		quoteDC.push({value:lineDC.get("v.value"), key:lineDC.get("v.name")});
		}
		//console.log('Disc info: ');
        //console.log(quoteDC);

		var quoteLT = [];
		var lineLT = component.find("lineLT");
		var defaultLeadTime = 1.0;
		if ($A.util.isArray(lineLT)) {            
    		lineLT.forEach(cmpLT => { 
                defaultLeadTime = cmpLT.get("v.value");
                if(defaultLeadTime==null){ defaultLeadTime=1.0; }
            		quoteLT.push({value:defaultLeadTime, key:cmpLT.get("v.name")});
            })
		} else {
            defaultLeadTime = lineLT.get("v.value");
            if(defaultLeadTime==null){ defaultLeadTime=1.0; }
    			quoteLT.push({value:defaultLeadTime, key:lineLT.get("v.name")});
		}
        //console.log('LT info: ');
        //console.log(quoteLT);
		
		var quoteNDO = [];
		var lineNDO = component.find("lineNDO");
		if ($A.util.isArray(lineNDO)) {
    		lineNDO.forEach(cmpNDO => { 
            	quoteNDO.push({value:cmpNDO.get("v.value"), key:cmpNDO.get("v.name")});
            })
		} else {
    			quoteNDO.push({value:lineNDO.get("v.value"), key:lineNDO.get("v.name")});
		}
		//console.log('NDO info: ');
        //console.log(quoteNDO);
		//console.log(lineNDO);
		
		var quoteSCO = [];
		var lineSCO = component.find("lineSCO");
		if ($A.util.isArray(lineSCO)) {
        lineSCO.forEach(cmpSCO => { 
          quoteSCO.push({value:cmpSCO.get("v.value"), key:cmpSCO.get("v.name")});
        	})
		} else {
      	quoteSCO.push({value:lineSCO.get("v.value"), key:lineSCO.get("v.name")});
		}
		//console.log('Service info: ');
        //console.log(quoteSCO);
		//console.log(lineSCO);

		//alert(JSON.stringify(component.get("v.BldLineSPEC")));
		var lineSpecs = component.get("v.BldLineSPEC");
		if(lineSpecs==''){
        	lineSpecs.push({prodid:"",matid:"",material:"",width:"",thickness:"",bevel:"", length:"", fin:""});
		}

        var action = component.get('c.Add'+DocObjectName+'Lines');
 
		action.setParams({strQuoteRecordID: DocRecordId, strQuotePB: DocPriceBook, strQuoteCurr: DocCurrency, strQuoteRecType: DocRecordType, SelectedPartMap: SelectedPartMap, lineQTY: JSON.stringify(quoteQTY), lineUP: JSON.stringify(quoteUP), lineDC: JSON.stringify(quoteDC), lineSPEC: JSON.stringify(lineSpecs), lineLT: JSON.stringify(quoteLT), lineNDO: JSON.stringify(quoteNDO), lineSCO: JSON.stringify(quoteSCO)});
		
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
        var DocRecordId = component.get("v.DocRecordId");
      	//close all screens and reset fields   
        component.set("v.SelectedPartListContainer","{}");
        component.set("v.SelectedPartListContainerQty","{}");
        component.set("v.SelectedPartListContainerUP","{}");
		component.set("v.SelectedPartListContainerSPEC","{}");
      	component.set("v.SelectedPartList","");
        component.set("v.SelectedPartListUP","");
		component.set("v.SelectedPartListQty","");
		component.set("v.SelectedPartListSPEC","");
        component.set("v.SearchFilterMAP", "{}");
      	component.set("v.SearchFilterSQL", "");
      	component.set("v.isOpen", false);
      	component.set("v.isOpen2", false);

        var ReloadPageUrl = $A.get("e.force:navigateToURL");
        ReloadPageUrl.setParams({"url": "/one/one.app#/sObject/"+ DocRecordId +"/view"});
        ReloadPageUrl.fire();
   	},
        
    clearSearch: function(component, event, helper) {         
        var SelectedTab = component.get("v.SelectedTab");
        var SelectedSubTab = component.get("v.SelectedSubTab");
        //console.log('were here0');
        //clear general filters
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	}        
        component.set("v.SearchFilterMAP", SearchFilterMap);
      	component.set("v.SearchFilterSQL", "");
        component.set("v.searchText", "");
        //console.log('were here1');
        //var SearchFilter = component.get("v.SearchFilterSQL");
        //alert('search filter: '+SearchFilter);
        
        if(SelectedTab='tab-JOINTS'){
        //joint fields
        component.find("ProductCode").set("v.value", "--All--");
        component.find("Joint_Media__c").set("v.value", "--All--");
        component.find("Joint_Seal_Material__c").set("v.value", "--All--");
        component.find("Joint_Flow__c").set("v.value", "--All--");
        component.find("Joint_Nipple_Size__c").set("v.value", "");
        component.find("Joint_M_Size__c").set("v.value", "");
        component.find("Joint_P_Size__c").set("v.value", "");
        component.find("Joint_S_Size__c").set("v.value", "");
        component.find("Joint_N_Size__c").set("v.value", "");
        component.find("Joint_O_Size__c").set("v.value", "");
        //console.log('were here2');
   		}
        if(SelectedTab=='tab-CPQ'){ 
        	if(SelectedSubTab=='tab-CPQ-BLADE'){ 
            	component.set("BldConfigUP", "");
            	component.set("BldConfigICP", "");
            	component.set("BldConfigCURR", "");
            	component.set("BldConfigMATID", "");
            	component.set("BldConfigMAT", "");
            	component.set("BldConfigWIDTH", "");
            	component.set("BldConfigTHICK", "");
            	component.set("BldConfigBEVEL", "");
            	component.set("BldConfigLEN", "");
            	component.set("BldConfigSURFIN","");
            	component.set("BldConfigSURFINcost","");
            	component.set("BldConfigSURPACKcost","");
            	component.set("BldConfigRATECOST","");
            	component.set("BldConfigRATE","");
            	component.set("BldConfigMATGROUP","");

            	component.set("BldLineQTY","");
            	component.set("BldLineSPEC","");
            	component.set("BldLineICP","");
            	component.set("BldLineUP","");
            	component.set("BldLineUPpm","");
            	component.set("BldLineCOST", "");
            	//component.set("BldLineADDED","false");
            	component.set("BldLineMARGIN","");
            	component.set("BldLineMARGINPCT","");
            	//component.set("BladeDetails","");
            	//component.set("BladeMaterialsList","");
            	//component.set("BladeWidthList","");
            	//component.set("BladeThicknessList","");
                
                component.find("BldCFGmaterialList").set("v.value","--Choose--");
				component.find("BldCFGwidthList").set("v.value","--Choose--");
                component.find("BldCFGthicknessList").set("v.value","--Choose--");
                component.find("BldCFGbevelList").set("v.value","--Choose--");
                component.find("BldCFGlengthInput").set("v.value","");
                component.find("BldFinishingList").set("v.value","--Choose--");
                component.find("BldCFGrateInput").set("v.value","1.4");     
			}
        }
        //component.find("BLD_Material__c").set("v.value", "--All--");
		//component.find("BLD_Width__c").set("v.value", "");
		//component.find("BLD_Length__c").set("v.value", "");
		//component.find("BLD_Thickness__c").set("v.value", "");
		//component.find("BLD_Bevel_Angle__c").set("v.value", "");
           
        var action = component.get("c.searchParts");
		$A.enqueueAction(action);
   	},

    switchMainTab: function(component, event, helper) {          
        //clear filter
        var SelectedTab = component.get("v.SelectedTab");
        //console.log('SelectedTab: ');
        //console.log(SelectedTab);
        if(SelectedTab!='tab-DUMMIES'){ 
           //component.set("v.SelectedSubTab","");
        }
        
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	}        
        component.set("v.SearchFilterMAP", SearchFilterMap);
      	component.set("v.SearchFilterSQL", "");
        //component.set("v.searchText", "");
        //console.log('SearchFilterMap:');
       // console.log(SearchFilterMap);
        
        if(SelectedTab == 'tab-JOINTS'){
                
        //joint fields
        component.find("ProductCode").set("v.value", "--All--");
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
        }
        
        var action = component.get("c.searchParts");
		$A.enqueueAction(action);
   	},
          
    switchSubTab: function(component, event, helper) {          
        //clear filter
        var SearchFilterMap = component.get("v.SearchFilterMap");
      	for (var key in SearchFilterMap){ 
           	delete SearchFilterMap[key];
    	}        
        component.set("v.SearchFilterMAP", SearchFilterMap);
      	component.set("v.SearchFilterSQL", "");
        
        var SelectedTab = component.get("v.SelectedTab");
        if(SelectedTab=='tab-DUMMIES'){ 
        	//clear picklist
        	component.find("Product_Line__c").set("v.value", "--All--");
        } else {
           //component.set("v.SelectedSubTab","");
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
        var DocRecordId = component.get("v.DocRecordId");  
        var DocObjectName = component.get("v.DocObjectName");         
        var SearchFilter = component.get("v.SearchFilterSQL");
        var SelectedTab = component.get("v.SelectedTab");
        var SelectedSubTab = component.get("v.SelectedSubTab");
        var SelectedHisTab = component.get("v.SelectedHisTab");
        if(SelectedTab=='tab-HISTORY'){ 
            	SearchFilter = 'HISTORY' + SearchFilter;
                if(SelectedHisTab=='tab-HISTORY-FH'){ SearchFilter = SearchFilter + ' AND product2.Product_Family__c=\'FH (Fluid Handling)\''; }
            	if(SelectedHisTab=='tab-HISTORY-DCF'){ SearchFilter = SearchFilter + ' AND product2.Product_Family__c=\'DCF (Doctoring, Cleaning, Filtration)\''; }
        }
        if(SelectedTab=='tab-DUMMIES'){ 
            	if(SelectedSubTab=='tab-SERVICES-GEN'){ SearchFilter = SearchFilter + ' AND Product_Family__c not in(\'DCF (Doctoring, Cleaning, Filtration)\',\'FH (Fluid Handling)\') AND (NOT product_family__c  like \'FP%\')'; }
            	if(SelectedSubTab=='tab-SERVICES-FH'){ SearchFilter = SearchFilter + ' AND Product_Family__c=\'FH (Fluid Handling)\''; }
            	if(SelectedSubTab=='tab-SERVICES-DCF'){ SearchFilter = SearchFilter + ' AND Product_Family__c=\'DCF (Doctoring, Cleaning, Filtration)\''; }
            	if(SelectedSubTab=='tab-SERVICES-FL'){ SearchFilter = SearchFilter + ' AND Product_Family__c like \'FP%\''; }
            	if(SelectedSubTab=='tab-SERVICES-WP'){ SearchFilter = SearchFilter + ' AND Location__c=\'KCD\' AND product2.name like \'zSER%\''; }
            	if(SelectedSubTab=='tab-SERVICES-KJTR'){SearchFilter = SearchFilter + ' AND Location__c=\'KJ\' AND product2.name like \'Q%\''; }
            	if(SelectedSubTab=='tab-SERVICES-NML'){ SearchFilter = SearchFilter + ' AND Location__c=\'NML\''; }
            	if(SelectedSubTab=='tab-SERVICES-VK'){ SearchFilter = SearchFilter + ' AND Location__c=\'VKFIN\''; }
            	if(SelectedSubTab=='tab-SERVICES-SMH'){ SearchFilter = SearchFilter + ' AND Location__c=\'SMH\''; }
            	if(SelectedSubTab=='tab-SERVICES-KBC'){ SearchFilter = SearchFilter + ' AND Location__c=\'KBC\''; }
            	if(SelectedSubTab=='tab-SERVICES-DEV'){ SearchFilter = SearchFilter + ' AND Product_Family__c=\'DCF (Doctoring, Cleaning, Filtration)\''; }
            	if(SelectedSubTab=='tab-SERVICES-KSASER'){ SearchFilter = SearchFilter + ' AND Location__c=\'KSA\' AND product2.Service_Item__c= true'; }
            	if(SelectedSubTab=='tab-SERVICES-KSAPRD'){ SearchFilter = SearchFilter + ' AND Location__c=\'KSA\' AND product2.name like \'CN%\''; }
            SearchFilter = SearchFilter + ' AND Miscellaneous_Item__c=True AND PSG_E_Dummy__c=True';
        }
        //console.log('Searchfilter is now: ' + SearchFilter + ' Selected subtab is now: ' + SelectedSubTab);
        if(SelectedTab=='tab-JOINTS'){ SearchFilter = SearchFilter + ' AND Product_Line__c=\'FH - Joints\''; }
        if(SelectedTab=='tab-DOCTORS'){ SearchFilter = SearchFilter + ' AND Product_Line__c=\'Doctoring Systems\''; }
        //if(SelectedTab=='tab-PARTS'){ SearchFilter = SearchFilter + ' AND Product_Line__c=\'FH - Spare Parts\''; }
        if(SelectedTab=='tab-KLPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'KL\''; }
        if(SelectedTab=='tab-KCDPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'KCD\''; }
        if(SelectedTab=='tab-KSAPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'KSA\''; }
        if(SelectedTab=='tab-KJPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'KJ\''; }
        if(SelectedTab=='tab-NMLPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'NML\''; }
        if(SelectedTab=='tab-SMHPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'SMH\''; }
        if(SelectedTab=='tab-KBCPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'KBC\''; }
        if(SelectedTab=='tab-VKPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'VKFIN\''; }
        if(SelectedTab=='tab-VKNAPARTS'){ SearchFilter = SearchFilter + ' AND Location__c=\'VKNA\''; }
        if(SelectedTab=='tab-SYPHONS'){ SearchFilter = SearchFilter + ' AND Product_Line__c=\'FH - Syphons\''; }
        if(SelectedTab=='tab-BLADES'){ SearchFilter = SearchFilter + ' AND Product_Classification_Record_Type_Name__c=\'PSG-E Product - Blade\''; }
        //console.log('Searchfilter is now: ' + SearchFilter + ' Selected subtab is now: ' + SelectedSubTab + ' Selected tab is now: ' + SelectedTab);
        
      	var searchText = component.get('v.searchText');
		var SelectedPartMap = component.get("v.SelectedPartListContainer");
      	var SelectedPartMapQty = component.get("v.SelectedPartListContainerQty");
        
        //console.log('strRecordID: '+DocRecordId);
        //console.log('strObjectName: '+DocObjectName);
        
        var action = component.get('c.searchForParts');
        action.setParams({strRecordID: DocRecordId, strObjectName: DocObjectName, searchText: searchText, searchFilter: SearchFilter, SelectedPartMap: SelectedPartMap});
      	action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.SearchResults", response.getReturnValue());
                //console.log('result: ');
                //console.log(response.getReturnValue());                
                var action2 = component.get("c.highlightSelectedParts");
				$A.enqueueAction(action2);
        	}
      	});
      	$A.enqueueAction(action);
        
      	//scroll to table top
      	document.getElementById('anchor_ScrollTo').scrollIntoView();        
   },
    
    highlightSelectedParts: function(component, event, helper) {        
        var SelectedPartMap = component.get("v.SelectedPartListContainer");
        var SelectedTab = component.get("v.SelectedTab");
        var SelectedSubTab = component.get("v.SelectedSubTab");
        
        if(SelectedTab=='tab-DUMMIES'){ 
        	if(SelectedSubTab=='tab-SERVICES-DEV'){ 
       			//var SelectedPart = "";
                //var SelectedPartDups = "";
                var CountArray = [];
                for(var key in SelectedPartMap){
                    CountArray[key.substr(0, 18)+"-dup"]=0;
                }
       			for (var key in SelectedPartMap){
                    CountArray[key.substr(0, 18)+"-dup"]=CountArray[key.substr(0, 18)+"-dup"]+1;
                }
                //console.log("CountArray");
                //console.log(CountArray);
                
                let button = component.find("AddDummyButton");
                
                for(var key in CountArray){
                    for(var x=0; x < button.length; x++){
            
                        if(button[x].get("v.name")==key){
                        	button[x].set("v.label",CountArray[key]);
        					button[x].set("v.variant","brand");  
                        }
                    }   
    			}                
        	} 
        }
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
       
       		var action = component.get("c.searchParts");
			$A.enqueueAction(action);
      //}
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
        	//console.log('Search Filter: ' + SearchFilter);
       
       		var action = component.get("c.searchParts");
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
       
       		var action = component.get("c.searchParts");
			$A.enqueueAction(action);
   	},
                                 
    expandPriceTool: function(component, event, helper) {
		var ButtonId = String(event.getSource().get("v.value"));
       	var ButtonClass = String(event.getSource().get("v.class"));
        var ButtonImg = String(event.getSource().get("v.iconName"));
        
        //toggle between section arrow
        if(ButtonImg=='utility:chevronright'){
            event.getSource().set("v.iconName","utility:chevrondown");
        } else {
            event.getSource().set("v.iconName","utility:chevronright");
        }

        //hide or show price section
        var cmps = document.getElementById('sec-' + ButtonId);
        if(cmps.style.display=='none'){
            cmps.style.display = 'block'; 
        } else {
            cmps.style.display = 'none';
        }  
        //alert(cmps.style);
        //$A.util.toggleClass(cmps, 'slds-hidex');
    },          
})