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
        	var action = component.get('c.getQuoteHistory');
        	action.setParams({sAccountID: docid});      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.OrderHistory", response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action);
        }    
      
	},
    
    updateOrders : function(component, event, helper) {
			var userId = component.get("v.CurrentUser");    
        	var OrderScope = String(event.getSource().get("v.value"))
        
        	var action = component.get('c.getQuoteHistory');
        	action.setParams({strUserID: userId, strYear: OrderScope});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.OrderHistory", response.getReturnValue());
        		}
      		});
      		$A.enqueueAction(action);
            
	},
    
    expandOrder : function(component, event, helper) {
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
            cmps.style.display = ''; 
        } else {
            cmps.style.display = 'none';
        }
	},
    
    ReOrder : function(component, event, helper) {
        alert("This quote will be converted to an order");
    }
 

    
})