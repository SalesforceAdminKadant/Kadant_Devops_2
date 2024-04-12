({
init : function (component) {
// Find the component whose aura:id is "QuickQuoteSMH"
var flow = component.find("QuickQuoteSMH");
// In that component, start your flow. Reference the flow’s Unique Name.
flow.startFlow("SMH_Quick_Quote_2");
},
})