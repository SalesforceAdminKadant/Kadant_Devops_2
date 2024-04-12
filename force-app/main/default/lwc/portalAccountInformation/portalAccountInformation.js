import { LightningElement, track, wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id'; 
import getAccountShippingAddress from '@salesforce/apex/PortalController.getAccountShippingAddress';
import getDsm from '@salesforce/apex/PortalController.getDsm';
import getRelatedAccounts from '@salesforce/apex/PortalController.getUserRelatedAccounts';


import USER_ID_FIELD from '@salesforce/schema/User.Id';
import PORTAL_ACCOUNT_SELECTION_FIELD from '@salesforce/schema/User.Portal_Account_Selection__c';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';

export default class PortalAccountInformation extends LightningElement {    
    userId = Id;
    @track acctId;
    @track acctName;
    @track dsmId;
    @track dsmName;
    @track dsmPhone;
    @track dsmEmail;
    @track objUser = {};
    @track error;   //this holds errors
    @track street;
    @track city;
    @track state;
    @track zip;
    @track country;
    @track selectedAccountId;
    @track allRelatedAccounts = [];

    @wire(getRecord, { recordId: '$userId', fields: ['User.FirstName', 'User.LastName', 'User.Name', 'User.AccountId'] })
    userData({error, data}) {
        if(data) {
            //window.console.log('data ====> '+JSON.stringify(data));
            let objCurrentData = data.fields;            
            this.objUser = {
                FirstName : objCurrentData.FirstName.value,
                LastName : objCurrentData.LastName.value,
                Name : objCurrentData.Name.value,
                AccountId : objCurrentData.AccountId.value,
            }
            this.acctId = objCurrentData.AccountId.value;
            //console.log('Account ID: ' + this.acctId);
        } 
        else if(error) {
            window.console.log('error ====> '+JSON.stringify(error))
        } 
    }

    @wire(getAccountShippingAddress, { id: '$acctId'})
    wiredOfficeLocations({ error, data }) {
        if (data) {     
            //window.console.log('Account Data ====> '+ JSON.stringify(data));  
            this.acctName = data.Name;
            this.dsmId = data.KSD_DSM__c;
            this.street = data.ShippingAddress.street;
            this.city = data.ShippingAddress.city;
            this.state = data.ShippingAddress.state;
            this.zip = data.ShippingAddress.postalCode;
            this.country = data.ShippingAddress.country;   
        }        
        else if (error) {
            window.console.log('error ====> '+JSON.stringify(error))
        }
    }
    
    @wire(getDsm, { id: '$dsmId'})
    wiredDsm({ error, data }) {
        if (data) {     
            //window.console.log('DSM data ====> '+ JSON.stringify(data));  
            this.dsmName = data.Name;
            this.dsmPhone = data.MobilePhone;
            this.dsmEmail = data.Email;            
        }        
        else if (error) {
            window.console.log('error ====> '+JSON.stringify(error))
        }
    }

    @wire(getRelatedAccounts, {})
    relatedAccounts({ error, data }) {
        if (data) {
            for(var i=0; i<data.length; i++) {
                this.allRelatedAccounts = [...this.allRelatedAccounts ,{value: data[i].accountId , label: data[i].accountName}];
                if(data[i].isCurrentPortalSelectedAccount == true){
                    this.selectedAccountId = data[i].accountId;
                }
            }
        }
        else if (error) {
            window.console.log('error ====> '+JSON.stringify(error))
        }
    }

    handleAccountSelection(event){
        const selectedAccountValue = event.detail.value;
        this.selectedAccountId = selectedAccountValue;
        this.updateUser();
    }

    updateUser() {
        const fields = {};
        fields[USER_ID_FIELD.fieldApiName] = this.userId;
        fields[PORTAL_ACCOUNT_SELECTION_FIELD.fieldApiName] = this.selectedAccountId;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account selection updated!',
                        variant: 'success'
                    })
                );
                // Display fresh data in the form
                //return refreshApex(this.contact);
                location.reload();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating account selection.',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}