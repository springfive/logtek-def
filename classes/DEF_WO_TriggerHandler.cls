/**
* @description       : Handler for the Work Order berfore insert trigger.
* @author            : Jawahar Moorthy (SpringFive)
* @group             : 
* @last modified on  : 02-17-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   07-11-2020   Sofiane Bazizen (SpringFive)   Initial Version
**/
public without sharing class DEF_WO_TriggerHandler extends TriggerHandler {
    
    private List<SVMXC__Service_Order__c> triggerNew;
    private List<SVMXC__Service_Order__c> triggerOld;
    private Map<Id, SVMXC__Service_Order__c> triggerMapNew;
    private Map<Id, SVMXC__Service_Order__c> triggerMapOld;
    public DEF_WO_TriggerHandler() {
        //this.setMaxLoopCount(2); //@dev
        this.triggerOld = (List<SVMXC__Service_Order__c>) Trigger.old;
        this.triggerNew = (List<SVMXC__Service_Order__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, SVMXC__Service_Order__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, SVMXC__Service_Order__c>) Trigger.oldMap;
    }
    
    
    public override void beforeInsert() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_BI')){
            System.debug('@In beforeInsert...');
            Set<Id> locationSet=new Set<Id>();
            Set<Id> pmIdSet = new Set<Id>();
            List<SVMXC__Site__c> locationRecords=new List<SVMXC__Site__c>();
            List<SVMXC__PM_Plan__c> pmList=new List<SVMXC__PM_Plan__c>();
            set<id> PrimaryTerritoryOwnerSet = new set<id> ();
            for(SVMXC__Service_Order__c woInstance:this.triggerNew){
                //get WO location - If its associated to WO
                if(woInstance.SVMXC__Site__c!=null){
                    locationSet.add(woInstance.SVMXC__Site__c);
                }
                //Get WO PM Plan - If wo is of type maintenancee and have a parent PM plan
                if(woInstance.SVMXC__PM_Plan__c != null && woInstance.SVMXC__Order_Type__c == DEF_StringHelper.WO_ORDERTYPE_MAINTENANCE){
                    pmIdSet.add(woInstance.SVMXC__PM_Plan__c);
                }
                

            }
            
            
            //get full details(addresss+default territory) of WO location
            if(locationSet.size()>0){
                locationRecords=[SELECT Id,DefaultTerritory__c,SVMXC__City__c,SVMXC__Country__c,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__State__c,SVMXC__Street__c,SVMXC__Zip__c FROM SVMXC__Site__c WHERE Id IN: locationSet];
            }
            Map<Id,SVMXC__Site__c> locationMap=new Map<Id,SVMXC__Site__c>();
            if(locationRecords.size()>0)
            {
                locationMap=new Map<Id,SVMXC__Site__c>(locationRecords);
            }

            //Retrieving field values of the WO parent PM plan (that are not retrieved in the trigger context).
            if(pmIdSet.size()>0){
                pmList=[SELECT Id, SVMXC__Start_Date__c, PmStartOfYear__c FROM SVMXC__PM_Plan__c WHERE Id In :pmIdSet];

            }
            Map<Id, SVMXC__PM_Plan__c> pmPlans=new Map<Id, SVMXC__PM_Plan__c>();
            if(pmList.size()>0){
                pmPlans = new Map<Id, SVMXC__PM_Plan__c> (pmList);
            }
            
            for(SVMXC__Service_Order__c woInstance:this.triggerNew){
                //**---> Set WorkOrder Default Territory based on the location**//
                if(woInstance.SVMXC__Primary_Territory__c==null && woInstance.SVMXC__Order_Status__c=='New' && woInstance.SVMXC__Site__c!=null && locationMap.size()>0 && locationMap.containsKey(woInstance.SVMXC__Site__c)){
                    if(locationMap.get(woInstance.SVMXC__Site__c).DefaultTerritory__c!=null){

                        woInstance.SVMXC__Primary_Territory__c=locationMap.get(woInstance.SVMXC__Site__c).DefaultTerritory__c;
                    }
                    
                }
                //**---> Update Location Information on Work Order - Before Create**//
                if(woInstance.SVMXC__Site__c!=null && locationMap.size()>0 && locationMap.containsKey(woInstance.SVMXC__Site__c)){
                    SVMXC__Site__c locationInstance=locationMap.get(woInstance.SVMXC__Site__c);
                    if(locationInstance.SVMXC__City__c!=null){
                        woInstance.SVMXC__City__c=locationInstance.SVMXC__City__c;
                    }
                    if(locationInstance.SVMXC__State__c!=null){
                        woInstance.SVMXC__State__c=locationInstance.SVMXC__State__c;
                    }
                    if(locationInstance.SVMXC__Street__c!=null){
                        woInstance.SVMXC__Street__c=locationInstance.SVMXC__Street__c;
                    }
                    if (locationInstance.SVMXC__Zip__c!=null) {
                        woInstance.SVMXC__Zip__c=locationInstance.SVMXC__Zip__c;
                    }
                    if(locationInstance.SVMXC__Country__c!=null){
                        woInstance.SVMXC__Country__c=locationInstance.SVMXC__Country__c;
                    }
                    if(locationInstance.SVMXC__Latitude__c!=null){
                        woInstance.SVMXC__Latitude__c=locationInstance.SVMXC__Latitude__c;
                    }
                    if(locationInstance.SVMXC__Longitude__c!=null){
                        woInstance.SVMXC__Longitude__c=locationInstance.SVMXC__Longitude__c;
                    }


                }
                //**---> Update Work Order Designation Year(technical field) based on PM Plan Start Date - Before Create**//
                if(woInstance.SVMXC__PM_Plan__c != null && woInstance.SVMXC__Order_Type__c == DEF_StringHelper.WO_ORDERTYPE_MAINTENANCE && String.isBlank(woInstance.TECH_Designation_Year__c) && woInstance.SVMXC__PM_Plan__c != null && pmPlans.size()>0 && pmPlans.containsKey(woInstance.SVMXC__PM_Plan__c) && woInstance.SVMXC__Preferred_Start_Time__c != null){
                    Datetime woPrefDateTime = null; // WO preferred start time
                    Date woPmStartDate = null; //Start date of theWO parent Pm Plan.
                    Date pmStarOfYear = null; //First day of the year based on the WO pm plan start date (e.g: if PM Start Date = 2020-06-15, then pmStarOfYear = 2020-01-01);
                    Integer pmDeltaStarOfYear = null; //gap (in days) between the first day of the year and the start date of the Pm plan

                    woPrefDateTime = (Datetime) woInstance.SVMXC__Preferred_Start_Time__c;
                    woPmStartDate = Date.valueOf(pmPlans.get(woInstance.SVMXC__PM_Plan__c).SVMXC__Start_Date__c);
                    pmStarOfYear = Date.valueOf(pmPlans.get(woInstance.SVMXC__PM_Plan__c).PmStartOfYear__c);
    
                    pmDeltaStarOfYear = pmStarOfYear.daysBetween(woPmStartDate);
    
                    System.debug('@woPrefDateTime: ' + woPrefDateTime);
                    System.debug('@woPmStartDate: ' + woPmStartDate);
                    System.debug('@pmStarOfYear: ' + pmStarOfYear);
                    System.debug('@pmDeltaStarOfYear: ' + pmDeltaStarOfYear);
    
                    /*
                     * The designation year = Preferred start time of the WO - gap beteween the begining of the year and the PM plan start date.
                     */
                    woInstance.TECH_Designation_Year__c = String.valueOf(Date.valueOf(woPrefDateTime).addDays(pmDeltaStarOfYear * (- 1)).year());
    
                    
                    System.debug('@Designation Year: ' + woInstance.TECH_Designation_Year__c);

                }
                

                
            }
            

        }
        
    }
    
    public override void beforeUpdate() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_BU')){
            system.debug('@In beforeUpdate...');
            Set<Id> locationSet=new Set<Id>();
            List<SVMXC__Site__c> locationRecords=new List<SVMXC__Site__c>();
            set<id> PrimaryTerritoryOwnerSet = new set<id> ();

            for(SVMXC__Service_Order__c woInstance:this.triggerNew){
                //get WO location - If its associated to WO
                if(woInstance.SVMXC__Site__c!=null){
                    locationSet.add(woInstance.SVMXC__Site__c);
                }
                
            }
            
            //get full details(addresss+default territory) of WO location
            if(locationSet.size()>0){
                locationRecords=[SELECT Id,DefaultTerritory__c,SVMXC__City__c,SVMXC__Country__c,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__State__c,SVMXC__Street__c,SVMXC__Zip__c FROM SVMXC__Site__c WHERE Id IN: locationSet];
            }
            Map<Id,SVMXC__Site__c> locationMap=new Map<Id,SVMXC__Site__c>();
            if(locationRecords.size()>0)
            {
                locationMap=new Map<Id,SVMXC__Site__c>(locationRecords);
            }

            for(SVMXC__Service_Order__c woInstance:this.triggerNew){
                //**--->Set Status to Assigned Technician When WO is dispatched to technician and country is not GB**//
                if(woInstance.SVMXC__Dispatch_Status__c != this.triggerMapOld.get(woInstance.Id).SVMXC__Dispatch_Status__c && woInstance.SVMXC__Dispatch_Status__c == 'Assigned' && woInstance.SVMXC__Country__c != 'GB'){
                    woInstance.SVMXC__Order_Status__c = 'Assigned Technician';
                }
                 //**--->Set Status to Customer Confirmed When Customer Confirmed is true or Dispatch status is set assigned and Country is GB**//
                if((woInstance.Customer_Confirmed__c!=this.triggerMapOld.get(woInstance.Id).Customer_Confirmed__c && woInstance.Customer_Confirmed__c == true && woInstance.SVMXC__Order_Status__c != 'Customer Confirmed') || (woInstance.SVMXC__Dispatch_Status__c != this.triggerMapOld.get(woInstance.Id).SVMXC__Dispatch_Status__c && woInstance.SVMXC__Dispatch_Status__c == 'Assigned' && woInstance.SVMXC__Country__c == 'GB')){
                    woInstance.SVMXC__Order_Status__c = 'Customer Confirmed';

                }
                //**---> Set WorkOrder Default Territory based on the location**//
                if((woInstance.SVMXC__Primary_Territory__c==null && woInstance.SVMXC__Order_Status__c=='New' && woInstance.SVMXC__Site__c!=null && locationMap.size()>0 && locationMap.containsKey(woInstance.SVMXC__Site__c)) || (woInstance.SVMXC__Site__c!=this.triggerMapOld.get(woInstance.Id).SVMXC__Site__c && woInstance.SVMXC__Site__c!=null && locationMap.size()>0 && locationMap.containsKey(woInstance.SVMXC__Site__c))){
                    if(locationMap.get(woInstance.SVMXC__Site__c).DefaultTerritory__c!=null){

                        woInstance.SVMXC__Primary_Territory__c=locationMap.get(woInstance.SVMXC__Site__c).DefaultTerritory__c;
                    }
                    
                }
                //**---> Update Location Information on Work Order - Before Update**//
                if(woInstance.SVMXC__Site__c!=this.triggerMapOld.get(woInstance.Id).SVMXC__Site__c && woInstance.SVMXC__Site__c!=null && locationMap.size()>0 && locationMap.containsKey(woInstance.SVMXC__Site__c)){
                    SVMXC__Site__c locationInstance=locationMap.get(woInstance.SVMXC__Site__c);
                    if(locationInstance.SVMXC__City__c!=null){
                        woInstance.SVMXC__City__c=locationInstance.SVMXC__City__c;
                    }
                    if(locationInstance.SVMXC__State__c!=null){
                        woInstance.SVMXC__State__c=locationInstance.SVMXC__State__c;
                    }
                    if(locationInstance.SVMXC__Street__c!=null){
                        woInstance.SVMXC__Street__c=locationInstance.SVMXC__Street__c;
                    }
                    if (locationInstance.SVMXC__Zip__c!=null) {
                        woInstance.SVMXC__Zip__c=locationInstance.SVMXC__Zip__c;
                    }
                    if(locationInstance.SVMXC__Country__c!=null){
                        woInstance.SVMXC__Country__c=locationInstance.SVMXC__Country__c;
                    }
                    if(locationInstance.SVMXC__Latitude__c!=null){
                        woInstance.SVMXC__Latitude__c=locationInstance.SVMXC__Latitude__c;
                    }
                    if(locationInstance.SVMXC__Longitude__c!=null){
                        woInstance.SVMXC__Longitude__c=locationInstance.SVMXC__Longitude__c;
                    }
                    
                }
                //**---> Set TechTriggerBackOffice to true when status is Job validated or Customer Confirmed**//
                if (woInstance.Tech_Trigger_Back_Office__c!=true && (woInstance.SVMXC__Order_Status__c=='Job Validated' || woInstance.SVMXC__Order_Status__c=='Customer Confirmed') && woInstance.SVMXC__Order_Status__c!=this.triggerMapOld.get(woInstance.Id).SVMXC__Order_Status__c) {
                    woInstance.Tech_Trigger_Back_Office__c=true;
                }
                

            }
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterInsert() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_AI')){
            System.debug('@In afterInsert...');
            //system.debug(' Loop Count...'+this.currentLoopValue()); //@dev
            
            List<SVMXC__Service_Order__c> woToSendToBO=new List<SVMXC__Service_Order__c>();
            list<SVMXC__Service_Order__c> WoListForOwnerUpdate = new list<SVMXC__Service_Order__c> ();
            set<id> PrimaryTerritorySet = new set<id> ();
            set<id> WOSetForOwnerUpdate = new set<id> ();
            List<DEF_WorkOrderPlatformEvent__e> WOPEList = new List<DEF_WorkOrderPlatformEvent__e>();
            for(SVMXC__Service_Order__c workorderInstance:this.triggerNew)
            {
                if (workorderInstance.Tech_Trigger_Back_Office__c==true) {
                    //Apex Code is for sending work order id to the back office whenever the callout work order is created
                    //DEF_WO_SendWOToBackOffice.SendWODetails(workorderInstance);
                    woToSendToBO.add(workorderInstance);
                }
                //Apex code to set the Owner of WO from Owner of Territory
                if(String.valueOf(workorderInstance.OwnerId).startsWith('005') && workorderInstance.SVMXC__Primary_Territory__c != null) {
                    
                    
                    DEF_WorkOrderPlatformEvent__e WOPEInstance = new DEF_WorkOrderPlatformEvent__e();
                    WOPEInstance.WorkOrderId__c = String.valueOf(workorderInstance.Id);
                    WOPEList.add(WOPEInstance);
                    System.debug('@WoListForOwnerUpdate...');

                }
                
            }
            //**Start-->Apex Code is for sending work order id to the back office whenever the callout work order is created**//
            if(woToSendToBO.size()>0){
                System.enqueueJob(new DEF_API_WO_RequestCallBack(woToSendToBO));
                
            }
            //**End--> Apex Code is for sending work order id to the back office whenever the callout work order is created**//
            //**Start-->Apex code to set the Owner of WO from Owner of Territory
            if(WOPEList.size()>0){
                System.debug('@publish(WOPEList)');
                List<Database.SaveResult> results = EventBus.publish(WOPEList);
                System.debug('results'+results);

                //DEF_WO_TriggerHelper.SetOwnerTOWorkOrder(WoListForOwnerUpdate,PrimaryTerritorySet);
            }
            //**End-->Apex code to set the Owner of WO from Owner of Territory

            
            
                        
            List<SVMXC__Service_Order__c> woListToUpdate = new List<SVMXC__Service_Order__c> ();
            
            //Key(concatenate: PmId + _ + WoDesignationYear), Value(higest visit number).
            Map<String, Decimal> maxVisitMap = new Map<String, Decimal> ();
            
            //Set of Pm Ids. Used to filter the aggregate Workorders.
            Set<String> pmIdSet = new Set<String> ();
            
            /*Filtering: rerieving only Work Orders of type Maintenance who are not populated with a visit number + adding the records to the woFilteredList*/
            list<SVMXC__Service_Order__c> woFilteredList = new list<SVMXC__Service_Order__c> ();
            for (SVMXC__Service_Order__c wo : this.triggerNew) {
                if (wo.SVMXC__Order_Type__c == DEF_StringHelper.WO_ORDERTYPE_MAINTENANCE && wo.VisitNumber__c == null) {
                    woFilteredList.add(wo);
                }
            }
            
             

            

            //[Display]
            System.debug('woFilteredList.Size: ' + woFilteredList.size());
            
            //Retrieving the list of Pm plan Ids from the created Work Orders.
            for (SVMXC__Service_Order__c wo :[SELECT Id, SVMXC__PM_Plan__c FROM SVMXC__Service_Order__c WHERE Id in :woFilteredList]) {
                pmIdSet.add(wo.SVMXC__PM_Plan__c);
            }
           
            
            System.debug('@pmIdSet: ' + pmIdSet);
            
            //Using Aggregation to retrieve for each Pm Plan aniversary year the current highest visit number.
            for (AggregateResult aggregate :[
                SELECT MAX(VisitNumber__c) maxVisit, SVMXC__PM_Plan__c, TECH_Designation_Year__c FROM SVMXC__Service_Order__c
                WHERE SVMXC__PM_Plan__c In :pmIdSet
                GROUP BY SVMXC__PM_Plan__c, TECH_Designation_Year__c
            ]) {
                
                System.debug('aggregate: ' + aggregate);
                maxVisitMap.put((String) aggregate.get('TECH_Designation_Year__c'), (Decimal) aggregate.get('maxVisit'));
                
            }
            
            System.debug('maxVisitMap: ' + maxVisitMap);
            
            
            /* 
* Updating the newly created WO with visit number, taking into account:
* - The current highest visit number for each designation year (from exisit WO)
* - The Preffered start(1) date and creation date(2) of the newly created wo.
*/
            Decimal maxVisit;
            String woDesigYear = null;
            String woDesigYearOld = null;
            for (SVMXC__Service_Order__c wo :[SELECT Id, SVMXC__Preferred_Start_Time__c, TECH_Designation_Year__c, VisitNumber__c
                                              FROM SVMXC__Service_Order__c WHERE Id In :this.triggerNew
                                              ORDER BY TECH_Designation_Year__c, SVMXC__Preferred_Start_Time__c, createdDate]) {
                                                  
                                                  woDesigYear = wo.TECH_Designation_Year__c;
                                                  System.debug('woDesigYear: ' + woDesigYear);
                                                  
                                                  //getting current highest visit number for the WO designation year.
                                                  if(maxVisit == null || woDesigYear != woDesigYearOld){
                                                      
                                                      maxVisit = maxVisitMap.get(woDesigYear) == null ? 0 : maxVisitMap.get(woDesigYear);
                                                      
                                                  }
                                                  
                                                  woDesigYearOld = woDesigYear;
                                                  System.debug('maxVisit before: ' + maxVisit);
                                                  if (wo.VisitNumber__c == null) {
                                                      //woDesigYear = wo.TECH_Designation_Year__c;
                                                      
                                                      wo.VisitNumber__c = maxVisit + 1;
                                                      woListToUpdate.add(wo);
                                                      
                                                      System.debug('wo visit: ' + wo.VisitNumber__c);
                                                      maxVisit++;
                                                  }
                                                  
                                              }
            
            //DML
            Update woListToUpdate;
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_AU')){
            System.debug('@On After Update ...');

            //**Start-->Apex Code is for sending work order id to the back office whenever the callout work order is created**//
            /*
try {
for(SVMXC__Service_Order__c workorderInstance:this.triggerNew)
{
if(this.triggerMapOld.containsKey(workorderInstance.Id)){
if(this.triggerMapOld.get(workorderInstance.Id).Tech_Trigger_Back_Office__c!=workorderInstance.Tech_Trigger_Back_Office__c){
if (workorderInstance.Tech_Trigger_Back_Office__c==true) {
//Apex Code is for sending work order id to the back office whenever the callout work order is created
DEF_WO_SendWOToBackOffice.SendWODetails(workorderInstance);
}
}
}
}
} catch (Exception e) {
System.debug('The Error Thrown When calling the DEF_WO_SendWOToBackOffice '+e);

}
*/
            //**End--> Apex Code is for sending work order id to the back office whenever the callout work order is created**//
            
            //**Start-->Apex Code to Send Email with attachement (SIR) when the work Order status is Job Complete and has Email field**//
            /*
try {
List<SVMXC__Service_Order__c> woToSendEmail=new List<SVMXC__Service_Order__c>();
for(SVMXC__Service_Order__c workorderInstance:this.triggerNew){
if(this.triggerMapOld.containsKey(workorderInstance.Id)){
if((this.triggerMapOld.get(workorderInstance.Id).SVMXC__Order_Status__c!=workorderInstance.SVMXC__Order_Status__c) && workorderInstance.SVMXC__Order_Status__c=='Job Complete' && workorderInstance.Contact_Email_SF__c!=null){
woToSendEmail.add(workorderInstance);
}
}

}
//send filtered Work Orders to class DEF_WO_SendEmailToContacts
if(woToSendEmail.size()>0){
DEF_WO_SendEmailToContacts.SendEmailToContacts(woToSendEmail);

}

} catch (Exception e) {
System.debug('The Error Thrown When calling the DEF_WO_SendEmailToContacts '+e);

}
*/
            //**End--> Apex Code to Send Email with attachement (SIR) when the work Order status is Job Complete and has Email field**//
            Set<Id> technicianSetToCreateEvent=new Set<Id>();
            Set<Id> accountSetToCreateEvent=new Set<Id>();
            Set<Id> woSetToUpdateEvent=new Set<Id>();
            list<SVMXC__Service_Order__c> WoListForOwnerUpdate = new list<SVMXC__Service_Order__c> ();
            set<id> PrimaryTerritorySet = new set<id> ();
            List<SVMXC__Service_Order__c> woListToCreateEvent=new List<SVMXC__Service_Order__c>();
            List<SVMXC__Service_Order__c> woToSendEmail=new List<SVMXC__Service_Order__c>();
            List<SVMXC__Service_Order__c> woToSendToBO=new List<SVMXC__Service_Order__c>();
            List<DEF_WorkOrderPlatformEvent__e> WOPEList = new List<DEF_WorkOrderPlatformEvent__e>();
            for(SVMXC__Service_Order__c workorderInstance:this.triggerNew)
            {
                if(workorderInstance.SVMXC__Group_Member__c!=null){
                    technicianSetToCreateEvent.add(workorderInstance.SVMXC__Group_Member__c);
                }
                if(workorderInstance.SVMXC__Company__c!=null){
                    accountSetToCreateEvent.add(workorderInstance.SVMXC__Company__c);
                }
                if(workorderInstance.Create_Event_From_Mobile__c==true && workorderInstance.Create_Event_From_Mobile__c!=this.triggerMapOld.get(workorderInstance.Id).Create_Event_From_Mobile__c){
                    if (workorderInstance.SVMXC__Preferred_End_Time__c!=null && workorderInstance.SVMXC__Preferred_Start_Time__c!=null && workorderInstance.SVMXC__Group_Member__c!=null) {
                        woListToCreateEvent.add(workorderInstance);
                        
                    }
                    
                }
                if(workorderInstance.SVMXC__Order_Status__c=='Customer Confirmed' && workorderInstance.SVMXC__Order_Status__c!=this.triggerMapOld.get(workorderInstance.Id).SVMXC__Order_Status__c){
                    woSetToUpdateEvent.add(workorderInstance.Id);
                    
                }
                if(this.triggerMapOld.get(workorderInstance.Id).Tech_Trigger_Back_Office__c!=workorderInstance.Tech_Trigger_Back_Office__c){
                    if (workorderInstance.Tech_Trigger_Back_Office__c==true) {
                        //**Start-->Apex Code is for sending work order id to the back office whenever the callout work order is created**//
                        //DEF_WO_SendWOToBackOffice.SendWODetails(workorderInstance);
                        woToSendToBO.add(workorderInstance);
                        //**End--> Apex Code is for sending work order id to the back office whenever the callout work order is created**//
                        
                    }
                }
                
                if((this.triggerMapOld.get(workorderInstance.Id).SVMXC__Order_Status__c!=workorderInstance.SVMXC__Order_Status__c) && workorderInstance.SVMXC__Order_Status__c=='Job Complete'){
                    woToSendEmail.add(workorderInstance);
                }
                //Apex code to set the Owner of WO from Owner of Territory
                if(workorderInstance.SVMXC__Primary_Territory__c!=this.triggerMapOld.get(workorderInstance.Id).SVMXC__Primary_Territory__c && workorderInstance.SVMXC__Primary_Territory__c != null) {
                    
                   DEF_WorkOrderPlatformEvent__e WOPEInstance = new DEF_WorkOrderPlatformEvent__e();
                    WOPEInstance.WorkOrderId__c = String.valueOf(workorderInstance.Id);
                    WOPEList.add(WOPEInstance);

                }
                
                
            }
            
            
            //**Start--> Code for Create Event for Work Order Whenever The CreateEventFromMobile Is set to True **//
            if(woListToCreateEvent.size()>0){
                DEF_WO_TriggerHelper.CreateEventFromMobile(woListToCreateEvent,technicianSetToCreateEvent,accountSetToCreateEvent);
            }
            //**End--> Code for Create Event for Work Order Whenever The CreateEventFromMobile Is set to True **//
            
            //**Start--> Code to Update Salesforce Event and Servicemax Event whenever the WorkOrder Status Changes to "Customer Confirmed" **//
            if(woSetToUpdateEvent.size()>0){
                DEF_WO_TriggerHelper.UpdateEventRelatedToWorkOrder(woSetToUpdateEvent);
            }
            //**End--> Code to Update Salesforce Event and Servicemax Event whenever the WorkOrder Status Changes to "Customer Confirmed"  **//
            
            //**Start-->Apex Code to Send Email with attachement (SIR) when the work Order status is Job Complete and has Email field**//
            if(woToSendEmail.size()>0){
                //DEF_WO_SendEmailToContacts.SendEmailToContacts(woToSendEmail); -- temporarily commented
                DEF_WO_SirSender.SendEmailToContacts(woToSendEmail);
            }
            //**End--> Apex Code to Send Email with attachement (SIR) when the work Order status is Job Complete and has Email field**//
            
            //**Start-->Apex Code is for sending work order id to the back office whenever the callout work order is created**//
            if(woToSendToBO.size()>0){
                System.enqueueJob(new DEF_API_WO_RequestCallBack(woToSendToBO));
                
            }
            //**End--> Apex Code is for sending work order id to the back office whenever the callout work order is created**//
            //}
            //**Start-->Apex code to set the Owner of WO from Owner of Territory
            if(WOPEList.size()>0){
                System.debug('WOPEList'+WOPEList);
                List<Database.SaveResult> results = EventBus.publish(WOPEList);
                //DEF_WO_TriggerHelper.SetOwnerTOWorkOrder(WoListForOwnerUpdate,PrimaryTerritorySet);
                
            }
            //**End-->Apex code to set the Owner of WO from Owner of Territory
        }
    }
    
    
    //Delete contexts
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_BD')){
            
        }
    }
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_AD')){
            
        }
        
    }
    
    //Undelete Contexts
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        if(DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_AUD')){
            
        }
        
    }
    
    
}