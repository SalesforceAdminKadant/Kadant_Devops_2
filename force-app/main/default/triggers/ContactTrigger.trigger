trigger ContactTrigger on Contact (before insert, before update) {

    //Before trigger
    if(trigger.isBefore){
        if(trigger.isInsert){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }

        if(trigger.isUpdate){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }
    }

    /*
    //After trigger
    if(trigger.isAfter){
        if(trigger.isInsert){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }

        if(trigger.isUpdate){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
        }
    }
    */


    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<Contact> lstContactsNew, map<Id,Contact> mapContactsNew, Map<Id,Contact> mapContactsOld){
    
        for(Contact cnt : lstContactsNew){
            if(trigger.isInsert && cnt.Description_hidden__c != null && cnt.Description == null) {
                cnt.Description = cnt.Description_hidden__c;
            }
            //Initialize the "Active_Contact_Lookup__c" and "Inactive_Contact_Lookup__c" fields
            if(cnt.Employment_Status__c==null)
                cnt.Employment_Status__c='Active';

            if(cnt.Employment_Status__c=='Active')
                cnt.Active_Contact_Lookup__c=cnt.AccountId;
            else
                cnt.Active_Contact_Lookup__c=null;   

            if(cnt.Employment_Status__c!='Active')
            {
                cnt.Inactive_Contact_Lookup__c=cnt.AccountId;
            }
            else{
                cnt.Inactive_Contact_Lookup__c=null;
            }

            if(cnt.Preferred_Language__c == 'Default' && cnt.Account_Language__c != 'Default')
                cnt.Preferred_Language__c = cnt.Account_Language__c;
        }        
    }
}