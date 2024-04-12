({
	initComponent: function (component, event, helper) 
	{
		//console.log("UMachineSectionMapReadOnly: initComponent at " + window.location.origin);

		component.set("v.lcHost", window.location.origin);

		var rec = component.get("v.recordId");
		var lch = component.get("v.lcHost");
		var ret = component.get("v.returl");

		component.set("v.iframeSrc", "/apex/Machine_Section_MapReadOnly?id=" + rec + "&lcHost=" + lch + "&retURL=" + ret);

		window.addEventListener("beforeunload", $A.getCallback(function(event)
		{
			//console.log("UMachineSectionMapReadOnly: beforeunload");

			var dirty = component.get("v.dirty");
			if (dirty)
			{
				return 'The machine map has changed. Are you sure you want to leave without saving?';
			}
			else
			{
				helper.sendToVf(component, "clearEdit", null);
			}
		}));

		window.addEventListener("message", $A.getCallback(function(event) 
		{
			var vf = component.get("v.vfHost");
			if (vf == null)
			{
				var j = JSON.parse(event.data);

				vf = j.type;
				if (vf === "vfHost")
				{
					component.set("v.vfHost", j.value);
				}
			}
			else
			if (event.origin == vf)
			{
				var j = JSON.parse(event.data);
				if (j.type)
				{
					console.log(j.type + " = " + j.value);

					switch (j.type)
					{
						case "dirty":
							component.set("v.dirty", j.value);
							break;
					}
				}
			}
		}));
	}
})