({
	onLoad : function(component, event, helper) {
        
		//var userId = $A.get("$SObjectType.CurrentUser.Id");
        
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
        
        if(docid!=''){ 
        	component.set("v.cusId",docid);
            
            var action = component.get('c.ShowFiles');
        	action.setParams({docId: docid});      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.DataSet", response.getReturnValue());                    
					//component.set("v.ShowSpinner",false);
					//
					//console.log(docid);
	
        		}
      		});
      		$A.enqueueAction(action);
        }
    },
    
    
    handleFilesChange: function(component, event, helper) {
        var fileName = '';
        var files = event.getSource().get("v.files");
        
        if (files.length > 0) {
            component.set("v.nofiles", false);
            for (let i = 0; i < files.length; i++) {
    			fileName = fileName + files[i]['name'] + ', ';
  			}
        } else {
            	fileName = 'No File Selected..';
            	component.set("v.nofiles", true);
        }
        component.set("v.fileName", fileName);
    },
    
    
    startUpload : function(component, event, helper) {
        
        component.set("v.showLoadingSpinner",true);
        
        var files = component.find("file").get("v.files");
        if (files.length > 0) {
          
            //fileName = files[0]['name'];
            for (let i = 0; i < files.length; i++) {
    			var file = files[i];
                
                console.log(file.name);
        
        
        var cusId = component.get("v.cusId");
        //var file = component.find("file").get("v.files")[0];

        // Convert file content in Base64
        var objFileReader = new FileReader();
        objFileReader.readAsDataURL(file);

        objFileReader.onload = $A.getCallback(function(){
            var fileContents = objFileReader.result;   
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
      
            var action = component.get("c.UploadFile");  
        	action.setParams({
            	cusId: component.get("v.cusId"),
            	fileName: file.name,
            	base64Data:  encodeURIComponent(fileContents), 
            	contentType: file.type
        	});
        
            console.log(file.type);
            
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {                 
					console.log(response.getReturnValue());
                                        
                    var action2 = component.get("c.onLoad");  
                    $A.enqueueAction(action2);                   
                    
                    component.set("v.showLoadingSpinner",false);
                    component.set("v.fileName", "No files selected..");
                    component.set("v.nofiles", true);
 
        		}
      		});
      		$A.enqueueAction(action);
        });
        
      			}
        }    

    }
    

 
})