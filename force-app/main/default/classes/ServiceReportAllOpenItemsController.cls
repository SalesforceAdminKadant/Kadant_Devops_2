public class ServiceReportAllOpenItemsController {
    public String macId { get; set; } 
    public String errorMessage { get; set; }
    public String accountSite { get; set; }
    public List<ServiceReportPrint> srps { get; set; }
    public Boolean showActionItems { get; set; }
    public String htmlCode { get; set; }

    public ServiceReportAllOpenItemsController(ApexPages.StandardController controller) {
        errorMessage = '';
                
        macId = ApexPages.CurrentPage().getparameters().get('id');
        Service_Report__c sReport = [SELECT Id, Account_Site__c, Machine__c FROM Service_Report__c WHERE Machine__c = :macId LIMIT 1];
        accountSite = sReport.Account_Site__c;
        
        // In this report using the Machine ID returned above get all Open items to produce the report.
        Service_Topic_Item__c[] stItems = [SELECT Id, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Service_Report__r.Machine__c = :macId AND Status__c = 'Open' ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC];

        if (!stItems.isEmpty())
        {
            srps = new List<ServiceReportPrint>();
            String filter = '';            
            for (Service_Topic_Item__c st : stItems)
            {
                // Using the Line ID go and get the Image created when the Line upload!!                
                ServiceReportPrint srp = new ServiceReportPrint();
                String[] fileIds = null;
                filter = st.Id;                

                srp.sriId = st.Id;
                srp.sriPosition = st.Position__c;
                srp.sectionName = st.Machine_Section__c;
                srp.visitDate = st.Service_Report_Item__r.Service_Report__r.Visit_Date__c;
                srp.visitPerson = st.Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName + ' ' + st.Service_Report_Item__r.Service_Report__r.CreatedBy.LastName;
                srp.sriSummary = getSummaryLines(st.Summary__c);
                // Make sure Image Size is 100% if no value has been stored in the table.  Image_Size__c is a new field!!
                srp.imageSize = (String.isBlank(st.Image_Size__c)) ? '100' : st.Image_Size__c;

                // Implement SharinPix by pulling the URL to the image
                List<Image> sriImageList = new List<Image>();
                sharinpix__SharinPixImage__c[] imgs = [SELECT Name, Fit_to_Size__c, sharinpix__Title__c, sharinpix__Description__c FROM sharinpix__SharinPixImage__c WHERE Service_Topic_Item__c = :filter AND Service_Topic_Item__c != NULL ORDER BY sharinpix__SortPosition__c];
                if (!imgs.isEmpty())
                {
                    for (sharinpix__SharinPixImage__c spi : imgs)
                    {                        
                        Image img = new Image();
                        img.imageUrl = spi.Fit_to_Size__c;
                        img.captionDescription = spi.sharinpix__Description__c;
                        sriImageList.add(img);
                    }
                }
                srp.sriImages = sriImageList;
                srps.add(srp);
            }            
        }
        else
        {
            errorMessage = 'There are no files attached to this line item!';
        }

        showActionItems = false;

        Service_Topic_Item__c[] openActions = [SELECT Position__c, Priority__c, Customer_Action_Summary__c, Topic__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c FROM Service_Topic_Item__c WHERE Status__c = 'Open' AND Service_Report_Item__r.Service_Report__r.Machine__c = :macId ORDER BY Priority__c ];
        if (!openActions.isEmpty())
        {  
            showActionItems = true;   
            htmlCode = '<p class="objText">Summary of open action items including this and previous reports.</p>';    
            htmlCode = htmlCode + '<table width="100%" style="border-collapse: collapse;">'; 
            htmlCode = htmlCode + '<tr><td class="openActionHeader">Priority</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Date</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Position</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Topic</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Comment</td></tr>';  
            
            for (Service_Topic_Item__c oa : openActions)
            { 
                //Date theDate = date.newinstance(oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.year(), oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.month(), oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.day());
                //Datetime newDate = (Datetime)oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c;
                String theDate = oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.format();
                if (oa.Priority__c == 'Critical')
                {
                    htmlCode = htmlCode + '<tr><td align="CENTER" class="openActionTableText"><span style="color: RED;">' + oa.Priority__c + '</span></td>';
                }
                else if (oa.Priority__c == 'Moderate')
                {
                    htmlCode = htmlCode + '<tr><td align="CENTER" class="openActionTableText"><span style="color: ORANGE;">' + oa.Priority__c + '</span></td>';
                }
                else
                {
                    htmlCode = htmlCode + '<tr><td align="CENTER" class="openActionTableText">' + oa.Priority__c + '</td>';
                }                
                htmlCode = htmlCode + '<td class="openActionTableText">' + theDate + '</td>';
                htmlCode = htmlCode + '<td class="openActionTableText">' + oa.Position__c + '</td>';
                htmlCode = htmlCode + '<td class="openActionTableText">' + oa.Topic__c + '</td>';
                htmlCode = htmlCode + '<td class="openActionTableText">' + oa.Customer_Action_Summary__c + '</td></tr>';
            }            
            htmlCode = htmlCode + '</table>';
        }
    }

    public class ServiceReportPrint
    {
        public String sriId {get; set;}
        public String sriPosition { get; set; }
        public String sectionName { get; set; }
        public Date visitDate { get; set; }
        public String visitPerson { get; set; }
        public List<String> sriSummary {get; set;}
        public List<Image> sriImages { get; set; }
        public String imageSize { get; set; }
    }

    public List<String> getSummaryLines(String summary) 
    {
        if (summary == null) {
            return new List<String>();
        }
        return summary.split('\n');
    }

    public class Image
    {
        public String imageUrl { get; set;}
        public String captionDescription { get; set; }
    }
}