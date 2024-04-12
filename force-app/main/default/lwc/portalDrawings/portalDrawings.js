import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getDrawings from '@salesforce/apex/PortalController.getDrawings';
import Id from '@salesforce/user/Id'; 

export default class PortalDrawings extends NavigationMixin (LightningElement) {
    userId = Id;
    @track acctId;
    @track drawings = [];
    // fields from Controller
    // Id, Name, Title__c, Category__c, Machine__r.Name
    @track columns = [
        { label: 'Drawing Name', fieldName: 'Name', type: 'text', editable: false, initialWidth: 150, sortable: true, hideDefaultActions: true },    
        { label: 'Title', fieldName: 'Title__c', type: 'text', editable: false, sortable: true },
        { label: 'Machine Name', fieldName: 'MachineName', type: 'text', initialWidth: 150, editable: false, sortable: true },
        { label: 'Category', fieldName: 'Category__c', type: 'text', initialWidth: 150, editable: false, sortable: true }, 
        { label: '', fieldName: '', type: 'text', initialWidth: 50, editable: false, sortable: false, hideDefaultActions: true },      
    ];

    @wire(getRecord, { recordId: '$userId', fields: ['User.AccountId'] })
    userData({error, data}) {
        if(data) {
            //console.log('data ====> '+JSON.stringify(data));
            let objCurrentData = data.fields;            
            this.objUser = {                
                AccountId : objCurrentData.AccountId.value,
            }
            this.acctId = objCurrentData.AccountId.value;
            //console.log('Account ID: ' + this.acctId);
        } 
        else if(error) {
            window.console.log('error ====> '+JSON.stringify(error))
        } 
    }

    @wire(getDrawings, { acctId: '$acctId'}) 
    wiredDrawings({ error, data }) {
        if (data) {
            //console.log('Drawings data ====> '+ JSON.stringify(data));  
            let currentData = [];   
            data.forEach((row) => {
                let rowData = {};
                rowData.Id = row.Id;
                rowData.Name = row.Name;
                rowData.Title__c = row.Title__c;
                if (row.Machine__c) {
                    rowData.MachineName = row.Machine__r.Name;
                }                
                rowData.Category__c = row.Category__c;
                currentData.push(rowData);
            });
            this.drawings = currentData;
            this.error = undefined;
        } else if (error) {
            this.error = error;            
        }
    } 

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.reports));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.reports = parseData;
    }
}