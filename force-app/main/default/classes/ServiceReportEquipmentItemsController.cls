global with sharing class ServiceReportEquipmentItemsController 
{
    public String equipId { get; set; } 
    public String errorMessage { get; set; }
    public String accountSite { get; set; }
    public List<ServiceReportPrint> srps { get; set; }
    public Boolean showActionItems { get; set; }
    public String htmlCode { get; set; }
    public String section { get; set; }
    public String position { get; set; }

    public ServiceReportEquipmentItemsController() {
        errorMessage = '';
                
        equipId = ApexPages.CurrentPage().getparameters().get('id');
        // Get the first 3 charaters to determine Equipment is called for: Cleaning, Doctor, Belt, Roll, Filter or Drainage
        String equip = equipId.Left(3);
        Service_Topic_Item__c[] stItems;
        
        if (equip == 'a5K') {
            // Doctor
            stItems = [SELECT Id, Priority__c, Customer_Action_Summary__c, Topic__c, Status__c, Service_Report_Item__r.Service_Report__r.Account_Site__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Doctor__c = :equipId ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC LIMIT 30];
        }           
        else if (equip == 'a5H') {
            // Cleaning
            stItems = [SELECT Id, Priority__c, Customer_Action_Summary__c, Topic__c, Status__c, Service_Report_Item__r.Service_Report__r.Account_Site__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Cleaning__c = :equipId ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC LIMIT 30];
        }
        else if (equip == 'a5I') {
            // Filter
            stItems = [SELECT Id, Priority__c, Customer_Action_Summary__c, Topic__c, Status__c, Service_Report_Item__r.Service_Report__r.Account_Site__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Filter__c = :equipId ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC];
        }
        else if (equip == 'a5M') {
            // Roll
            stItems = [SELECT Id, Priority__c, Customer_Action_Summary__c, Topic__c, Status__c, Service_Report_Item__r.Service_Report__r.Account_Site__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Roll__c = :equipId ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC];
        }
        else if (equip == 'a5J') {
            // Drainage
            stItems = [SELECT Id, Priority__c, Customer_Action_Summary__c, Topic__c, Status__c, Service_Report_Item__r.Service_Report__r.Account_Site__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Drainage__c = :equipId ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC];
        }
        else if (equip == 'a5F') {
            // Belt
            stItems = [SELECT Id, Priority__c, Customer_Action_Summary__c, Topic__c, Status__c, Service_Report_Item__r.Service_Report__r.Account_Site__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c, Service_Report_Item__r.Service_Report__r.CreatedBy.FirstName, Service_Report_Item__r.Service_Report__r.CreatedBy.LastName, Position__c, Machine_Section__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Belt__c = :equipId ORDER BY Service_Report_Item__r.Service_Report__r.CreatedDate DESC];
        }        

        if (!stItems.isEmpty())
        {
            srps = new List<ServiceReportPrint>();
            String filter = '';            
            for (Service_Topic_Item__c st : stItems)
            {
                // Using the Line ID go and get the Image created when the Line upload!!                
                ServiceReportPrint srp = new ServiceReportPrint();
                String[] fileIds = null;
                accountSite = st.Service_Report_Item__r.Service_Report__r.Account_Site__c;
                filter = st.Id;                

                srp.sriId = st.Id;
                srp.sriPosition = st.Position__c;
                position = st.Position__c;
                srp.status = st.Status__c;
                srp.sectionName = st.Machine_Section__c;
                section = st.Machine_Section__c;
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

        if (!stItems.isEmpty())
        {  
            showActionItems = true;   
            htmlCode = '<p class="objText">Summary of last 30 Action Items.</p>';    
            htmlCode = htmlCode + '<table width="100%" style="border-collapse: collapse;">'; 
            htmlCode = htmlCode + '<tr><td class="openActionHeader">Priority</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Date</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Status</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Topic</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Comment</td></tr>';  
            
            for (Service_Topic_Item__c oa : stItems)
            {
                String tempStr = '<tr><td align="CENTER" class="openActionTableText">&nbsp;</td>';
                String theDate = oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.format();
                if (oa.Priority__c == 'Critical') {
                    tempStr = '<tr><td align="CENTER" class="openActionTableText"><span style="color: RED;">' + oa.Priority__c + '</span></td>';
                }
                else if (oa.Priority__c != null) {                    
                    tempStr = '<tr><td align="CENTER" class="openActionTableText">' + oa.Priority__c + '</td>';                    
                }    
                htmlCode = htmlCode + tempStr;    
                htmlCode = htmlCode + '<td class="openActionTableText">' + theDate + '</td>';
                tempStr = '<td align="CENTER" class="openActionTableText">&nbsp;</td>';
                if (oa.Status__c != null) {
                    tempStr = '<td class="openActionTableText">' + oa.Status__c + '</td>';                    
                }
                htmlCode = htmlCode + tempStr; 
                tempStr = '<td align="CENTER" class="openActionTableText">&nbsp;</td>';
                if (oa.Topic__c != null) {
                    tempStr = '<td class="openActionTableText">' + oa.Topic__c + '</td>';                    
                }
                htmlCode = htmlCode + tempStr;
                tempStr = '<td align="CENTER" class="openActionTableText">&nbsp;</td></tr>';
                if (oa.Customer_Action_Summary__c != null) {
                    tempStr = '<td class="openActionTableText">' + oa.Customer_Action_Summary__c + '</td></tr>';   
                }      
                htmlCode = htmlCode + tempStr;    
            }            
            htmlCode = htmlCode + '</table>';
        }
    }

    public class ServiceReportPrint
    {
        public String sriId {get; set;}
        public String status { get; set; }
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