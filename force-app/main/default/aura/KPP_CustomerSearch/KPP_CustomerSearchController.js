({
	CreateFilter : function(component, event, helper) {
		    
        var strFilter ="";
      	var SelectListId = String(event.getSource().getLocalId());
      	var SelectListValue = String(event.getSource().get("v.value"));
        
      	var SearchFilterMap = component.get("v.SearchFilterMap");
         
		if(SelectListValue == ""){
            delete SearchFilterMap[SelectListId];
       	}
       	else{
               strFilter =" AND " + SelectListId + " like '%" + SelectListValue + "%' ";
                
			SearchFilterMap[SelectListId] = strFilter;
       	}
       
       	var SearchFilter="";
       	for (var key in SearchFilterMap){ SearchFilter = SearchFilter + SearchFilterMap[key]; }
       	component.set("v.Searchfilter", SearchFilter);
        
	},
    
    handleClick: function(component, event, helper) {
        var SQLfilter = component.get("v.Searchfilter");
        
        var payload = {
            recordId: "some string",
            recordData: {
    			value: SQLfilter
			}
        };

        component.find("sampleMessageChannel").publish(payload);
    }
})