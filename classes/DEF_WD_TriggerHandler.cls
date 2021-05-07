/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 01-29-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public inherited sharing class DEF_WD_TriggerHandler extends TriggerHandler {
    private List<SVMXC__Service_Order_Line__c> triggerNew;
    private List<SVMXC__Service_Order_Line__c> triggerOld;
    private Map<Id, SVMXC__Service_Order_Line__c> triggerMapNew;
    private Map<Id, SVMXC__Service_Order_Line__c> triggerMapOld;
    public DEF_WD_TriggerHandler() {
        this.triggerOld = (List<SVMXC__Service_Order_Line__c>) Trigger.old;
        this.triggerNew = (List<SVMXC__Service_Order_Line__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, SVMXC__Service_Order_Line__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, SVMXC__Service_Order_Line__c>) Trigger.oldMap;
    }
    //Insert Contexts
    public override void beforeInsert() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_BI') || Test.isRunningTest()){
            List<SVMXC__Service_Order_Line__c> wdList=new List<SVMXC__Service_Order_Line__c>();
            Set<Id> techIds=new Set<Id>();
            for(SVMXC__Service_Order_Line__c workDetailInstance : this.triggerNew) {
                if((workDetailInstance.SVMXC__Line_Type__c=='Travel' || workDetailInstance.SVMXC__Line_Type__c=='Labor') && workDetailInstance.SVMXC__Start_Date_and_Time__c!=null && workDetailInstance.SVMXC__End_Date_and_Time__c!=null && workDetailInstance.SVMXC__Group_Member__c!=null){
                    wdList.add(workDetailInstance);
                    techIds.add(workDetailInstance.SVMXC__Group_Member__c);
                }
                
            }
            List<SVMXC__Service_Order_Line__c> workDetailList=new List<SVMXC__Service_Order_Line__c>();
            if(techIds.size()>0 && wdList.size()>0){
                workDetailList=[SELECT Name,SVMXC__End_Date_and_Time__c,SVMXC__Group_Member__c,SVMXC__Line_Type__c,SVMXC__Start_Date_and_Time__c FROM SVMXC__Service_Order_Line__c WHERE (SVMXC__Line_Type__c = 'Travel' OR SVMXC__Line_Type__c = 'Labor') AND SVMXC__Group_Member__c IN: techIds];
            }
            system.debug('workDetailList '+workDetailList);
            Map<Id,List<SVMXC__Service_Order_Line__c>> techWorkDetailMap=new Map<Id,List<SVMXC__Service_Order_Line__c>>();
            for(SVMXC__Service_Order_Line__c workDetailInstance : workDetailList)
            {

                if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                    List<SVMXC__Service_Order_Line__c> WDInstance=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                    WDInstance.add(workDetailInstance);
                    techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);

                }
                else{
                    List<SVMXC__Service_Order_Line__c> WDInstance=new List<SVMXC__Service_Order_Line__c>();
                    WDInstance.add(workDetailInstance);
                    techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);

                }
            }
            for(SVMXC__Service_Order_Line__c workDetailInstance : wdList) {
                String WorkDetailNames='';
                Integer OverlapLength=0;
                List<SVMXC__Service_Order_Line__c> WDExistingList=new List<SVMXC__Service_Order_Line__c>();
                if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                    WDExistingList=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                }
                if(WDExistingList.size()>0){
                    for(SVMXC__Service_Order_Line__c existingRecord:WDExistingList){
                        if(existingRecord.SVMXC__Start_Date_and_Time__c < workDetailInstance.SVMXC__End_Date_and_Time__c && existingRecord.SVMXC__End_Date_and_Time__c > workDetailInstance.SVMXC__Start_Date_and_Time__c && existingRecord.SVMXC__Group_Member__c == workDetailInstance.SVMXC__Group_Member__c){
                            OverlapLength++;
                            if(existingRecord.Name!=null){
                                if(WorkDetailNames==''){
                                    WorkDetailNames=existingRecord.Name;
                                }
                                else{
                                    WorkDetailNames=WorkDetailNames+','+existingRecord.Name;
                                }
                            }
                        }
                        
                    }
                }
                if(OverlapLength>0){
                    workDetailInstance.addError('Start date time and End date time Overlapping with '+WorkDetailNames+' records of line type labor and travel ');
    
                }
                else{
                    //workDetailList.add(workDetailInstance);
                    if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                        List<SVMXC__Service_Order_Line__c> WDInstance=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                        WDInstance.add(workDetailInstance);
                        techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);
        
                    }
                    else{
                        List<SVMXC__Service_Order_Line__c> WDInstance=new List<SVMXC__Service_Order_Line__c>();
                        WDInstance.add(workDetailInstance);
                        techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);
        
                    }
                    System.debug('non overlap  record '+workDetailInstance);
                }
                
                
            }
        }
    }
    
    public override void afterInsert() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_AI')){
            
        }
    }
    //Update Contexts
    public override void beforeUpdate() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_BU') || Test.isRunningTest()){
            List<SVMXC__Service_Order_Line__c> wdList=new List<SVMXC__Service_Order_Line__c>();
            Set<Id> techIds=new Set<Id>();
            for(SVMXC__Service_Order_Line__c workDetailInstance : this.triggerNew) {
                if((workDetailInstance.SVMXC__Line_Type__c=='Travel' || workDetailInstance.SVMXC__Line_Type__c=='Labor') && workDetailInstance.SVMXC__Start_Date_and_Time__c!=null && workDetailInstance.SVMXC__End_Date_and_Time__c!=null && workDetailInstance.SVMXC__Group_Member__c!=null){
                    wdList.add(workDetailInstance);
                    techIds.add(workDetailInstance.SVMXC__Group_Member__c);
                }
                
            }
            List<SVMXC__Service_Order_Line__c> workDetailList=new List<SVMXC__Service_Order_Line__c>();
            if(techIds.size()>0 && wdList.size()>0){
                workDetailList=[SELECT Name,SVMXC__End_Date_and_Time__c,SVMXC__Group_Member__c,SVMXC__Line_Type__c,SVMXC__Start_Date_and_Time__c FROM SVMXC__Service_Order_Line__c WHERE (SVMXC__Line_Type__c = 'Travel' OR SVMXC__Line_Type__c = 'Labor') AND SVMXC__Group_Member__c IN: techIds];
            }
            Map<Id,List<SVMXC__Service_Order_Line__c>> techWorkDetailMap=new Map<Id,List<SVMXC__Service_Order_Line__c>>();
            for(SVMXC__Service_Order_Line__c workDetailInstance : workDetailList)
            {

                if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                    List<SVMXC__Service_Order_Line__c> WDInstance=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                    WDInstance.add(workDetailInstance);
                    techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);

                }
                else{
                    List<SVMXC__Service_Order_Line__c> WDInstance=new List<SVMXC__Service_Order_Line__c>();
                    WDInstance.add(workDetailInstance);
                    techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);

                }
            }
            for(SVMXC__Service_Order_Line__c workDetailInstance : wdList) {
                String WorkDetailNames='';
                Integer OverlapLength=0;
                List<SVMXC__Service_Order_Line__c> WDExistingList=new List<SVMXC__Service_Order_Line__c>();
                if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                    WDExistingList=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                }
                if(WDExistingList.size()>0){
                    for(SVMXC__Service_Order_Line__c existingRecord:WDExistingList){
                        if(existingRecord.SVMXC__Start_Date_and_Time__c < workDetailInstance.SVMXC__End_Date_and_Time__c && existingRecord.SVMXC__End_Date_and_Time__c > workDetailInstance.SVMXC__Start_Date_and_Time__c && existingRecord.SVMXC__Group_Member__c == workDetailInstance.SVMXC__Group_Member__c && existingRecord.Id!=workDetailInstance.Id){
                            OverlapLength++;
                            if(existingRecord.Name!=null){
                                if(WorkDetailNames==''){
                                    WorkDetailNames=existingRecord.Name;
                                }
                                else{
                                    WorkDetailNames=WorkDetailNames+','+existingRecord.Name;
                                }
                            }
                        }
                        
                    }
                }
                if(OverlapLength>0){
                    workDetailInstance.addError('Start date time and End date time Overlapping with '+WorkDetailNames+' records of line type labor and travel ');
    
                }
                else{
                    if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                        List<SVMXC__Service_Order_Line__c> WDInstance=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                        Map<Id,SVMXC__Service_Order_Line__c> WDMap=new Map<Id,SVMXC__Service_Order_Line__c>(WDInstance);
                        WDMap.put(workDetailInstance.Id,workDetailInstance);
                        //WDInstance.add(workDetailInstance);
                        techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDMap.values());
        
                    }
                    else
                    {
                        List<SVMXC__Service_Order_Line__c> WDInstance=new List<SVMXC__Service_Order_Line__c>();
                        WDInstance.add(workDetailInstance);
                        techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDInstance);
        
                    }
                    System.debug('non overlap  record '+workDetailInstance);
                }
                
                
            }
            
            
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_AU')){
            
        }
    }
    //Delete contexts
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_BD')){
            
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_AD')){
            
        }
    }
    
    //Undelete Contexts
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WD_AUD')){
            
        }
    }
}