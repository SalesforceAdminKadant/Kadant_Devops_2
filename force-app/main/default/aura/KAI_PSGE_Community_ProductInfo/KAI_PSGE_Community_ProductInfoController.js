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

        	component.set("v.ProductId",Pnum);
        
        	var searchText = Pnum.replace();
        	var SearchFilter = "";
    
			var SelectedDivisionMap = component.get("v.SelectedDivisionsContainer");
 			SelectedDivisionMap["PSGE"] = "PSGE";
        	//SelectedDivisionMap["KJ"] = "KJ";
			component.set("v.SelectedDivisionsContainer",SelectedDivisionMap);
       
			var SelectedDivisionMap2 = component.get("v.SelectedDivisionsContainer");
    
            //#####################################################
            //#
            //#		 	GET PRODUCT DETAILS FROM ORG
            //#
            //#####################################################
            
        	var action = component.get('c.searchForPartsGeneric');
        	action.setParams({searchText: searchText, searchFilter: SearchFilter, SelectedDivisionMap: SelectedDivisionMap2});
      		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.ProductInfo", response.getReturnValue());
                console.log(response.getReturnValue());
                if(response.getReturnValue()[0][3].substring(0,2)=='RJ'){component.set("v.ProductType","Joints");}
                if(response.getReturnValue()[0][14]!=' '){component.set("v.ProductType","Blades");}
        		}
      		});
      		$A.enqueueAction(action);
            
            //#####################################################
            //#
            //#		 	GET PRODUCT PRICING FROM ORG
            //#
            //#####################################################          

			var SelectedPartMap = component.get("v.SelectedPartMap");
            SelectedPartMap[Pid]=Pnum;
 
            var SelectedPartMapQty = component.get("v.SelectedPartMapQty");
            SelectedPartMapQty[Pid]='1';
           
            var action2 = component.get('c.GetProductPricing');
            action2.setParams({strRecordID: '0Q00z000001qto9CAA', strObjectName: 'Quote', SelectedPartMap: SelectedPartMap, SelectedPartMapQty: SelectedPartMapQty});
      		action2.setCallback(this, function(response2) {
        	var state2 = response2.getState();
        	if (state2 === 'SUCCESS') {
          		component.set("v.ProductPrice", response2.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action2);
            
            
 
        }
            
	}

    
})