import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getTasks from '@salesforce/apex/VisitReportController.GetTask';
import GetContacts from '@salesforce/apex/VisitReportController.GetContacts';
import getObjects from '@salesforce/apex/FieldPickerController.getObjects';

export default class KBC_VisitReport extends NavigationMixin(LightningElement) {
    @api recordId;
    @track Tasks;
    @track Contacts;

    @wire(getTasks, {visitReportId: '$recordId' })
    wiredGetTasks({ error, data }) {
        if (data) {
            var accDatatask = JSON.stringify(data);
            this.Tasks = JSON.parse(accDatatask); 
            console.log('Tasks ====> ' + JSON.stringify(JSON.parse(accDatatask)));
            this.error = undefined;          
        } else if (error) {
            console.log('Tasks ====> Error:'+ this.error);     
            this.error = error;
        }

    };


    @wire(GetContacts, {visitReportId: '$recordId' })
    wiredGetContacts({ error, data }) {
        if (data) {
            var accDataContact = JSON.stringify(data);
            this.Contacts = JSON.parse(accDataContact); 
            //console.log('Contacts ====> ' + JSON.stringify(JSON.parse(accDataContact)));
            this.error = undefined;          
        } else if (error) {
            console.log('Contacts ====> Error:'+ this.error);     
            this.error = error;
        }

    };


    handleRowAction(event) {
        const actionTarget = event.target.id;
        //alert(actionTarget.substring(0, 18));
        window.open('/'+actionTarget.substring(0, 18),"_blank");
        
        /*
        //console.log(actionTarget.substring(0, 18));
        //alert(actionTarget);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: actionTarget.substring(0, 18),
                //objectApiName: 'Case', // objectApiName is optional
                actionName: 'view'
            }
        });
       */
    };

    handleClick(event) {
        //alert(this.recordId)
        window.open('/lightning/o/Task/new?defaultFieldValues=Visit_Report__c='+this.recordId, "_self");
    };
}