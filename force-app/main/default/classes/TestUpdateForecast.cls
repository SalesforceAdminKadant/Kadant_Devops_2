@isTest(SeeAllData=true)
public with sharing class TestUpdateForecast 
{
    static testMethod void testWebService()
    {
        Forecast__c f = new Forecast__c(Name = 'Q1 2013');
        insert f;
        UpdateForecast uf = new UpdateForecast();
        uf.updateForecast(f.Id);
    }
}