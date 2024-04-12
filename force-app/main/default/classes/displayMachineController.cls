public class displayMachineController {
public String currentMachineId { get; set; } 
    public String[] fileIds { get; set; }
    public String errorMessage { get; set; }
    
    public displayMachineController (ApexPages.StandardController controller) {
        errorMessage = '';
        // Using the current Machine ID go and get the Sections ORDERED by Section Order
        currentMachineId = ApexPages.CurrentPage().getparameters().get('id');
        Machine_Section__c[] macSections = [SELECT Id FROM Machine_Section__c WHERE Machine__c = :currentMachineId AND Map_Created__c = true ORDER BY Sequence__c ASC];
        
        if (!macSections.isEmpty())
        {
            String filter = '';
            Integer i = 0;
            fileIds = new List<String>();
            for (Machine_Section__c mac : macSections)
            {
                // Usng the Machine Section ID go and get the Image created when the Map was saved; if it was saved!!
                filter = mac.Id;                
                ContentDocumentLink[] docLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :filter];
                if (!docLink.isEmpty())
                {
                    // now go and get the actual SVG file ID that gets used in the Visual Force page
                    ContentVersion[] cvId = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :docLink[0].ContentDocumentId AND PublishStatus = 'P' AND IsLatest = true AND IsDeleted = false];
                    if (!cvId.isEmpty())
                    {
                    	fileIds.add('/sfc/servlet.shepherd/version/download/' + cvId[0].Id);
                    }
                }
            }            
        }
        else
        {
            errorMessage = 'There are no Machine Maps associated with this Machine!';
        }
    }
}