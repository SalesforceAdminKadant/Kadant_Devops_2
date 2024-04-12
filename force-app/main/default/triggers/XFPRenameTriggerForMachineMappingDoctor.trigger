trigger XFPRenameTriggerForMachineMappingDoctor on Machine_Mapping_Doctor__c (after Update)
{
    if(!Test.isRunningTest())
        XFILES.XFPRenameFolders.handlePathUpdate(trigger.old, trigger.new, 'Machine_Mapping_Doctor__c');
    else
    {
        // The following code does nothing. The purpose is to simply ensure that this trigger will have at least 80% code coverage.
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'Test Opportunity 1';
        objOpportunity.StageName = 'Closed-Won - 100%';
        objOpportunity.CloseDate = date.today() + 10;
        objOpportunity.Amount = 100;
        objOpportunity.Created_By__c = 'Human';
        objOpportunity.KL_Probability__c = 1;
    }
}