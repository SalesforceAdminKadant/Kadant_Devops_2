({
    getTagInfo : function (component, event, helper) {
        console.log('getTagInfo');
        var action = component.get("c.getTagsList");
        //action.setParams({ruleId:component.get('v.rule').RuleLongNm__c, timeZone: component.get('v.timeZone') });
        action.setParams({ruleId:component.get('v.rule').Id, timeZone: component.get('v.timeZone') });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                var temp = response.getReturnValue();
                //console.log(JSON.stringify(temp));
                var tags = [];
                //var colors = ["orange", "blue", "green", "purple"];
                var colors = ["rgb(247, 223, 117)", "rgb(145, 153, 155)", "rgb(253, 99, 95)", "purple"];
                for(var i = 0; i < temp.length; i++) {
                    tags.push({name:temp[i], color: colors[i]});
                }
                component.set('v.tags', tags);
            }
        });
        $A.enqueueAction(action);
    },
    getActiveData : function (component, event, helper) {
        //console.log('getActiveData');
        //console.log(JSON.stringify(component.get('v.rule')));
        var activeAlerts = component.get("c.getChartMap");
        //activeAlerts.setParams({ruleId : component.get('v.rule').RuleLongNm__c});
        activeAlerts.setParams({
                ruleId : component.get('v.rule').Id,
                timeZone : component.get('v.timeZone')
            });
        activeAlerts.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                //console.log('Rule ID - ' + component.get('v.rule').Id + ', Timezone - ' + component.get('v.timeZone'));
                var data = JSON.parse(response.getReturnValue());
                console.log(JSON.stringify(data));
                helper.createGraph(component, data);
                component.set('v.showSpinner',false);
                helper.getTagInfo(component, event, helper);
            }

        });

        $A.enqueueAction(activeAlerts);
    },
    createGraph : function(component, data) {
        console.log('createGraph');
        var el = component.find('barChart').getElement();
        var ctx = el.getContext('2d');
        var option = {
          responsive: false,
          barThickness: 'flex',
          legend: {
              display: false
          },
          scales: {
            yAxes: [{
              gridLines: {
                display: true,
                color: "rgba(255,99,132,0.2)"
              },
              ticks: {
                  min : -2,
                  max : 2,
                  userCallback: function(item, index) {
                                     if (!(index % 2)) return item;
                                     else return '';
                                     }
              }
            }],
            xAxes: [{
              gridLines: {
                display: false
              },
              ticks: {
                    userCallback: function(item, index) {
                        if (!(index % 2)) return item;
                        else return '';
                    },
                    fontSize: 15,
                    maxRotation : 0,
                    minRotation : 0
              }
            }]
          }
        };
        new Chart(ctx, {
            type: 'bar',
            data: data,
            options: option
        });
    },
})