import { LightningElement, wire, api } from 'lwc';
import { gql, graphql } from "lightning/uiGraphQLApi";
import { createRecord} from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";

export default class IME_UploadFiles extends NavigationMixin(LightningElement) {
    @api recordId;
    ServiceAppointmentId;
    NavigationId;

    fileData;
    ContentVersionId;

    results;
    errors;

    @wire(graphql, {
      query: gql`
        query AccountWithName ($WOId: ID) {
          uiapi {
            query {
              ServiceAppointment(where: {ParentRecordId: { eq: $WOId } } ) {
                edges {
                  node {
                    Id
                    AppointmentNumber {
                      value
                    }
                  }
                }
              }
            }
          }
      }`,
      variables: "$variables",
    })
    graphqlQueryResult({ data, errors }) {
      if (data) {
        this.results = data.uiapi.query.ServiceAppointment.edges.map((edge) => edge.node);
        this.ServiceAppointmentId = this.results[0].Id;
        //console.log(this.results[0].Id);
        //console.log('Result: ' + this.results);
      }
      this.errors = errors;
      //console.log('Error: ' + this.errors);
    }

    async handleFilesSelected(event) {
        const file = event.target.files[0];
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file);
    }

    handleClick(){
        const {base64, filename, recordId} = this.fileData
        const UploadFile = {Title: filename,
                            PathOnClient: filename,
                            VersionData: base64,
                            Description: 'test File',
                            FirstPublishLocationId: recordId
        }
        //Create ContentVersion
        const payload = {apiName: 'ContentVersion', fields:UploadFile};
        createRecord(payload)
            .then(response => {
                this.ContentVersionId = JSON.stringify(response);
                console.log(this.ContentVersionId);
            });
        
        if (this.recordId.slice(0,3) == '0WO') {
          this.NavigationId = this.ServiceAppointmentId;
        } else {
          this.NavigationId = this.recordId;
        }

        console.log(this.recordId);
        console.log(this.NavigationId);

        this[NavigationMixin.Navigate]({
                type: "standard__webPage",
                attributes: {
                    url: "com.salesforce.fieldservice://v1/sObject/"+this.NavigationId
                }
            });
    }

    //Query Variables
    get variables() {
      return {
        WOId: this.recordId,
      };
    }
}