import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import SR_OBJECT from '@salesforce/schema/Service_Report__c';
import SRI_OBJECT from '@salesforce/schema/Service_Report_Item__c';

import SR_ID from '@salesforce/schema/Service_Report_Item__c.Service_Report__c';
import SRI_ID from '@salesforce/schema/Service_Topic_Item__c.Service_Report_Item__c';

export default class ServiceReportBreadcrumb extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    @track currenObjectName;
    @track currenRecordId;
    @track srId;
    @track sriId;
    @track srisrId;
    @track boolVisible = false;

    connectedCallback() {
        this.currenRecordId = this.recordId;
        this.currenObjectName = this.objectApiName;

        if (this.currenObjectName == "Service_Topic_Item__c")
        {
            this.boolVisible = true; 
        }
    }

    // Using the Service Report Item Id go and get the Service Report ID
    @wire(getRecord, { recordId: '$recordId', fields: [SR_ID] }) sr;

    get the_srid() { // Used on the HTML page!!
        this.srId = getFieldValue(this.sr.data, SR_ID);
        return getFieldValue(this.sr.data, SR_ID);
    }

    @wire(getRecord, { recordId: '$recordId', fields: [SRI_ID] }) sri;

    get the_sri_id() { // Used on the HTML page!!
        this.sriId = getFieldValue(this.sri.data, SRI_ID);
        return getFieldValue(this.sri.data, SRI_ID);
    }

    @wire(getRecord, { recordId: '$sriId', fields: [SR_ID] }) srisr;

    get the_sr_id() { // Used on the HTML page!!
        this.srisrId = getFieldValue(this.srisr.data, SR_ID);
        return getFieldValue(this.srisr.data, SR_ID);
    }

    navigateToSr(event) {
        let nav_id = this.srId;
        if (this.srId == undefined)
        {
            nav_id = this.srisrId;
        }        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: nav_id,
                objectApiName: SR_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }

    navigateToSri(event) {
        if (this.currenObjectName != "Service_Report_Item__c")
        {
            // Add hide STI!!
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.sriId,
                    objectApiName: SRI_OBJECT.objectApiName,
                    actionName: 'view'
                }
            });
        }
    }
}