import { LightningElement, api, wire, track } from 'lwc';
import getOpenTopic from '@salesforce/apex/MachineSectionController.getOpenTopic';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';


export default class EditServiceTopic extends LightningElement{
    @api recordId;  // Gets the Current Service Report Item
    @track machine_cat;
    @track position;
    @track topic;
    @track summary;

    @wire(getOpenTopic, { id: '$recordId'})
    wiredGetTopic(result)
    {
        if(result.data)
        {
            //console.log("Topics: " + JSON.stringify(result));
            this.machine_cat = result.data.Service_Report_Item__r.Machine_Category__c;   
            this.position = result.data.Position__c;   
            this.topic = result.data.Topic__c;   
            this.summary = result.data.Summary__c;
        }
        else if (result.error) {                
            if (Array.isArray(result.error.body)) {
                this.error = result.error.body.map(e => e.message).join(', ');
            } else if (typeof result.error.body.message === 'string') {
                this.error = result.error.body.message + ", getOpenTopic!";
            }
            this.stiList = undefined;
        }
    }

    handleSummaryChange(event) {
        this.summary = event.target.value;
    }

    updateTopic() {
        let record = {
            fields: {
                Id: this.recordId,
                Summary__c: this.summary,
            },
        };
        //console.log("New Topic Summary: " + this.summary);
        updateRecord(record)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record Is Updated',
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
}