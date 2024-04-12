@isTest(SeeAllData=True)
public without sharing class TestKadantPortalClasses{
    
    static testMethod void KadantPortalFunctionsTest(){
        
        User[] u = [select id from user limit 1];
        
        //function 1
        KadantPortalClasses.getOrderHistory(u[0].Id, 2019);
        
    }
}