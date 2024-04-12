({
	onLoad : function(component, event, helper) {
        
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var page = 'home';  
   
        if(userId!=''){ 
            
            var nCount=0;
            
        	var action = component.get('c.getHomeOrders');
            action.setParams({sUser:userId });      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
                
        		if (state === 'SUCCESS') {
                    component.set("v.DataSet", response.getReturnValue());
    
					var DataSet = component.get("v.DataSet");
                    /*
                    for (var key in DataSet){                        
                        if(DataSet[key][6]=='Service Request'){DataSet[key][6]='Service';}
                        nCount++;
                    }
					*/
                    component.set("v.DataSet", DataSet);
                } 
                
               
      		});
      		$A.enqueueAction(action);

        }    
      
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
        alert("Thanks for this order");
    }
      
    
})