import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue, createRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getRecordType from '@salesforce/apex/MachineSectionController.getRecordType';
import getSectionList from '@salesforce/apex/MachineSectionController.getSectionList';
import getDoctorList from '@salesforce/apex/MachineSectionController.getDoctorList';
import getCleaningList from '@salesforce/apex/MachineSectionController.getCleaningList';
import getFilterList from '@salesforce/apex/MachineSectionController.getFilterList';
import getDrainageList from '@salesforce/apex/MachineSectionController.getDrainageList';
import getRollsList from '@salesforce/apex/MachineSectionController.getRollsList';
import getBeltList from '@salesforce/apex/MachineSectionController.getBeltList';
import getCleaningType from '@salesforce/apex/MachineSectionController.getCleaningType';
import getLastBladeChange from '@salesforce/apex/MachineSectionController.getLastBladeChange';
import getLastComformaticChange from '@salesforce/apex/MachineSectionController.getLastComformaticChange';
import MC_ID from '@salesforce/schema/Service_Report__c.Machine__c';
import SRLNUM_FIELD from '@salesforce/schema/Service_Report__c.Line_Item_Number__c';
import SRL_OBJECT from '@salesforce/schema/Service_Report_Item__c';
import SR_FIELD from '@salesforce/schema/Service_Report_Item__c.Service_Report__c';
import REC_FIELD from '@salesforce/schema/Service_Report_Item__c.RecordTypeId';
import POS_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Name__c';
import CAT_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Category__c';
import SEC_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Section__c';
import CLN_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Mapping_Cleaning__c';
import DOC_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Mapping_Doctor__c';
import DRN_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Mapping_Drainage__c';
import FLT_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Mapping_Filter__c';
import ROL_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Mapping_Roll__c';
import BLT_FIELD from '@salesforce/schema/Service_Report_Item__c.Machine_Mapping_Belt__c';
import SRIBLD_FIELD from '@salesforce/schema/Service_Report_Item__c.Blade_Stickout__c';
import SRICON_FIELD from '@salesforce/schema/Service_Report_Item__c.Construction__c';
import SRIBDC_FIELD from '@salesforce/schema/Service_Report_Item__c.Design_Blade_Contact_from_BDC__c';
import SRIPLI_FIELD from '@salesforce/schema/Service_Report_Item__c.Loading_PLI__c';
import SRILPU_FIELD from '@salesforce/schema/Service_Report_Item__c.Loading_Pressure_Units__c';
import SRIPRS_FIELD from '@salesforce/schema/Service_Report_Item__c.Loading_Pressure__c';
import SRIMTL_FIELD from '@salesforce/schema/Service_Report_Item__c.Metalized__c';
import SRITBA_FIELD from '@salesforce/schema/Service_Report_Item__c.Target_Blade_Angle__c';
import SRIBAT_FIELD from '@salesforce/schema/Service_Report_Item__c.Blade_Angle_TS__c';
import SRIBAD_FIELD from '@salesforce/schema/Service_Report_Item__c.Blade_Angle_DS__c';
import SRIBL_FIELD from '@salesforce/schema/Service_Report_Item__c.Blade_Level__c';
import SRILBB_FIELD from '@salesforce/schema/Service_Report_Item__c.Last_Backing_Blade_Change__c';
import SRILCT_FIELD from '@salesforce/schema/Service_Report_Item__c.Last_Conformatic_Tube_Change__c';
import LNUM_FIELD from '@salesforce/schema/Service_Report_Item__c.Line_Order_Number__c';
import BLD_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Blade_Stickout__c';
import CON_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Construction__c';
import BDC_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Design_Blade_Contact_from_BDC__c';
import PLI_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Loading_PLI__c';
import LPU_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Loading_Pressure_Units__c';
import PRS_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Loading_Pressure__c';
import MTL_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Metalized__c';
import TBA_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Target_Blade_Angle__c';
import BAT_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Blade_Angle_TS__c';
import BAD_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Blade_Angle_DS__c';
import BL_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.Blade_Level__c';
import RT_FIELD from '@salesforce/schema/Machine_Mapping_Doctor__c.RecordType.Name';

