({
        onInit: function(component, event, helper) {
        // proactively search on component initialization
        var nMaxDistance = component.find("DistanceInput").get("v.value");
        var boolMetric = component.get("v.UnitToggle");
        var boolPriority = component.get("v.PriorityRankingToggle");
        var bool8020 = component.get("v.X8020Toggle");
        var boolOwner = component.get("v.OwnerToggle");
        var boolLeads = component.get("v.LeadsToggle");
        var recordId = component.get("v.recordId");   
        var objectName = component.get("v.sObjectName");
            if(objectName == 'Lead'){boolLeads = true; bool8020 = false; boolPriority= false;}
            console.log('object : ' + objectName);
            console.log(' distance :' + nMaxDistance + ' metric: ' + boolMetric + ' prio: ' + boolPriority + ' Owner: ' +boolOwner);
       helper.accountList(component, recordId, nMaxDistance, boolMetric, boolPriority,bool8020,boolOwner,boolLeads);
    },
    onChangeToggle: function(component, event, helper){
        var nMaxDistance = component.find("DistanceInput").get("v.value");
        var boolMetric = component.get("v.UnitToggle");
        var boolPriority = component.get("v.PriorityRankingToggle");
        var bool8020 = component.get("v.X8020Toggle");
        var boolOwner = component.get("v.OwnerToggle");
        var boolLeads = component.get("v.LeadsToggle");
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
            if(objectName == 'Lead'){boolLeads = true; bool8020 = false; boolPriority= false;}
        console.log('distance2 :' + nMaxDistance +' metric21: ' + boolMetric + ' prio1: ' + boolPriority);
       helper.accountList(component, recordId, nMaxDistance, boolMetric, boolPriority,bool8020,boolOwner,boolLeads);
    }	       
    

})