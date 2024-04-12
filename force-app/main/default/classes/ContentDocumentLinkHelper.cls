/**
 * Created by GearsCRM on 9/30/2021.
 */

public with sharing class ContentDocumentLinkHelper {

    public static void attachToOpportunityFileShare(Map<Id, Id> accountCDLinkId){     
        List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId, Contact.AccountId 
                                                                        FROM AccountContactRelation 
                                                                        WHERE AccountId IN: accountCDLinkId.keySet() 
                                                                        AND IsDirect = false];

        if(!accountContactRelationList.isEmpty()){
            Map<Id, Set<Id>> oppAccountIdToAccountIdsMap = new Map<Id, Set<Id>>();
            for(AccountContactRelation accCon: accountContactRelationList){
                if(!oppAccountIdToAccountIdsMap.containsKey(accCon.AccountId)){
                    oppAccountIdToAccountIdsMap.put(accCon.AccountId, new Set<Id>{accCon.Contact.AccountId});
                }else{
                    oppAccountIdToAccountIdsMap.get(accCon.AccountId).add(accCon.Contact.AccountId);
                }
            }

            if(!oppAccountIdToAccountIdsMap.isEmpty()){
                for(Id accId: oppAccountIdToAccountIdsMap.keySet()){
                    for(Id relatedAccId : oppAccountIdToAccountIdsMap.get(accId)){
                        Id contentDocumentId = accountCDLinkId.get(accId);
                        accountCDLinkId.put(relatedAccId, contentDocumentId);
                    }
                }
            }
        }
        
        Map<Id,List<Opportunity_File_Share__c>> accountOppFileShareMap = new Map<Id,List<Opportunity_File_Share__c>>();
        for(Opportunity_File_Share__c fileShare : [SELECT Id, Account__c FROM Opportunity_File_Share__c WHERE Account__c IN:accountCDLinkId.keySet()]){
            if(accountOppFileShareMap.containsKey(fileShare.Account__c)){
                accountOppFileShareMap.get(fileShare.Account__c).add(fileShare);
            }else{
                accountOppFileShareMap.put(fileShare.Account__c, new List<Opportunity_File_Share__c>{fileShare});
            }
        }

        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        List<Opportunity_File_Share__c> newFileShares = new List<Opportunity_File_Share__c>();

        Set<Id> fileShareIds = new Set<Id>();
        for(Id accountId : accountCDLinkId.keySet()){
            if(!accountOppFileShareMap.isEmpty()
                    && accountOppFileShareMap.get(accountId).size() > 0
                    && accountOppFileShareMap.containsKey(accountId)){
                    fileShareIds.add(accountOppFileShareMap.get(accountId)[0].Id);
            }
        }

        if(!fileShareIds.isEmpty()){
            Map<Id, Set<Id>> fileIdToContentDocumentIdsMap = new Map<Id, Set<Id>>();
            List<ContentDocumentLink> cLinks = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: fileShareIds];

            for(ContentDocumentLink cLink : cLinks){
                if(!fileIdToContentDocumentIdsMap.containsKey(cLink.LinkedEntityId)){
                    fileIdToContentDocumentIdsMap.put(cLink.LinkedEntityId, new Set<Id>{cLink.ContentDocumentId});
                }else{
                    fileIdToContentDocumentIdsMap.get(cLink.LinkedEntityId).add(cLink.ContentDocumentId);
                }
            }

            for(Id accountId : accountCDLinkId.keySet()){
                if(!accountOppFileShareMap.isEmpty()
                        && accountOppFileShareMap.get(accountId).size() > 0
                        && accountOppFileShareMap.containsKey(accountId)){
                        Boolean isValid = true;
                        
                        Id fileShareId = accountOppFileShareMap.get(accountId)[0].Id;
                        Id contentDocumentId = accountCDLinkId.get(accountId);

                        if(!fileIdToContentDocumentIdsMap.isEmpty()){
                            if(fileIdToContentDocumentIdsMap.get(fileShareId) != null){
                                if(fileIdToContentDocumentIdsMap.get(fileShareId).contains(contentDocumentId)){
                                    isValid = false;
                                }
                            }
                        }

                        if(isValid){
                            contentDocumentLinks.add(new ContentDocumentLink(
                                    LinkedEntityId = accountOppFileShareMap.get(accountId)[0].Id,
                                    ContentDocumentId = accountCDLinkId.get(accountId),
                                    Visibility = 'AllUsers'));
                        }
                }else{
                    newFileShares.add(new Opportunity_File_Share__c(
                            Account__c = accountId)
                    );
                }
            }

            if(!newFileShares.isEmpty()){
                insert newFileShares;
    
                for(Opportunity_File_Share__c fileShare : newFileShares){
                    contentDocumentLinks.add(new ContentDocumentLink(
                            LinkedEntityId = fileShare.Id,
                            ContentDocumentId = accountCDLinkId.get(fileShare.Account__c) ,
                            Visibility = 'AllUsers')
                    );
                }
            }
    
            insert contentDocumentLinks;
        }
    }
}