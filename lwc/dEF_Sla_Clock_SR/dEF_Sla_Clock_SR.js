/**
 * @description       : 
 * @author            : Sofiane Bazizen (SpringFive)
 * @last modified on  : 13-04-2021
 * Modifications Log 
 * Ver   Date         Author                                    Modification
 * 1.0   13-04-2021   Sofiane Bazizen (SpringFive)              Initial Version
**/
import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getSlaDetails from '@salesforce/apex/DEF_SlaClockHelper.getSlaDetails';
import getDiff from '@salesforce/apex/DEF_SlaClockHelper.getDiff';
import TIME_ZONE from '@salesforce/i18n/timeZone';

import ACTUAL_INIT_RESP_FIELD from '@salesforce/schema/SVMXC__Service_Request__c.SVMXC__Actual_Initial_Response__c';
import INIT_RESP_FIELD from '@salesforce/schema/SVMXC__Service_Request__c.InitialResponse__c';
import INIT_RESP_CUST_BY_FIELD from '@salesforce/schema/SVMXC__Service_Request__c.InitialResponseCustomerBy__c';
import CREATED_DATE_FIELD from '@salesforce/schema/SVMXC__Service_Request__c.CreatedDate';
import BUSINESS_HOURS_FIELD from '@salesforce/schema/SVMXC__Service_Request__c.Tech_BusinessHours__c';
const fields = [ACTUAL_INIT_RESP_FIELD, INIT_RESP_FIELD, INIT_RESP_CUST_BY_FIELD, CREATED_DATE_FIELD, BUSINESS_HOURS_FIELD];
const timeZone = TIME_ZONE;

export default class DEF_Sla_Clock_SR extends LightningElement {

	@api recordId

	@track ringValue;	//Used to set the Progress ring level
    @track direction = 'fill';	//Used to define in which direction of the Progress ring will fill up.
    @track variant = 'base';	//Used to define the Progress ring visual class (ex. base; expired; warning;)
	

		
	@track data;	//Service Request fields.
	@track error;	//Error information
	@wire(getRecord, { recordId: '$recordId', fields })
    wiredRecord({error, data}) {
        if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
			this.data = undefined;
        } else if (data) {
			this.error = undefined;
			this.data = data;

			//Calling SLA handler (to calculate deadlines and update the progress ring visual)
			this.start();
        }
    }



    @track timeVal = '0:0:0:0';
	@track remainTime;
	@track deadLine;
    timeIntervalInstance;
    totalMilliseconds = 0;

	//calculate deadlines info and update the progress ring visual
	start(event) {
        var parentThis = this;	//Context

		var currentTime = new Date();	//Variable containing the current DateTime
		var initRespCustBy = getFieldValue(this.data, INIT_RESP_CUST_BY_FIELD);	//SLA deadline DateTime retrieved from the Service Request (in epoch format)
		parentThis.deadLine = Date.parse(initRespCustBy);	//updating deadLine variable with the initRespCustBy value but converted into DateTime (Non Epoch)
			
		var createdDateRaw = getFieldValue(this.data, CREATED_DATE_FIELD);	//Created DateTime of the Service Request (Epoch format)
		var createdDate = Date.parse(createdDateRaw);	//Created DateTime of the Service Request converted in DateTime from epoch.
		var actualInitRespRaw = getFieldValue(this.data, ACTUAL_INIT_RESP_FIELD);	//Date of the Actual intitial response retrieved from the Service request (epoch).
		var actualInitResp = Date.parse(actualInitRespRaw);	//Date of the Actual intitial response retrieved from the Service request converted in DateTime.

		
		//Console Display
		//console.log('timeZone ==> '+ this.timeZone);
		//console.log('currentTime ==> '+ currentTime);
		//console.log('createdDate ==> '+ createdDate);
		//console.log('deadLine ==> '+ parentThis.deadLine);
		//console.log('actualInitResp ==> '+ actualInitResp);
		

        // Run timer code in every 100 milliseconds
		var timerInterval = 1000;
        this.timeIntervalInstance = setInterval(function() {

			//console.log('@in interval function...');
			

            // Time calculations for hours, minutes, seconds and milliseconds
            var hours = Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((parentThis.totalMilliseconds % (1000 * 60)) / 1000);
            var milliseconds = Math.floor((parentThis.totalMilliseconds % (1000)));
            parentThis.timeVal = hours + ":" + minutes + ":" + seconds + ":" + milliseconds;


			currentTime = new Date();
			parentThis.ringValue = Math.round(( ( currentTime - createdDate ) / ( parentThis.deadLine - createdDate ) ) * 100);
			parentThis.remainTime = parentThis.deadLine - currentTime;


			/* If Actual init response dateTime is <= SLA Initial Response, the component display the filled up green ring */
			if(actualInitResp <= parentThis.deadLine){

				//console.log('@actualInitResp <= parentThis.deadLine...');

				//Set the ring value to 100 to fill up the component progress ring.
				parentThis.ringValue = 100;

				//Set component class to base-autocomplete to make the ring fuill upon reaching 100
				parentThis.variant = 'base-autocomplete';


				//console.log('Clearing Intervcal...');

				//Stop timer
				clearInterval(parentThis.timeIntervalInstance);

			
			}
			/* If Actual init response dateTime or current date time exeeds the SLA initial Response time then we display the Expired red ring*/
			else if(actualInitResp > parentThis.deadLine || currentTime > parentThis.deadLine){

				//console.log('@actualInitResp > parentThis.deadLine || currentTime > parentThis.deadLine...');

				parentThis.variant = 'expired';
				parentThis.ringValue = 100;

				//Stop timer
				clearInterval(parentThis.timeIntervalInstance);
			
			}
			else if(parentThis.ringValue >= 80){

				//console.log('@parentThis.ringValue >= 80...');

				parentThis.variant = 'warning';

			}
			else{
				
				//console.log('@else...');

				parentThis.variant = 'base-autocomplete';
			
			}

			
            parentThis.totalMilliseconds += timerInterval;
        }, timerInterval);
    }





	get timeZone(){
		return timeZone;
	}

	get actualInitResp() {
        return getFieldValue(this.data, ACTUAL_INIT_RESP_FIELD);
    }

	get initResp() {
        return getFieldValue(this.data, INIT_RESP_FIELD);
    }

	get createdDate() {
        return getFieldValue(this.data, CREATED_DATE_FIELD);
    }
	
	get businessHours() {
        return getFieldValue(this.data, BUSINESS_HOURS_FIELD);
    }

	get initRespCustBy() {
        return getFieldValue(this.data, INIT_RESP_CUST_BY_FIELD);
    }

	get deadLineMSG() {
        return Date.parse(getFieldValue(this.data, INIT_RESP_CUST_BY_FIELD));
    }





	


}