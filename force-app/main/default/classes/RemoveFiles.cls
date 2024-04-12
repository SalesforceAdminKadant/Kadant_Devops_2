/***********************************************/
/* Remove all files from a given Object Record */
/***********************************************/
public class RemoveFiles {

    @InvocableMethod
    public static void removeFiles(List<Id> recordIds) {
        try {
            List<ContentDocument> lstCD = new List<ContentDocument>();
            for(ContentDocumentLink objCDL : [SELECT Id, ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId in :recordIds])
            {
                for(ContentDocument objCD : [SELECT Id
                    FROM ContentDocument
                    WHERE Id = :objCDL.ContentDocumentId])
                {
                    lstCD.add(objCD);
                }
            }
            if(!lstCD.isEmpty())
                delete lstCD;
        }
            catch (Exception e) {
                KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com', 'An error has occurred in RemoveFiles.', 'The following error has occurred in the RemoveFiles function: ' + e.getMessage() + '.');
        }
    }
}