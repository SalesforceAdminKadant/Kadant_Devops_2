import { LightningElement, api, wire, track } from 'lwc';

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import OPP_OBJECT from '@salesforce/schema/Opportunity';
import OPPACT_FIELD from '@salesforce/schema/Opportunity.Account_and_Site__c';
import BUDGET_FIELD from '@salesforce/schema/Opportunity.Is_the_budget_approved__c';
import CURCUS_FIELD from '@salesforce/schema/Opportunity.Are_they_a_current_customer__c';
import WHTSPC_FIELD from '@salesforce/schema/Opportunity.Are_they_a_White_Space_Target__c';
import DECISN_FIELD from '@salesforce/schema/Opportunity.We_understand_decision_making_criteria__c';
import TECHNL_FIELD from '@salesforce/schema/Opportunity.We_have_a_technical_solution_advantage__c';
import COACH_FIELD from '@salesforce/schema/Opportunity.We_have_an_internal_Coach__c';
import MAKER_FIELD from '@salesforce/schema/Opportunity.Our_Coach_is_the_final_decision_maker__c';
import INFLUNCER_FIELD from '@salesforce/schema/Opportunity.We_have_additional_relationships__c';
import ESTABL_FIELD from '@salesforce/schema/Opportunity.Competitor_has_established_business__c';
import COMPTR_FIELD from '@salesforce/schema/Opportunity.Competitor_has_a_Coach__c';
import QUALIF_FIELD from '@salesforce/schema/Opportunity.Qualification__c';
import INSITE_FIELD from '@salesforce/schema/Opportunity.Insight__c';
import RELATE_FIELD from '@salesforce/schema/Opportunity.Relationship__c';
import COMPIT_FIELD from '@salesforce/schema/Opportunity.Competition__c';
import TOTAL_FIELD from '@salesforce/schema/Opportunity.Total_Score__c';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import RECORDTYPE_FIELD from '@salesforce/schema/Opportunity.RecordTypeId';

let i = 0;

function addScore (first, second, third, fourth)
{
    var x = 0;
    var y = 0;
    var z = 0;
    var w = 0;
    var score = 0;
    if (typeof first != 'number') {
        if (!isNaN(first))
        {
            x = Number(first);
        }
    }
    else
    {
        x = first;
    }
    if (typeof second != 'number') {
        if (!isNaN(second))
        {
            y = Number(second);
        }
    }
    else
    {
        y = second;
    }
    if (typeof third != 'number') {
        if (!isNaN(third))
        {
            z = Number(third);
        }
    }
    else
    {
        z = third;
    }
    if (typeof fourth != 'number') {
        if (!isNaN(fourth))
        {
            w = Number(fourth);
        }
    }
    else
    {
        w = fourth;
    }
    score = x + y + z + w;
    return score;
}

export default class Scorecard extends LightningElement {
    @api recordId;
    @track error;
    @track dateValue;
    @track accountSite;
    @track oppRecordTypeId;
    @track budgets = [];
    @track curcus = [];
    @track whtspc = [];
    @track decision = [];
    @track technical = [];
    @track coach = [];
    @track maker = [];
    @track influencer = [];
    @track established = [];
    @track competitor = [];
    @track opportunity;
    @track selectedBudgetValue;
    @track selectedCurCusValue;
    @track selectedWhtspcValue;
    @track selectedDecisionValue;
    @track selectedTechnicalValue;
    @track selectedCoachValue;
    @track selectedMakerValue;
    @track selectedInfluencerValue;
    @track selectedEstablishedValue;
    @track selectedCompetitorValue;
    @track qualificationScore = 0;
    @track insightScore = 0;
    @track relationshipScore = 0;
    @track competitionScore = 0;
    @track totalScore = 0;

    connectedCallback(){         
        var newDate = new Date();
        this.dateValue = newDate.toISOString();
        //console.log(newDate.toISOString());
    }

