/**
 * @description       : Apex helper used to caalculate SLA info for the Service Request.
 * @author            : Sofiane Bazizen (SpringFive)
 * @last modified on  : 13-04-2021
 * Modifications Log 
 * Ver   Date         Author                                    Modification
 * 1.0   13-04-2021   Sofiane Bazizen (SpringFive)              Initial Version
 **/
public class DEF_SlaClockHelper {

	

	/*-----------Wrappers----------*/

	public class slaInfoWrapper {

		@AuraEnabled Public Id srId { get; set; }
		@AuraEnabled Public Datetime initRespCustBy { get; set; }

	}

	public class srWrapper {

		@InvocableVariable Public Id srId;
		@InvocableVariable Public Datetime startDate;
		@InvocableVariable Public Id bhId;
		@InvocableVariable Public Decimal initResp;
		@InvocableVariable Public Datetime initRespCustBy;

	}

	public class slaInfoWrapper2 {

		@InvocableVariable(label='sr Id' description='sr Id' required=true)
		Public Id srId;
		@InvocableVariable(label='init deadline' description='init deadline' required=true)
		Public Datetime initRespCustBy;

	}


	/**
	 * @description : Update the relevant Service Request Initial Response Deadline based on the Sla Term and Business hours.
	 * @param srIdList : List of Service Request Ids
	 */
	@InvocableMethod
	public static List<slaInfoWrapper2> setSrSla(List<srWrapper> srWrapperList) {

		System.debug('@In DEF_SlaClockHelper.setSrSla');

		List<slaInfoWrapper2> slaWrapperList = new List<slaInfoWrapper2>();

		Id bhId;
		Datetime startDate;
		Long interval;
		Datetime initRespCustBy;

		for (srWrapper sr: srWrapperList){

			bhId = sr.bhId;
			startDate = sr.startDate;
			interval = (Long) sr.initResp * 60 * 1000;

			initRespCustBy = BusinessHours.add(bhId, startDate, interval);

			System.debug('@startDate: ' + startDate);
			System.debug('@initResp: ' + sr.initResp);
			System.debug('@interval: ' + interval);
			System.debug('@initRespCustBy: ' + initRespCustBy);

			slaInfoWrapper2 slaW = new slaInfoWrapper2();
			slaW.srId = sr.srId;
			slaW.initRespCustBy = initRespCustBy;

			slaWrapperList.add(slaW);

		}

		return slaWrapperList;


	}



	/**
	 * @description : Returns the time spent between to dateTime taking into account the Business Hours
	 * @param st : Start DateTime
	 * @param et : End DateTime
	 * @param bhId : Business Hours Id
	 */
	@AuraEnabled
	public static Decimal getDiff(Id bhId, DateTime st, Datetime et) {

		System.debug('@In DEF_SlaClockHelper.getDiff method...');

		Decimal result = BusinessHours.diff(bhId, st, et);
		Decimal resultInMinutes = result / 1000 / 60;

		System.debug('@result: ' + result);
		System.debug('@resultInMinutes: ' + resultInMinutes);

		return result;

	}

	@AuraEnabled(Cacheable = true)
	public static slaInfoWrapper getSlaDetails(Id srId) {

		Id bhId;
		Datetime startDate;
		Long interval;

		SVMXC__Service_Request__c sr = [
		                                SELECT Id, CreatedDate, SVMXC__Actual_Initial_Response__c, InitialResponse__c, Tech_BusinessHours__c
		                                FROM SVMXC__Service_Request__c
		                                WHERE Id = :srId];

		bhId = sr.Tech_BusinessHours__c;
		startDate = sr.CreatedDate;
		interval = (Long) sr.InitialResponse__c * 60 * 1000;

		Datetime initRespCustBy = BusinessHours.add(bhId, startDate, interval);

		System.debug('@startDate: ' + startDate);
		System.debug('@initResp: ' + sr.InitialResponse__c);
		System.debug('@interval: ' + interval);
		System.debug('@initRespCustBy: ' + initRespCustBy);

		slaInfoWrapper slaW = new slaInfoWrapper();
		slaW.initRespCustBy = initRespCustBy;

		return slaW;

	}

}