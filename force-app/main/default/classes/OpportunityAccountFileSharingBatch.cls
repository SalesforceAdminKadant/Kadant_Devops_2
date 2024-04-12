global class OpportunityAccountFileSharingBatch implements Database.Batchable<sObject>, Schedulable, Database.Stateful, Database.AllowsCallouts {
    global Id oppId;

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new OpportunityAccountFileSharingBatch(), 50);
    }

    global OpportunityAccountFileSharingBatch(){}

    global OpportunityAccountFileSharingBatch(Id oppId){
        this.oppId = oppId;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, AccountId FROM Opportunity';
        query += ' WHERE No_of_Files__c != null';
        query += ' AND AccountId != null';
        if(oppId != null){
            query += ' AND Id =: oppId';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : scope){
            accountIds.add(opp.AccountId);
        }

        List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId, Contact.AccountId 
                                                                        FROM AccountContactRelation 
                                                                        WHERE AccountId IN: accountIds
                                                                        AND IsDirect = false];

        if(!accountContactRelationList.isEmpty()){
            Map<Id, Set<Id>> accIdToAccountIdsMap = new Map<Id, Set<Id>>();
            Map<Id, List<ContentDocumentLink>> accIdToCLinksMap = new Map<Id, List<ContentDocumentLink>>();
            Map<Id,List<Opportunity_File_Share__c>> accIdToOppFileSharesMap = new Map<Id,List<Opportunity_File_Share__c>>();
            List<ContentDocumentLink> relatedAccountCLinksList = new List<ContentDocumentLink>();
            List<Opportunity_File_Share__c> relatedAccountShareList = new List<Opportunity_File_Share__c>();
            for(AccountContactRelation accCon: accountContactRelationList){
                if(!accIdToAccountIdsMap.containsKey(accCon.AccountId)){
                    accIdToAccountIdsMap.put(accCon.AccountId, new Set<Id>{accCon.Contact.AccountId});
                }else{
                    accIdToAccountIdsMap.get(accCon.AccountId).add(accCon.Contact.AccountId);
                }
            }

            List<ContentDocumentLink> cDocLinkList = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: accIdToAccountIdsMap.keySet()];
            if(!cDocLinkList.isEmpty()){
                for(ContentDocumentLink cLink : cDocLinkList){
                    if(!accIdToCLinksMap.containsKey(cLink.LinkedEntityId)){
                        accIdToCLinksMap.put(cLink.LinkedEntityId, new List<ContentDocumentLink>{cLink});
                    }else{
                        accIdToCLinksMap.get(cLink.LinkedEntityId).add(cLink);
                    }
                }
            }

            for(Opportunity_File_Share__c fileShare : [SELECT Id, Account__c FROM Opportunity_File_Share__c WHERE Account__c IN:accIdToAccountIdsMap.keySet()]){
                if(accIdToOppFileSharesMap.containsKey(fileShare.Account__c)){
                    accIdToOppFileSharesMap.get(fileShare.Account__c).add(fileShare);
                }else{
                    accIdToOppFileSharesMap.put(fileShare.Account__c, new List<Opportunity_File_Share__c>{fileShare});
                }
            }

            for(Id accId : accIdToAccountIdsMap.keySet()){
                for(Id relatedAccId : accIdToAccountIdsMap.get(accId)){
                    if(accIdToCLinksMap.get(accId) != null){
                        for(ContentDocumentLink cLink : accIdToCLinksMap.get(accId)){
                            ContentDocumentLink newClink = new ContentDocumentLink();
                            newClink.LinkedEntityId = relatedAccId;
                            newClink.ContentDocumentId = cLink.ContentDocumentId;
                            newClink.Visibility = 'AllUsers';
                            relatedAccountCLinksList.add(newClink);
             try
            {
                if(!relatedAccountCLinksList.isEmpty())
                    insert relatedAccountCLinksList;
            }
            catch(DmlException e1)
            {
            }
                           relatedAccountCLinksList.clear();
                        }
                    }
    
                    if(accIdToOppFileSharesMap.get(accId) != null){
                        for(Opportunity_File_Share__c share : accIdToOppFileSharesMap.get(accId)){
                            Opportunity_File_Share__c newShare = new Opportunity_File_Share__c();
                            newShare.Account__c = relatedAccId;
                            relatedAccountShareList.add(newShare);
                            insert relatedAccountShareList;
            try
            {
                if(!relatedAccountShareList.isEmpty())
                    insert relatedAccountShareList;
            }
            catch(DmlException e2)
            {
            }
                        }
                    }
                }
            }
            
            try
            {
                if(!relatedAccountCLinksList.isEmpty())
                    insert relatedAccountCLinksList;
            }
            catch(DmlException e1)
            {
            }

            try
            {
                if(!relatedAccountShareList.isEmpty())
                    insert relatedAccountShareList;
            }
            catch(DmlException e2)
            {
            }
        }
    }

    global void finish(Database.BatchableContext BC){

    }
}