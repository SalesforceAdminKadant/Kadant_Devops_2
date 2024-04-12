import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NOZ_HEIGHT from '@salesforce/schema/Machine_Mapping_Cleaning__c.Distance_to_Fabric_Roll__c';
import NOZ_ANGLE from '@salesforce/schema/Machine_Mapping_Cleaning__c.Nozzle_Fan_Angle__c';
import NOZ_SPACE from '@salesforce/schema/Machine_Mapping_Cleaning__c.Nozzle_Spacing__c';
import NOZ_NUM from '@salesforce/schema/Machine_Mapping_Cleaning__c.Nozzle_Quantity__c';
import NOZ_CODE from '@salesforce/schema/Machine_Mapping_Cleaning__c.Nozzle_Code__c';
import SHOWER from '@salesforce/resourceUrl/shower_spray';
import NOZZLE from '@salesforce/resourceUrl/nozzle_angle';

function getPercentCover (nozSprayWidth, distance, num, n) {
    var coverage = 0.0;    
    var m = Math.floor(nozSprayWidth / distance, 0) + 1;

    if (n == m)
    {
        coverage = 100 * (num - (m - 1)) * (nozSprayWidth - distance * (m - 1)) / (distance * (num - 1) + nozSprayWidth);
    }
    else if (n == (m - 1))
    {
        if (m > 1)
        {
            coverage = 100 * (2 * distance + (num - m) / (m - 1) * (nozSprayWidth - m * (nozSprayWidth - distance * (m - 1)))) / (distance * (num - 1) + nozSprayWidth); 
        }
        else
        {
            coverage = 100 * (num - 1) * (distance - nozSprayWidth) / (distance * (num - 1) + nozSprayWidth);
        }
    }
    else if (n <= (m - 2))
    {
        coverage = 100 * 2 * distance / (distance * (num - 1) + nozSprayWidth);
    }
    else
    {
        coverage = 0;
    }
    return coverage;
}

function getRotationAngle (nozzle_code)
{
    //console.log("Nozzle Code in: " + nozzle_code);
    var angle = 5;
    if (typeof nozzle_code != "undefined")
    {
        if (nozzle_code != null)       
        {        
            var theCode = nozzle_code.substring(0,2);
            if (["FF","FH","PN","PT","PP"].indexOf(theCode) > -1)
            {
                angle = 0;
            }
        }
    }
    return angle;
}

export default class ShowerCalculation extends LightningElement {
    @api showerID;
    @api showTitle;

    @wire(getRecord, { recordId: '$showerID', fields: [NOZ_HEIGHT, NOZ_ANGLE, NOZ_SPACE, NOZ_NUM, NOZ_CODE] }) shower;

    shower_spray = SHOWER;
    nozzle_angle = NOZZLE;

    @track spray;
    @track sangle;
    @track nangle;
    @track distant;
    @track num;
    @track ncode;
    @track swidth = '';
    @track twidth = '';
    @track nocover = '';
    @track single = '';
    @track double = '';
    @track triple = '';
    @track fourth = '';
    @track total = '';
   
    get sheight() {
        this.spray = getFieldValue(this.shower.data, NOZ_HEIGHT);
        return getFieldValue(this.shower.data, NOZ_HEIGHT);
    }

    get nozangle() {
        this.sangle = getFieldValue(this.shower.data, NOZ_ANGLE);
        return getFieldValue(this.shower.data, NOZ_ANGLE);
    }

    get nozspace() {
        this.distant = getFieldValue(this.shower.data, NOZ_SPACE);
        return getFieldValue(this.shower.data, NOZ_SPACE);
    }

    get noznum() {
        this.num = getFieldValue(this.shower.data, NOZ_NUM);
        return getFieldValue(this.shower.data, NOZ_NUM);
    }

    get nozcode() {
        this.ncode = getFieldValue(this.shower.data, NOZ_CODE);
        var code = getFieldValue(this.shower.data, NOZ_CODE);        
        return getRotationAngle(code);
    }

    calculateClick(event)
    {
        var inp = this.template.querySelectorAll("lightning-input");
        inp.forEach(function(element){
            if(element.name=="sprayHeight")
                this.spray = element.value;

            else if(element.name=="sprayAngle")
                this.sangle = element.value;

            else if(element.name=="rotationAngle")
                this.nangle = element.value;

            else if(element.name=="distanceToNozzles")
                this.distant = element.value;

            else if(element.name=="numberOfNozzles")
                this.num = element.value;
        },this);

        //this.nangle = getRotationAngle(this.nozcode);
        
        var sprayWidth = 2 * this.spray * Math.tan(this.sangle/2*Math.PI/180) * Math.cos(this.nangle*Math.PI/180);
        //console.log("Spray Width: " + sprayWidth);
        this.swidth = sprayWidth.toFixed(1);
        var totalSprayWidth = (this.num - 1) * this.distant + sprayWidth;
        totalSprayWidth = Math.round(totalSprayWidth, 0);
        this.twidth = totalSprayWidth.toFixed(0);
        //console.log("Total Spray Width: " + totalSprayWidth);

        // No Coverage calc: If distance > Spray Width then call helper function else 0
        var noCoverage = 0.0;
        if (this.distant > sprayWidth)
        {
            noCoverage = getPercentCover(sprayWidth, this.distant, this.num, 0);
        }
        this.nocover = noCoverage.toFixed(1);       

        var singleCoverage = getPercentCover(sprayWidth, this.distant, this.num, 1);
        this.single = singleCoverage.toFixed(1);
        var doubleCoverage = getPercentCover(sprayWidth, this.distant, this.num, 2);       
        this.double = doubleCoverage.toFixed(1);
        var tripleCoverage = getPercentCover(sprayWidth, this.distant, this.num, 3);       
        this.triple = tripleCoverage.toFixed(1);
        var fourCoverage = getPercentCover(sprayWidth, this.distant, this.num, 4);       
        this.fourth = fourCoverage.toFixed(1);

        var totalCoverage = 0.00;
        totalCoverage = noCoverage + singleCoverage + doubleCoverage + tripleCoverage + fourCoverage;  
        this.total = totalCoverage.toFixed(1);        

        //console.log("I'm out!!");
    }
}