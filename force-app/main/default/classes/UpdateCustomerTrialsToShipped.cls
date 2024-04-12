global class UpdateCustomerTrialsToShipped
{

    public void updateMe(string id)
    {
        
        Trial__c objTrial = [SELECT Id, Status__c
            FROM Trial__c
            WHERE Id = :id LIMIT 1];
        objTrial.Status__c = 'SHIPPED';        
        Update(objTrial);

    }

}