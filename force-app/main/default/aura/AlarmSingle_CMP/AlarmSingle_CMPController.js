({
	fireApplicationEvent : function(component, event) {
        console.log('fireApplicationEvent');
        var appEvent = $A.get("e.c:eventSelect_EVT");
        appEvent.setParams({"rule" : component.get('v.rule') });
        appEvent.fire();
    }
})