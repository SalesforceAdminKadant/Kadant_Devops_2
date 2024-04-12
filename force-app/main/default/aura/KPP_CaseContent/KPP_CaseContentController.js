({
	getDocumentDetail : function(component, message, helper) {
        
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        var param ='';
        var docid = '';
        var cusid = '';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
            } 
            if(param.substring(0,6)=='cusid='){
            	   cusid = param.replace('cusid=','');
            }  
        }

        if(docid!='' && cusid!=''){ 
            component.set("v.DocId", docid);   
            component.set("v.CusId", cusid);  
        	var action = component.get('c.getCase');
        	action.setParams({sDocumentID: docid, sAccountID: cusid});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
          			component.set("v.DocumentDetail", response.getReturnValue());

                    //alert(response.getReturnValue());
                    
                   var action2 = component.get('c.initForm'); 
                   $A.enqueueAction(action2);
                   
        		}
      		});
      		$A.enqueueAction(action);
         }    
          
         if(docid!='' && cusid!=''){
             
            var action3 = component.get('c.getAssets');
        	action3.setParams({sAccountID: cusid});
      		action3.setCallback(this, function(response3) {
        		var state3 = response3.getState();
        		if (state3 === 'SUCCESS') {
          			component.set("v.AssetList", response3.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action3);
            
        }  
	},
    
    /*
    selectedAsset : function(component, event, helper) {
        var SelectListId = String(event.getSource().getLocalId());
      	var SelectListValue = String(event.getSource().get("v.value"));
        console.log('Selected:'+SelectListValue );
        //if(SelectListValue=='none'){
        //   	component.set("v.DocAsset","");
        //} else {
        	component.set("v.DocAsset",SelectListValue);
    	//}
	},
    */
    
    editForm : function(component, event, helper) {
        var ROmode = document.getElementById('readonlyModus');
        var EDmode = document.getElementById('editModus');
        EDmode.style.display = '';
        ROmode.style.display = 'none';
 
	},
    
    initForm : function(component, event, helper) {
        var dataset = component.get("v.DocumentDetail");
        
        /*
        //preset linked asset value
        if(dataset[0][10]!=''){
            component.set("v.DocAsset",dataset[0][10]);            
        }
        */
        
        //force form in edit mode
        
        if(dataset[0][7]=='... '){
        	var ROmode = document.getElementById('readonlyModus');
        	var EDmode = document.getElementById('editModus');
        	EDmode.style.display = '';
        	ROmode.style.display = 'none';
        }
        
	},
    
    cancelForm : function(component, event, helper) {
        var DocId = component.get("v.DocId");
        var CusId = component.get("v.CusId");
        
        var urlEvent = $A.get("e.force:navigateToURL");
        var url="/case?page=cas&docid="+DocId+"&cusid="+CusId;
        urlEvent.setParams({"url": url	});
    	urlEvent.fire();
	},
    
    saveForm : function(component, event, helper) {

        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        var CusId = component.get("v.CusId");
        var DocId = component.get("v.DocId");
        var DocSubject = document.getElementById('DocSubject');
        var DocDescription = document.getElementById('DocDescription');
		var DocAsset = component.find("DocAsset").get("v.value");
        
        console.log("Selected: "+DocAsset);
        
        var action = component.get("c.saveCase");  
        action.setParams({ sCaseID: DocId,  sSubject: DocSubject.value, sAssetID: DocAsset,  sDescription: DocDescription.value , sUser:userId });
            
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {                 
					//console.log(response.getReturnValue());
                	var urlEvent = $A.get("e.force:navigateToURL");
        			var url="/case?page=cas&docid="+DocId+"&cusid="+CusId;
        			urlEvent.setParams({"url": url	});
    				urlEvent.fire();
        		}
         });
      	 $A.enqueueAction(action);
	}
    
})