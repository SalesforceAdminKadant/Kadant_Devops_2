({

    onLoad : function(component, message, helper) {
    
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        var param ='';
        var docid = '';
        var cusid = '';
        var page = '';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
            } 
            if(param.substring(0,6)=='cusid='){
            	   cusid = param.replace('cusid=','');
            }  
            if(param.substring(0,5)=='page='){
            	   page = param.replace('page=','');                
            }  
        }
        
        if(page!=''){ component.set("v.Page",page);   }
        
        if(cusid!=''){ component.set("v.CusId",cusid);   }
        
        if(docid!=''){   component.set("v.DocId",docid); }
        
	},
    
 
    makeCase : function (component, event, helper) {
    	
       var userId = $A.get("$SObjectType.CurrentUser.Id");  
        
        var page = component.get("v.Page");
        var cusid = component.get("v.CusId");
        var docid = component.get("v.DocId");
        if(page=="cus"){ cusid = docid; }

        var ButtonTitle = String(event.getSource().get("v.title"));

        //console.log(ButtonTitle);
       
        if(docid!=''){ 

        	var action = component.get('c.createCase');
            action.setParams({sAccountID: cusid, sSubject: "...", sType: ButtonTitle, sDescription: " ", sUser: userId});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
                    
          			//component.set("v.DocumentDetail", response.getReturnValue());
          			var urlEvent = $A.get("e.force:navigateToURL");
                    var url="/case?page=cas&docid="+response.getReturnValue()+"&cusid="+cusid;
                    urlEvent.setParams({"url": url	});
    				urlEvent.fire();
        		}
      		});
      		$A.enqueueAction(action);

        } 
        
    },
    
    
    makeComment : function (component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        var page = component.get("v.Page");
        var cusid = component.get("v.CusId");
        var docid = component.get("v.DocId");
        
        var url="";
        if(page=="cus") {url="/customer?page=cus&docid="+docid+"&tabset-7d7af=773f0";}
        if(page=="cas") {url="/case?page=cas&docid="+docid+"&cusid="+cusid+"&tabset-28dfd=4b40c";}
        
    	urlEvent.setParams({"url": url 	});
    	urlEvent.fire();
	},
    
    uploadFiles : function (component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        var page = component.get("v.Page");
        var cusid = component.get("v.CusId");
        var docid = component.get("v.DocId");
        
        var url="";
        if(page=="cus") {url="/customer?page=cus&docid="+docid+"&tabset-7d7af=2c264";}
        if(page=="cas") {url="/case?page=cas&docid="+docid+"&cusid="+cusid+"&tabset-28dfd=70b19";}
        
    	urlEvent.setParams({"url": url	});
    	urlEvent.fire();
	}
    
})