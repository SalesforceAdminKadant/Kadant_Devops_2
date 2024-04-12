import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAssets from '@salesforce/apex/BomController.GetAssets';

export default class AllAssetsForParent extends NavigationMixin(LightningElement) {
    @api recordId;
    @track assets = [];

    // fields from Controller
    // Id, Name, SerialNumber, InstallDate, Account.Name, Product2.Name
    @track columns = [        
        { label: 'Account Name', fieldName: 'AccountName', type: 'text', initialWidth: 170, editable: false, sortable: true, hideDefaultActions: false },
        { 
            label: 'Asset Name', 
            fieldName: 'url', 
            type: 'url', 
            editable: false, 
            initialWidth: 220,
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank' },
            sortable: true, 
            hideDefaultActions: true }, 
        { label: 'Serial Number', fieldName: 'SerialNumber', type: 'text', editable: false, initialWidth: 150, sortable: true, hideDefaultActions: true },
        { label: 'Product Name', fieldName: 'ProductName', type: 'text', initialWidth: 150, editable: false, sortable: true, hideDefaultActions: true },
        { label: 'Install Date', fieldName: 'InstallDate', type: 'date', editable: false, initialWidth: 100, sortable: true, hideDefaultActions: true,
            typeAttributes:{
                month: "short",
                day: "2-digit",
                year: "numeric"
            }
        },        
    ];

    @wire(getAssets, { id: '$recordId'}) 
    wiredOrders({ error, data }) {
        if (data) {            
            let currentData = [];   
            data.forEach((row) => {
                //console.log('Asset Account Name ====> '+ row.Account.Name);  
                let rowData = {};
                rowData.Id = row.Id;
                rowData.Name = row.Name;
                rowData.SerialNumber = row.SerialNumber,
                rowData.InstallDate = row.InstallDate;
                rowData.AccountName = row.Account.Name;
                rowData.url = window.location.protocol + '//' + window.location.host + '/lightning/r/' + row.Id + '/view';
                if (row.Product2)
                {
                    rowData.ProductName = row.Product2.Name;
                }
                else
                {
                    rowData.ProductName = 'No Product';
                }
                currentData.push(rowData);
            });
            this.assets = currentData;
            this.error = undefined;
        } else if (error) {
            this.error = error;            
        }
    }

    openWindowToPrintClick()
    {
      this[NavigationMixin.GenerateUrl]({
          type: "standard__component",
          attributes: {            
            componentName: "c__OpenAccountAssetsAura"
          },
          state: {
            c__recordId: this.recordId
          }
        }).then(url => {
          window.open(url, "_blank");
      });
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.assets));
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
        this.assets = parseData;
    }
}