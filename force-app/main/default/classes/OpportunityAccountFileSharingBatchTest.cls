@isTest(SeeAllData=true)
private class OpportunityAccountFileSharingBatchTest {

    @IsTest(SeeAllData=true)
    static void shareBatchParam() {

        Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity Where AccountId != Null LIMIT 1];

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = opportunity.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        Account acc = new Account();
        acc.Name = 'Testil';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'test'; 
        con.LastName = 'testington';
        con.Email = 'testington@sfdc.com';
        con.AccountId = acc.Id;
        insert con;

        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = opportunity.AccountId;
        acr.ContactId = con.Id;
        insert acr;

        List<Opportunity_File_Share__c> fileShares = [SELECT Id FROM Opportunity_File_Share__c WHERE Account__c =:opportunity.AccountId LIMIT 1];

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Test Another File',
                PathOnClient =  'AnotherFile.png',
                VersionData = Blob.valueOf('Updated content'),
                IsMajorVersion = true
        );
        insert contentVersion;

        ContentDocumentLink anotherCdl = new ContentDocumentLink();
        anotherCdl.LinkedEntityId = opportunity.AccountId;
        anotherCdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id=:contentVersion.Id LIMIT 1].ContentDocumentId;
        anotherCdl.shareType = 'V';
        insert anotherCdl;

        Test.startTest();
        Database.executeBatch(new OpportunityAccountFileSharingBatch(opportunity.Id));
        Test.stopTest();
    }

    private static List<ContentDocument> createDocument(){
        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient =  'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;

        return [
                SELECT Id, Title, LatestPublishedVersionId
                FROM ContentDocument LIMIT 1
        ];
    }
}