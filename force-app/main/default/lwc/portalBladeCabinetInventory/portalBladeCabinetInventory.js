import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getBCInventory from '@salesforce/apex/PortalController.getBladeCabinetMinimum';
import Id from '@salesforce/user/Id'; 

export default class PortalBladeCabinetInventory extends LightningElement {userId = Id;
    @track acctId;
    @track inventory = [];
    // fields from Controller
    // Id, Name, Customer_Item_Number__c, Current_Inventory_Level__c, Minimum_Inventory_Level__c, On_Order_In_Transit_Quantity__c, Product__r.Description, Product__r.Blade_Quick_Identifier__c
    @track columns = [
        { label: 'Customer No.', fieldName: 'Customer_Item_Number__c', type: 'text', editable: false, initialWidth: 140, sortable: true, hideDefaultActions: true },    
        { label: 'Part Number', fieldName: 'Name', type: 'text', editable: false, initialWidth: 140, sortable: true, hideDefaultActions: true },    
        { label: 'Description', fieldName: 'Part_Description__c', type: 'text', editable: false, initialWidth: 600, sortable: true },
        { label: 'ID', fieldName: 'Quick_Identifier__c', type: 'text', initialWidth: 80, editable: false, sortable: true },
        { label: 'QTY', fieldName: 'Quantity__c', type: 'text', initialWidth: 80, editable: false, sortable: true }, 
        { label: 'MIN', fieldName: 'Minimum', type: 'text', initialWidth: 80, editable: false, sortable: true }, 
        { label: 'OnOrder', fieldName: 'OnOrder', type: 'text', initialWidth: 80, editable: false, sortable: true }, 
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

    @wire(getBCInventory, { acctId: '$acctId'}) 
    wiredDrawings({ error, data }) {
        if (data) {
            //console.log('Drawings data ====> '+ JSON.stringify(data));  
            let currentData = [];   
            data.forEach((row) => {
                let rowData = {};
                rowData.Id = row.Id;
                rowData.Customer_Item_Number__c = row.Customer_Item_Number__c;
                rowData.Name = row.Name;        
                rowData.Part_Description__c = row.Product__r.Description;      
                rowData.Quick_Identifier__c = row.Product__r.Blade_Quick_Identifier__c;      
                rowData.Quantity__c = row.Current_Inventory_Level__c;           
                rowData.Minimum = row.Minimum_Inventory_Level__c; 
                rowData.OnOrder = row.On_Order_In_Transit_Quantity__c; 
                currentData.push(rowData);
            });
            this.inventory = currentData;
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
        let parseData = JSON.parse(JSON.stringify(this.inventory));
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
        this.inventory = parseData;
    }
}