import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import getMachines from '@salesforce/apex/PortalController.getMachines';
import Id from '@salesforce/user/Id'; 

export default class PortalAccountMachines extends NavigationMixin(LightningElement) {
    userId = Id;
    macsections = [];
    latestActions = [];
    sortBy;
    sortDirection;
    svgImage;
    sortedDirection = 'asc';
    sortedColumn;
    
    @track acctId;
    @track  machines = [];
    @track  ALL_MACHINES = [];

    @wire(getRecord, { recordId: '$userId', fields: ['User.AccountId'] })
    userData({error, data}) {
        if(data) {
            //window.console.log('data ====> '+JSON.stringify(data));
            let objCurrentData = data.fields;            
            this.objUser = {                
                AccountId : objCurrentData.AccountId.value,
            }
            // Finch Account ID:
            //this.acctId = '0013000000DK6EFAA1';
            this.acctId = objCurrentData.AccountId.value;
            console.log('Account ID: ' + this.acctId);
        } 
        else if(error) {
            window.console.log('error ====> '+JSON.stringify(error))
        } 
    }

    @wire(getMachines, { acctId: '$acctId'}) 
    wiredMachines({ error, data }) {
        if (data) {
            //window.console.log('Machine data ====> '+JSON.stringify(data));
            let newData = data.map((item) =>
                Object.assign({}, item, {toggleOpen:false})
            )
            this.ALL_MACHINES = newData;
            this.machines = newData;
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
            this.machines = this.ALL_MACHINES.filter(_mac => _mac['Machine_Status__c'] === actionName);
        } else if (actionName === 'all') {
            this.machines = this.ALL_MACHINES;
        }

        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columns = [...cols];
    }

    openSectionsAction(event) {
        let index = event.target.dataset.index;
        let machine = this.machines[index];

        machine.toggleOpen = !machine.toggleOpen;

        this.machines.forEach(element => {
            if(element.Id !== machine.Id){
                let toggleIcon = this.template.querySelector('[data-machine-id="' + element.Id + '"]');
                if(toggleIcon){
                   element.toggleOpen = false;
                   toggleIcon.iconName = 'utility:chevronright';
                }
            }
        });

        let toggleIcon = this.template.querySelector('[data-machine-id="' + machine.Id + '"]');
        if(toggleIcon && machine.toggleOpen == true){
            toggleIcon.iconName = 'utility:chevrondown';
        }else if(toggleIcon && machine.toggleOpen == false){
            toggleIcon.iconName = 'utility:chevronright';
        }
    }

    doSorting(event) {
        if(this.sortedColumn === event.currentTarget.dataset.id){
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        }else{
            this.sortedDirection = 'asc';
        }

        const cols = ['Name','Grade_Category__c','Primary_Grade__c','Machine_Status__c'];
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
        let table = JSON.parse(JSON.stringify(this.machines));
        table.sort((a,b) => {
            return a[event.currentTarget.dataset.id] > b[event.currentTarget.dataset.id] ? 1 * reverse : -1 * reverse
        });
        this.sortedColumn = event.currentTarget.dataset.id;
        this.machines = table;
    }
}