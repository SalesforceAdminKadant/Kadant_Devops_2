({        
    loadKbMax : function(component, event, helper) {
        console.log('IN before add event listener!');
    	window.addEventListener("DOMContentLoaded", function() {            
            console.log('Inside Event Listener!');
            //start the embed
            var config = new kbmax.ConfiguratorEmbed({
                elementId: "viewer",
                configuratorId: 4,
                showHeader: false,
                showDrawer: true,
                showMove: false,
                bindToFormSelector: "",
                loadStyle: "none",
            });
        });
    },
    
    onRender : function(component, event, helper) {
		console.log("Inside the Render!");
    	var mytestbtn = component.find("mytestbtn");
    	mytestbtn.getElement().addEventListener("click", function(e){
        //alert("Event Captured!" + component.get("v.myString"));
        console.log('Inside Event Listener!');
        //start the embed
        var config = new kbmax.ConfiguratorEmbed({
            elementId: "viewer",
            configuratorId: 4,
            showHeader: false,
            showDrawer: true,
            showMove: false,
            bindToFormSelector: "",
            loadStyle: "none",
        });
            e.stopPropagation();
        }, false);
	}
})