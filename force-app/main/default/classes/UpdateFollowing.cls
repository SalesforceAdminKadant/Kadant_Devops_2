global class UpdateFollowing
{

    public void updateMe(String id, Boolean boolDeleteUserFollows)
    {
        
        Follow__c[] fList = new List<Follow__c>();
        EntitySubscription[] listESS = new List<EntitySubscription>();
        ID pID;
        String strID;

        Follow__c[] fDelete = [SELECT Id FROM Follow__c Where OwnerId = :id];
        
        if(!fDelete.isEmpty())
        {
            delete fDelete;
            Database.emptyRecycleBin(fDelete);
        }
            
        if(boolDeleteUserFollows == true)
        {
            for(EntitySubscription objESS : [SELECT Id, ParentId
                FROM EntitySubscription
                WHERE SubscriberId = :id Limit 200])
            {
                strID = objESS.ParentId;
                pID = strID.Left(15);
                if(pID.getSObjectType().getDescribe().getLabel() == 'User')
                {
                    listESS.add(objESS);
                }
            }
            if(!listESS.isEmpty())
                delete listESS;
        }

        EntitySubscription[] ess2 = [SELECT Id, ParentId, Parent.Name, SubscriberId
            FROM EntitySubscription
            WHERE SubscriberId = :id Limit 200];

        for (EntitySubscription es: ess2)
        {
            strID = es.ParentId;
            pID = strID.Left(15);
            Follow__c f = new Follow__c(Object_Type__c = pID.getSObjectType().getDescribe().getLabel(),
                Object_ID__c = es.ParentId,
                Object__c = es.Parent.Name,
                OwnerId = es.SubscriberId);
            fList.add(f);
        }
            
        if(!fList.isEmpty())
            insert fList;

    }

}