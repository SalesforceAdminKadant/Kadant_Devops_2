import { LightningElement, track, api, wire } from 'lwc';
import getKbcRotorRepairList from '@salesforce/apex/PortalController.getRotorRepairList';
import getKbcRotorRepair from '@salesforce/apex/PortalController.getRotorRepair';

// row actions
const actions = [
    { label: 'Open Details', name: 'open_details'}
];

export default class portalRotorRepairStatus extends LightningElement {
    @api recordId;
    @track showTracking = false;
    @track isModalOpen = false;
    // Paging settings
    data = [];
    @track page = 1;
    perpage = 5;
    @track pages = [];
    set_size = 5;
    @track error;
    @track the_acct;
    @track the_name;
    @track the_rma;
    @track the_order;
    @track the_status;
    @track the_tracking;
    @track the_shipped;
    @track the_carrier;

    // fields from Controller
    // Id, Name, Account_Name__c, Status__c, RMA__c, Order_Number__c, Shipped_Date__c, Tracking_Number__c
    @track columns = [
        { label: 'RMA Number', fieldName: 'RMA__c', type: 'text', editable: false },
        { label: 'Order Number', fieldName: 'Order_Number__c', type: 'text', editable: false },
        { label: 'Status', fieldName: 'Status__c', type: 'text', editable: false },
        { label: 'Shipped Date', fieldName: 'Shipped_Date__c', type: 'date', editable: false, 
            typeAttributes:{
                month: "short",
                day: "2-digit",
                year: "numeric"
            }
        },
        { label: 'Tracking Number', fieldName: 'Tracking_Number__c', type: 'text', editable: false },
        { type: 'action', typeAttributes: { rowActions: actions } },
    ];

    renderedCallback() {
        this.renderButtons();
    }

    renderButtons = () => {
        this.template.querySelectorAll('button').forEach((but) => {
            but.style.backgroundColor = this.page === parseInt(but.dataset.id, 10) ? 'dodgerblue' : 'white';
            but.style.color = this.page === parseInt(but.dataset.id, 10) ? 'white' : 'black';
        });
    }

    get pagesList() {
        let mid = Math.floor(this.set_size / 2) + 1;
        if (this.page > mid) {
            return this.pages.slice(this.page - mid, this.page + mid - 1);    
        }
        return this.pages.slice(0, this.set_size);
    }

    async connectedCallback() {
        this.data = await getKbcRotorRepairList();
        this.setPages(this.data);        
    }
    
    pageData = () => {
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page * perpage) - perpage;
        let endIndex = (page * perpage);
        return this.data.slice(startIndex, endIndex);
    }

    setPages = (data) => {
        let numberOfPages = Math.ceil(data.length / this.perpage);
        for (let index = 1; index <= numberOfPages; index++) {
            this.pages.push(index);
        }
    }

    get hasPrev() {
        return this.page > 1;
    }

    get hasNext() {
        return this.page < this.pages.length
    }

    onNext = () => {
        ++this.page;
    }

    onPrev = () => {
        --this.page;
    }

    onPageClick = (e) => {
        this.page = parseInt(e.target.dataset.id, 10);
    }

    get currentPageData() {
        return this.pageData();
    }

    handleRowAction(event){
        const row = event.detail.row;
        this.recordId = row.Id;
        //console.log("Inside Handle Row Action Record ID: " + this.recordId);
        getKbcRotorRepair({id: this.recordId})
        // then/catch is a Javascript Promise!!
            .then(result => {
                let data = result;
                //this.contacts = result;	
                //console.log("Item: " + JSON.stringify(data));
                this.the_acct = data.Account_Name__c;
                this.the_name = data.Name;
                this.the_rma = data.RMA__c;
                this.the_order = data.Order_Number__c;
                let trak = data.Status__c;
                if (trak == 'Shipped')
                {
                    this.showTracking = true;
                }
                else
                {
                    this.showTracking = false;
                }
                this.the_status = trak;
                this.the_tracking = data.Tracking_Number__c;
                this.the_shipped = data.Shipped_Date__c;
                this.the_carrier = data.Carrier__c;
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

    submitDetails() {
        this.isModalOpen = false;
    }
}