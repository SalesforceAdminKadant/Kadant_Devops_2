({
	sendToVf: function(component, type, value)
	{
		var vf = component.get("v.vfHost");
		if (vf != "")
		{
			var message = JSON.stringify( {"type": type, "value": value} );
			var vfWindow = component.find("vfFrame").getElement().contentWindow;

			vfWindow.postMessage(message, vf);
		}
	}
})