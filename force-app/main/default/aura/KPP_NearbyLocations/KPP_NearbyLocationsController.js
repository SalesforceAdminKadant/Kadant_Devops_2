({
        onInit: function(component, event, helper) {
            
		var query = window.location.search.substring(1);
       	var vars = query.split("&");
       	var param ='';
        var docid = '';
        var page = 'cus';
        
        for (var key in vars){             
            param = vars[key];
        	if(param.substring(0,6)=='docid='){
            	   docid = param.replace('docid=','');
                	component.set("v.accountId",docid);
            }
                        
            if(param.substring(0,5)=='page='){
            	   page = param.replace('page=','');
            } 
        }

       	//console.log('cus='+docid);  
            
        // proactively search on component initialization
        var nMaxDistance = component.find("DistanceInput").get("v.value");
        var boolMetric = component.get("v.UnitToggle");
        var boolPriority = component.get("v.PriorityRankingToggle");
        var bool8020 = component.get("v.X8020Toggle");
        var boolOwner = component.get("v.OwnerToggle");
        var boolLeads = component.get("v.LeadsToggle");
        var accountId = docid;   
        var objectName = component.get("v.DocObjectName");
            if(objectName == 'Lead'){boolLeads = true; bool8020 = false; boolPriority= false;}
            console.log('object : ' + objectName);
            console.log(' distance :' + nMaxDistance + ' metric: ' + boolMetric + ' prio: ' + boolPriority + ' Owner: ' +boolOwner);
       
            
        helper.accountList(component, accountId, nMaxDistance, boolMetric, boolPriority,bool8020,boolOwner,boolLeads)
        
        },
    
 
    
    onChangeToggle: function(component, event, helper){
        var nMaxDistance = component.find("DistanceInput").get("v.value");
        var boolMetric = component.get("v.UnitToggle");
        var boolPriority = component.get("v.PriorityRankingToggle");
        var bool8020 = component.get("v.X8020Toggle");
        var boolOwner = component.get("v.OwnerToggle");
        var boolLeads = component.get("v.LeadsToggle");
        var accountId = component.get("v.accountId");
        var objectName = component.get("v.sObjectName");
            if(objectName == 'Lead'){boolLeads = true; bool8020 = false; boolPriority= false;}
        console.log('distance2 :' + nMaxDistance +' metric21: ' + boolMetric + ' prio1: ' + boolPriority);
       helper.accountList(component, accountId, nMaxDistance, boolMetric, boolPriority,bool8020,boolOwner,boolLeads);
    },
    
    OpenAccount: function(component, event, helper){

       
      	var SelectedMarker = component.get("v.selectedMarkerValue");
      	console.log(SelectedMarker);
        
        //var aTags = document.getElementById("AccMap").querySelectorAll("p");
        //var aTags = component.find("AccMap");
        //var aTags = component.find("AccMap").querySelectorAll("p");
 
        var aTags = component.find("AccMap").getElementsByTagName("p");
        console.log(aTags);
		var searchText = SelectedMarker;
		var found;

		for (var i = 0; i < aTags.length; i++) {
  			if (aTags[i].textContent == searchText) {
    			found = aTags[i];
	    		break;
  			}
		}
        console.log(found);
        
        //alert('Test 123');
    }
    

})