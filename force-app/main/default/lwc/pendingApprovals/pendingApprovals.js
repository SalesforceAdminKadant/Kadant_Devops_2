import { LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getPendingApprovals from '@salesforce/apex/PendingApprovalsController.getPendingApprovals';

const columns = [
    { label: 'Type', fieldName: 'RecordObject', sortable: true },
    { label: 'Pending Item', fieldName: 'RecordId', type: 'url', sortable: true, typeAttributes: { label: {fieldName: 'RecordName'}, value: {fieldname:'RecordId'}, target : '_blank'}},
    { label: 'Assigned To', fieldName: 'AssignedToName', sortable: true },
    { label: 'Approver Name', fieldName: 'ApproverName', sortable: true },
    { label: 'Date Created', fieldName: 'CreatedDate', type: 'date', sortable: true },
];
let i = 0;

export default class PendingRequests extends LightningElement {
    userId = Id;
    // for testing Chris Martin = 00560000005C1rAAAS
    //userId = '00560000005C1rAAAS';
    @track page = 1; //this will initialize 1st page
    @track items = []; //it contains all the records.
    @track data = []; //data to be displayed in the table
    @track columns; //holds column info.
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 25; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track error = '';  
    @track sortBy;
    @track sortDirection;
    @track showPaging = false;

    @wire(getPendingApprovals, { user_id: '$userId'})
    wiredPendingRequests({ error, data}) { 
        if (data) {
            for(i=0; i<data.length; i++) {
                let sfObj = data[i].SfObject;
                let theUrl = '/lightning/r/'+sfObj+'/'+data[i].RecordId+'/view';                
                //console.log('Record Name: ' + theUrl);
                //console.log("Result: " + JSON.stringify(data));
                this.items = [...this.items,
                                    {   RecordId:theUrl, 
                                        RecordName:data[i].RecordName, 
                                        RecordObject:data[i].RecordObject, 
                                        AssignedToName:data[i].AssignedToName,
                                        ApproverName:data[i].ApproverName,
                                        CreatedDate:data[i].CreatedDate}];
            }

            this.totalRecountCount = data.length;
            if (this.totalRecountCount > 20) {
                this.showPaging = true;
            }
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            //initial data to be displayed ----------->
            //slice will take 0th element and ends with 5, but it doesn't include 5th element
            //so 0 to 4th rows will be displayed in the table
            this.data = this.items.slice(0, this.pageSize);
            this.endingRecord = this.pageSize;
            this.columns = columns;
        } else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", getPendingApprovals!";
            }
        }
    }

    //clicking on previous button this method will be called
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }             
    }

    //this method displays records page by page
    displayRecordPerPage(page){

        /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
        page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
        so, slice(5,10) will give 5th to 9th records.
        */
        this.startingRecord = ((page -1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.data = this.items.slice(this.startingRecord, this.endingRecord);

        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
    } 

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.items));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // checking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.items = parseData;
        this.displayRecordPerPage(this.page);
    }
}