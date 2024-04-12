public class ServiceReportItemPositionsController {
    public String sriId { get; set; } 
    public String errorMessage { get; set; }
    public List<PositionItem> pis {get; set; }

    public ServiceReportItemPositionsController(ApexPages.StandardController controller) {        
        errorMessage = '';
                
        sriId = ApexPages.CurrentPage().getparameters().get('id');        

        // Get Machine Section and Poisiton using the current open Service Report Item
        Service_Report_Item__c[] srItem = [SELECT Id, Machine_Name__c, Machine_Section__c FROM Service_Report_Item__c WHERE Id = :sriId];
        if (!srItem.isEmpty())
        {
            String machineSection = srItem[0].Machine_Section__c;
            String position = srItem[0].Machine_Name__c;
            // Now use the Position and Machine Section to get all previous items
            Service_Report_Item__c[] srItems = [SELECT Id, Name, Service_Report__r.Visit_Date__c, CreatedDate, createdBy.Name FROM Service_Report_Item__c WHERE Machine_Name__c = :position AND Machine_Section__c = :machineSection ORDER BY CreatedDate ASC];
            
            pis = new List<PositionItem>();
            for (Service_Report_Item__c sr : srItems)
            {
                PositionItem pi = new PositionItem();
                pi.id = sr.Id;
                pi.name = sr.Name;
                pi.visitDate = sr.Service_Report__r.Visit_Date__c;
                pi.reportDate = sr.CreatedDate.format('MMM-dd-YYYY');
                pi.creator = sr.createdBy.Name;
                pis.add(pi);
            }            
        }
        else
        {
            errorMessage = 'ERROR: cannot get the records at this time!';
        }
    }

    public class PositionItem
    {
        public String id { get; set; }
        public String name { get; set; }
        public Date visitDate { get; set;}
        public String reportDate { get; set;}        
        public String creator { get; set; }
    }
}