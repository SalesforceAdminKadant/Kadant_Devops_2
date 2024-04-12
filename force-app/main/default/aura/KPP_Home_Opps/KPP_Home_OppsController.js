({
	onLoad : function(component, event, helper) {
        
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var page = 'home';  
   
        if(userId!=''){ 
            
            var nCount=0;
            
        	var action = component.get('c.getHomeOpps');
            action.setParams({sUser:userId });      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
                
        		if (state === 'SUCCESS') {
                    component.set("v.DataSet", response.getReturnValue());
    
					var DataSet = component.get("v.DataSet");
                    for (var key in DataSet){                        
                        //if(DataSet[key][6]=='Service Request'){DataSet[key][6]='Service';}
                        DataSet[key][10] = DataSet[key][10] +'%';
                        nCount++;
                    }
					
                    /*
                    for(var x=nCount;x<6;x++){
                      DataSet[x] = [];
                      for (var j = 0; j < 11; j++) { if(j==2) {DataSet[x][j] = '\xa0';} else {DataSet[x][j] = '';} } 
            		}
                    */
                    component.set("v.DataSet", DataSet);
                } 
                
                /*
                if (state === 'ERROR') {                    
                    var DataSet = [];
                    
                    for(var x=0;x<6;x++){
                    	DataSet[x] = [];
                        for (var j = 0; j < 11; j++) { if(j==2) {DataSet[x][j] = '\xa0';} else {DataSet[x][j] = '';} } 
            		}

                	component.set("v.DataSet", DataSet);                    
                }
                */
                
      		});
      		$A.enqueueAction(action);

        }    
      
	}
})