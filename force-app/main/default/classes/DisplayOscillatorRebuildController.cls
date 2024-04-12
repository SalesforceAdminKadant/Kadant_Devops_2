public class DisplayOscillatorRebuildController {
    public String srId { get; set; } 
    public String errorMessage { get; set; }
    public String accountSite { get; set; }
    public Date repairDate { get; set; }
    public String userName { get; set; }
    public String userEmail { get; set; }
    public String userMobile { get; set; }
    public String soRmaNumber { get; set; }
    public List<String> visitSummary { get; set; }
    public Boolean hasVisitSum { get; set; }
    public List<OscReportPrint> orps { get; set; }

    public DisplayOscillatorRebuildController(ApexPages.StandardController controller) {
        errorMessage = '';
                
        srId = ApexPages.CurrentPage().getparameters().get('id');
        Oscillator_Rebuild__c oReport = [SELECT Id, Name, Account_Name_Site__c, Order__r.Name, CreatedById, Visit_Summary__c, Repair_Date__c FROM Oscillator_Rebuild__c WHERE Id = :srId];
        accountSite = oReport.Account_Name_Site__c;
        soRmaNumber =  oReport.Order__r.Name;
        repairDate = oReport.Repair_Date__c;
        hasVisitSum = false;
        if (!String.isEmpty(oReport.Visit_Summary__c))
        {
            visitSummary = getSummaryLines(oReport.Visit_Summary__c);
            hasVisitSum = true;
        }        

        // Get the user name, email address, and mobile phone for cover page
        User usr = [SELECT Id, Name, Username, MobilePhone FROM USER WHERE Id = :oReport.CreatedById];
        userName = usr.name;
        userEmail = usr.Username;
        userMobile = usr.MobilePhone;
        
        Oscillator_Rebuild_Line_Item__c[] orItems = [SELECT Id, Product_Type2__c, Serial_No__c, Oscillator_Model_Serial_Number__r.Name, Ball_Screw_Serial_Number__c, Repair_Type__c, Comments__c, Repair_Components__c, Image_Size__c FROM Oscillator_Rebuild_Line_Item__c WHERE Oscillator_Rebuild__c = :srId ORDER BY Name ASC];

        if (!orItems.isEmpty())
        {
            orps = new List<OscReportPrint>();
            String filter = '';
            for (Oscillator_Rebuild_Line_Item__c ori : orItems)
            {
                // Using the Line ID go and get the Image created when the Line upload!!                
                OscReportPrint orp = new OscReportPrint();
                filter = ori.Id;

                orp.sriId = ori.Id;
                orp.productType = ori.Product_Type2__c;
                orp.oscillatorSerialNumber = ori.Oscillator_Model_Serial_Number__r.Name;
                // I don't know but this is the Model Number below!!
                orp.motorSerialNumber = ori.Serial_No__c;
                orp.ballSerialNumber = ori.Ball_Screw_Serial_Number__c;
                orp.repairType = ori.Repair_Type__c;
                orp.comments = getSummaryLines(ori.Comments__c);
                orp.repairComponents = getSummaryLines(ori.Repair_Components__c);
                // Make sure Image Size is 100% if no value has been stored in the table.  Image_Size__c is a new field!!
                orp.imageSize = (String.isBlank(ori.Image_Size__c)) ? '100' : ori.Image_Size__c;

                // Implement SharinPix by pulling the URL to the image
                List<Image> sriImageList = new List<Image>();
                sharinpix__SharinPixImage__c[] imgs = [SELECT Name, Fit_to_Size__c, sharinpix__Title__c, sharinpix__Description__c FROM sharinpix__SharinPixImage__c WHERE Oscillator_Rebuild_Line_Item__c = :filter AND Oscillator_Rebuild_Line_Item__c != NULL ORDER BY sharinpix__SortPosition__c];
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
                orp.sriImages = sriImageList;
                orps.add(orp);
            }
        }
    }

    public List<String> getSummaryLines(String summary) 
    {
        if (summary == null) {
            return new List<String>();
        }
        return summary.split('\n');
    }

    public class OscReportPrint
    {
        public String sriId {get; set;}
        public String productType { get; set; }
        public String oscillatorSerialNumber { get; set; }
        public String ballSerialNumber { get; set; }
        public String motorSerialNumber { get; set; }
        public String repairType { get; set; }
        public List<String> comments {get; set;}
        public List<String> repairComponents {get; set;}
        public List<Image> sriImages { get; set; }
        public String imageSize { get; set; }
    }

    public class Image
    {
        public String imageUrl { get; set; }
        public String captionDescription { get; set; }
    }
}