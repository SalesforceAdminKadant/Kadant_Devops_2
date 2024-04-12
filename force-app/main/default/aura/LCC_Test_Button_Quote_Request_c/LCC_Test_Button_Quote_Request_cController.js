({
    accept : function(component, event, helper) {
        alert('Test');
        $A.get("e.force:closeQuickAction").fire();
    }
})