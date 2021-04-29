/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-14-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public without sharing class DEF_SC_TriggerHelper {

    public static void createIncludedServices(List<SVMXC__Service_Contract__c> scList,Set<Id> servicePlanSet) {
        String soQuery=DEF_StringHelper.soQuery;
        //Query Service Offering those are related to the Service Plan
        List<SVMXC__Service_Offerings__c> serviceOfferingList=(List<SVMXC__Service_Offerings__c>) Database.query(soQuery);
        Map<Id,List<SVMXC__Service_Offerings__c>> spToServiceOfferingMap=new Map<Id,List<SVMXC__Service_Offerings__c>>();
        List<SVMXC__Service_Contract_Services__c> includedServiceList=new List<SVMXC__Service_Contract_Services__c>();
        //Create Map with key as Service Plan Id and value as related service offering
        for(SVMXC__Service_Offerings__c soInstance:serviceOfferingList){
            if(spToServiceOfferingMap.containsKey(soInstance.SVMXC__Service_Plan__c)){
                List<SVMXC__Service_Offerings__c> soExistingList=spToServiceOfferingMap.get(soInstance.SVMXC__Service_Plan__c);
                soExistingList.add(soInstance);
                spToServiceOfferingMap.put(soInstance.SVMXC__Service_Plan__c,soExistingList);
            }
            else{
                List<SVMXC__Service_Offerings__c> soNewList=new List<SVMXC__Service_Offerings__c>();
                soNewList.add(soInstance);
                spToServiceOfferingMap.put(soInstance.SVMXC__Service_Plan__c,soNewList);
            }
        }
         
        for(SVMXC__Service_Contract__c scInstance:scList){
            if(spToServiceOfferingMap.containsKey(scInstance.SVMXC__Service_Plan__c)){
                //Get List<Service Offering> of current service contract
                List<SVMXC__Service_Offerings__c> soInstanceList=spToServiceOfferingMap.get(scInstance.SVMXC__Service_Plan__c);
                for(SVMXC__Service_Offerings__c soInstance:soInstanceList){
                    SVMXC__Service_Contract_Services__c includedServicesInstance=new SVMXC__Service_Contract_Services__c();
                    //Mapping to create Included services from service offering
                    // Field: Allowed Units
                    if(soInstance.SVMXC__Included_Units__c!=null){
                        includedServicesInstance.SVMXC__Included_Units__c=soInstance.SVMXC__Included_Units__c;
                    }
                    // Field: Expense Discount - Not Covered
                    if(soInstance.SVMXC__Expense_Discount_Not_Covered__c!=null){
                        includedServicesInstance.SVMXC__Expense_Discount_Not_Covered__c=soInstance.SVMXC__Expense_Discount_Not_Covered__c;
                    }
                    // Field: Expense Discount Covered
                    if(soInstance.SVMXC__Expense_Discount_Covered__c!=null){
                        includedServicesInstance.SVMXC__Expense_Discount_Covered__c=soInstance.SVMXC__Expense_Discount_Covered__c;
                    }
                    // Field: Labor Discount - Not Covered
                    if(soInstance.SVMXC__Labor_Discount_Not_Covered__c!=null){
                        includedServicesInstance.SVMXC__Labor_Discount_Not_Covered__c=soInstance.SVMXC__Labor_Discount_Not_Covered__c;
                    }
                    // Field: Labor Discount Covered
                    if(soInstance.SVMXC__Labor_Discount_Covered__c!=null){
                        includedServicesInstance.SVMXC__Labor_Discount_Covered__c=soInstance.SVMXC__Labor_Discount_Covered__c;
                    }
                    // Field: Parts Discount - Not Covered
                    if(soInstance.SVMXC__Parts_Discount_Not_Covered__c!=null){
                        includedServicesInstance.SVMXC__Parts_Discount_Not_Covered__c=soInstance.SVMXC__Parts_Discount_Not_Covered__c;
                    }
                    // Field: Parts Discount Covered
                    if(soInstance.SVMXC__Parts_Discount_Covered__c!=null){
                        includedServicesInstance.SVMXC__Parts_Discount_Covered__c=soInstance.SVMXC__Parts_Discount_Covered__c;
                    }
                    // Field: Service Type
                    if(soInstance.SVMXC__Available_Services__c!=null){
                        includedServicesInstance.SVMXC__Service__c=soInstance.SVMXC__Available_Services__c;
                    }
                    // Field: Travel Discount - Not Covered
                    if(soInstance.SVMXC__Travel_Discount_Not_Covered__c!=null){
                        includedServicesInstance.SVMXC__Travel_Discount_Not_Covered__c=soInstance.SVMXC__Travel_Discount_Not_Covered__c;
                    }
                    // Field: Travel Discount Covered
                    if(soInstance.SVMXC__Travel_Discount_Covered__c!=null){
                        includedServicesInstance.SVMXC__Travel_Discount_Covered__c=soInstance.SVMXC__Travel_Discount_Covered__c;
                    }
                    // Field: Service/Maintenance Contract
                    includedServicesInstance.SVMXC__Service_Contract__c=scInstance.Id;
                    
                    //add Included Service Instance Created to the List
                    includedServiceList.add(includedServicesInstance);
                }


            }

        }
        //Create Included Services in Bulk
        Database.SaveResult[] includedServiceResult = Database.insert(includedServiceList,false);
    }

}