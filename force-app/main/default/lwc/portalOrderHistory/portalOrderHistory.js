import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getOrderHistory from '@salesforce/apex/PortalController.getOrderHistory';
import Id from '@salesforce/user/Id'; 

export default class PortalOrderHistory extends LightningElement {
    userId = Id; 
    latestActions = [];
    sortBy;
    sortDirection;
    svgImage;
    sortedDirection = 'asc';
    sortedColumn;

    @track acctId;
    @track ALL_ORDERS = [];
    @track orders = [];

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

    @wire(getOrderHistory, { acctId: '$acctId'}) 
    wiredOrderHistory({ error, data }) {
        if (data) {
            let newData = data.map((item) =>
                Object.assign({}, item, {toggleOpen:false})
            )
            this.ALL_ORDERS = newData;
            this.orders = newData;
            this.error = undefined;
        } else if (error) {
            this.error = error;            
        }
    } 

    handleHeaderAction(event) {
        const actionName = event.detail.action.name;
        const colDef = event.detail.columnDefinition;
        const cols = this.columns;

        if (actionName !== undefined && actionName !== 'all') {
            // How do I get the selected 
            this.orders = this.ALL_ORDERS.filter(_ord => _ord['TotalAmount'] === actionName);
        } else if (actionName === 'all') {
            this.orders = this.ALL_ORDERS;
        }

        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columns = [...cols];
    }

    openOrdersAction(event) {
        let index = event.target.dataset.index;
        let order = this.orders[index];

        order.toggleOpen = !order.toggleOpen;

        this.orders.forEach(element => {
            if(element.Id !== order.Id){
                let toggleIcon = this.template.querySelector('[data-order-id="' + element.Id + '"]');
                if(toggleIcon){
                   element.toggleOpen = false;
                   toggleIcon.iconName = 'utility:chevronright';
                }
            }
        });

        let toggleIcon = this.template.querySelector('[data-order-id="' + order.Id + '"]');
        if(toggleIcon && order.toggleOpen == true){
            toggleIcon.iconName = 'utility:chevrondown';
        }else if(toggleIcon && order.toggleOpen == false){
            toggleIcon.iconName = 'utility:chevronright';
        }
    }

    doSorting(event) {
        if(this.sortedColumn === event.currentTarget.dataset.id){
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        }else{
            this.sortedDirection = 'asc';
        }

        const cols = ['Name','Division__c','PoNumber','EffectiveDate','Desired_Ship_Date__c', 'TotalAmount'];
        cols.forEach(element => {
            let sortIcon = this.template.querySelector('[data-icon-id="' + element+ '"]');
            if(sortIcon){
                sortIcon.iconName = '';
            }
        });

        let sortedColIcon = this.template.querySelector('[data-icon-id="' + event.currentTarget.dataset.id + '"]');
        if(this.sortedDirection === 'asc'){
            sortedColIcon.iconName = 'utility:arrowup';
        }
        if(this.sortedDirection === 'desc'){
            sortedColIcon.iconName = 'utility:arrowdown';
        }

        let reverse = this.sortedDirection === 'asc' ? 1 : -1;
        let table = JSON.parse(JSON.stringify(this.orders));
        table.sort((a,b) => {
            return a[event.currentTarget.dataset.id] > b[event.currentTarget.dataset.id] ? 1 * reverse : -1 * reverse
        });
        this.sortedColumn = event.currentTarget.dataset.id;
        this.orders = table;
    }
}