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

public without sharing class DEF_SC_TriggerHandler extends TriggerHandler {
    
    private List<SVMXC__Service_Contract__c> triggerNew;
    private List<SVMXC__Service_Contract__c> triggerOld;
    private Map<Id, SVMXC__Service_Contract__c> triggerMapNew;
    private Map<Id, SVMXC__Service_Contract__c> triggerMapOld;
    public DEF_SC_TriggerHandler() {
        this.triggerOld = (List<SVMXC__Service_Contract__c>) Trigger.old;
        this.triggerNew = (List<SVMXC__Service_Contract__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, SVMXC__Service_Contract__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, SVMXC__Service_Contract__c>) Trigger.oldMap;
    }
    
    
    public override void beforeInsert() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_BI')){
            System.debug('@In beforeInsert...');
        }
        
    }
    
    public override void beforeUpdate() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_BU')){
            System.debug('@In beforeUpdate...');
            
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterInsert() {
        //System.debug('@afterInsert is Allowed: '+DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_AI'));
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_AI')){
            System.debug('@In afterInsert...');
            //Get list of Integration profile ids separated by ',' from custom label
            String labelValue = Label.DEF_IntegrationProfile;
            Boolean isIntegrationUser=false;
            //get current user profile id
            Id currUserprofileId= userinfo.getProfileId();
            //Get RecordType Label from StringHelper Class
            String scRecordTypeLabel=DEF_StringHelper.SC_RecordType;
            String scRecordTypeId='';
            List<SVMXC__Service_Contract__c> contractLineList=new List<SVMXC__Service_Contract__c>();
            Set<Id> servicePlanSet=new Set<Id>();
            if(!String.isBlank(scRecordTypeLabel)){
                scRecordTypeId=Schema.SObjectType.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get(scRecordTypeLabel).getRecordTypeId();
            }
            if(!String.isBlank(labelValue)){
                //Check current user belongs to Integration profile
                if(labelValue.contains(currUserprofileId)){
                    //Set Integration flag to true if the current user profile is in Custom label
                    isIntegrationUser=true;
                }

            }
            System.debug('list Size '+this.triggerNew.size());
            for(SVMXC__Service_Contract__c scInstance:this.triggerNew){
                System.debug('if condition variables scInstance.SVMX_PS_Parent_Contract__c'+scInstance.SVMX_PS_Parent_Contract__c);
                System.debug('if condition variables scInstance.RecordTypeId'+scInstance.RecordTypeId);
                System.debug('if condition variables scInstance.SVMXC__Service_Plan__c'+scInstance.SVMXC__Service_Plan__c);
                System.debug('if condition variables isIntegrationUser'+isIntegrationUser);
                if(scInstance.SVMX_PS_Parent_Contract__c!=null && scInstance.RecordTypeId==scRecordTypeId && scInstance.SVMXC__Service_Plan__c!=null && isIntegrationUser){

                    contractLineList.add(scInstance);
                    servicePlanSet.add(scInstance.SVMXC__Service_Plan__c);
                    
                }

            }

            //Create Included Services for the Contract Lines
            if(contractLineList.size()>0){
                DEF_SC_TriggerHelper.createIncludedServices(contractLineList,servicePlanSet);

            }
            
        }
    }
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_AU')){
            System.debug('@In afterUpdate...');
        }
            
    }
    
    
    //Delete contexts
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_BD')){
            System.debug('@In beforeDelete...');
            
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_AD')){
            System.debug('@In afterDelete...');
            
        }
        
    }
    
    //Undelete Contexts
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_SC_AUD')){
            System.debug('@In afterUndelete...');
            
        }
        
    }
    
    
}