({
	getHeaderData : function(component, event, helper) {
        console.log('getHeaderData');
        var assetId = component.get('v.selectedAssetId');
        console.log(assetId);
        var action = component.get("c.getData");
        action.setParams({assetId : assetId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var headerDetails = JSON.parse(response.getReturnValue());

                component.set('v.headerDetails',headerDetails);
                if(assetId) {
                    component.set('v.defaultTimezone', headerDetails.assetTimezone);
                    component.set('v.isUserTimezone', false);
                    helper.getRulesData(component, event, helper);
                }
            }
            else if (state === "INCOMPLETE") {}
            else if (state === "ERROR") {
                component.set('v.showSpinner',false);
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
    },
    getRulesData : function(component, event, helper) {
        console.log('getRulesData');
        var action = component.get("c.getRules");
        action.setParams({assetId : component.get('v.selectedAssetId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                component.set('v.rules',response.getReturnValue());
                component.set('v.rulessortedbyName',response.getReturnValue());
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
                component.set('v.showSpinner',false);
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
    },
    getAccountsData : function(component, event, helper) {
        console.log("getAccountsData");
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
            component.set('v.showSpinner',false);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.accounts', response.getReturnValue());
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
    },
    getAssetsData : function(component, event, helper) {
        console.log('getAssetsData');
        var action = component.get("c.getAssets");
        action.setParams({accId : component.get('v.selectedAccountId')});
        action.setCallback(this, function(response) {
            component.set('v.showSpinner',false);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.assets', response.getReturnValue());
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
    }
})