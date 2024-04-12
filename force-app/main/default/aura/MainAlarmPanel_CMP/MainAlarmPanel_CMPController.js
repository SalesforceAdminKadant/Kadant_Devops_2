({
	doInIt : function(component, event, helper) {
        console.log('doInIt');
        helper.getAccountsData(component, event, helper);
        //component.set('v.disabledAssetSelect', false);
        //helper.getAssetsData(component, event, helper);
        helper.getHeaderData(component, event, helper);
	},
    handleSelection: function (component, event, helper) {
        console.log('In handle Selection...');
        //component.set('v.showSpinner',true);
        var selectedAlarm = event.getParam("rule");
        console.log(selectedAlarm);
        component.set('v.selectedRule',selectedAlarm);
        var LongName = component.get('v.selectedRule.RuleLongNm__c');
        if(LongName != null){
        	component.set('v.headerText',LongName);
        }
        component.set('v.showModel', true);
        var main = component.find("main");
        var detail = component.find("detail");
        $A.util.removeClass(main,'slds-show');
        $A.util.addClass(main,'slds-hide');
        $A.util.removeClass(detail,'slds-hide');
        $A.util.addClass(detail,'slds-show');
    },
    onAccountSelection : function(component, event, helper) {
        component.set('v.showSpinner',true);
        var accountId = component.get('v.selectedAccountId');
        if(accountId.startsWith("001")) {
            component.set('v.disabledAssetSelect', false);
            helper.getAssetsData(component, event, helper);
            component.set('v.showSpinner',false);
        }
        else {
            component.set('v.disabledAssetSelect', true);
            component.set('v.showSpinner',false);
        }
    },
    
    onAssetSelection : function(component, event, helper) {
        component.set('v.showRules', true);
        helper.getHeaderData(component, event, helper);
    },
    onTimezoneChange : function(component, event, helper) {
        var headerDetails = component.get('v.headerDetails');
        var isUserTimezone = component.get('v.isUserTimezone');
        var timeZone;
        if(isUserTimezone == true) {
            timeZone = headerDetails.userTimezone;
        } else {
            timeZone = headerDetails.assetTimezone;
        }
        component.set('v.defaultTimezone', timeZone);
    },
    onBack : function(component, event, helper) {
        component.set('v.showRules', false);
        component.set('v.selectedAssetId','');
    },
    closeModel : function(component, event, helper) {
        var showModel = component.get('v.showModel');
        if(showModel == true) {
            component.set('v.headerText','Alerts');
            component.set('v.showModel', false);
            var main = component.find("main");
            var detail = component.find("detail");
            $A.util.removeClass(main,'slds-hide');
            $A.util.addClass(main,'slds-show');
            $A.util.removeClass(detail,'slds-show');
            $A.util.addClass(detail,'slds-hide');
        } else {
            component.set('v.showRules', false);
        	component.set('v.selectedAssetId','');
        }
    },
    handleSelect: function(component,event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue == 'Severity'){
            console.log('Inside Active Alerts sort..');
            var totalAlerts = component.get('v.rules');
            var activeAlerts = [];
            var infoAlerts = [];
            var afterSort = [];
            for(var i=0; i<totalAlerts.length; i++){
                if(totalAlerts[i].AlertStatus__c == 'ACTIVE'){
                    afterSort.push(totalAlerts[i]);
                }
            }
            for(var i=0; i<totalAlerts.length; i++){
                if(totalAlerts[i].AlertStatus__c != 'ACTIVE'){
                    afterSort.push(totalAlerts[i]);
                }
            }
            component.set('v.rules',afterSort);
        }else if(selectedMenuItemValue == 'Date'){
            var direction = component.get('v.sortDirection');
            if(direction == 'ASC') {
                direction = 'DESC';
            } else {
                direction = 'ASC';
            }
            component.set('v.showSpinner',true);
            var action = component.get("c.getSortedRules");
            action.setParams({direction : direction, assetId : component.get('v.selectedAssetId')});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log(JSON.stringify(response.getReturnValue()));
                    component.set('v.rules',response.getReturnValue());
                    component.set('v.sortDirection',direction);
                    var output = response.getReturnValue();
                    var count = output.length;
                    component.set('v.totalRules', count);
                    var activeAlerts = [];
                    for(var i=0; i<output.length; i++){
                        if(output[i].AlertStatus__c == 'ACTIVE'){
                            activeAlerts.push(output[i]);
                        }
                    }
                    var activeAlertscount = activeAlerts.length;
                    var otherscount = count - activeAlertscount;
                    component.set('v.totalActiverules', activeAlertscount);
                    component.set('v.totalInActiverules', otherscount);
                    component.set('v.showSpinner',false);
                }
                else if (state === "INCOMPLETE") {}
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            }); 
            $A.enqueueAction(action);
            component.set('v.showSpinner',false);
        }else if(selectedMenuItemValue == 'Name'){
            component.set('v.rules',component.get('v.rulessortedbyName'));
        }
    },
})