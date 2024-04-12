({	
    doInIt : function(component, event, helper) {
        console.log('ShowChart doInIt');
        var totwidth = document.documentElement.clientWidth;
        var width = (totwidth * 75)/100;
        console.log(width);
        component.set('v.width',width);
    },
    ctr : function(component, event, helper) {
        console.log('ShowChart ctr');
        helper.getActiveData(component, event, helper);
    }
})