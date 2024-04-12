@isTest(SeeAllData=true)
public without sharing class TestMachineMappingTriggers
{
    static testMethod void testEvent()
    {
        Machine_Mapping_Cleaning__c mmc = [Select Id, Name From Machine_Mapping_Cleaning__c LIMIT 1];
        update mmc;
        Machine_Mapping_Doctor__c mmd = [Select Id, Name From Machine_Mapping_Doctor__c LIMIT 1];
        update mmd;
        Machine_Mapping_Drainage__c mmdr = [Select Id, Name From Machine_Mapping_Drainage__c LIMIT 1];
        update mmdr;
        Machine_Mapping_Filter__c mmf = [Select Id, Name From Machine_Mapping_Filter__c LIMIT 1];
        update mmf;
        Machine_Mapping_Belt__c mmb = [Select Id, Name From Machine_Mapping_Belt__c LIMIT 1];
        update mmb;
        Machine_Mapping_Accessory__c mma = [Select Id, Name From Machine_Mapping_Accessory__c LIMIT 1];
        update mma;
        //Machine_Mapping_Rotary_Joint__c mmrj = [Select Id, Name From Machine_Mapping_Rotary_Joint__c LIMIT 1];
        //update mmrj;
       
    }
}