import { LightningElement, api, wire, track } from 'lwc';
import getImageList from '@salesforce/apex/MachineSectionController.getImageList';


export default class ServiceReportImages extends LightningElement {
    @api recordId;  // Gets the Current Service Report
    @track sriId;
    @track imageUrl;
    @track title;
    @track description;
    @track isModalOpen = false;

    @wire(getImageList, { sri_id: '$recordId'}) images;

    openModal(event) {
        // to open modal set isModalOpen track value as true
        //console.log("Image ID: " + event.currentTarget.dataset.imgurl);
        this.imageUrl = event.currentTarget.dataset.imgurl;
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isModalOpen = false;
    }
}