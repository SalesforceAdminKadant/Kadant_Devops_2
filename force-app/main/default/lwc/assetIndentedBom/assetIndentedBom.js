import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getBom from '@salesforce/apex/BomController.GetAssetBomData';

const actions = [
  { label: 'Show details', name: 'show_details' },
];

const columns = [
  {
      type: 'text',
      initialWidth: 200,
      fieldName: 'N',
      label: 'Part Number',
  },
  {
      type: 'text',
      initialWidth: 315,
      fieldName: 'D',
      label: 'Description',      
  },
  {
      type: 'number',
      initialWidth: 75,
      fieldName: 'Q',
      label: 'Qty',
  },
  { 
      type: "action", 
      typeAttributes: { rowActions: actions },
  },
];
    

export default class BomReporting extends NavigationMixin(LightningElement){
    @api recordId;
    @track bomTable = '';
    @track columns = columns;
    @track isModalOpen = false;
    @track prodId;

    @wire(getBom, { assetId: '$recordId' }) 
    wiredGetBom({ error, data }) {
        if (data) {
          if (data.includes('No BOM found'))
          {
            this.bomTable = 'No BOM found for this part';
          }
          else
          {
            //console.log('BOM data ====> '+ JSON.parse(data));  
            this.bomTable = JSON.parse(data);            
          }
          this.error = undefined;          
        } else if (error) {
            console.log('BOM Error ====> '+ this.error);     
            this.error = error;
        }
    }    

    clickToExpandAll(e) {
        const grid =  this.template.querySelector('lightning-tree-grid');
        grid.expandAll();
    }
  
    clickToCollapseAll(e) {
        const grid =  this.template.querySelector('lightning-tree-grid');
        grid.collapseAll();
    }
  
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        //console.log("Action Name: " + actionName);
        const row = event.detail.row;
        this.prodId = row.P;
        //console.log("ID: " + id);
        this.openModal();        
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
}