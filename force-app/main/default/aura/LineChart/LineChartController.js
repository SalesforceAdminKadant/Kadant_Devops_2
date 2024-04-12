/**
 * Created by naveen on 26/02/19.
 */
({
    getLineData : function (component, event, helper) {
        console.log('getLineData');
        var action = component.get("c.getLineChartMap");
        action.setParams({ ruleId : component.get('v.rule').Id, tagName : component.get('v.tag')});
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                var temp = JSON.parse(response.getReturnValue());
                helper.createLineGraph(component, temp);
                component.set('v.showSpinner',false);
            }
        });
        $A.enqueueAction(action);
    }
})