/**
 * @author: Sofiane Bazizen (SpringFive)
 * @description: Send emails to the relevant entitled Contacts for "Completed" Work Order 
 * @last modified on  : 2020-01-11
 * @last modified by  : Sofiane Bazizen
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2020-01-11   Sofiane Bazizen					  Initial Version
*/
public class DEF_WO_SirSender {

	@InvocableMethod(label = 'Send Email To Contacts With Related Files')
	public static void SendEmailToContacts(List<SVMXC__Service_Order__c> workorderRecords) {

		System.debug('@In DEF_WO_SirSender.SendEmailToContacts method...');
		System.debug('@List, workorderRecord: ' + workorderRecords);

		//Key: Work Order Id, Value: Wrapper containing the WO info + parent Contracts + emails of the recipients.
		Map<Id, DEF_WO_SirSender_Helper.woWrapper> woWrapperMap = new Map<Id, DEF_WO_SirSender_Helper.woWrapper> ();

		//List of Contract Ids from which we want to retrive the entitled contacts.
		Set<Id> serviceContractIdSet = new Set<Id> ();

		//Set of Work Order Ids
		Set<Id> workOrderSet = new Set<Id> ();

		//Create Map of WorkOrder Id-->WorkOrder
		Map<Id, SVMXC__Service_Order__c> workOrderMap = new Map<Id, SVMXC__Service_Order__c> (workorderRecords);

		//populating the workOrderSet with List of WorkOrder Id
		workOrderSet = workOrderMap.keySet();

		//retrieving Work Order parent contract data from the workorderRecords list
		String woQuery = DEF_WO_SirSender_Helper.woQuery;
		for (SVMXC__Service_Order__c wo : Database.query(woQuery)) {

			System.debug('@wo: ' + wo);
			woWrapperMap.put(wo.Id, new DEF_WO_SirSender_Helper.woWrapper(wo));
			serviceContractIdSet.addAll(woWrapperMap.get(wo.Id).getcontractIdSet());

		}

		System.debug('@woWrapperMap: ' + woWrapperMap);

		if (!woWrapperMap.isEmpty()) {
			//Retrieving Contracts with related Entitled Contacts (only the Ent Contacts who must receive the SIR).
			String scQuery = DEF_WO_SirSender_Helper.scQuery;
			Map<Id, SVMXC__Service_Contract__c> scMap = new Map<Id, SVMXC__Service_Contract__c> ((List<SVMXC__Service_Contract__c>) Database.query(scQuery));


			//Populating the Wo Wrapper with the relevant emails.
			for (DEF_WO_SirSender_Helper.woWrapper wrp : woWrapperMap.values()) {

				System.debug('@wrp.getcontractIdSet(): ' + wrp.getcontractIdSet());


				for (String scId : wrp.getcontractIdSet()) {

					if(scMap.containsKey(scId)){
						wrp.addItemsToEmailSet(scMap.get(scId).R00N70000001hzcxEAA);
					}
					
				}



			}

			//Retrieving SIR attachments.
			DEF_WO_SirSender_Helper.retrieveSirAttachments(woWrapperMap);

			//Sending emails
			DEF_WO_SirSender_Helper.sendSirEmails(woWrapperMap);


			/*****************************************************************/
			/*                        LOG DISPLAY                            */
			/*****************************************************************/
			System.debug('');
			System.debug('@Contract info');
			for (SVMXC__Service_Contract__c sc : scMap.values()) {
				System.debug('@Contract: ' + sc);
				System.debug('@associated ent contacts: ');
				for (SVMXC__Service_Contract_Contacts__c eCt : sc.R00N70000001hzcxEAA) {
					System.debug('@full Name: ' + eCt.Full_Name__c);
				}

			}


			System.debug('');
			System.debug('@Wrapper info');
			for (DEF_WO_SirSender_Helper.woWrapper wrp : woWrapperMap.values()) {

				System.debug('');
				System.debug('@wo Id: ' + wrp.getWo().Id);
				System.debug('@wo Contracts: ' + wrp.getcontractIdSet());
				System.debug('@wo emails: ' + wrp.getemailSet());
				System.debug('@Technician email: ' + wrp.getTechEmail());
				System.debug('@Attachments: ' + wrp.getAttachmentList());
				System.debug('@===============');

			}

			/*****************************************************************/
			/*                        END LOG DISPLAY                        */
			/*****************************************************************/

		}





	}
}