/**
 * Created by GearsCRM on 9/27/2021.
 */

@IsTest(SeeAllData=true)
private class ContentDocumentLinkTest {

    @IsTest(SeeAllData=true)
    static void quoteRequestTest () {

        Quote_Request__c quoteRequest = [SELECT Id, Number_Of_Attachments__c FROM Quote_Request__c LIMIT 1];
        
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = quoteRequest.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        quoteRequest = [SELECT Id, Number_Of_Attachments__c  FROM Quote_Request__c LIMIT 1];
        //System.assertEquals(1, quoteRequest.Number_Of_Attachments__c);

        delete cdl;
        quoteRequest = [SELECT Id, Number_Of_Attachments__c  FROM Quote_Request__c LIMIT 1];
        //System.assertEquals(decNumberOfAttachments - 1, quoteRequest.Number_Of_Attachments__c);
    }

    @IsTest(SeeAllData=true)
    static void drawingTest () {

        Drawing__c drawing = [SELECT Id FROM Drawing__c LIMIT 1];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = drawing.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        drawing = [SELECT Id, Number_Of_Files__c  FROM Drawing__c LIMIT 1];
        //System.assertEquals(1, drawing.Number_Of_Files__c);

        delete cdl;
        drawing = [SELECT Id, Number_Of_Files__c  FROM Drawing__c LIMIT 1];
        //System.assertEquals(0, drawing.Number_Of_Files__c);
    }

    @IsTest(SeeAllData=true)
    static void opportunityTest () {
        Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity Where AccountId != Null LIMIT 1];

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

        //create ContentDocumentLink  record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = opportunity.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        opportunity = [SELECT Id, AccountId, No_of_Files__c  FROM Opportunity LIMIT 1];
        //System.assertEquals(1, opportunity.No_of_Files__c);

        List<Opportunity_File_Share__c> fileShares = [SELECT Id FROM Opportunity_File_Share__c WHERE Account__c =:opportunity.AccountId];
        //System.assertEquals(1, fileShares.size());

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Test Another File',
                PathOnClient =  'AnotherFile.png',
                VersionData = Blob.valueOf('Updated content'),
                IsMajorVersion = true
        );
        insert contentVersion;

        ContentDocumentLink anotherCdl = new ContentDocumentLink();
        anotherCdl.LinkedEntityId = opportunity.Id;
        anotherCdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id=:contentVersion.Id].ContentDocumentId;
        anotherCdl.shareType = 'V';
        insert anotherCdl;

        fileShares = [SELECT Id FROM Opportunity_File_Share__c WHERE Account__c =:opportunity.AccountId];
        //System.assertEquals(1, fileShares.size());

        opportunity = [SELECT Id, AccountId, No_of_Files__c  FROM Opportunity LIMIT 1];
        //System.assertEquals(2, opportunity.No_of_Files__c);

        delete cdl;

        opportunity = [SELECT Id, No_of_Files__c  FROM Opportunity LIMIT 1];
        //System.assertEquals(1, opportunity.No_of_Files__c);
    }

    @IsTest(SeeAllData=true)
    static void accountTest () {
        Account account = [SELECT Id FROM Account LIMIT 1];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = account.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        account = [SELECT Id, No_of_Files__c  FROM Account LIMIT 1];
        //System.assertEquals(1, account.No_of_Files__c);

        delete cdl;
        account = [SELECT Id, No_of_Files__c  FROM Account LIMIT 1];
        //System.assertEquals(0, account.No_of_Files__c);
    }

    @IsTest(SeeAllData=true)
    static void quoteTest () {
        Quote quote = [SELECT Id FROM Quote LIMIT 1];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = quote.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        quote = [SELECT Id, No_of_Files__c  FROM Quote LIMIT 1];
        //System.assertEquals(1, quote.No_of_Files__c);

        delete cdl;
        quote = [SELECT Id, No_of_Files__c  FROM Quote LIMIT 1];
        //System.assertEquals(0, quote.No_of_Files__c);
    }

    @IsTest(SeeAllData=true)
    static void orderTest () {
        Order order = [SELECT Id FROM Order LIMIT 1];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = order.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        order = [SELECT Id, No_of_Files__c  FROM Order LIMIT 1];
        //System.assertEquals(1, order.No_of_Files__c);

        delete cdl;
        order = [SELECT Id, No_of_Files__c  FROM Order LIMIT 1];
        //System.assertEquals(0, order.No_of_Files__c);
    }
    
    @IsTest(SeeAllData=true)
    static void WorkOrderTest () {
        WorkOrder WorkOrder = [SELECT Id FROM WorkOrder LIMIT 1];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = WorkOrder.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        //WorkOrder = [SELECT Id, No_of_Files__c  FROM WorkOrder LIMIT 1];
        //System.assertEquals(1, WorkOrder.No_of_Files__c);

        delete cdl;
        //WorkOrder = [SELECT Id, No_of_Files__c  FROM WorkOrder LIMIT 1];
        //System.assertEquals(0, WorkOrder.No_of_Files__c);
    }
    
    @IsTest(SeeAllData=true)
    static void AssetTest () {
        Asset Asset = [SELECT Id FROM Asset LIMIT 1];
        //create ContentDocumentLink  record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = Asset.Id;
        cdl.ContentDocumentId = createDocument()[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        //Asset = [SELECT Id, No_of_Files__c  FROM Asset LIMIT 1];
        //System.assertEquals(1, Asset.No_of_Files__c);

        delete cdl;
        //Asset = [SELECT Id, No_of_Files__c  FROM Asset LIMIT 1];
        //System.assertEquals(0, Asset.No_of_Files__c);
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