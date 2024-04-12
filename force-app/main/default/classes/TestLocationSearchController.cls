@isTest(SeeAllData=True)
public class TestLocationSearchController {
    static testMethod void testLocationSearchController(){
        
        Account testaccount=[select id, shippinglatitude, shippinglongitude from account where shippinglatitude != null and shippinglongitude!= null limit 1];
        Lead testlead = [select id, latitude, longitude from Lead where latitude != null and longitude!= null limit 1];
        LocationSearchController.getCenter(testaccount.Id);
        LocationSearchController.getNearbyCustomers(testaccount.Id, 25, true, true, true,true,true);
        LocationSearchController.getNearbyCustomers(testlead.Id, 25, true, true, true,true,true);
        LocationSearchController.getNearbyCustomers(testaccount.Id, 25, true, true, true,true,false);
        LocationSearchController.getNearbyCustomers(testaccount.Id, 25, false, true, true,true,true);
        LocationSearchController.getNearbyCustomers(testaccount.Id, 25, false, true, true,true,false);
    }
}