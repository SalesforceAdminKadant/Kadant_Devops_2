public with sharing class LocationSearchController {
    
     @AuraEnabled 
    public static List<Account>getCenter(Id recordId){
		Schema.sObjectType objType = recordId.getSObjectType();
        string theobject = String.valueOf(objType); 
        List<sObject> centerlist = new List<sObject>();
        system.debug(theobject);
        if(theobject == 'Account'){
        centerlist = [select id, shippinglatitude, shippinglongitude from account where id = :recordId];
    	}
        if(theobject == 'Lead'){
        centerlist = [select id, latitude, longitude from lead where id = :recordId];
    	}
        system.debug(centerlist);
        return centerlist;
    }
	 @AuraEnabled
     public static List<Account> getNearbyCustomers(Id recordId, Integer maxDistance, Boolean metric, Boolean prioRatings, Boolean prioRanks, Boolean includeLeads, Boolean myLocations) {
		 system.debug(recordId);
         system.debug(maxDistance);
         system.debug(metric);
         system.debug('leads?' + includeLeads);
         system.debug('mine?' + myLocations);
         decimal centerlat = 0;
         decimal centerlong = 0;
         string acctrecordtype = '';
         string acctrating = '';
         string acctranking = '';
         string searchfilter = '';
         string searchstring = '';
         Id currentUser = UserInfo.getUserId();
        // Id theId = recordId;
        Schema.sObjectType objType = recordId.getSObjectType();
        string theobject = String.valueOf(objType); 
         
         
         List<sObject> locations = new List<sObject>();
         
         if(theobject == 'Account'){
             List<Account> acctlist = [select id, shippinglatitude, shippinglongitude, recordtype.name, rating, strategex_rank__c from account where id= :recordId limit 1];
            
             for(Account a: acctlist){ 
            centerlat = a.shippinglatitude;
            centerlong = a.shippinglongitude;
            acctrecordtype = a.recordtype.name;
            acctrating = a.rating;
            acctranking = a.Strategex_Rank__c;
            } 
    	 }
         if(theobject == 'Lead'){
           List<Lead> leadlist = [select id, latitude, longitude, division__c, PSG_E_Division__c  from lead where id= :recordId limit 1];
         
         	for(Lead a: leadlist){
             centerlat = a.latitude;
             centerlong = a.longitude; 
             acctrecordtype = a.division__c.left(3) + ' Account';
                if(a.Psg_e_division__c == true || a.division__c == 'KL'){acctrecordtype = 'Kadant Europe Accounts';}
                if(a.division__c=='KJ' || a.division__c =='KSD'){acctrecordtype = 'US Account';}
         	}
         }
         system.debug(acctrecordtype);
         //if(acctrecordtype == 'Kadant Europe Accounts'){
         List<String> rankingCategories = new List<String>{'A','B','BB','BLV','BMV','BHV','ND','','TS','W','RF'};
         List<String> ratingCategories = new List<String>{'Farming/Nurturing','Growth/New Business','Low Priority/Call instead of Visit',''};
         List<String> allowedStatuses = new List<String>{'Undetermined','Qualified-Hot'};
         if(prioRatings ==true){
             ratingCategories.clear(); 
             ratingCategories.add('Farming/Nurturing');
             ratingCategories.add('Growth/New Business');
            }
         if(prioRanks ==true){
            rankingCategories.clear(); 
            rankingCategories.add('A');
            rankingCategories.add('TS');
            rankingCategories.add('W');
            rankingCategories.add('RF');
             }
         system.debug(ratingCategories);
         system.debug(rankingCategories);
            // searchfilter = 'and rating in (' +ratingCategories+ ')';
        // }
         
         Location center = new Location();
         center.Latitude = centerlat;
         center.Longitude = centerlong;
         system.debug(center);
           
         if(metric==true && myLocations ==false){
         List<Account> accounts1 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km')
            from Account where id != :recordId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') limit 200];
         //searchstring = 'select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,ShippingLatitude, ShippingLongitude, Rating, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude),\'' + 'km' + '\') from Account where id != :recordId and Active__c = true and ShippingLatitude <> null and recordtypeid = :acctrecordtype ' + searchfilter + ' and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), \'' + 'km' + '\') < :maxDistance order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude),\'' + 'km' + '\') limit 200';
         //system.debug(searchstring);
         //accounts = Database.query(searchstring);
           system.debug(accounts1);
          	locations.addAll(accounts1);
				 if(includeLeads==true){
                 List<sObject> leads1 = [select id, name, Street, PostalCode, City, Owner.Name, Latitude, Status, Longitude, DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'km')
                 from Lead where Latitude<> null and Status in :allowedStatuses and DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') < :maxDistance
                 order by DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') limit 200];
                 system.debug('leads' + includeLeads);
                 system.debug(leads1);
                locations.addAll(leads1);
             }
         }
         if(metric==true && myLocations ==true){
         List<sObject> accounts2 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km')
            from Account where id != :recordId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and id in (select account__c from account_division__c where account_owner__c = :currentUser and active__c = true) and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') limit 200];
         //searchstring = 'select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,ShippingLatitude, ShippingLongitude, Rating, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude),\'' + 'km' + '\') from Account where id != :recordId and Active__c = true and ShippingLatitude <> null and recordtypeid = :acctrecordtype ' + searchfilter + ' and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), \'' + 'km' + '\') < :maxDistance order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude),\'' + 'km' + '\') limit 200';
         //system.debug(searchstring);
         //accounts = Database.query(searchstring);
           system.debug(accounts2);
          locations.addAll(accounts2);
             if(includeLeads==true){
                 List<sObject> leads2 = [select id, name, Street, PostalCode, City, Owner.Name, Latitude, Longitude, Status, DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'km')
                 from Lead where Latitude<> null and Status in :allowedStatuses and OwnerId = : currentuser and DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') < :maxDistance
                 order by DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') limit 200];
                 
                 system.debug(leads2);
              	locations.addAll(leads2);
             }

         }
         if(metric==false && myLocations ==false){
         List<Account> accounts3 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi')
            from Account where id != :recordId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') limit 200];
           system.debug(accounts3);
          	locations.addAll(accounts3);
			if(includeLeads==true){
                 List<sObject> leads3 = [select id, name, Street, PostalCode, City, Owner.Name, Latitude, Status, Longitude, DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi')
                 from Lead where Latitude<> null and Status in :allowedStatuses and DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') < :maxDistance
                 order by DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') limit 200];
                 system.debug('leads' + includeLeads);
                 system.debug(leads3);
                locations.addAll(leads3);
             }
         }
         if(metric==false && myLocations ==true){
         List<sObject> accounts4 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi')
            from Account where id != :recordId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and id in (select account__c from account_division__c where account_owner__c = :currentUser and active__c = true) and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') limit 200];
          system.debug(accounts4);
          locations.addAll(accounts4);
          if(includeLeads==true){
                 List<sObject> leads4 = [select id, name, Street, PostalCode, City, Owner.Name, Latitude, Longitude, Status, DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi')
                 from Lead where Latitude<> null and Status in :allowedStatuses and OwnerId = : currentuser and DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') < :maxDistance
                 order by DISTANCE(Address, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') limit 200];
                 
                 system.debug(leads4);
              	locations.addAll(leads4);
             }

         }
         
           return locations;  
    }

    public class Location {

        @AuraEnabled public Decimal Latitude {get; set;}
        @AuraEnabled public Decimal Longitude {get; set;}
        public Location() {}
    }
}