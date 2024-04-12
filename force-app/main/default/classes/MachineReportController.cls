public class MachineReportController {
    public String mrId { get; set; } 
    public String accountSite { get; set; }
    public String machineNumber { get; set; }
    public String errorMessage { get; set; }
    public List<macSections> macSects { get; set; }
    
    public MachineReportController (ApexPages.StandardController controller) {
        errorMessage = '';

        mrId = ApexPages.CurrentPage().getparameters().get('id');
        Machine__c mac = [SELECT Account_and_Site__c, Name FROM Machine__c WHERE Id = :mrId];
        accountSite = mac.Account_and_Site__c;
        machineNumber = mac.Name;

        Machine_Section__c[] macItems = [SELECT Id, Name FROM Machine_Section__c WHERE Machine__c = :mrId AND Map_Created__c = true ORDER BY Sequence__c ASC];

        if (!macItems.isEmpty())
        {   
            macSects = new List<macSections>();                            
            for (Machine_Section__c macItem : macItems)
            {
                macSections ms = new macSections();               
                ms.Name = macItem.Name;                

                // Using the Machine Section ID go and get All Doctors, Cleaning, and Filters                
                Machine_Mapping_Doctor__c[] doctorItems = [SELECT RecordType.Name, Label_Name__c, Blade_Kadant_Item_Number__c, Blade_Customer_Item_Number__c, Blade_Supplier__c, Blade_Description__c,Holder_Type__c,Holder_Customer_Item_Number__c,Holder_Supplier__c,Holder_Description__c,Doctor_Supplier__c,Doctor_Back_Loading_Mechanism__c,Loading_Pressure__c,Bearing_Kadant_Item_Number__c,Bearing_Description__c,Oscillator_Kadant_Item_Number__c,Oscillator_Description__c,Loading_Kadant_Item_Number__c,Loading_Customer_Item_Number__c,Loading_Description__c,Tube_Type__c,Tube_Supplier__c,Notes__c FROM Machine_Mapping_Doctor__c WHERE Machine_Section__c = :macItem.Id];
                List<Doctor> macDrItems = new List<Doctor>();
                if (!doctorItems.isEmpty())
                {                    
                    for (Machine_Mapping_Doctor__c drItem : doctorItems)
                    {
                        Doctor dr = new Doctor();
                        dr.recType = drItem.RecordType.Name;
                        dr.position = drItem.Label_Name__c;
                        dr.bladeSupplier = drItem.Blade_Supplier__c;
                        dr.bladeKadantNum = drItem.Blade_Kadant_Item_Number__c;
                        dr.bladeCustNum = drItem.Blade_Customer_Item_Number__c;
                        dr.bladeDesc = drItem.Blade_Description__c;
                        dr.holderType = drItem.Holder_Type__c;
                        dr.holderSupplier = drItem.Holder_Supplier__c;
                        dr.holderDesc = drItem.Holder_Description__c;
                        dr.drSupplier = drItem.Doctor_Supplier__c;
                        dr.drBackLoading = drItem.Doctor_Back_Loading_Mechanism__c;
                        dr.loadingPressure = String.valueOf(drItem.Loading_Pressure__c);
                        dr.bearingKadantNum = drItem.Bearing_Kadant_Item_Number__c;
                        dr.tubeType = drItem.Tube_Type__c;
                        dr.tubeSupplier = drItem.Tube_Supplier__c;
                        dr.bearingDesc = drItem.Bearing_Description__c;
                        dr.oscKadantNum = drItem.Oscillator_Kadant_Item_Number__c;
                        dr.oscDesc = drItem.Oscillator_Description__c;
                        dr.loadKadantNum = drItem.Loading_Kadant_Item_Number__c;
                        dr.loadCustNum = drItem.Loading_Customer_Item_Number__c;
                        dr.loadDesc = drItem.Loading_Description__c;
                        dr.drNotes = drItem.Notes__c;
                        macDrItems.add(dr);
                    }
                }       
                ms.drs = macDrItems;

                // Now go get the Shower data
                Machine_Mapping_Cleaning__c[] showerItems = [SELECT RecordType.Name, Position_No__c, Competitor__c, Out_of_Service__c, Application__c, Notes__c, Has_Brush__c, Nozzle_Code__c, nozzle_supplier__c, Nozzle_Quantity__c, Nozzle_Spacing__c, Shower_Pressure__c, Fluid_Source__c, Distance_to_Fabric_Roll__c, Pipe_Diameter__c FROM Machine_Mapping_Cleaning__c WHERE Machine_Section__c = :macItem.Id];
                List<Shower> macShrItems = new List<Shower>();
                if (!showerItems.isEmpty())
                {
                    for (Machine_Mapping_Cleaning__c shrItem : showerItems)
                    {
                        Shower shr = new Shower();
                        shr.recType = shrItem.RecordType.Name;
                        shr.position = shrItem.Position_No__c;
                        shr.application = shrItem.Application__c;
                        shr.shrManufacturer = shrItem.Competitor__c;
                        shr.nozzleSupplier = shrItem.nozzle_supplier__c;
                        shr.nozzleCode = shrItem.Nozzle_Code__c;
                        shr.nozzleQty = String.valueOf(shrItem.Nozzle_Quantity__c);
                        shr.nozzleSpacing = shrItem.Nozzle_Spacing__c;
                        shr.shrPressure = shrItem.Shower_Pressure__c;
                        shr.fluidSource = shrItem.Fluid_Source__c;
                        shr.distFabric = String.valueOf(shrItem.Distance_to_Fabric_Roll__c);
                        shr.pipeDiameter = String.valueOf(shrItem.Pipe_Diameter__c);
                        shr.brushInstalled = shrItem.Has_Brush__c;
                        shr.outOfService = String.valueOf(shrItem.Out_of_Service__c);
                        shr.drNotes = shrItem.Notes__c;
                        macShrItems.add(shr);
                    }
                }
                ms.shrs = macShrItems;
                macSects.add(ms);
            }
        }
         else
        {
            errorMessage = 'There are no Machine Maps associated with this Machine!';
        }
    }
    public class macSections
    {        
        public String Name { get; set; }
        public List<Doctor> drs { get; set; }
        public List<Shower> shrs { get; set; }
    }
    public class Doctor
    {
        public String recType { get; set; }
        public String position { get; set; }
        public String bladeSupplier { get; set; }
        public String bladeKadantNum { get; set; }
        public String bladeCustNum { get; set; }
        public String bladeDesc { get; set; }
        public String holderType { get; set; }
        public String holderSupplier { get; set; }
        public String holderDesc { get; set; }
        public String drSupplier { get; set; }
        public String drBackLoading { get; set; }
        public String loadingPressure { get; set; }
        public String bearingKadantNum { get; set; }        
        public String tubeType { get; set; }   
        public String tubeSupplier { get; set; }   
        public String bearingDesc { get; set; }
        public String oscKadantNum { get; set; }        
        public String oscDesc { get; set; }  
        public String loadKadantNum { get; set; }        
        public String loadCustNum { get; set; }   
        public String loadDesc { get; set; }  
        public String drNotes { get; set; }         
    }
    public class Shower
    {
        public String recType { get; set; }
        public String position { get; set; }
        public String application { get; set; }
        public String shrManufacturer { get; set; }
        public String nozzleSupplier { get; set; }
        public String nozzleCode { get; set; }
        public String nozzleQty { get; set; }
        public String nozzleSpacing { get; set; }
        public String shrPressure { get; set; }
        public String fluidSource { get; set; }
        public String distFabric { get; set; }
        public String pipeDiameter { get; set; }
        public String brushInstalled { get; set; }        
        public String outOfService { get; set; }   
        public String drNotes { get; set; }         
    }
}