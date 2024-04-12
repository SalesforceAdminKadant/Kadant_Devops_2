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

        	var action = component.get('c.getDrawingFileID');
        	action.setParams({PartID: Pid});
      		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === 'SUCCESS') {
          		component.set("v.DrawingFileId", response.getReturnValue());
                //component.set("v.DrawingImage","https://kadant--c.na67.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId="+response.getReturnValue());
                //component.set("v.DrawingUrl","https://kadant--c.na67.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=SVGZ&versionId="+response.getReturnValue());
                component.set("v.DrawingImage","/psgeagent/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId="+response.getReturnValue());
                component.set("v.DrawingUrl","/psgeagent/sfc/servlet.shepherd/version/renditionDownload?rendition=SVGZ&versionId="+response.getReturnValue());


                //alert(response.getReturnValue());
                //THUMB240BY180       
        		}
      		});
      		$A.enqueueAction(action);
 
        }
            
	}

    
})