import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getQuoteHistory from '@salesforce/apex/PortalController.getQuoteHistory';
import Id from '@salesforce/user/Id'; 

export default class PortalQuoteHistory extends LightningElement {
    userId = Id; 
    latestActions = [];
    sortBy;
    sortDirection;
    svgImage;
    sortedDirection = 'asc';
    sortedColumn;

    @track acctId;
    @track ALL_QUOTES = [];
    @track quotes = [];

    @wire(getRecord, { recordId: '$userId', fields: ['User.AccountId'] })
    userData({error, data}) {
        if(data) {
            //window.console.log('data ====> '+JSON.stringify(data));
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

    @wire(getQuoteHistory, { acctId: '$acctId'}) 
    wiredQuoteHistory({ error, data }) {
        if (data) {
            //console.log('Account ID: ' + this.acctId);
            //window.console.log('data ====> '+JSON.stringify(data));
            let newData = data.map((item) =>
                Object.assign({}, item, {toggleOpen:false})
            )
            this.ALL_QUOTES = newData;
            this.quotes = newData;
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
            this.quotes = this.ALL_QUOTES.filter(_ord => _ord['TotalAmount'] === actionName);
        } else if (actionName === 'all') {
            this.quotes = this.ALL_QUOTES;
        }

        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columns = [...cols];
    }

    openQuotesAction(event) {
        let index = event.target.dataset.index;
        let quote = this.quotes[index];

        quote.toggleOpen = !quote.toggleOpen;

        this.quotes.forEach(element => {
            if(element.Id !== quote.Id){
                let toggleIcon = this.template.querySelector('[data-quote-id="' + element.Id + '"]');
                if(toggleIcon){
                   element.toggleOpen = false;
                   toggleIcon.iconName = 'utility:chevronright';
                }
            }
        });

        let toggleIcon = this.template.querySelector('[data-quote-id="' + quote.Id + '"]');
        if(toggleIcon && quote.toggleOpen == true){
            toggleIcon.iconName = 'utility:chevrondown';
        }else if(toggleIcon && quote.toggleOpen == false){
            toggleIcon.iconName = 'utility:chevronright';
        }
    }

    doSorting(event) {
        if(this.sortedColumn === event.currentTarget.dataset.id){
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        }else{
            this.sortedDirection = 'asc';
        }

        const cols = ['Quote_Number__c','Opportunity.Name','Quote_Total__c'];
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
        let table = JSON.parse(JSON.stringify(this.quotes));
        table.sort((a,b) => {
            return a[event.currentTarget.dataset.id] > b[event.currentTarget.dataset.id] ? 1 * reverse : -1 * reverse
        });
        this.sortedColumn = event.currentTarget.dataset.id;
        this.quotes = table;
    }
}