/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   12-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class DEF_WD_TriggerHelper {
    public static void beforeInsert_OverlapTimeEntry(List<SVMXC__Service_Order_Line__c> wdList) {
        List<SVMXC__Service_Order_Line__c> workDetailList=[SELECT Name,SVMXC__End_Date_and_Time__c,SVMXC__Group_Member__c,SVMXC__Line_Type__c,SVMXC__Start_Date_and_Time__c FROM SVMXC__Service_Order_Line__c WHERE SVMXC__Line_Type__c = 'Travel' OR SVMXC__Line_Type__c = 'Labor'];
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
            //if((workDetailInstance.SVMXC__Line_Type__c=='Travel' || workDetailInstance.SVMXC__Line_Type__c=='Labor') && workDetailInstance.SVMXC__Start_Date_and_Time__c!=null && workDetailInstance.SVMXC__End_Date_and_Time__c!=null && workDetailInstance.SVMXC__Group_Member__c!=null){
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
    public static void beforeUpdate_OverlapTimeEntry(List<SVMXC__Service_Order_Line__c> wdList) {
        List<SVMXC__Service_Order_Line__c> workDetailList=[SELECT Name,SVMXC__End_Date_and_Time__c,SVMXC__Group_Member__c,SVMXC__Line_Type__c,SVMXC__Start_Date_and_Time__c FROM SVMXC__Service_Order_Line__c WHERE SVMXC__Line_Type__c = 'Travel' OR SVMXC__Line_Type__c = 'Labor'];
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
        System.debug('Records to update '+wdList);
        for(SVMXC__Service_Order_Line__c workDetailInstance : wdList) {
            //if((workDetailInstance.SVMXC__Line_Type__c=='Travel' || workDetailInstance.SVMXC__Line_Type__c=='Labor') && workDetailInstance.SVMXC__Start_Date_and_Time__c!=null && workDetailInstance.SVMXC__End_Date_and_Time__c!=null && workDetailInstance.SVMXC__Group_Member__c!=null){
            String WorkDetailNames='';
            Integer OverlapLength=0;
            List<SVMXC__Service_Order_Line__c> WDExistingList=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
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
            System.debug('WD '+workDetailInstance+' Length '+OverlapLength);
            if(OverlapLength>0){
                workDetailInstance.addError('Start date time and End date time Overlapping with '+WorkDetailNames+' records of line type labor and travel ');

            }
            else{
                //workDetailList.add(workDetailInstance);
                if(techWorkDetailMap.containsKey(workDetailInstance.SVMXC__Group_Member__c)){
                    List<SVMXC__Service_Order_Line__c> WDInstance=techWorkDetailMap.get(workDetailInstance.SVMXC__Group_Member__c);
                    Map<Id,SVMXC__Service_Order_Line__c> WDMap=new Map<Id,SVMXC__Service_Order_Line__c>(WDInstance);
                    WDMap.put(workDetailInstance.Id,workDetailInstance);
                    //WDInstance.add(workDetailInstance);
                    techWorkDetailMap.put(workDetailInstance.SVMXC__Group_Member__c,WDMap.values());
    
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