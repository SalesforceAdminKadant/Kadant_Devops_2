@isTest(SeeAllData=true)
public class MachineSectionControllerTest {
    public static void createMachineSections(Integer amount, String mac) {
        List<Machine_Section__c> ms = new List<Machine_Section__c>();

        for (Integer i = 1; i <= amount; i++) {
            ms.add(new Machine_Section__c(Machine__c = mac, Name = 'Test Section ' + i, Sequence__c = i, Section_Type__c = 'Press'));
        }

        insert ms;
    }

    public static void createCleanings(Integer amount, String sec) {
        List<Machine_Mapping_Cleaning__c> cln = new List<Machine_Mapping_Cleaning__c>();

        for (Integer i = 1; i <= amount; i++) {
            cln.add(new Machine_Mapping_Cleaning__c(Machine_Section__c = sec, Position_No__c = 'Shower ' + i));
        }

        insert cln;
    }

    public static void createDoctors(Integer amount, String sec) {
        List<Machine_Mapping_Doctor__c> dr = new List<Machine_Mapping_Doctor__c>();

        for (Integer i = 1; i <= amount; i++) {
            dr.add(new Machine_Mapping_Doctor__c(Machine_Section__c = sec, Label_Name__c = 'Doctor ' + i));
        }

        insert dr;
    }

    public static void createFilters(Integer amount, String sec) {
        List<Machine_Mapping_Filter__c> fl = new List<Machine_Mapping_Filter__c>();

        for (Integer i = 1; i <= amount; i++) {
            fl.add(new Machine_Mapping_Filter__c(Machine_Section__c = sec, Application__c = 'Filter ' + i));
        }

        insert fl;
    }

    public static void createDrainages(Integer amount, String sec) {
        List<Machine_Mapping_Drainage__c> drn = new List<Machine_Mapping_Drainage__c>();

        for (Integer i = 1; i <= amount; i++) {
            drn.add(new Machine_Mapping_Drainage__c(Machine_Section__c = sec, Application__c = 'Drainage ' + i));
        }

        insert drn;
    }

    public static void createRolls(Integer amount, String sec) {
        List<Machine_Mapping_Roll__c> rl = new List<Machine_Mapping_Roll__c>();

        for (Integer i = 1; i <= amount; i++) {
            rl.add(new Machine_Mapping_Roll__c(Machine_Section__c = sec, Label__c = 'Roll ' + i));
        }

        insert rl;
    }

    public static void createBelts(Integer amount, String sec) {
        List<Machine_Mapping_Belt__c> blt = new List<Machine_Mapping_Belt__c>();

        for (Integer i = 1; i <= amount; i++) {
            blt.add(new Machine_Mapping_Belt__c(Machine_Section__c = sec, Postion__c = 'Belt ' + i));
        }

        insert blt;
    }

    @isTest(SeeAllData=true)
    static void getMachineSections() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 1';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 1';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        MachineSectionControllerTest.createMachineSections(3, mac.Id);

        Test.startTest();
        List<Machine_Section__c> rs = MachineSectionController.getSectionList(mac.Id);
        Test.stopTest();

