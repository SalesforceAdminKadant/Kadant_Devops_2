import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getOpenServiceTopics from '@salesforce/apex/PortalController.getOpenServiceTopics';
import Id from '@salesforce/user/Id'; 

export default class PortalToDos extends NavigationMixin(LightningElement) {
    userId = Id;
    @track acctId;
    @track topics = [];

    // fields from Controller
    // Id, Machine__c, CreatedDate, Position__c, Priority__c, Topic__c, Customer_Action_Summary__c, Status__c
    @track columns = [
        { 
            label: 'Report', 
            fieldName: 'ReportId', 
            type: 'url', 
            editable: false, 
            initialWidth: 130, 
            typeAttributes: {label: { fieldName: 'ReportName' }, 
            target: '_blank'},
            sortable: true, 
            hideDefaultActions: true 
        },
        { label: 'Machine', fieldName: 'Machine__c', type: 'text', editable: false, initialWidth: 120, sortable: true, hideDefaultActions: true },
        { label: 'Position', fieldName: 'Position__c', type: 'text', editable: false, sortable: true, hideDefaultActions: true },
        { label: 'Topic', fieldName: 'Topic__c', type: 'text', editable: false, initialWidth: 120, sortable: true, hideDefaultActions: true },
        { label: 'Date', fieldName: 'CreatedDate', type: 'date', editable: false, initialWidth: 125, sortable: true, hideDefaultActions: true,
            typeAttributes:{
                month: "short",
                day: "2-digit",
                year: "numeric"
            }
        },
        { label: 'Summary', fieldName: 'Customer_Action_Summary__c', type: 'text', editable: false, sortable: true },
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

    @wire(getOpenServiceTopics, {acctId: '$acctId', maxRecords: 5}) 
    wiredTopics({ error, data }) {
        if (data) {
            //console.log('data ====> '+JSON.stringify(data));
            let currentData = [];            
            data.forEach((row) => {
                let rowData = {};
                rowData.Id = row.Id;
                rowData.Position__c = row.Position__c;
                rowData.Topic__c = row.Topic__c;
                rowData.CreatedDate = row.CreatedDate;
                rowData.Customer_Action_Summary__c = row.Customer_Action_Summary__c;
                rowData.Machine__c = row.Machine__c;                
                rowData.ReportId = window.location.protocol + '//' + window.location.host + '/KadantAccessPortal/apex/displayServiceReport?Id=' + row.Service_Report_Item__r.Service_Report__r.Id;                
                rowData.ReportName = row.Service_Report_Item__r.Service_Report__r.Name;                
                currentData.push(rowData);
            });
            this.topics = currentData;
            this.error = undefined;
        }
        else if (error) {
            this.error = error; 
        }
    } 
    
    openActionItems() {        
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/KadantAccessPortal/s/open-action-items'
            }            
        }, true);
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.topics));
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
        this.topics = parseData;
    }
}