    @wire(getObjectInfo, { objectApiName: OPP_OBJECT }) objectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: [OPPACT_FIELD, BUDGET_FIELD, CURCUS_FIELD, 
        WHTSPC_FIELD, DECISN_FIELD, TECHNL_FIELD, COACH_FIELD, COACH_FIELD, MAKER_FIELD, INFLUNCER_FIELD,
        ESTABL_FIELD, COMPTR_FIELD, QUALIF_FIELD, INSITE_FIELD, RELATE_FIELD, COMPIT_FIELD, 
        TOTAL_FIELD, RECORDTYPE_FIELD] })
    getOppRecordType({ error, data }){
        if(data){
            var result = JSON.parse(JSON.stringify(data));
            //console.log('opp data: ', result);
            this.opportunity = result;
            this.oppRecordTypeId = result.fields.RecordTypeId.value;
            this.accountSite = result.fields.Account_and_Site__c.value;
            this.selectedBudgetValue = result.fields.Is_the_budget_approved__c.value;
            this.budgetValue = result.fields.Is_the_budget_approved__c.value;
            this.selectedCurCusValue = result.fields.Are_they_a_current_customer__c.value;
            this.curcusValue = result.fields.Are_they_a_current_customer__c.value;
            this.selectedWhtspcValue = result.fields.Are_they_a_White_Space_Target__c.value;
            this.whtspcValue = result.fields.Are_they_a_White_Space_Target__c.value;
            this.selectedDecisionValue = result.fields.We_understand_decision_making_criteria__c.value;
            this.decisionValue = result.fields.We_understand_decision_making_criteria__c.value;
            this.selectedTechnicalValue = result.fields.We_have_a_technical_solution_advantage__c.value;
            this.technicalValue = result.fields.We_have_a_technical_solution_advantage__c.value;
            this.selectedCoachValue = result.fields.We_have_an_internal_Coach__c.value;
            this.coachValue = result.fields.We_have_an_internal_Coach__c.value;
            this.selectedMakerValue = result.fields.Our_Coach_is_the_final_decision_maker__c.value;
            this.makerValue = result.fields.Our_Coach_is_the_final_decision_maker__c.value;
            this.selectedDecisionValue = result.fields.Our_Coach_is_the_final_decision_maker__c.value;
            this.decisionValue = result.fields.Our_Coach_is_the_final_decision_maker__c.value;
            this.selectedInfluencerValue = result.fields.We_have_additional_relationships__c.value;
            this.influencerValue = result.fields.We_have_additional_relationships__c.value;
            this.selectedEstablishedValue = result.fields.Competitor_has_established_business__c.value;
            this.establishedValue = result.fields.Competitor_has_established_business__c.value;
            this.selectedCompetitorValue = result.fields.Competitor_has_a_Coach__c.value;
            this.competitorValue = result.fields.Competitor_has_a_Coach__c.value;
            this.qualificationScore = result.fields.Qualification__c.value;
            this.insightScore = result.fields.Insight__c.value;
            this.relationshipScore = result.fields.Relationship__c.value;
            this.competitionScore = result.fields.Competition__c.value;
            this.totalScore = result.fields.Total_Score__c.value;
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
    };

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: BUDGET_FIELD })
    budgetFieldInfo({ data, error }) {
        if (data) {
            //console.log("Budget Picklist: " + JSON.stringify(data));
            this.budgets = [];
            for (i = 0; i < data.values.length; i++) {
                this.budgets = [...this.budgets, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", budgetFieldInfo!";
            }
        }
    } 
    
    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: CURCUS_FIELD })
    curcusFieldInfo({ data, error }) {
        if (data) {
            //console.log("Current Customer Picklist: " + JSON.stringify(data));
            this.curcus = [];
            for (i = 0; i < data.values.length; i++) {
                this.curcus = [...this.curcus, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", curcusFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: WHTSPC_FIELD })
    whtspcFieldInfo({ data, error }) {
        if (data) {
            //console.log("Budget Picklist: " + JSON.stringify(data));
            this.whtspc = [];
            for (i = 0; i < data.values.length; i++) {
                this.whtspc = [...this.whtspc, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", whtspcFieldInfo!";
            }
        }
    }

    budgetHandler(event) {   
        this.selectedBudgetValue = event.detail.value;
        this.qualificationScore = addScore(this.selectedBudgetValue, this.selectedCurCusValue, this.selectedWhtspcValue, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Budget Value: " + this.selectedBudgetValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    curcusHandler(event) {  
        this.selectedCurCusValue = event.detail.value;
        this.qualificationScore = addScore(this.selectedBudgetValue, this.selectedCurCusValue, this.selectedWhtspcValue, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Current Customer Value: " + this.selectedCurCusValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    whtspcHandler(event) {            
        this.selectedWhtspcValue = event.detail.value;
        this.qualificationScore = addScore(this.selectedBudgetValue, this.selectedCurCusValue, this.selectedWhtspcValue, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("White Space Value: " + this.selectedWhtspcValue);                
        //console.log("Total Score: " + this.totalScore);
    }   
    
    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: DECISN_FIELD })
    decisionFieldInfo({ data, error }) {
        if (data) {
            //console.log("Decision Picklist: " + JSON.stringify(data));
            this.decision = [];
            for (i = 0; i < data.values.length; i++) {
                this.decision = [...this.decision, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", decisionFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: TECHNL_FIELD })
    technicalFieldInfo({ data, error }) {
        if (data) {
            //console.log("Decision Picklist: " + JSON.stringify(data));
            this.technical = [];
            for (i = 0; i < data.values.length; i++) {
                this.technical = [...this.technical, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", technicalFieldInfo!";
            }
        }
    }

    decisionHandler(event) {            
        this.selectedDecisionValue = event.detail.value;
        this.insightScore = addScore(this.selectedDecisionValue, this.selectedTechnicalValue, 0, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Decision Value: " + this.selectedDecisionValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    technicalHandler(event) {            
        this.selectedTechnicalValue = event.detail.value;
        this.insightScore = addScore(this.selectedDecisionValue, this.selectedTechnicalValue, 0, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Technical Value: " + this.selectedTechnicalValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: COACH_FIELD })
    coachFieldInfo({ data, error }) {
        if (data) {
            //console.log("Coach Picklist: " + JSON.stringify(data));
            this.coach = [];
            for (i = 0; i < data.values.length; i++) {
                this.coach = [...this.coach, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", coachFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: MAKER_FIELD })
    makerFieldInfo({ data, error }) {
        if (data) {
            //console.log("Maker Picklist: " + JSON.stringify(data));
            this.maker = [];
            for (i = 0; i < data.values.length; i++) {
                this.maker = [...this.maker, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", makerFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: INFLUNCER_FIELD })
    influencerFieldInfo({ data, error }) {
        if (data) {
            //console.log("Influencer Picklist: " + JSON.stringify(data));
            this.influencer = [];
            for (i = 0; i < data.values.length; i++) {
                this.influencer = [...this.influencer, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", influencerFieldInfo!";
            }
        }
    }

    coachHandler(event) {            
        this.selectedCoachValue = event.detail.value;
        this.relationshipScore = addScore(this.selectedCoachValue, this.selectedMakerValue, this.selectedInfluencerValue, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Coach Value: " + this.selectedCoachValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    makerHandler(event) {            
        this.selectedMakerValue = event.detail.value;
        this.relationshipScore = addScore(this.selectedMakerValue, this.selectedMakerValue, this.selectedInfluencerValue, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Maker Value: " + this.selectedCoachValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    influencerHandler(event) {            
        this.selectedInfluencerValue = event.detail.value;
        this.relationshipScore = addScore(this.selectedMakerValue, this.selectedMakerValue, this.selectedInfluencerValue, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Influencer Value: " + this.selectedInfluencerValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: ESTABL_FIELD })
    establishedFieldInfo({ data, error }) {
        if (data) {
            //console.log("Established Picklist: " + JSON.stringify(data));
            this.established = [];
            for (i = 0; i < data.values.length; i++) {
                this.established = [...this.established, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", establishedFieldInfo!";
            }
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$oppRecordTypeId', fieldApiName: COMPTR_FIELD })
    competitorFieldInfo({ data, error }) {
        if (data) {
            //console.log("Competitor Picklist: " + JSON.stringify(data));
            this.competitor = [];
            for (i = 0; i < data.values.length; i++) {
                this.competitor = [...this.competitor, { label: data.values[i].label, value: data.values[i].value }];                
            };
        }
        else if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message + ", competitorFieldInfo!";
            }
        }
    }

    establishedHandler(event) {            
        this.selectedEstablishedValue = event.detail.value;
        this.competitionScore = addScore(this.selectedEstablishedValue, this.selectedCompetitorValue, 0, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Established Value: " + this.selectedEstablishedValue);                
        //console.log("Total Score: " + this.totalScore);
    }

    competitorHandler(event) {            
        this.selectedCompetitorValue = event.detail.value;
        this.competitionScore = addScore(this.selectedEstablishedValue, this.selectedCompetitorValue, 0, 0);
        this.totalScore = addScore(this.competitionScore, this.relationshipScore, this.insightScore, this.qualificationScore);
        //console.log("Competitor Value: " + this.selectedCompetitorValue);    
        //console.log("Total Score: " + this.totalScore);
    }

    updateScoreCard() {
        //console.log('Opp ID: ' + this.recordId);
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[BUDGET_FIELD.fieldApiName] = this.selectedBudgetValue;
        fields[CURCUS_FIELD.fieldApiName] = this.selectedCurCusValue;
        fields[WHTSPC_FIELD.fieldApiName] = this.selectedWhtspcValue;
        fields[DECISN_FIELD.fieldApiName] = this.selectedDecisionValue;
        fields[TECHNL_FIELD.fieldApiName] = this.selectedTechnicalValue;
        fields[COACH_FIELD.fieldApiName] = this.selectedCoachValue;
        fields[MAKER_FIELD.fieldApiName] = this.selectedMakerValue;
        fields[INFLUNCER_FIELD.fieldApiName] = this.selectedInfluencerValue;
        fields[ESTABL_FIELD.fieldApiName] = this.selectedEstablishedValue;
        fields[COMPTR_FIELD.fieldApiName] = this.selectedCompetitorValue;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'This Scorecard has been Updated',
                        variant: 'success',
                    }),
                );
                return refreshApex(this.opportunity);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error on data save',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}