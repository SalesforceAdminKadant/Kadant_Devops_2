({
     accountList : function(component, recordId, nMaxDistance, boolMetric, boolPriority,bool8020,boolOwner,boolLeads) {
        var action2 = component.get("c.getNearbyCustomers");
        var action = component.get("c.getCenter");
        var self = this;
        var accounts = [];
        var mapMarkers = [];
		var centerLocations = [];  
        var centerLat='';
        var centerLong='';
         action.setParams({recordId : recordId});
         action.setCallback(this, function(actionResult){
             var state = actionResult.getState();
             if (state === 'SUCCESS'){
             var centerlocations = actionResult.getReturnValue();
                 //console.log('Result returned action: ' +JSON.stringify(centerlocations));
           for ( var i = 0; i < centerlocations.length; i++ ) {
               	 var centerlocation= centerlocations[i];
                 //console.log(centerlocation.ShippingLatitude + ' latlong ' + centerlocation.ShippingLongitude);
               if(centerlocation.ShippingLatitude != null) {
               var setcenter = {
                'location': {
                    'Latitude': centerlocation.ShippingLatitude,
                    'Longitude': centerlocation.ShippingLongitude
                },
            	}; 
               centerLat = centerlocation.ShippingLatitude;
               centerLong =centerlocation.ShippingLongitude;
           	   }
               if(centerlocation.Latitude != null) {
               var setcenter = {
                'location': {
                    'Latitude': centerlocation.Latitude,
                    'Longitude': centerlocation.Longitude
                },
            	}; 
               centerLat = centerlocation.Latitude;
               centerLong = centerlocation.Longitude;
           	   }
             }
                 //console.log('setcenter ' + setcenter);
                 component.set('v.center',setcenter);    
           }
         });
         $A.enqueueAction(action);
                  
         action2.setParams({
            recordId: recordId,
            maxDistance: nMaxDistance,
            metric: boolMetric,
            prioRatings: boolPriority,
            prioRanks: bool8020,
             includeLeads: boolLeads,
             myLocations: boolOwner
                    });
        action2.setCallback(this, function(actionResult){
            var state = actionResult.getState();
            if (state === 'SUCCESS'){
            var accounts = actionResult.getReturnValue();
			console.log('Result returned action2: ' +JSON.stringify(accounts));
            component.set("v.accountlist", accounts);
                //component.set('v.mapMarkers',actionResult.getReturnValue());
            for ( var i = 0; i < accounts.length; i++ ) {
                
                var account = accounts[i];
                //console.log(account);
                //var accountOwner = account.Account_Owner_Name__c.toLowerCase();
                //console.log('ownername: ' + accountOwner + ' username: ' + userName + ' ownertoggle: ' + boolOwner);
                //var marker = [];
                //if(boolOwner==false || (boolOwner== true && accountOwner== userName)){
                  // console.log('am i in the loop?');
                if(account.ShippingLatitude != null){ 
                var marker = {
                    'location': {
                        //'Street': account.ShippingStreet,
                       // 'City': account.ShippingCity,
                       //'PostalCode': account.ShippingPostalCode,
                        'Latitude': account.ShippingLatitude,
                        'Longitude': account.ShippingLongitude 
                    },
                    'title': account.Name + ' ' + account.AccountNumber,
                    'icon': 'standard:location',
                    'description': account.ShippingStreet + ', ' + account.ShippingPostalCode + ', ' + account.ShippingCity + '<br>' + account.Rating+ ' / ' +account.Strategex_Rank__c+ '<br>' + account.Account_Owner_Name__c
                    };
                    console.log(marker);
                    mapMarkers.push( marker );
                 } 
                if(account.Latitude != null ){
                     var marker = {
                    'location': {
                        //'Street': account.ShippingStreet,
                       // 'City': account.ShippingCity,
                       //'PostalCode': account.ShippingPostalCode,
                        'Latitude': account.Latitude,
                        'Longitude': account.Longitude 
                    },
                    'title': account.Name + ' ',
                    'icon': 'standard:location',
                    mapIcon: {
               		path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',            
                	fillColor: 'orange',
                	fillOpacity: .8,
                	strokeWeight: 0,
                	scale: .10,
            		},     
                    'description': account.Street + ', ' + account.PostalCode + ', ' + account.City + '<br>' + account.Status+ '<br>' + account.Owner.Name
                    };
					console.log(marker);                 
                    mapMarkers.push( marker );
                }
                //}
               // console.log('what am I trying to push'); console.log(marker);
            	//if (!marker.length === 0) {  
               // mapMarkers.push( marker );
                //    console.log('what am I trying to push in ifstatement'); console.log(marker);
               // }  
                //console.log(mapMarkers);
        	}
            var centermarker = {
                'location': {
                    'Latitude': centerLat,
                    'Longitude': centerLong
                	},
                mapIcon: {
                path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',            
                fillColor: 'green',
                fillOpacity: .8,
                strokeWeight: 0,
                scale: .10,
            	},

            };
                //console.log(centermarker);
        		mapMarkers.push( centermarker );
                
        component.set( 'v.mapMarkers', mapMarkers );
            }
        });
        $A.enqueueAction(action2);
         
    }   
    
    
})