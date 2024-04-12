({
init : function (component) {
// Find the component whose aura:id is "LMPRequest"
var flow = component.find("LMPRequest");
// In that component, start your flow. Reference the flow’s Unique Name.
flow.startFlow("Screen_Salesforce_License_Request");
},
})