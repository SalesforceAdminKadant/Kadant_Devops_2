import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getServiceReports from '@salesforce/apex/PortalController.getServiceReports';
import Id from '@salesforce/user/Id'; 

const serviceActions = [
    { label: 'Open Report', name: 'openReport' },    
];

export default class PortalServiceReports extends NavigationMixin (LightningElement) {
    userId = Id;
    @track acctId;
    @track reports = [];
    // fields from Controller
    // Id, Name, Machine_Name__c, Visit_Date__c, Objective__c
    @track columns = [
        { 
            label: 'Report Number', 
            fieldName: 'url', 
            type: 'url', 
            editable: false, 
            initialWidth: 150,
            typeAttributes: {label: { fieldName: 'Name' } },
            sortable: true, 
            hideDefaultActions: true },        
        { label: 'Machine Name', fieldName: 'MachineName', type: 'text', editable: false, initialWidth: 150, sortable: true, hideDefaultActions: true }, 
        { label: 'Visit Date', fieldName: 'Visit_Date__c', type: 'date', editable: false, initialWidth: 150, sortable: true, hideDefaultActions: true,
            typeAttributes:{
                month: "short",
                day: "2-digit",
                year: "numeric"
            }
        },        
        { label: 'Objective', fieldName: 'Objective__c', type: 'text', editable: false, sortable: true },    
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

    @wire(getServiceReports, { acctId: '$acctId'}) 
    wiredOrders({ error, data }) {
        if (data) {
            let currentData = [];   
            data.forEach((row) => {
                let rowData = {};
                rowData.Id = row.Id;
                rowData.Name = row.Name;
                if (row.Machine__c) {
                    rowData.MachineName = row.Machine__r.Name;                    
                }
                rowData.url = window.location.protocol + '//' + window.location.host + '/KadantAccessPortal/apex/displayServiceReport?Id=' + row.Id;
                rowData.Visit_Date__c = row.Visit_Date__c;
                rowData.Objective__c = row.Objective__c;
                currentData.push(rowData);
            });
            this.reports = currentData;
            this.error = undefined;
        } else if (error) {
            this.error = error;            
        }
    } 

    openReportAction(event) {
        const actionName = event.detail.action.name;
        console.log("Action Name: " + actionName);
        const row = event.detail.row;
        const id = row.Id;
        console.log("Report ID: " + id);
        // Go and get the Map for this Machine Sections
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: window.location.protocol + '//' + window.location.host + '/KadantAccessPortal/apex/displayServiceReport?Id=' + id
            }
        }).then(generatedUrl => {
            window.open(generatedUrl);
        });
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