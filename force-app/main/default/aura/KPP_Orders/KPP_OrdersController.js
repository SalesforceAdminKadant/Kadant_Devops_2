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
        	component.set("v.ShowSpinner",true);
        	var action = component.get('c.getOrderHistory');
        	action.setParams({sAccountID: docid});      		
        	action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.OrderHistory", response.getReturnValue());                    
                    var action2 = component.get("c.drawCharts");
					$A.enqueueAction(action2);
					component.set("v.ShowSpinner",false);
        		}
      		});
      		$A.enqueueAction(action);
        }    
      
	},
    
    updateOrders : function(component, event, helper) {
        	component.set("v.ShowSpinner",true);
			var userId = component.get("v.CurrentUser");    
        	var OrderScope = String(event.getSource().get("v.value"))
        
        	var action = component.get('c.getOrderHistory');
        	action.setParams({strUserID: userId, strYear: OrderScope});
      		action.setCallback(this, function(response) {
        		var state = response.getState();
        		if (state === 'SUCCESS') {
					component.set("v.OrderHistory", response.getReturnValue());
                    console.log(response.getReturnValue());
                    component.set("v.ShowSpinner",false);
                    
                    var action2 = component.get("c.drawCharts");
					$A.enqueueAction(action2);
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
        alert("Thanks for this order");
    },
 
	drawCharts : function(component, event, helper) {

        var Orders = component.get("v.OrderHistory");
     	console.log(component.get("v.OrderHistory"));

        
        //let canvas1 = document.getElementById("pie-chart1").getContext('2d');
		//canvas1.clearRect(0, 0, 180, 180);
                  
        //let canvas2 = document.getElementById("pie-chart2").getContext('2d');
		//canvas2.clearRect(0, 0, 180, 180);
        
        //let canvas3 = document.getElementById("pie-chart3").getContext('2d');
		//canvas3.clearRect(0, 0, 180, 180);

        //######################
        //#
        //#		Group data
        //#
        //######################
        
        var labelset1=[];
     	var dataset1=[];

        var labelset2=[];
     	var dataset2=[];
        
        var labelset3=[];
     	var dataset3=[];
   
        var set1=[];
        var set2=[];
        var set3=[];
        
     	for (var key in Orders){
        	if(Orders[key][5]=='H'){
                set1[key]=Orders[key][11].replace('RO-','');
                set3[key]=Orders[key][9].substr(-4).replace('.211','KJE').replace('.243','JF').replace('.231','KUK');
         	}
        	if(Orders[key][5]=='L'){
                set2[key]=Orders[key][9].replace('null','Other');
         	}
         };
		        
        var set1reduced = set1.reduce((a, c) => (a[c] = (a[c] || 0) + 1, a), Object.create(null));
        var set2reduced = set2.reduce((a, c) => (a[c] = (a[c] || 0) + 1, a), Object.create(null));
        var set3reduced = set3.reduce((a, c) => (a[c] = (a[c] || 0) + 1, a), Object.create(null));

        console.log(set3reduced);
        
        
        for(var key1 in set1reduced){
               labelset1.push(key1);
               dataset1.push(set1reduced[key1]);
        }
        
      
       for(var key2 in set2reduced){
               labelset2.push(key2);
               dataset2.push(set2reduced[key2]);
        }
        
        
        for(var key3 in set3reduced){
               labelset3.push(key3);
               dataset3.push(set3reduced[key3]);
        }
        
       
        //######################
        //#
        //#		Draw chart 1
        //#
        //######################

                new Chart(document.getElementById("pie-chart1"), {
                    type: 'pie',
                    data: {
                        labels:labelset1,
                        datasets: [{
                            label: "Sales by country",
                            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset1
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'Sales by country'
                        }
                    }
                });

        //######################
        //#
        //#		Draw chart 2
        //#
        //######################
        
        		/*
        		new Chart(document.getElementById("pie-chart2"), {
                    type: 'pie',
                    data: {
                        labels:labelset2,
                        datasets: [{
                            label: "Sales by product group",
                            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset2
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'Sales by product group'
                        }
                    }
                });
                */
        
        		new Chart(document.getElementById("pie-chart2"), {
                    type: 'bar',
                    data: {
                        labels:labelset2,
                        datasets: [{
                            label: "Sales by product group",
                            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset2
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'Sales by product group'
                        }
                    }
                });
   
        //######################
        //#
        //#		Draw chart 3
        //#
        //######################

        		new Chart(document.getElementById("pie-chart3"), {
                    type: 'pie',
                    data: {
                        labels:labelset3,
                        datasets: [{
                            label: "Sales by Kadant division",
                            backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
                            data: dataset3
                        }]
                    },
                    options: {
                        title: {
                            display: true,
                            text: 'Sales by Kadant division'
                        }
                    }
                });
        
        

    }
    
})