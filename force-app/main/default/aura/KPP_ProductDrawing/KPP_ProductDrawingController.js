({
	loadScreen : function(component, event, helper) {
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
		var query = window.location.search.substring(1);
        var vars = query.split("&");
        var param ='';
        var docid = '';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
            }        
        }
   
		//alert(docid);
        
        if(docid!=''){
            
            //alert(userId);
            
            var action = component.get('c.getDrawingFileID');
            action.setParams({PartID: docid, UserID: userId});
      		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
                    var dwgIDs = response.getReturnValue().split("@");
            	//alert(dwgIDs[1]);
                if(dwgIDs[1]=="NoDrawing"){
                	component.set("v.DrawingMsg", "No drawing available.");
                }
                else if(dwgIDs[1]=="Detail"){
                  	component.set("v.DrawingMsg", "Details drawings cannot be viewed.");
                }
                else{
             	    component.set("v.DrawingFileId", dwgIDs[0]);
				    component.set("v.DrawingImage","https://kadant--sand.sandbox.my.site.com/KadantPartnerPortal/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=" + dwgIDs[1].substring(0,15) + "&operationContext=CHATTER&page=0");
                    component.set("v.DrawingUrl","https://kadant--sand.sandbox.my.site.com/KadantPartnerPortal/sfc/servlet.shepherd/document/download/"+dwgIDs[0]+"?operationContext=S1");
                }
                //THUMB240BY180       
        		}
      		});
      		$A.enqueueAction(action);
 
        }
	}
})