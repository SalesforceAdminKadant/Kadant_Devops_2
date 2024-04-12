({
	onLoad : function(component, event, helper) {
        
		//var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(window.location.search.substring(0));
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
            component.set("v.DocId",docid)
        	var action = component.get('c.getChat');
        	action.setParams({sDocumentID: docid});      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.DataSet", response.getReturnValue());  
					console.log(docid);
        		}
      		});
      		$A.enqueueAction(action);
        }    
      
	},
    
    
    showComment : function(component, event, helper) {
        var ButtonId = String(event.getSource().get("v.value"));
       	var ButtonClass = String(event.getSource().get("v.class"));
        
        //hide or show comment button
        var cmpc = document.getElementById('divc-' + ButtonId);        
        cmpc.style.display = 'none';


        //hide or show comment section
        var cmps = document.getElementById('div-' + ButtonId);
        if(cmps.style.display=='none'){
            cmps.style.display = ''; 
        } else {
            cmps.style.display = 'none';
        }
	},
    
    
    makeComment : function(component, event, helper) {
 
   			var ButtonId = String(event.getSource().get("v.value"));
       		var ButtonClass = String(event.getSource().get("v.class"));
        
        	var comment = document.getElementById('commentid-' + ButtonId);
        
        	var action = component.get('c.createComment');
        	action.setParams({sTopicID: ButtonId, sComment: comment.value });
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.DataSet", response.getReturnValue());  

                    var action2 = component.get('c.onLoad');
                    $A.enqueueAction(action2);
                    
        		}
      		});
      		$A.enqueueAction(action);
	},
    
    
    makeChat : function(component, event, helper) {
        
        //console.log(window.location.search.substring(0));
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

        console.log(docid);
        
        if(docid!=''){ 
            component.set("v.DocId",docid)
            var sBody = component.get("v.sBody");
            
        	var action = component.get('c.createChat');
        	action.setParams({sDocumentID: docid, sBody: sBody });
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.DataSet", response.getReturnValue());  

                    var action2 = component.get('c.onLoad');
                    $A.enqueueAction(action2);
                    
        		}
      		});
      		$A.enqueueAction(action);
        }    
      
	}
})