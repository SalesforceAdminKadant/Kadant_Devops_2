global with sharing class ForecastItemWrapper implements Comparable {

    public Forecast_Item__c myTask;
    
    // Constructor
    public ForecastItemWrapper(Forecast_Item__c t) {
        myTask = t;
    }
    
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        ForecastItemWrapper compareToTask = (ForecastItemWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (myTask.Sort_Order__c > compareToTask.myTask.Sort_Order__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (myTask.Sort_Order__c <> compareToTask.myTask.Sort_Order__c) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }

}