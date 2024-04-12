import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import getOpenTopicsList from '@salesforce/apex/MachineSectionController.getOpenTopicsList';
import getOpenTopic from '@salesforce/apex/MachineSectionController.getOpenTopic';

const actions = [
    { label: 'Complete', name: 'Complete' },
    { label: 'Customer Chose No Action', name: 'Customer Chose No Action' },
    { label: 'View Details', name: 'view_details'},
    { label: 'Edit', name: 'edit'}
    //    { label: 'View Details', name: 'view_details'} - linked to edit action item
    
];

/*
Go and get all Open Topics for the Service Report Line Item for the current piece of equipment
    if we are at the Service Report Item level.  However, if we are at the Machine level
    get all ofthe Open Topics for this piece of equipment.
*/
export default class OpenServiceTopics extends LightningElement {
    @api objectApiName;
    @api recordId;
    @track wiredTopics = [];
    @track stiList;
    @track error;
    @track title;
    @track dt_height;
    @track isModalOpen = false;
    @track isEditOpen = false;
    @track stiID;
    //create a new variable and change the top to viewmodal and new one to edit modal - both set to false - IK
    @track the_date;
    @track the_position;
    @track the_priority;
    @track the_topic;                
    @track the_action;
    @track the_summary;
    @track the_owner;
    rowOffset = 0;
    @track columns = [];  
    @track the_status;
    @track summary;

    @wire(getOpenTopicsList, { id: '$recordId', objName: '$objectApiName'})
    wiredGetTopics(result) {   
        //console.log('Record ID: ' + this.recordId);
        //console.log('Object name: ' + this.objectApiName);
        if (this.objectApiName == 'Service_Report_Item__c')
        {
            this.title = 'Open Topics';
            this.dt_height = 'height: 200px;';
            this.columns = [
                { label: 'Date Created', fieldName: 'CreatedDate', type: 'date', editable: false },
                { label: 'Priority', fieldName: 'Priority__c', type: 'text', editable: false },
                { label: 'Topic', fieldName: 'Topic__c', type: 'text', editable: false },
                { label: 'Summary', fieldName: 'Customer_Action_Summary__c', type: 'text', editable: false },
                {
                    type: 'action',
                    typeAttributes: { rowActions: actions },
                },
            ];
        }
        else
        {
            this.title = 'Open Topics for Machine';
            this.dt_height = 'height: 600px;';
            this.columns = [
                { label: 'Date Created', fieldName: 'CreatedDate', type: 'date', editable: false },
                { label: 'Position', fieldName: 'Position__c', type: 'text', editable: false },
                { label: 'Topic', fieldName: 'Topic__c', type: 'text', editable: false },
                { label: 'Summary', fieldName: 'Customer_Action_Summary__c', type: 'text', editable: false },
                {
                    type: 'action',
                    typeAttributes: { rowActions: actions },
                },
            ];
        }
        this.wiredTopics = result;
        if(result.data)
        {
            //console.log("Topics: " + JSON.stringify(result));
            this.stiList = result.data;           
        }
        else if (result.error) {                
            if (Array.isArray(result.error.body)) {
                this.error = result.error.body.map(e => e.message).join(', ');
            } else if (typeof result.error.body.message === 'string') {
                this.error = result.error.body.message + ", getOpenTopicsList!";
            }
            this.stiList = undefined;
        }        
    }
    
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        console.log("Action Name: " + actionName);
        const row = event.detail.row;
        const id = row.Id;
        console.log("ID: " + id);
        if (actionName == 'view_details')
        {
            this.viewTopic(id);
        }
        else if(actionName == 'edit'){
            this.editRecord(id);
        }
        else
        {
            this.updateTopic(id, actionName);
            // this.edit;
        }
    }
    
    handleCancel = () => {
        this.isEditOpen = false;
    }

    handleEdit = () =>{
       let div = document.getElementById("toggle");
       div.style.visibility="hidden";
    }

    handleSummaryChange(event) {
        this.summary = event.target.value;    
    }

    handleActionChange(event) {
        this.the_action = event.target.value;    
    }

    editRecord(the_id){
        // console.log('Inside Edit Record ID' + the_id);
        this.stiID = the_id; 
        getOpenTopic({id: the_id})
            // then/catch is a Javascript Promise!!
                .then(result => {
                    let data = result;
                    //this.contacts = result;
                    // console.log("Item: " + JSON.stringify(data));
                    this.the_topic = data.Topic__c;                
                    this.the_action = data.Customer_Action_Summary__c;
                    this.the_summary = data.Summary__c;
                    this.summary = data.Summary__c;
                    this.the_owner = data.Owner.Name;
                    this.the_status = data.Status__c;
                    this.the_position = data.Position__c;
                    //console.log("Account: " + data.Account_Name__c);
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error;
                    //console.log("Got an Error: " + JSON.stringify(this.error));
                });
        this.isEditOpen = true;   
    }
 
    updateTopic(id, status) {
        let record = {
            fields: {
                Id: id,
                Status__c: status,
            }
        };
        updateRecord(record)        
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Status has been Updated',
                        variant: 'success',
                    }),
                );
                return refreshApex(this.wiredTopics);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error on data save',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });     
    }

    updateTopicSummary() {
        let record = {
            fields: {
                Id: this.stiID,
                Summary__c: this.summary,
                Customer_Action_Summary__c: this.the_action,
            }
        };
        updateRecord(record)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Summary has been Updated',
                        variant: 'success',
                    }),
                );
                return refreshApex(this.wiredTopics);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error on data save',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
            this.isEditOpen = false;   
    }

    viewTopic(the_id) {
        getOpenTopic({id: the_id})
        // then/catch is a Javascript Promise!!
            .then(result => {
                let data = result;
                //this.contacts = result;
                //console.log("Item: " + JSON.stringify(data));
                this.the_date = data.CreatedDate;
                this.the_position = data.Position__c;
                this.the_priority = data.Priority__c;
                this.the_topic = data.Topic__c;                
                this.the_action = data.Customer_Action_Summary__c;
                this.the_summary = data.Summary__c;
                this.the_owner = data.Owner.Name;
                //console.log("Account: " + data.Account_Name__c);
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                //console.log("Got an Error: " + JSON.stringify(this.error));
            });
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}