public without sharing class displayServiceReportController {
    public String srId { get; set; } 
    public String errorMessage { get; set; }
    public String accountSite { get; set; }
    public List<String> reportComments { get; set; }
    public List<String> reportSummary { get; set; }
    public String machineNumber { get; set; }   
    public Date visitDate { get; set; }
    public String objective { get; set; }
    public String userName { get; set; }
    public String userEmail { get; set; }
    public String userMobile { get; set; }
    public List<ServiceReportPrint> srps { get; set; }
    public Boolean showActionItems { get; set; }
    public Boolean srComments { get; set; }
    public Boolean srSummary { get; set; }
    public String contributors { get; set; }
    public Boolean showContributors { get; set; }
    public Boolean hideContributors { get; set; }
    public Boolean showOscillatorItems { get; set; }
    public String visitObjective { get; set; }
    public String commentsTitle { get; set; }
    public String contactNames { get; set; }
    public String htmlCode { get; set; }
    public String caHtmlCode { get; set; }
    public String tbSummaryTable { get; set; }
    public String tbMachineTable { get; set; }
    public List<OscReportPrint> orps { get; set; }
    public List<String> visitSummary { get; set; }
    public Boolean hasVisitSum { get; set; }

    public displayServiceReportController(ApexPages.StandardController controller) {
        errorMessage = '';

        srId = ApexPages.CurrentPage().getparameters().get('id');
        Service_Report__c sReport = [SELECT Id, Name, Account__c, Account_Site__c, Conclusion__c, Objective__c, CreatedById, Machine__r.Name, Machine__c, Summary__c, Visit_Date__c, Report_Contributor__c FROM Service_Report__c WHERE Id = :srId];
        Oscillator_Rebuild__c[] oReport = [SELECT Id, Name, Account_Name_Site__c, Order__r.Name, CreatedById, Visit_Summary__c, Repair_Date__c FROM Oscillator_Rebuild__c WHERE Service_Report__c = :srId];
        Oscillator_Rebuild_Line_Item__c[] orItems = [SELECT Id, Product_Type2__c, Serial_No__c, Oscillator_Model_Serial_Number__r.Name, Ball_Screw_Serial_Number__c, Repair_Type__c, Comments__c, Repair_Components__c, Image_Size__c FROM Oscillator_Rebuild_Line_Item__c WHERE Oscillator_Rebuild__r.Service_Report__c = :srId ORDER BY Name ASC];
        accountSite = sReport.Account_Site__c;
        srComments = false;
        srSummary = false;
        hasVisitSum = false;
        showContributors = false;
        hideContributors = true;
        showOscillatorItems = false;
        visitObjective = 'Current Visit Objective';
        commentsTitle = 'Conclusion';

        if (!String.isEmpty(sReport.Conclusion__c))
        {
            srComments = true;
            reportComments = getSummaryLines(sReport.Conclusion__c);
        }

        if (!String.isEmpty(sReport.Summary__c))
        {
            srSummary = true;
            reportSummary = getSummaryLines(sReport.Summary__c);
        } 
        
        if (!String.isEmpty(sReport.Report_Contributor__c))
        {
            hideContributors = false;
            showContributors = true;
            contributors = sReport.Report_Contributor__c;
        } 

        //system.debug('Just before the NULL check!');   
        if (!oReport.isEmpty())
        {
            if (!String.isEmpty(oReport[0].Visit_Summary__c))
            {
                visitSummary = getSummaryLines(oReport[0].Visit_Summary__c);
                hasVisitSum = true;
            }            
        } 
        
        machineNumber = sReport.Machine__r.Name;  
        visitDate = sReport.Visit_Date__c;
        objective = sReport.Objective__c;        
        contactNames = '';
        String macId = sReport.Machine__c;        
        String tmpDate = String.valueOf(visitDate);
        
        Service_Reports_Additional_Contact__c[] addContacts = [select First_Name__c, Last_Name__c from Service_Reports_Additional_Contact__c where Service_Report__c = :srId];
        for (Service_Reports_Additional_Contact__c acon : addContacts)
        {
            String fullName = acon.First_Name__c + ' ' + acon.Last_Name__c + ', ';
            contactNames = contactNames + fullName;
        }

        if (!String.isEmpty(contactNames))
        {
            contactNames = contactNames.substring(0,contactNames.length()-2);
        }
        else 
        {
            contactNames = 'No Contact Added!';
        }
        // Get the user name, email address, and mobile phone for cover page
        User usr = [SELECT Id, Name, Username, MobilePhone FROM USER WHERE Id = :sReport.CreatedById];
        userName = usr.name;
        userEmail = usr.Username;
        userMobile = usr.MobilePhone;
        
        Service_Report_Item__c[] srItems = [SELECT Id, RecordType.Name, Machine_Name__c, Machine_Section__r.Name, Blade_Stickout__c, Target_Blade_Angle__c, Blade_Angle_TS__c, Blade_Angle_DS__c, 
            Blade_Level__c, Design_Blade_Contact_from_BDC__c, Blade_Contact_from_BDC__c, Construction__c, Metalized__c, Yankee_Operating_Pressure__c, Yankee_Setup_Pressure__c, Loading_Pressure__c, 
            Loading_PLI__c, Doctor_Set_up_Stop_Block_Pressure__c, Conformatic_Tube__c, Last_Backing_Blade_Change__c, Last_Conformatic_Tube_Change__c, Beam_Total_Hours__c, Blade_Angle_Center__c, 
            Cleaning_Frequency_in_Minutes__c, Cleaning_Width_in_Inches__c, High_Pressure_Water_PSI__c, Vacuum_Blower_Total_Hours__c, High_Pressure_Unit_Total_Hours__c, Vacuum_Pressure_in_Hg__c,
            Crepe_Count_Increase__c, Blade_Life_Increase__c, Reduction_in_Basis_Weight_Variability__c, Increase_in_Softness__c, CD_Tensile_Variability_Reduction__c, MD_Tensile_Variability_Reduction__c,
            Yankee_Speed__c, Doctor_Loading__c, Doctor_Loading_Units__c, Grade_Name__c, Grade_Name_Description__c, Basis_Weight__c, Oscillator_On__c, Blade_Type__c,
            Bevel__c, Machine_Configuration__c, Coating_Supplier__c, Product_Trade_Names__c, Feed_Rates__c, Vibration_Monitoring_Equipment_Present__c,
            Vibration_Monitoring_Supplier__c, Blade_Postion__c, Dryer_Metallized__c, Hide_Yankee_Data_Table__c
            FROM Service_Report_Item__c WHERE Service_Report__c = :srId ORDER BY Line_Order_Number__c, Name ASC];        

        if (!srItems.isEmpty())
        {
            srps = new List<ServiceReportPrint>();
            String filter = '';
            for (Service_Report_Item__c sri : srItems)
            {                
                // Using the Line ID go and get the Image created when the Line upload!!                
                ServiceReportPrint srp = new ServiceReportPrint();
                String[] fileIds = null;
                filter = sri.Id; 
                srp.showYankeeGrid = false;
                srp.showMcleanGrid = false;
                srp.hideMcleanGrid = true;      
                srp.showTrialBladeSummary = false;
                srp.showTrialBladeConditions = false;
                Boolean hideTable = sri.Hide_Yankee_Data_Table__c;
                system.debug ('hideTable: ' + hideTable);
                
                if (sri.RecordType.Name == 'Yankee')
                {
                    srp.showYankeeGrid = true;
                    srp.showTrialBladeSummary = false;
                    srp.showTrialBladeConditions = false;
                    srp.bladeStickout = sri.Blade_Stickout__c;
                    srp.bladeLevel = sri.Blade_Level__c;
                    srp.targetBlade = sri.Target_Blade_Angle__c;
                    srp.bladeAngleTs = sri.Blade_Angle_TS__c;
                    srp.bladeAngleCenter = sri.Blade_Angle_Center__c;
                    srp.bladeAngleDs = sri.Blade_Angle_DS__c;
                    srp.designBlade = String.valueOf(sri.Design_Blade_Contact_from_BDC__c);
                    srp.bladeContact = String.valueOf(sri.Blade_Contact_from_BDC__c);
                    srp.construction = sri.Construction__c;
                    srp.blade_change = sri.Last_Backing_Blade_Change__c;
                    srp.conformatic_change = sri.Last_Conformatic_Tube_Change__c;
                    Boolean tmpBool = sri.Metalized__c;
                    String metal = 'No';
                    if (tmpBool)
                    {
                        metal = 'Yes';
                    }
                    srp.metalized = metal;
                    srp.operatingPressure = sri.Yankee_Operating_Pressure__c;
                    srp.profilePressure = sri.Yankee_Setup_Pressure__c;
                    srp.stopBlockPressure = sri.Doctor_Set_up_Stop_Block_Pressure__c;
                    srp.loadingPressure = sri.Loading_Pressure__c;
                    srp.loadingPli = sri.Loading_PLI__c;
                }

                if (sri.RecordType.Name == 'Mclean')
                {
                    srp.showMcleanGrid = true;
                    srp.hideMcleanGrid = false;
                    srp.showTrialBladeSummary = false;
                    srp.showTrialBladeConditions = false;
                    srp.beam_total = String.valueOf(sri.Beam_Total_Hours__c);
                    srp.cleaning_freq = String.valueOf(sri.Cleaning_Frequency_in_Minutes__c);
                    srp.cleaning_width = String.valueOf(sri.Cleaning_Width_in_Inches__c);
                    srp.high_pressure = String.valueOf(sri.High_Pressure_Water_PSI__c);
                    srp.hpu = String.valueOf(sri.High_Pressure_Unit_Total_Hours__c);
                    srp.vac_blower = String.valueOf(sri.Vacuum_Blower_Total_Hours__c);
                    srp.vac_pressure = String.valueOf(sri.Vacuum_Pressure_in_Hg__c);
                }
                
                if (sri.RecordType.Name == 'TrialBladeSummary' && !hideTable)
                {
                    visitObjective = 'Trial Objective';
                    commentsTitle = 'Trial Objective and Background Information';
                    srp.showTrialBladeSummary = true;                    
                    tbSummaryTable = '<p class="objText">Trial Summary</p>';    
                    tbSummaryTable = tbSummaryTable + '<table width="100%" style="border-collapse: collapse;">'; 
                    if (!String.isEmpty(String.valueOf(sri.Crepe_Count_Increase__c)))
                    {
                        tbSummaryTable = tbSummaryTable + '<tr><td class="yankeeTableText">Crepe Count Increase</td><td class="yankeeTableText">' + String.valueOf(sri.Crepe_Count_Increase__c) + '</td></tr>';                        
                    }
                    if (!String.isEmpty(String.valueOf(sri.Blade_Life_Increase__c)))
                    {
                        tbSummaryTable = tbSummaryTable + '<tr><td class="yankeeTableText">Blade Life Increase</td><td class="yankeeTableText">' + String.valueOf(sri.Blade_Life_Increase__c) + '</td></tr>';                        
                    }
                    if (!String.isEmpty(String.valueOf(sri.MD_Tensile_Variability_Reduction__c)))
                    {
                        tbSummaryTable = tbSummaryTable + '<tr><td class="yankeeTableText">Reduction in MD</td><td class="yankeeTableText">' + String.valueOf(sri.MD_Tensile_Variability_Reduction__c) + '</td></tr>';                        
                    }                   
                    if (!String.isEmpty(String.valueOf(sri.CD_Tensile_Variability_Reduction__c)))
                    {
                        tbSummaryTable = tbSummaryTable + '<tr><td class="yankeeTableText">CD Tensile Variability</td><td class="yankeeTableText">' + String.valueOf(sri.CD_Tensile_Variability_Reduction__c) + '</td></tr>';                        
                    }
                    if (!String.isEmpty(String.valueOf(sri.Reduction_in_Basis_Weight_Variability__c)))
                    {
                        tbSummaryTable = tbSummaryTable + '<tr><td class="yankeeTableText">Reduction in Basis Weight Variability</td><td class="yankeeTableText">' + String.valueOf(sri.Reduction_in_Basis_Weight_Variability__c) + '</td></tr>';                        
                    }
                    if (!String.isEmpty(sri.Increase_in_Softness__c))
                    {
                        tbSummaryTable = tbSummaryTable + '<tr><td class="yankeeTableText">Increase in Softness</td><td class="yankeeTableText">' + sri.Increase_in_Softness__c + '</td></tr>';                        
                    }
                    tbSummaryTable = tbSummaryTable + '<tr><td class="emptyRow" colspan="2"></td></tr>';
                    tbSummaryTable = tbSummaryTable + '</table>';
                }

                if (sri.RecordType.Name == 'TrialBladeMachines')
                {
                    srp.showTrialBladeConditions = true;
                    Boolean oscBool = sri.Oscillator_On__c;
                    String osc = 'No';
                    if (oscBool)
                    {
                        osc = 'Yes';
                    }
                    Boolean vmeBool = sri.Vibration_Monitoring_Equipment_Present__c;
                    String vme = 'No';
                    if (vmeBool)
                    {
                        vme = 'Yes';
                    }
                    Boolean dryerBool = sri.Dryer_Metallized__c;
                    String dryer = 'No';
                    if (dryerBool)
                    {
                        dryer = 'Yes';
                    }
                    tbMachineTable = '<p class="objText">Machine Conditions</p>';    
                    tbMachineTable = tbMachineTable + '<table width="100%" style="border-collapse: collapse;">'; 
                    if (!String.isEmpty(String.valueOf(sri.Yankee_Speed__c)))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Yankee Speed</td><td class="yankeeTableText">' + String.valueOf(sri.Yankee_Speed__c) + '</td></tr>';                        
                    }
                    if (!String.isEmpty(String.valueOf(sri.Doctor_Loading__c)))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Doctor Loading</td><td class="yankeeTableText">' + String.valueOf(sri.Doctor_Loading__c) + ' ' + sri.Doctor_Loading_Units__c + '</td></tr>';                        
                    }
                    if (!String.isEmpty(sri.Grade_Name__c))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Grade Name</td><td class="yankeeTableText">' + sri.Grade_Name__c + '</td></tr>';                        
                    }
                    if (!String.isEmpty(sri.Grade_Name_Description__c))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Grade Name Description</td><td class="yankeeTableText">' + sri.Grade_Name_Description__c + '</td></tr>';                        
                    }
                    if (!String.isEmpty(String.valueOf(sri.Basis_Weight__c)))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Basis Weight</td><td class="yankeeTableText">' + sri.Basis_Weight__c + '</td></tr>';                        
                    }
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Oscillator On</td><td class="yankeeTableText">' + osc + '</td></tr>'; 
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Blade Type</td><td class="yankeeTableText">' + sri.Blade_Type__c + '</td></tr>'; 
                    if (!String.isEmpty(String.valueOf(sri.Bevel__c)))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Bevel</td><td class="yankeeTableText">' + String.valueOf(sri.Bevel__c) + '</td></tr>'; 
                    }                    
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Machine Name/Number</td><td class="yankeeTableText">' + machineNumber + '</td></tr>'; 
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Machine Configuration</td><td class="yankeeTableText">' + sri.Machine_Configuration__c + '</td></tr>'; 
                    if (!String.isEmpty(sri.Coating_Supplier__c))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Coating Supplier</td><td class="yankeeTableText">' + sri.Coating_Supplier__c + '</td></tr>'; 
                    }
                    if (!String.isEmpty(sri.Product_Trade_Names__c))
                    {
                        String namesText = '';
                        List<String> prodNames = sri.Product_Trade_Names__c.split(',');
                        if (prodNames.size() > 0)
                        {
                            for (Integer i = 0; i < prodNames.size(); i++) {
                                namesText = namesText + prodNames[i] + '<br />';
                            }
                        }                        
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Product Trade Names</td><td class="yankeeTableText">' + namesText + '</td></tr>'; 
                    }
                    if (!String.isEmpty(sri.Feed_Rates__c))
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Feed Rates</td><td class="yankeeTableText">' + sri.Feed_Rates__c + '</td></tr>'; 
                    }
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Vibration Monitoring Equipment Present</td><td class="yankeeTableText">' + vme + '</td></tr>'; 
                    if (vmeBool)
                    {
                        tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Vibration Monitoring Supplier</td><td class="yankeeTableText">' + sri.Vibration_Monitoring_Supplier__c + '</td></tr>'; 
                    }
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Blade Position</td><td class="yankeeTableText">' + sri.Blade_Postion__c + '</td></tr>'; 
                    tbMachineTable = tbMachineTable + '<tr><td class="yankeeTableText">Dryer Metallized</td><td class="yankeeTableText">' + dryer + '</td></tr>'; 
                    tbMachineTable = tbMachineTable + '<tr><td class="emptyRow" colspan="2"></td></tr>';
                    tbMachineTable = tbMachineTable + '</table>';
                } 

                srp.sriPosition = sri.Machine_Name__c;
                srp.sectionName = sri.Machine_Section__r.Name;
                // New functionality: Go get the Service Topic Lines               
                
                if (sri.RecordType.Name == 'Mclean')
                {
                    List<Service_Topic_Item__c> mcleanTopics = [SELECT Topic__c FROM Service_Topic_Item__c WHERE Service_Report_Item__c = :filter ORDER BY Topic__c ASC];
                    // Need a Distinct list of M-clean Topics!!!
                    Set<String> distinctTopics = new Set<String>();
                    for (Service_Topic_Item__c mtop : mcleanTopics)
                    {
                        distinctTopics.add(mtop.Topic__c);
                    }

                    if (!distinctTopics.isEmpty())
                    {
                        List<ServiceTopicItemMclean> mcleanTopicItems = new List<ServiceTopicItemMclean>();                        
                        for (String dt : distinctTopics)
                        {
                            List<McleanItem> mcleanItemList = new List<McleanItem>();
                            if (!String.isEmpty(dt))
                            {
                                ServiceTopicItemMclean msti = new ServiceTopicItemMclean();
                                string mimgFilter = '';
                                msti.stiTopic = dt;                                 
                                List<Service_Topic_Item__c> stiItems = [SELECT Id, Component__c, Inspection_Status__c, Summary__c, Image_Size__c FROM Service_Topic_Item__c WHERE Service_Report_Item__c = :filter AND Topic__c = :dt ORDER BY Topic_Order_Number__c ASC];
                                if (!stiItems.isEmpty())
                                {
                                    for (Service_Topic_Item__c st : stiItems)
                                    {
                                        McleanItem mtopic = new McleanItem(); 
                                        mtopic.showVisitDate = false;
                                        mtopic.showReplacedDate = false;
                                        mimgFilter = st.Id;                                        
                                        mtopic.stiComponent = st.Component__c;
                                        mtopic.stiInspection = st.Inspection_Status__c;
                                        if (!String.isEmpty(st.Summary__c))
                                        {
                                            mtopic.stiSummary = getSummaryLines(st.Summary__c);
                                            mtopic.showMcleanNotes = true;
                                        }
                                        else
                                        {
                                            mtopic.showMcleanNotes = false;
                                        }
                                        if ((dt == 'Beam') && (st.Component__c == 'Head to Fabric Profile'))
                                        {
                                            List<Service_Topic_Item__c> stiLastCompleteds = [SELECT Service_Report_Item__r.Service_Report__r.Visit_Date__c FROM Service_Topic_Item__c WHERE Service_Report_Item__c = :filter AND Topic__c = 'Beam' AND Component__c = 'Head to Fabric Profile' AND Inspection_Status__c = 'Completed' ORDER BY Service_Report_Item__r.Service_Report__r.Visit_Date__c DESC LIMIT 1];
                                            if (!stiLastCompleteds.isEmpty())
                                            {
                                                for (Service_Topic_Item__c slc : stiLastCompleteds)
                                                {
                                                    mtopic.lastDate = slc.Service_Report_Item__r.Service_Report__r.Visit_Date__c;
                                                }
                                            }
                                            mtopic.showVisitDate = true;
                                        }
                                        if ((dt == 'Wear Components') && (st.Inspection_Status__c == 'Replaced'))
                                        {
                                            String component = st.Component__c;
                                            List<Service_Topic_Item__c> stiLastReplaceds = [SELECT Service_Report_Item__r.Service_Report__r.Visit_Date__c FROM Service_Topic_Item__c WHERE Service_Report_Item__c = :filter AND Topic__c = 'Wear Components' AND Component__c = :component AND Inspection_Status__c = 'Replaced' ORDER BY Service_Report_Item__r.Service_Report__r.Visit_Date__c DESC LIMIT 1];
                                            if (!stiLastReplaceds.isEmpty())
                                            {
                                                for (Service_Topic_Item__c slr : stiLastReplaceds)
                                                {
                                                    mtopic.lastDate = slr.Service_Report_Item__r.Service_Report__r.Visit_Date__c;
                                                }
                                            }
                                            mtopic.showReplacedDate = true;
                                        }
                                        mtopic.imageSize = (String.isBlank(st.Image_Size__c)) ? '100' : st.Image_Size__c; 
                
                                        // Implement SharinPix by pulling the URL to the image
                                        List<Image> msriImageList = new List<Image>();
                                        sharinpix__SharinPixImage__c[] mimgs = [SELECT Name, Fit_to_Size__c, sharinpix__Title__c, sharinpix__Description__c FROM sharinpix__SharinPixImage__c WHERE Service_Topic_Item__c = :mimgFilter AND Service_Topic_Item__c != NULL ORDER BY sharinpix__SortPosition__c];
                                        if (!mimgs.isEmpty())
                                        {
                                            for (sharinpix__SharinPixImage__c spi : mimgs)
                                            {                        
                                                Image mimg = new Image();
                                                mimg.imageUrl = spi.Fit_to_Size__c;
                                                mimg.captionDescription = spi.sharinpix__Description__c;
                                                msriImageList.add(mimg);
                                            }
                                        }
                                        mtopic.stiImages = msriImageList;
                                        mcleanItemList.add(mtopic);
                                    }
                                    msti.mcleanItem = mcleanItemList;
                                }
                                mcleanTopicItems.add(msti);
                                srp.stiItemsMcleans = mcleanTopicItems;                                
                            }                            
                        }
                        srps.add(srp);
                    }
                }
                else
                {
                    Service_Topic_Item__c[] sriTopics = null;
                    sriTopics = [SELECT Id, Topic__c, Image_Size__c, Customer_Action_Summary__c, Summary__c FROM Service_Topic_Item__c WHERE Service_Report_Item__c = :filter ORDER BY Topic_Order_Number__c, Name ASC];
                    List<ServiceTopicItem> sriTopicList = new List<ServiceTopicItem>();

                    if (!sriTopics.isEmpty())
                    {                    
                        string imgFilter = '';
                        for (Service_Topic_Item__c sti : sriTopics)
                        {
                            ServiceTopicItem topic = new ServiceTopicItem();                        
                            imgFilter = sti.Id;
                            topic.stiTopic = sti.Topic__c;
                            topic.stiSummary = getSummaryLines(sti.Summary__c);
                            topic.imageSize = (String.isBlank(sti.Image_Size__c)) ? '100' : sti.Image_Size__c; 
    
                            // Implement SharinPix by pulling the URL to the image
                            List<Image> sriImageList = new List<Image>();
                            sharinpix__SharinPixImage__c[] imgs = [SELECT Name, Fit_to_Size__c, sharinpix__Title__c, sharinpix__Description__c FROM sharinpix__SharinPixImage__c WHERE Service_Topic_Item__c = :imgFilter AND Service_Topic_Item__c != NULL ORDER BY sharinpix__SortPosition__c];
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
                            topic.stiImages = sriImageList;
                            sriTopicList.add(topic);
                        }
                        srp.stiItems = sriTopicList;
                        srps.add(srp);
                    }
                }
            }            
        }
        if (!orItems.isEmpty()) 
        {
            showOscillatorItems = true;
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
        else
        {
            errorMessage = 'There are no files attached to this line item!';
        }
        
        showActionItems = false;
        
        /*
        Service_Topic_Item__c[] completedActions = [SELECT Service_Report_Item__r.Machine_Name__c, Priority__c, Customer_Action_Summary__c, Topic__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c FROM Service_Topic_Item__c WHERE Status__c = 'Complete' AND Service_Report_Item__r.Service_Report__r.Id = :srId AND Service_Report_Item__r.Machine_Name__c != null ORDER BY Priority__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c DESC LIMIT 50];
        if (!completedActions.isEmpty())
        {
            Integer caCount = 0;            
            showActionItems = true;   
            caHtmlCode = '<p class="objLabel">Summary action items completed on this visit.</p>';    
            caHtmlCode = caHtmlCode + '<table width="100%" style="border-collapse: collapse;">'; 
            caHtmlCode = caHtmlCode + '<tr><td class="openActionHeader">Priority</td>';
            caHtmlCode = caHtmlCode + '<td class="openActionHeader">Date</td>';
            caHtmlCode = caHtmlCode + '<td class="openActionHeader">Position</td>';
            caHtmlCode = caHtmlCode + '<td class="openActionHeader">Topic</td>';
            caHtmlCode = caHtmlCode + '<td class="openActionHeader">Comment</td></tr>';
            for (Service_Topic_Item__c ca : completedActions)
            {
                String theCaDate = ca.Service_Report_Item__r.Service_Report__r.Visit_Date__c.format();
                if ((ca.Priority__c == 'Critical') || (ca.Priority__c == 'Safety'))
                {
                    caHtmlCode = caHtmlCode + '<tr><td align="CENTER" class="openActionTableText" valign="top"><span style="color: RED;">' + ca.Priority__c + '</span></td>';
                }
                else if (ca.Priority__c == 'Moderate')
                { 
                    caHtmlCode = caHtmlCode + '<tr><td align="CENTER" class="openActionTableText" valign="top"><span style="color: ORANGE;">' + ca.Priority__c + '</span></td>';                  
                } 
                else 
                {
                    caHtmlCode = caHtmlCode + '<tr><td align="CENTER" class="openActionTableText" valign="top">' + ca.Priority__c + '</td>';
                }                
                caHtmlCode = caHtmlCode + '<td class="openActionTableText" valign="top">' + theCaDate + '</td>';
                caHtmlCode = caHtmlCode + '<td class="openActionTableText" valign="top">' + ca.Service_Report_Item__r.Machine_Name__c + '</td>';
                caHtmlCode = caHtmlCode + '<td class="openActionTableText" valign="top">' + ca.Topic__c + '</td>';
                if (ca.Customer_Action_Summary__c == null)
                {
                    caHtmlCode = caHtmlCode + '<td class="openActionTableText" valign="top">&nbsp;</td></tr>';                
                }
                else 
                {
                    caHtmlCode = caHtmlCode + '<td class="openActionTableText" valign="top">' + ca.Customer_Action_Summary__c + '</td></tr>';                    
                }                
                caCount++;            
            }
            caHtmlCode = caHtmlCode + '</table></ br>'; 
            if (caCount == 0)
            {
                caHtmlCode = '';
            }
        }
        */
        
        Service_Topic_Item__c[] openActions = [SELECT Service_Report_Item__r.Machine_Name__c, Priority__c, Customer_Action_Summary__c, Topic__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c FROM Service_Topic_Item__c WHERE Status__c = 'Open' AND Service_Report_Item__r.Service_Report__r.Machine__c = :macId AND Service_Report_Item__r.Machine_Name__c != null ORDER BY Priority__c, Service_Report_Item__r.Service_Report__r.Visit_Date__c DESC LIMIT 99];
        if (!openActions.isEmpty())
        {  
            showActionItems = true;   
            htmlCode = '<p class="objLabel">Summary of open action items including this and previous reports.</p>';    
            htmlCode = htmlCode + '<table width="100%" style="border-collapse: collapse;">'; 
            htmlCode = htmlCode + '<tr><td class="openActionHeader">Priority</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Date</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Position</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Topic</td>';
            htmlCode = htmlCode + '<td class="openActionHeader">Comment</td></tr>';  
            
            Integer moderate = 0;
            Integer low = 0;
            Integer moderateMax = 10;
            Integer lowMax = 10;
            Integer lowTotal = 0;
            Integer modTotal = 0;
            Integer topicCount = 0;

            for (Service_Topic_Item__c oa : openActions)
            {                 
                //Date theDate = date.newinstance(oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.year(), oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.month(), oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.day());
                //Datetime newDate = (Datetime)oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c;
                String theDate = oa.Service_Report_Item__r.Service_Report__r.Visit_Date__c.format();
                if ((oa.Priority__c == 'Critical') || (oa.Priority__c == 'Safety'))
                {
                    htmlCode = htmlCode + '<tr><td align="CENTER" class="openActionTableText" valign="top"><span style="color: RED;">' + oa.Priority__c + '</span></td>';
                }
                else if (oa.Priority__c == 'Moderate')
                {                    
                    if (moderate < moderateMax)
                    {
                        htmlCode = htmlCode + '<tr><td align="CENTER" class="openActionTableText" valign="top"><span style="color: ORANGE;">' + oa.Priority__c + '</span></td>';
                    }
                } 
                else 
                {                    
                    if (low < lowMax)
                    {
                        htmlCode = htmlCode + '<tr><td align="CENTER" class="openActionTableText" valign="top">' + oa.Priority__c + '</td>';
                    }
                }
                if ((oa.Priority__c == 'Critical') || (oa.Priority__c == 'Safety'))
                {
                    htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + theDate + '</td>';
                    htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Service_Report_Item__r.Machine_Name__c + '</td>';
                    htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Topic__c + '</td>';
                    htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Customer_Action_Summary__c + '</td></tr>';                
                }
                if (oa.Priority__c == 'Moderate')
                {
                    if (moderate < moderateMax)
                    {
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + theDate + '</td>';
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Service_Report_Item__r.Machine_Name__c + '</td>';
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Topic__c + '</td>';
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Customer_Action_Summary__c + '</td></tr>';        
                        moderate++; 
                    }
                    modTotal++;                    
                }
                if (oa.Priority__c == 'Low')
                {
                    if (low < lowMax)
                    {
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + theDate + '</td>';
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Service_Report_Item__r.Machine_Name__c + '</td>';
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Topic__c + '</td>';
                        htmlCode = htmlCode + '<td class="openActionTableText" valign="top">' + oa.Customer_Action_Summary__c + '</td></tr>';      
                        low++;                    
                    }
                    lowTotal++;
                }                
                topicCount++;
            }            
            htmlCode = htmlCode + '</table>';            
            if ((modTotal > 10) || (lowTotal > 10))
            {
                htmlCode = htmlCode + '<p><small><i>Please Note: We have limited the number of action items shown on this report, however, all (' + topicCount + ') open action items can be viewed in the Kadant Access Portal (KAP) or provided by the DSM.</i></small></p>';                
            }            
            htmlCode = htmlCode + '<p><a href="https://dcf.kadant.com/en/kap-kadant-access-portal">Register for the Kadant Access Portal (KAP) today.</a></p>';
        }
    }

    public class ServiceReportPrint
    {
        public Boolean showYankeeGrid { get; set; }
        public Boolean showMcleanGrid { get; set; }
        public Boolean hideMcleanGrid { get; set; }
        public Boolean showTrialBladeSummary { get; set; }
        public Boolean showTrialBladeConditions { get; set; }
        public String sriPosition { get; set; }
        public String sectionName { get; set; }
        public String bladeStickout { get; set; }
        public String targetBlade { get; set; }
        public String bladeAngleTs { get; set; }
        public String bladeAngleCenter { get; set; }
        public String bladeAngleDs { get; set; }
        public String bladeLevel { get; set; }
        public String designBlade { get; set; }
        public String bladeContact { get; set; }
        public String construction { get; set; }
        public String metalized { get; set; }
        public String operatingPressure { get; set; }
        public String profilePressure { get; set; }
        public String stopBlockPressure { get; set; }
        public String loadingPressure { get; set; }
        public String loadingPli { get; set; }
        public String blade_change { get; set; }
        public String conformatic_change { get; set; }
        public String beam_total { get; set; }
        public String cleaning_freq { get; set; }
        public String cleaning_width { get; set; }
        public String high_pressure { get; set; }
        public String hpu { get; set; }
        public String vac_blower { get; set; }
        public String vac_pressure { get; set; }
        public List<ServiceTopicItem> stiItems { get; set; }
        public List<ServiceTopicItemMclean> stiItemsMcleans { get; set; }
    }

    public class ServiceTopicItem
    {
        public String stiTopic { get; set; }
        public List<String> stiSummary { get; set; }
        public List<Image> stiImages { get; set; }
        public String imageSize { get; set; }
    }

    public class ServiceTopicItemMclean
    {
        public String stiTopic { get; set; }
        public List<McleanItem> mcleanItem { get; set; }
    }

    public class McleanItem
    {
        public String stiComponent { get; set; }
        public String stiInspection { get; set; }
        public List<String> stiSummary { get; set; }
        public Date lastDate { get; set; }
        public Boolean showMcleanNotes { get; set; }
        public Boolean showVisitDate { get; set; }
        public Boolean showReplacedDate { get; set; }
        public List<Image> stiImages { get; set; }
        public String imageSize { get; set; }
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
        public String imageUrl { get; set;}
        public String captionDescription { get; set; }
    }
}