        System.assertEquals(rs.size(), 3);
    }

    @isTest(SeeAllData=true)
    static void getSectionCleaning() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;
        
        MachineSectionControllerTest.createCleanings(3, ms.Id);

        Test.startTest();
        List<Machine_Mapping_Cleaning__c> cl = MachineSectionController.getCleaningList(ms.Id);
        Test.stopTest();

        System.assertEquals(cl.size(), 3);
    }

    @isTest(SeeAllData=true)
    static void getSectionDoctor() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 3';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 3';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 2'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;
        
        MachineSectionControllerTest.createDoctors(3, ms.Id);

        Test.startTest();
        List<Machine_Mapping_Doctor__c> drs = MachineSectionController.getDoctorList(ms.Id);
        Test.stopTest();

        System.assertEquals(drs.size(), 3);
    }

    @isTest(SeeAllData=true)
    static void getSectionFilter() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 4';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 4';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 3'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;
        
        MachineSectionControllerTest.createFilters(3, ms.Id);

        Test.startTest();
        List<Machine_Mapping_Filter__c> fls = MachineSectionController.getFilterList(ms.Id);
        Test.stopTest();

        System.assertEquals(fls.size(), 3);
    }

    @isTest(SeeAllData=true)
    static void getSectionDrainage() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 5';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 5';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 4'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;
        
        MachineSectionControllerTest.createDrainages(3, ms.Id);

        Test.startTest();
        List<Machine_Mapping_Drainage__c> drns = MachineSectionController.getDrainageList(ms.Id);
        Test.stopTest();

        System.assertEquals(drns.size(), 3);
    }

    @isTest(SeeAllData=true)
    static void getSectionRoll() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 6';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 6';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 5'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;
        
        MachineSectionControllerTest.createRolls(3, ms.Id);

        Test.startTest();
        List<Machine_Mapping_Roll__c> rls = MachineSectionController.getRollsList(ms.Id);
        Test.stopTest();

        System.assertEquals(rls.size(), 3);
    }

    @isTest(SeeAllData=true)
    static void getSectionBelt() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 7';
        insert acc;

        Machine__c mac = new Machine__c();        
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 7';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 6'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;
        
        MachineSectionControllerTest.createBelts(2, ms.Id);

        Test.startTest();
        List<Machine_Mapping_Belt__c> blts = MachineSectionController.getBeltList(ms.Id);
        Test.stopTest();

        System.assertEquals(blts.size(), 2);
    }

    @isTest(SeeAllData=true)
    static void getRecordTypeTest() {
        Test.startTest();
        List<RecordType> recTypes = MachineSectionController.getRecordType();
        Test.stopTest();
        System.assertEquals(recTypes.size(), 5);
    }

    @isTest(SeeAllData=true)
    static void getDoctorTypeTest() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Doctor__c dr = new Machine_Mapping_Doctor__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '01260000000UOjQAAW';
        insert dr;

        Test.startTest();
        String drRecType = MachineSectionController.getDoctorType(dr.Id);
        Test.stopTest();
        System.assertEquals(drRecType, 'Single (Rigid Holder)');
    }

    @isTest(SeeAllData=true)
    static void getDoctorTypeBlankTest() {        
        Test.startTest();
        String drRecType = MachineSectionController.getDoctorType('');
        Test.stopTest();
        System.assertEquals(drRecType, null);
    }

    @isTest(SeeAllData=true)
    static void getCleaningTypeTest() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Cleaning__c cl = new Machine_Mapping_Cleaning__c();
        cl.Machine_Section__c = ms.Id;
        cl.RecordTypeId = '01260000000UOMqAAO';
        insert cl;

        Test.startTest();
        String clRecType = MachineSectionController.getCleaningType(cl.Id);
        Test.stopTest();
        System.assertEquals(clRecType, 'Fan Shower');
    }

    @isTest(SeeAllData=true)
    static void getCleaningTypeBlankTest() {
        Test.startTest();
        String clRecType = MachineSectionController.getCleaningType('');
        Test.stopTest();
        System.assertEquals(clRecType, null);
    }

    @isTest(SeeAllData=true)
    static void getCleaningTypeMcleanTest() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Cleaning__c cl = new Machine_Mapping_Cleaning__c();
        cl.Machine_Section__c = ms.Id;
        cl.RecordTypeId = '01260000000UONAAA4';
        insert cl;

        Test.startTest();
        String clRecType = MachineSectionController.getCleaningType(cl.Id);
        Test.stopTest();
        System.assertEquals(clRecType, 'Mclean');
    }

    @isTest(SeeAllData=true)
    static void getCleaningTypeMcleanBlankTest() {
        Test.startTest();
        String clRecType = MachineSectionController.getCleaningType('');
        Test.stopTest();
        System.assertEquals(clRecType, null);
    }

    @isTest(SeeAllData=true)
    static void getLastBladeChangeTest() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Doctor__c dr = new Machine_Mapping_Doctor__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '012600000005OLrAAM';
        insert dr;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Doctor__c = dr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        sri.RecordTypeId = '0120z000000UPd9AAG';
        sri.Last_Backing_Blade_Change__c = 'Test Blade Change';
        insert sri;

        Test.startTest();
        String bladeChange = MachineSectionController.getLastBladeChange(dr.Id);
        Test.stopTest();
        System.assertEquals(bladeChange, 'Test Blade Change');
    }

    @isTest(SeeAllData=true)
    static void getLastBladeChangeBlankTest() {
        Test.startTest();
        String bladeChange = MachineSectionController.getLastBladeChange('');
        Test.stopTest();
        System.assertEquals(bladeChange, 'Unknown');
    }

    @isTest(SeeAllData=true)
    static void getLastComformaticChangeTest() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Doctor__c dr = new Machine_Mapping_Doctor__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '012600000005OLrAAM';
        insert dr;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Doctor__c = dr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        sri.RecordTypeId = '0120z000000UPd9AAG';
        sri.Last_Conformatic_Tube_Change__c = 'Test Blade Change';
        insert sri;
        
        Test.startTest();
        String bladeChange = MachineSectionController.getLastComformaticChange(dr.Id);
        Test.stopTest();
        System.assertEquals(bladeChange, 'Test Blade Change');
    }

    @isTest(SeeAllData=true)
    static void getLastComformaticChangeBlankTest() {
        Test.startTest();
        String bladeChange = MachineSectionController.getLastComformaticChange('');
        Test.stopTest();
        System.assertEquals(bladeChange, 'Unknown');
    }

    @isTest(SeeAllData=true)
    static void getTopicCategoryTest() {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Doctor__c dr = new Machine_Mapping_Doctor__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '012600000005OLrAAM';
        insert dr;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Doctor__c = dr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        sri.RecordTypeId = '0120z000000UPd9AAG';
        insert sri;
        
        Test.startTest();
        String topicCat = MachineSectionController.getTopicCategory(sri.Id);
        Test.stopTest();
        System.assertEquals(topicCat, 'Yankee Doctor');
    }

    @isTest(SeeAllData=true)
    static void getTopicCategoryBlankTest() {
        Test.startTest();
        String topicCat = MachineSectionController.getTopicCategory('');
        Test.stopTest();
        System.assertEquals(topicCat, null);
    }

    @isTest(SeeAllData=true)
    static void getImagesTest() {
        Account acc1 = new Account(Name = 'Test Company 1');
        insert acc1;  

        Machine__c mac1 = new Machine__c(Account__c = acc1.Id, Account_for_Master_Detail__c = acc1.Id, Name = 'Test Machine 1');
        insert mac1;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc1.Id;
        sr.Reason_for_Service__c = 'adding testing for reason for service';
        sr.Objective__c = 'adding testing objective';                
        sr.Machine__c = mac1.Id;
        sr.Visit_Date__c = System.today();
        insert sr; 

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri; 

        sharinpix__SharinPixImage__c objSPI = new sharinpix__SharinPixImage__c(sharinpix__Title__c ='Test', Service_Report_Item__c = sri.Id);
        insert objSPI;
        Test.startTest();
        List<sharinpix__SharinPixImage__c> images = MachineSectionController.getImageList(sri.Id);
        Test.stopTest();
        System.assertEquals(images.size(), 1);
    }

    @isTest(SeeAllData=true)
    static void getListValuesTest()
    {
        Test.startTest();
        List<String> depValues = MachineSectionController.getListValues('Filter');
        Test.stopTest();
        System.assertEquals(depValues.size(), 4);
    }   
    
    @isTest(SeeAllData=true)
    static void getCleaningListTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Cleaning__c cl = new Machine_Mapping_Cleaning__c();
        cl.Machine_Section__c = ms.Id;
        cl.RecordTypeId = '01260000000UOMqAAO';
        insert cl;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Cleaning__c = cl.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Category__c = 'Cleaning';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Cleaning';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        Test.startTest();
        List<Service_Topic_Item__c> stiList = MachineSectionController.getOpenTopicsList(sri.Id, 'Service_Report_Item__c');
        Test.stopTest();
        System.assertEquals(stiList.size(), 1);
    }

    @isTest(SeeAllData=true)
    static void getDoctorListTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Doctor__c dr = new Machine_Mapping_Doctor__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '012600000005OLrAAM';
        insert dr;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Doctor__c = dr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Category__c = 'Doctor';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        Test.startTest();
        List<Service_Topic_Item__c> stiList = MachineSectionController.getOpenTopicsList(sri.Id, 'Service_Report_Item__c');
        Test.stopTest();
        System.assertEquals(stiList.size(), 1);
    }

    @isTest(SeeAllData=true)
    static void getDrainageListTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Drainage__c dr = new Machine_Mapping_Drainage__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '01260000000UONjAAO';
        insert dr;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Drainage__c = dr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Category__c = 'Drainage';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        Test.startTest();
        List<Service_Topic_Item__c> stiList = MachineSectionController.getOpenTopicsList(sri.Id, 'Service_Report_Item__c');
        Test.stopTest();
        System.assertEquals(stiList.size(), 1);
    }

    @isTest(SeeAllData=true)
    static void getFilterListTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.Account_for_Master_Detail__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Machine_Mapping_Filter__c dr = new Machine_Mapping_Filter__c();
        dr.Machine_Section__c = ms.Id;
        dr.RecordTypeId = '01260000000UONZAA4';
        insert dr;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Mapping_Filter__c = dr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Category__c = 'Filter';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        Test.startTest();
        List<Service_Topic_Item__c> stiList = MachineSectionController.getOpenTopicsList(sri.Id, 'Service_Report_Item__c');
        Test.stopTest();
        System.assertEquals(stiList.size(), 1);
    }

    @isTest(SeeAllData=true)
    static void getTopicListMACTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        Test.startTest();
        List<Service_Topic_Item__c> stiList = MachineSectionController.getOpenTopicsList(mac.Id, 'Machine__c');
        Test.stopTest();
        System.assertEquals(stiList.size(), 1);
    }

    @isTest(SeeAllData=true)
    static void getOpenTopicTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account Machine 2';
        insert acc;

        Machine__c mac = new Machine__c();
        mac.Account__c = acc.Id;
        mac.RecordTypeId = '01260000000DWaWAAW';
        mac.Name = 'Test Machine 2';
        mac.Trim_Width__c = 124.25;
        mac.Trim_Width_Units__c = 'IN';
        insert mac;

        Machine_Section__c ms = new Machine_Section__c();
        ms.Machine__c = mac.Id;
        ms.Name = 'Test Section 1'; 
        ms.Sequence__c = 1;
        ms.Section_Type__c = 'Press';
        insert ms;

        Service_Report__c sr = new Service_Report__c();
        sr.Account__c = acc.Id;
        sr.Machine__c = mac.Id;        
        sr.Objective__c = 'Test Objective';
        sr.Visit_Date__c = System.today();
        insert sr;

        Service_Report_Item__c sri = new Service_Report_Item__c();
        sri.Service_Report__c = sr.Id;
        sri.Machine_Name__c = 'Test Machine';
        sri.Machine_Section__c = ms.Id;
        sri.Line_Order_Number__c = 1.0;
        insert sri;

        Service_Topic_Item__c sti = new Service_Topic_Item__c();
        sti.Service_Report_Item__c = sri.Id;
        sti.Customer_Action_Summary__c = 'adding testing for Action Summary';
        sti.Status__c = 'Open';
        sti.Priority__c = 'Low';
        sti.Machine_Category__c = 'Doctor';
        sti.Topic__c = 'Bearings';
        sti.Summary__c = 'Just some testing text for sample data for the comments';
        insert sti;

        Test.startTest();
        Service_Topic_Item__c the_sti = MachineSectionController.getOpenTopic(sti.Id);
        Test.stopTest();
        System.assertEquals(the_sti.Id, sti.Id);
    }
}