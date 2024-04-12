@isTest(SeeAllData=true)

public with sharing class TestPricingRequestTrigger 
{
    static testMethod void testPricingRequest()
    {
        Pricing_Request__c objPR = [Select Id, Submitted_For_Approval__c From Pricing_Request__c Where Quote__c != null LIMIT 1];
        Approval.Lock(objPR.Id);                
        objPR.Submitted_For_Approval__c = false;
        objPR.Account__c = null;
        update objPR;
        objPR.Submitted_For_Approval__c = true;
        update objPR;
    }
}