let i = 0;

export default class ServiceReportLine extends NavigationMixin(LightningElement){
    /*
    1. Using the Service Report ID get the Machine ID
    2. Then go and get all of the Machine Sections associated with this Machine
    3. Finally get the Shower Applications in the Machine Section
    *** Will need to select the Cleaning, Doctor, Filter, or Drainage from the drop-down on the form!! ***
    I'm suggesting we use an LWC:
    1. Embed it on the Service Report page
    2. Provide a drop-down for which Product they want to start with
    3. Using the value selected fill the next drop down with the Topics available
    4. When this value is selected go and get the Serial Number and Desription from the Metadata
    */

    @api recordId;  // Gets the Current Service Report
    @track macid;   // Used inside the JS file!!
    @track btn_disabled = true;
    @track sriId;
    @track lineNum;
    @track serial_no;
    @track serial_desc;
    @track product_id;  // Unique ID from Cleaning, Doctor, etc.
    @track sections = [];
    @track selectedSectionId;
    @track product;
    @track productSelected;
    @track productName;
    @track doctorId;
    @track doctorType;
    @track cleaningId;
    @track cleainingType;    
    @track items = [];
    @track recordTypes = [];
    @track doctorSectionId;
    @track cleaningSectionId;
    @track filterSectionId;
    @track drainageSectionId;  
    @track rollsSectionId;  
    @track beltSectionId;
    @track theTopic;
    @track blade;
    @track contruction;
    @track bladeContact;
    @track loadPli;
    @track loadPressure;
    @track pressureUnits;
    @track metal;
    @track target_angle;
    @track angle_ts;
    @track angle_ds;
    @track blade_level;
    @track last_blade_change;
    @track last_conform_change;
    @track bladeTrialOption;
    
    @track productOptions = [
        { label: 'Select a Product', value: '' },
        { label: 'Doctor', value: 'doctor' },
        { label: 'Cleaning', value: 'cleaning' },
        { label: 'Filter', value: 'filter' },
        { label: 'Drainage', value: 'drainage' },
        { label: 'Rolls', value: 'rolls' },
        { label: 'Belt', value: 'belt' },
    ];
    
    @track bladeTrialOptions = [
        { label: 'Select Item', value: '' },
        { label: 'Trial Blade Summary', value: 'TrialBladeSummary' },
        { label: 'Trial Blade Machines', value: 'TrialBladeMachines' },
    ];

    @track error;
    @track productVisible = false;
    @track itemVisible = false;
    @track showBladeTrial = false;
    @track bladeTrialCheckbox = false;    
    @track bladeTrialOptionSelected = false;

    // Using the Service Report Id go and get the Machine ID
    @wire(getRecord, { recordId: '$recordId', fields: [MC_ID, SRLNUM_FIELD] }) machine;

    get the_mac() { // the_mac Used on the HTML page!!
        this.macid = getFieldValue(this.machine.data, MC_ID);
        return getFieldValue(this.machine.data, MC_ID);
    } 

    get the_lnum() {
        this.lineNum = getFieldValue(this.machine.data, SRLNUM_FIELD);
        return getFieldValue(this.machine.data, SRLNUM_FIELD);
    }

