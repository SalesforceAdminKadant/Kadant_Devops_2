import { LightningElement, api, wire, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import getTopicCategory from '@salesforce/apex/MachineSectionController.getTopicCategory';
import getTopics from '@salesforce/apex/MachineSectionController.getListValues';

import STI_OBJECT from '@salesforce/schema/Service_Topic_Item__c';
import TOP_FIELD from '@salesforce/schema/Service_Topic_Item__c.Topic__c';
import COM_FIELD from '@salesforce/schema/Service_Topic_Item__c.Component__c';
import INS_FIELD from '@salesforce/schema/Service_Topic_Item__c.Inspection_Status__c';
import CAS_FIELD from '@salesforce/schema/Service_Topic_Item__c.Customer_Action_Summary__c';
import PRI_FIELD from '@salesforce/schema/Service_Topic_Item__c.Priority__c';
import STA_FIELD from '@salesforce/schema/Service_Topic_Item__c.Status__c';
import IMG_FIELD from '@salesforce/schema/Service_Topic_Item__c.Image_Size__c';
import SUM_FIELD from '@salesforce/schema/Service_Topic_Item__c.Summary__c';
import SRI_FIELD from '@salesforce/schema/Service_Topic_Item__c.Service_Report_Item__c';
import MAC_FIELD from '@salesforce/schema/Service_Topic_Item__c.Machine_Category__c';

let i = 0;

export default class CreateServiceTopic extends NavigationMixin(LightningElement){
    @api recordId;  // Gets the Current Service Report Item
    @track stiId;
    @track machine_cat;
    @track topicValues = [];
    @track componentValues;
    @track inspectionValues;
    @track priorityValues;
    @track statusValues;
    @track imageValues;
    @track selectedMac;
    @track selectedTopic;
    @track selectedComponent;
    @track selectedInspection;
    @track selectedPriority;
    @track selectedStatus;
    @track selectedImage = '100';
    @track disableComponent = true;
    @track disableInspection = true;
    @track isMclean = false;
    @track customerActionSummary = '';
    @track summary = '';  
    @track error;
    @track isModalOpen = false;

    // private variables
    the_cat;

    @wire(getTopicCategory, { id: '$recordId'})
    wiredTopicCategory({ error, data }) {
        //console.log("Record ID: " + this.recordId);
        if(data)
        {
            this.machine_cat = data; 
            this.the_cat = data; 
            if (this.machine_cat == 'M-clean')
            {
                this.isMclean = true;
            }          
            //console.log("getTopicCategory data: " + this.machine_cat);
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getTopicCategory!";
            }
        }
    }

    @wire(getTopics, { cat: '$the_cat' })
    wiredTopics({ error, data }) {
        //console.log("Record ID: " + this.recordId);
        if(data)
        {
            //console.log("Inside get dependant value mac_cat: " + this.machine_cat);
            //console.log("Result: " + JSON.stringify(data));
            for(i = 0; i < data.length; i++)  {
                this.topicValues = [...this.topicValues, {value: data[i], label: data[i]} ];                                   
            }
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getTopics!";
            }
        }
    }

    // Service Topic info:
    @wire(getObjectInfo, { objectApiName: STI_OBJECT }) objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: COM_FIELD })
    comFieldInfo({ data, error }) {
        if (data) {
            this.comFieldData = data;
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", comFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: INS_FIELD })
    insFieldInfo({ data, error }) {
        if (data) {
            this.insFieldData = data;
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", insFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: PRI_FIELD })
    setPriorityPicklistOptions({error, data}) {
        if (data) {
            this.priorityValues = data.values;
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", setPriorityPicklistOptions!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STA_FIELD })
    setStatusPicklistOptions({error, data}) {
        if (data) {
            this.statusValues = data.values;
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", setStatusPicklistOptions!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: IMG_FIELD })
    setImagePicklistOptions({error, data}) {
        if (data) {
            this.imageValues = data.values;
        } 
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", setImagePicklistOptions!";
            }
        }
    }

    handleTopicChange(event) {
        this.selectedTopic = event.target.value;
        //console.log("Handle Topic Change: " + this.selectedTopic);

        let comKey = this.comFieldData.controllerValues[event.target.value];
        this.componentValues = this.comFieldData.values.filter(opt => opt.validFor.includes(comKey));

        this.disableComponent = false;        
    }
    
    handleComponentChange(event) {
        this.selectedComponent = event.target.value;        

        let insKey = this.insFieldData.controllerValues[event.target.value];
        this.inspectionValues = this.insFieldData.values.filter(opt => opt.validFor.includes(insKey));

        this.disableInspection = false;
    }

    handleCasChange(event) {        
        this.customerActionSummary = event.target.value;
    }

    handlePriorityChange(event) {        
        this.selectedPriority = event.target.value;
        // Set Status equal to Open is Priority is not set to "--None--"
        this.selectedStatus = 'Open';
    }

    handleInspectionChange(event) {        
        this.selectedInspection = event.target.value;
    }

    handleStatusChange(event) {        
        this.selectedStatus = event.target.value;        
    }

    handleImageChange(event) {        
        this.selectedImage = event.target.value;
    }

    handleSummaryChange(event) {
        this.summary = event.target.value;
    }

    createTopic() {
        const allValid = [...this.template.querySelectorAll('lightning-combobox')]
        .reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        if (allValid)
        {
            if ((this.selectedStatus == 'Open') && (this.customerActionSummary == '') && (this.selectedPriority == undefined))
            {
                alert('Because you have selected Open for the Status a Customer Action Summary must be filled out, and a Priority must be selected.');
            }          
            else if ((this.machine_cat == 'M-clean') && ((this.selectedComponent == undefined) ||(this.selectedInspection == undefined)))
            {
                alert('This is an M-clean Service Topic and you must select a Component and an Inspection Status.');
            }
            else
            {
                const fields = {};
                fields[SRI_FIELD.fieldApiName] = this.recordId;
                //console.log("SRI ID: " + this.recordId);  
                fields[MAC_FIELD.fieldApiName] = this.machine_cat;
                //console.log("Machine Category: " + this.machine_cat);  
                fields[TOP_FIELD.fieldApiName] = this.selectedTopic;
                //console.log("Topic: " + this.selectedTopic);  
                fields[CAS_FIELD.fieldApiName] = this.customerActionSummary;  
                //console.log("CAS: " + this.customerActionSummary);                  
                fields[SUM_FIELD.fieldApiName] = this.summary;
                console.log("Summary: " + this.summary);  
                if (this.selectedComponent != undefined)
                {
                    //console.log("Component: " + this.selectedComponent);
                    fields[COM_FIELD.fieldApiName] = this.selectedComponent;
                }        
                if (this.selectedInspection != undefined)
                {
                    //console.log("Inspection: " + this.selectedInspection);
                    fields[INS_FIELD.fieldApiName] = this.selectedInspection;
                }
                if (this.selectedPriority != undefined)
                {
                    //console.log("Priority: " + this.selectedPriority);
                    fields[PRI_FIELD.fieldApiName] = this.selectedPriority;
                }
                if (this.selectedStatus != undefined)
                {
                    //console.log("Status: " + this.selectedStatus);
                    fields[STA_FIELD.fieldApiName] = this.selectedStatus;
                }
                if (this.selectedImage != undefined)
                {
                    //console.log("Image: " + this.selectedImage);
                    fields[IMG_FIELD.fieldApiName] = this.selectedImage;
                }
                
                const recordInput = { apiName: STI_OBJECT.objectApiName, fields };
                createRecord(recordInput)
                    .then(sti => {
                        this.stiId = sti.id;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Service Topic Item created',
                                variant: 'success',
                            }),
                        );
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                            recordId: sti.id,
                            objectApiName: STI_OBJECT.objectApiName,
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
        }
        else
        {
            alert('Please fix missing fields that require input.');
        }
    }

    openModal() {
        // to open modal set isModalOpen track value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isModalOpen = false;
    }
}