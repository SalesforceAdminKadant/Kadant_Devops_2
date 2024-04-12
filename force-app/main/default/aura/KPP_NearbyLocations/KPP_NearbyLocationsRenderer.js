({
	   OpenAccountR: function(component, event, helper){

      	var SelectedMarker = component.get("v.selectedMarkerValue");
      	console.log(SelectedMarker);
        
        var aTags = document.getElementsByTagName("p");
        console.log(aTags);
		var searchText = SelectedMarker.vale;
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