    @wire(getRecordType, { })
    wiredRecordTypes({ error, data }) {
        if(data)
        {
            for (i = 0; i < data.length; i++) {
                // Output choice in the target field
                var tmpName = data[i].Name;
                if (tmpName == "Yankee")
                    tmpName = "Creping";
                this.recordTypes = [...this.recordTypes, { label: tmpName, value: data[i].Id }];
                //window.console.log("Record Types: " + tmpName);
            }             
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getRecordType!";
            }
            this.recordTypes = undefined;
        }
    } 

    @wire(getSectionList, { mac_id: '$macid'})
    wiredSections({ error, data }) {
        if(data)
        {
            for (i = 0; i < data.length; i++) {
                // Output choice in the target field
                this.sections = [...this.sections, { label: data[i].Name, value: data[i].Id }];
                //window.console.log("Option: " + data[i].Name);
            }             
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getSectionList!";
            }
            this.recordTypes = undefined;
        }
    }    

    get sectionsOptions() {
        return this.sections;
    }

    // Get list of Doctors if Doctor is selected
    @wire(getDoctorList, { sec_id: '$doctorSectionId' }) 
    wiredDoctors({ error, data }) {        
        if (data) 
        {
            this.items = [];
            for (i = 0; i < data.length; i++) {
                this.items = [...this.items, { label: data[i].Label_Name__c , value: data[i].Id }];                
            };            
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getDoctorList!";
            }
            this.items = undefined;
        }
    }

    @wire(getCleaningList, { sec_id: '$cleaningSectionId' }) 
    wiredShowers({ error, data }) {        
        if (data) 
        {
            this.items = [];
            for (i = 0; i < data.length; i++) {
                this.items = [...this.items, { label: data[i].Application__c , value: data[i].Id }];                
            };            
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getCleaningList!";
            }
            this.items = undefined;
        }
    }

    @wire(getFilterList, { sec_id: '$filterSectionId' }) 
    wiredFilters({ error, data }) {        
        if (data) 
        {
            this.items = [];
            for (i = 0; i < data.length; i++) {
                this.items = [...this.items, { label: data[i].Application__c , value: data[i].Id }];                
            };            
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getFilterList!";
            }
            this.items = undefined;
        }
    }

    @wire(getDrainageList, { sec_id: '$drainageSectionId' }) 
    wiredDrainage({ error, data }) {        
        if (data) 
        {
            this.items = [];
            for (i = 0; i < data.length; i++) {
                this.items = [...this.items, { label: data[i].Application__c , value: data[i].Id }];                
            };            
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getDrainageList!";
            }
            this.items = undefined;
        }
    }

    @wire(getRollsList, { sec_id: '$rollsSectionId' }) 
    wiredRolls({ error, data }) {        
        if (data) 
        {
            this.items = [];
            for (i = 0; i < data.length; i++) {
                this.items = [...this.items, { label: data[i].Label__c , value: data[i].Id }];                
            };            
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getRollsList!";
            }
            this.items = undefined;
        }
    }

    @wire(getBeltList, { sec_id: '$beltSectionId' }) 
    wiredBelt({ error, data }) {        
        if (data) 
        {
            this.items = [];
            for (i = 0; i < data.length; i++) {
                this.items = [...this.items, { label: data[i].Postion__c , value: data[i].Id }];                
            };            
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getBeltList!";
            }
            this.items = undefined;
        }
    }

    get itemOptions() {
        return this.items;
    }

    @wire(getCleaningType, { id: '$cleaningId'})
    wiredCleaningTypes({ error, data }) {
        if(data)
        {
            this.cleaningType = data;            
            console.log("getCleaningType data: " + this.cleaningType);
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getCleaningType!";
            }
            this.recordTypes = undefined;
        }
    }

    @wire(getLastBladeChange, { id: '$doctorId'})
    wiredLastBladeChange({ error, data }) {        
        if(data)
        {
            this.last_blade_change = data;
            //console.log("getLastBladeChange data: " + this.last_blade_change);
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getLastBladeChange!";
            }
            this.last_blade_change = undefined;
        }
    }

    @wire(getLastComformaticChange, { id: '$doctorId'})
    wiredLastComformaticChange({ error, data }) {        
        if(data)
        {
            this.last_conform_change = data;
            //console.log("getLastComformaticChange data: " + this.last_conform_change);
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getLastComformaticChange!";
            }
            this.last_conform_change = undefined;
        }
    }
    
    // The following is used to go get values for a Creping Doctor
    @wire(getRecord, { recordId: '$doctorId', fields: [BLD_FIELD, CON_FIELD, BDC_FIELD, PLI_FIELD, LPU_FIELD, PRS_FIELD, MTL_FIELD, RT_FIELD, TBA_FIELD, BAT_FIELD, BAD_FIELD, BL_FIELD] }) doctor;

    get the_blade() {
        this.blade = getFieldValue(this.doctor.data, BLD_FIELD);
        return getFieldValue(this.doctor.data, BLD_FIELD);
    }

    get the_contruction() {
        this.contruction = getFieldValue(this.doctor.data, CON_FIELD);
        return getFieldValue(this.doctor.data, CON_FIELD);
    }

    get the_bladeContact() {
        this.bladeContact = getFieldValue(this.doctor.data, BDC_FIELD);
        return getFieldValue(this.doctor.data, BDC_FIELD);
    }

    get the_loadPli() {
        this.loadPli = getFieldValue(this.doctor.data, PLI_FIELD);
        return getFieldValue(this.doctor.data, PLI_FIELD);
    }

    get the_pressureUnits() {
        this.pressureUnits = getFieldValue(this.doctor.data, LPU_FIELD);
        return getFieldValue(this.doctor.data, LPU_FIELD);
    }

    get the_loadPressure() {
        this.loadPressure = getFieldValue(this.doctor.data, PRS_FIELD);
        return getFieldValue(this.doctor.data, PRS_FIELD);
    }

    get the_metal() {
        this.metal = getFieldValue(this.doctor.data, MTL_FIELD);
        return getFieldValue(this.doctor.data, MTL_FIELD);
    }

    get the_dr_rec_type() {
        this.doctorType = getFieldValue(this.doctor.data, RT_FIELD);
        return getFieldValue(this.doctor.data, RT_FIELD);
    }

    get the_tba() {
        this.target_blade = getFieldValue(this.doctor.data, TBA_FIELD);
        return getFieldValue(this.doctor.data, TBA_FIELD);
    }

    get the_bat() {
        this.angle_ts = getFieldValue(this.doctor.data, BAT_FIELD);
        return getFieldValue(this.doctor.data, BAT_FIELD);
    }

    get the_bad() {
        this.angle_ds = getFieldValue(this.doctor.data, BAD_FIELD);
        return getFieldValue(this.doctor.data, BAD_FIELD);
    }

    get the_bl() {
        this.blade_level = getFieldValue(this.doctor.data, BL_FIELD);
        return getFieldValue(this.doctor.data, BL_FIELD);
    }

    sectionHandler(event) {  
        // In case the bastards go back and change the section need to clear the Item dropdown
        this.btn_disabled = true;
        this.selectedSectionId = event.detail.value;
        
        //console.log("Section ID: " + this.selectedSectionId);        
        var inp = this.template.querySelectorAll("lightning-combobox");
        inp.forEach(each => {
            if (each.label == "Product")    
            {
                each.value = '';
            }
        });

        if (this.selectedSectionId != null)
        {
            this.productVisible = true;
        }
    }

    productHandler(event) {  
        // Fill the Product Items drop down
        var inp = this.template.querySelectorAll("lightning-combobox");
        var id = this.selectedSectionId;
        var type = "";

        inp.forEach(function(element){
            if(element.name=="product")
            {
                this.product = event.detail.value;
                //console.log("Product: " + this.product);
                type = element.value;
                switch(type){
                    case "doctor":
                        this.doctorSectionId = id;                        
                        break;
                    case "cleaning":
                        this.cleaningSectionId = id;
                        break;
                    case "filter":
                        this.filterSectionId = id;
                        break;
                    case "drainage":
                        this.drainageSectionId = id;
                        break;
                    case "rolls":
                        this.rollsSectionId = id;
                        break;
                    case "belt":
                        this.beltSectionId = id;
                        break;
                    default:
                        break;
                }
            }
        },this);    
        if (event.detail.value != null)
        {
            this.itemVisible = true;
        }     
    }

    setProductItem(event) {
        switch(this.product){
            case "doctor":
                this.doctorId = event.detail.value;
                this.bladeTrialCheckbox = true;
                break;
            case "cleaning":
                this.cleaningId = event.detail.value;      
                this.bladeTrialCheckbox = false;      
                break;
            default:
                this.doctorId = '';
                this.cleaningId = '';
                this.bladeTrialCheckbox = false;  
                break;        
        }        
        //console.log("product selected: " + this.product);
        // This is to get the field Values selected in Product
        this.productSelected = event.detail.value;
        //console.log("Product ID: " + this.productSelected);        
        this.productName = event.target.options.find(opt => opt.value === event.detail.value).label;
        //console.log("Product Name: " + this.productName);
        this.btn_disabled = false;
    }    
    
    showBladeTrialOption(event) {
        if (event.target.checked) {
            this.showBladeTrial = true;
        }
        else{
            this.showBladeTrial = false;
            this.bladeTrialOptionSelected = false;
            // unselect any Blade Trial options that may have been selected!!
            var inp = this.template.querySelectorAll("lightning-combobox");
            inp.forEach(function(element){
                if(element.name=="bladeTrialItem")
                {
                    element.value = undefined;
                }
            });
        }
    }

    setBladeTrialOption(event) {        
        var test = event.detail.value;
        //console.log("BTO value: " + test);
        this.bladeTrialOption = event.detail.value;   
        this.bladeTrialOptionSelected = true; 
    }
    
    createClick(event) {
        this.btn_disabled = true;
        const fields = {};   

        fields[SR_FIELD.fieldApiName] = this.recordId;
        //console.log("SR ID: " + this.recordId);
        //console.log("Line Num: " + this.lineNum);

        if (this.lineNum == undefined)
        {
            this.lineNum = 0.0;
        }

        var newLineNumber = this.lineNum + 1.0;
        fields[LNUM_FIELD.fieldApiName] = (newLineNumber);
        //console.log("Last Line Number Type: " + (newLineNumber));
        this.lineNum = newLineNumber;        

        // Which record type from the RecordType Array do we use here?
        // If Creping then use the Yankee Record type, or if Cleaning and Mclean use Mclean Record Type else use the Standard         
        var rec_type = "";
        var index = 0;
        if ((this.doctorType == 'Creping') && (this.bladeTrialOptionSelected == false))
        {
            index = this.recordTypes.map(function(e) { return e.label; }).indexOf(this.doctorType);
            console.log("Inside Create with DoctorType: " + this.doctorType);
        }
        else if (this.cleaningType == 'Mclean')
        {
            index = this.recordTypes.map(function(e) { return e.label; }).indexOf(this.cleaningType);
            console.log("Inside Create with CleaningType: " + this.cleaningType);
        }
        // Check the Trial Blade drop-down for a value and get the Record Type by that Value!!
        else if ((this.bladeTrialOption != undefined)  && (this.bladeTrialOptionSelected == true))
        {
            index = this.recordTypes.map(function(e) { return e.label; }).indexOf(this.bladeTrialOption);
            console.log("Inside Create with Blade Trial Option: " + this.bladeTrialOption);
        }
        else 
        {
            index = this.recordTypes.map(function(e) { return e.label; }).indexOf("Standard"); 
        }
        rec_type = this.recordTypes[index].value;        
        //console.log("indexDrType: " + index);
        
        fields[REC_FIELD.fieldApiName] = rec_type;
        //console.log("SRI Record Type: " + rec_type);

        // for the Doctor it is Label_Name__c
        fields[POS_FIELD.fieldApiName] = this.productName;
        //console.log("Position: " + this.productName);

        var cat_field = this.product.charAt(0).toUpperCase() + this.product.slice(1);
        fields[CAT_FIELD.fieldApiName] = cat_field;
        if (this.bladeTrialOption != undefined) {
            fields[CAT_FIELD.fieldApiName] = "Trial Blade";
        }
        //console.log("Category: " + cat_field);

        fields[SEC_FIELD.fieldApiName] = this.selectedSectionId;
        //console.log("Section Selected: " + this.selectedSectionId);

        var prod = this.product;
        switch(prod){
            case "doctor":
                fields[DOC_FIELD.fieldApiName] = this.productSelected;
                //console.log("Selected Doctor ID: " + this.productSelected);
                if (this.doctorType == 'Creping')
                {
                    console.log("Save Dr. Type: " + this.doctorType);
                    if (this.blade != undefined)
                    {
                        fields[SRIBLD_FIELD.fieldApiName] = this.blade.toString();
                    }
                    if (this.contruction != undefined)
                    {
                        fields[SRICON_FIELD.fieldApiName] = this.contruction.toString();
                    }
                    if (this.bladeContact != undefined)
                    {
                        fields[SRIBDC_FIELD.fieldApiName] = this.bladeContact.toString();                    
                    }
                    if (this.loadPli != undefined)
                    {
                        fields[SRIPLI_FIELD.fieldApiName] = this.loadPli.toString();
                    }
                    fields[SRILPU_FIELD.fieldApiName] = this.pressureUnits;
                    if (this.loadPressure != undefined)
                    {
                        fields[SRIPRS_FIELD.fieldApiName] = this.loadPressure.toString();
                    }
                    fields[SRIMTL_FIELD.fieldApiName] = this.metal;
                    if (this.target_blade != undefined)
                    {
                        fields[SRITBA_FIELD.fieldApiName] = this.target_blade.toString();
                    }
                    if (this.angle_ts != undefined)
                    {
                        fields[SRIBAT_FIELD.fieldApiName] = this.angle_ts.toString();
                    }
                    if (this.angle_ds != undefined)
                    {
                        fields[SRIBAD_FIELD.fieldApiName] = this.angle_ds.toString();
                    }
                    if (this.blade_level != undefined)
                    {
                        fields[SRIBL_FIELD.fieldApiName] = this.blade_level.toString();
                    }
                    if (this.last_blade_change != undefined)
                    {
                        fields[SRILBB_FIELD.fieldApiName] = this.last_blade_change;
                    }
                    if (this.last_conform_change != undefined)
                    {
                        fields[SRILCT_FIELD.fieldApiName] = this.last_conform_change;
                    }
                }
                break;
            case "cleaning":
                fields[CLN_FIELD.fieldApiName] = this.productSelected;
                console.log("Selected Cleaning ID: " + this.productSelected);
                break;
            case "filter":
                fields[FLT_FIELD.fieldApiName] = this.productSelected;
                console.log("Selected Filter ID: " + this.productSelected);
                break;
            case "drainage":
                fields[DRN_FIELD.fieldApiName] = this.productSelected;
                console.log("Selected Drainage ID: " + this.productSelected);
                break;
            case "rolls":
                fields[ROL_FIELD.fieldApiName] = this.productSelected;
                console.log("Selected Rolls ID: " + this.productSelected);
                break;
            case "belt":
                fields[BLT_FIELD.fieldApiName] = this.productSelected;
                console.log("Selected Belt ID: " + this.productSelected);
                break;
            default:
                break;
        }

        const recordInput = { apiName: SRL_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(sri => {
                this.sriId = sri.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Service Report Line Item created',
                        variant: 'success',
                    }),
                );                
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                      recordId: sri.id,
                      objectApiName: SRL_OBJECT.objectApiName,
                      actionName: 'view'
                    }
                });                
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }); 
         
   }

    resetClick(event) {      
        this.btn_disabled = true;  
        this.productVisible = false;
        this.itemVisible = false;     
        this.showBladeTrial = false;
        this.bladeTrialCheckbox = false;    
        var inp = this.template.querySelectorAll("lightning-combobox");
        inp.forEach(each => {
            each.value = undefined;
        });
    }
}