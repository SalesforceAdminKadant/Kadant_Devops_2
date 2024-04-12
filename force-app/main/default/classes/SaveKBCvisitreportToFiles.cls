global class SaveKBCvisitreportToFiles {
   
    @invocableMethod(description='Create and Save a VF page template to a PDF file')
    global static List<string> SaveKBCvisitreportToFiles(List<FlowInputs> flowinputs) {
        List<Id> outputs = new List<Id>{};
        if(flowinputs.size() > 0) {
            for (FlowInputs flowinput: flowinputs) {
                    //Get the PDF File
                    Blob pdfBlob;
                    String HTMLpdf;
                    PageReference pdfPage = Page.DisplayVisitReport;
                    pdfPage.getParameters().put('id', flowinput.RecordId);
                    pdfPage.getParameters().put('Internal', flowinput.sInternal);
                    pdfPage.setRedirect(true);
                    if (Test.isRunningTest()) {
                        pdfBlob = Blob.valueOf('UNOT.TEST');
                    }   else {
                        pdfBlob = pdfPage.getContent(); 
                    }
                    

                    //Get Visit Report Information and Set sEXT for file name 
                    string sType;
                    if (flowinput.sInternal == 'True') {
                        sType = 'INT';
                    } else {
                        sType = 'EXT';
                    }

                    Visit_Report__c aVisitReport = [SELECT Name FROM Visit_Report__c WHERE Id = :flowinput.recordId LIMIT 1];

                    //Save the PDF file as a Content Version
                    ContentVersion cv = new ContentVersion(
                    Title='Visit Report - '+ sType +' - '+ aVisitReport.Name, 
                    PathOnClient='Visit Report - '+ sType +' - '+ aVisitReport.Name +'.pdf', 
                    VersionData= pdfBlob
                    );
                    insert cv;

                    //Link the PDF file to the Visit Report
                    cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
                    ContentDocumentLink cdl = new ContentDocumentLink(
                    ContentDocumentId = cv.ContentDocumentId,
                    LinkedEntityId = flowinput.recordId,
                    ShareType = 'I', // Inferred Share
                    Visibility = 'SharedUsers'
                    );
                    insert cdl;  

                    Id output = String.valueOf(cdl.Id);
                    outputs.add(output);
                
            }
        }
        return outputs;
    }

        //input details that comes to apex from flow
        global class FlowInputs{
    
            @InvocableVariable
            public Id RecordId;
            
            @InvocableVariable
            public String sInternal;
            
        }

        global class FlowOutputs{
    
            @InvocableVariable
            public Id RecordId;
            
        }
}