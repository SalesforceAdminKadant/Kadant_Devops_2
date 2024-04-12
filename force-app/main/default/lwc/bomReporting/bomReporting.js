import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getBom from '@salesforce/apex/BomController.GetBomData';

const actions = [
  { label: 'Open Product', name: 'show_details' },
  { label: 'Open Drawing', name: 'open_drawing' },
];

const columns = [
  {
      type: 'text',
      initialWidth: 150,
      fieldName: 'PN',
      label: 'Part Number',
  },
  {
      type: 'text',
      initialWidth: 350,
      fieldName: 'DN',
      label: 'Description',      
  },
  {
      type: 'number',
      initialWidth: 75,
      fieldName: 'QTY',
      label: 'Qty',
  },
  {
      type: 'text',
      initialWidth: 150,
      fieldName: 'DRG',
      label: 'Drawing',
  },
  {
      type: 'text',
      initialWidth: 75,
      fieldName: 'FAB',
      label: 'Fab?',
  },
  {
      type: 'text',
      initialWidth: 75,
      fieldName: 'POS',
      label: 'Pos.',
  },
  {
      type: 'currency',
      initialWidth: 75,
      fieldName: 'CP',
      label: 'Cost',

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
 
    @wire(getBom, { productId: '$recordId', bomType: 'Product' })  
    wiredGetBom({ error, data }) {
        if (data) {
          if (data.includes('No BOM found'))
          {
            this.bomTable = 'No BOM found for this part';
          }
          else
          {
            data = data + ']}';
            data = data.substring(0, data.length-2) + ']';
            //console.log('BOM data ====> '+ data);  
            this.bomTable = JSON.parse(data);            
          }
          this.error = undefined;          
        } else if (error) {
            console.log('BOM Error ====> '+ this.error);     
            this.error = error;
        }
    }    
   
    openWindowToPrintClick()
    {
      this.showOpenToPrint = true;
      this[NavigationMixin.GenerateUrl]({
          type: "standard__component",
          attributes: {            
            componentName: "c__OpenBomAura"
          },
          state: {
            c__recordId: this.recordId
          }
        }).then(url => {
          window.open(url, "_blank");
      });
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
      var prodId = row.PID;
      //console.log("ID: " + id);
      const drawId = row.DID;
      //console.log("Drawing ID: " + drawId);
      if (actionName == 'show_details')
      {
          this.viewProduct(prodId);
      }
      else
      {
          this.viewDrawing(drawId);
      }
    }

    viewProduct(productId) {
      this.prodId = productId;
      //console.log('View Product ID: ' + productId);
      if (productId !== '') {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: productId,
                objectApiName: 'Product2',
                actionName: 'view',
            },
          }).then(generatedUrl => {
            window.open(generatedUrl);
        });
      }
      else {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Missing Product Information',
            message: 'We could not find a Product Record!',
            variant: 'warning',
          })
        );
      }   
    }

    viewDrawing(drawingId) {  
      //console.log('View Draing ID: ' + drawingId);
      if (drawingId !== '') {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: drawingId,
                objectApiName: 'Drawing__c',
                actionName: 'view',
            },
          }).then(generatedUrl => {
            window.open(generatedUrl);
        });
      }
      else {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'No Drawing',
            message: 'We could not find a Drawing Record for this Product!',
            variant: 'warning',
          })
        );
      }      
    }

   openModal() {
      // to open modal set isModalOpen track value as true
      this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen track value as false
        this.isModalOpen = false;
    }
}