import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuoteDisplayData from '@salesforce/apex/PortalController.getQuoteDisplayData';
import Id from '@salesforce/user/Id'; 

export default class PortalOpenQuotes extends NavigationMixin(LightningElement) {
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
            console.log('Account data ====> '+JSON.stringify(data));
            let objCurrentData = data.fields;            
            this.objUser = {                
                AccountId : objCurrentData.AccountId.value,
            }
            this.acctId = objCurrentData.AccountId.value;
            console.log('Account ID: ' + this.acctId);
        } 
        else if(error) {
            window.console.log('error ====> '+JSON.stringify(error))
        } 
    }

    @wire(getQuoteDisplayData, { acctId: '$acctId'}) 
    wiredQuotes({ error, data }) {
        console.log('Inside get Quote Data!');
        if (data) {
            //console.log('Quote Display data ====> '+ JSON.stringify(data));
            let newData = data.map((item) =>
                Object.assign({}, item, {toggleOpen:false})
            )
            this.ALL_QUOTES = newData;
            this.quotes = newData;            
            this.error = undefined;
        } else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
            console.log('ERROR: ' + JSON.stringify(this.error));
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

    doSorting(event) {
        if(this.sortedColumn === event.currentTarget.dataset.id){
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        }else{
            this.sortedDirection = 'asc';
        }

        const cols = ['sfUrl','quoteName','quoteDate','expDate','quoteTotal'];
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

    doWarning() {        
        const event = new ShowToastEvent({
            // Show Toast that the Quote hasn't been found
            title: 'Kadant Information',
            message:
                'Contact your Kadant representative for a copy of the Quote.',
        });
        this.dispatchEvent(event);
    }
}