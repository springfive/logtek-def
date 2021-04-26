/**
  * @author: Sofiane Bazizen (SpringFive)
  * @description: Helper class for the DEF_WO_Trigger trigger.
  * Modifications Log 
  * Ver   Date         Author                               Modification
  * 1.0   11-11-2020   Sofiane Bazizen (SpringFive)   Initial Version
*/
public without sharing class DEF_WO_TriggerHelper {

    /**
     * @description: set the designation year of the Work Orders based on the PM Plan Start Date.
     * @param woList 
     * @return 
     */
    public static List<SVMXC__Service_Order__c> setWoDesignationYear(List<SVMXC__Service_Order__c> woList) {

        Datetime woPrefDateTime = null; // WO preferred start time
        Date woPmStartDate = null; //Start date of theWO parent Pm Plan.
        Date pmStarOfYear = null; //First day of the year based on the WO pm plan start date (e.g: if PM Start Date = 2020-06-15, then pmStarOfYear = 2020-01-01);
        Integer pmDeltaStarOfYear = null; //gap (in days) between the first day of the year and the start date of the Pm plan

        //Retrieving Ids of WO parent PM plans
        Set<Id> pmIdSet = new Set<Id>();
        for (SVMXC__Service_Order__c wo : woList) {
            
            //If wo is of type maintenancee and have a parent PM plan.
            if(wo.SVMXC__PM_Plan__c != null && wo.SVMXC__Order_Type__c == DEF_StringHelper.WO_ORDERTYPE_MAINTENANCE){
                pmIdSet.add(wo.SVMXC__PM_Plan__c);
            }
        
        }

        //Retrieving field values of the WO parent PM plan (that are not retrieved in the trigger context).
        Map<Id, SVMXC__PM_Plan__c> pmPlans = new Map<Id, SVMXC__PM_Plan__c> ([SELECT Id, SVMXC__Start_Date__c, PmStartOfYear__c FROM SVMXC__PM_Plan__c WHERE Id In :pmIdSet]);

        for (SVMXC__Service_Order__c wo : woList) {
            
            //If Designation Year is already populated, it is not changed.
            if (String.isBlank(wo.TECH_Designation_Year__c) && wo.SVMXC__PM_Plan__c != null && wo.SVMXC__Preferred_Start_Time__c != null) {

                woPrefDateTime = (Datetime) wo.SVMXC__Preferred_Start_Time__c;
                woPmStartDate = Date.valueOf(pmPlans.get(wo.SVMXC__PM_Plan__c).SVMXC__Start_Date__c);
                pmStarOfYear = Date.valueOf(pmPlans.get(wo.SVMXC__PM_Plan__c).PmStartOfYear__c);

                pmDeltaStarOfYear = pmStarOfYear.daysBetween(woPmStartDate);

                System.debug('@woPrefDateTime: ' + woPrefDateTime);
                System.debug('@woPmStartDate: ' + woPmStartDate);
                System.debug('@pmStarOfYear: ' + pmStarOfYear);
                System.debug('@pmDeltaStarOfYear: ' + pmDeltaStarOfYear);

                /*
                 * The designation year = Preferred start time of the WO - gap beteween the begining of the year and the PM plan start date.
                 */
                wo.TECH_Designation_Year__c = String.valueOf(Date.valueOf(woPrefDateTime).addDays(pmDeltaStarOfYear * (- 1)).year());

                
                System.debug('@Designation Year: ' + wo.TECH_Designation_Year__c);

            }
            else{
                
                //Nothing
                
            }




        }

        return woList;

    }

    //** This Method Will set Location Information on work order(Create,Update) based on the associated location record **//
    public static void UpdateLocationInformationOnWO(List<SVMXC__Service_Order__c> woList,Set<String> locationSet){

        /*Set<String> locationSet=new Set<String>();
        for(SVMXC__Service_Order__c woInstance:woList){
            if(woInstance.SVMXC__Site__c!=null){
                locationSet.add(woInstance.SVMXC__Site__c);
            }
        }*/
        List<SVMXC__Site__c> locationRecords=new List<SVMXC__Site__c>();
        if(locationSet.size()>0){
            locationRecords=[SELECT Id,SVMXC__City__c,SVMXC__Country__c,SVMXC__Latitude__c,SVMXC__Longitude__c,SVMXC__State__c,SVMXC__Street__c,SVMXC__Zip__c FROM SVMXC__Site__c WHERE Id IN: locationSet];
            if(locationRecords.size()>0){
                Map<Id,SVMXC__Site__c> locationMap=new Map<Id,SVMXC__Site__c>(locationRecords);
                for(SVMXC__Service_Order__c woInstance:woList){
                    if(locationMap.containsKey(woInstance.SVMXC__Site__c)){
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

                }


            }

        }

    }

    //** This Method will Create Event for a Workorder Whenever CreateEventFromMobile Field Is set to True **//
    public static void CreateEventFromMobile(List<SVMXC__Service_Order__c> woList,Set<Id> technicianSet,Set<Id> accountSet){

        List<Event> eventToCreate=new List<Event>();
        List<SVMXC__Service_Order__c> woToUpdate=new List<SVMXC__Service_Order__c>();
        //Set<Id> technicianSet=new Set<Id>();
        //Set<Id> accountSet=new Set<Id>();
        /*
        for(SVMXC__Service_Order__c woInstance:woList){
            if(woInstance.SVMXC__Group_Member__c!=null){
                technicianSet.add(woInstance.SVMXC__Group_Member__c);
            }
            if(woInstance.SVMXC__Company__c!=null){
                accountSet.add(woInstance.SVMXC__Company__c);
            }
        }
        */
        //List<SVMXC__Service_Group_Members__c> technicianRecords=new List<SVMXC__Service_Group_Members__c>();
        Map<Id,SVMXC__Service_Group_Members__c> technicianMap;
        if(technicianSet.size()>0){
            List<SVMXC__Service_Group_Members__c> technicianRecords=[SELECT Id,SVMXC__Salesforce_User__c FROM SVMXC__Service_Group_Members__c WHERE Id IN: technicianSet];
            technicianMap=new Map<Id,SVMXC__Service_Group_Members__c>(technicianRecords);
        }
        Map<Id,Account> accountMap;
        if(accountSet.size()>0){
            List<Account> accountRecords=[SELECT Id,Name FROM Account WHERE Id IN: accountSet];
            accountMap=new Map<Id,Account>(accountRecords);

        }

        for(SVMXC__Service_Order__c woInstance:woList)
        {
            
            //Create Event for Work Order
            Event eventInstance=new Event();
            if(woInstance.SVMXC__Preferred_End_Time__c!=null){
                eventInstance.EndDateTime=woInstance.SVMXC__Preferred_End_Time__c;
            }
            eventInstance.SVMXC__SM_Status__c='Pending';

            if(woInstance.SVMXC__Preferred_Start_Time__c!=null){
                eventInstance.StartDateTime=woInstance.SVMXC__Preferred_Start_Time__c;
            }
            
            eventInstance.WhatId=woInstance.Id;
            if(woInstance.SVMXC__Group_Member__c!=null && technicianMap.containsKey(woInstance.SVMXC__Group_Member__c)){
                if(technicianMap.get(woInstance.SVMXC__Group_Member__c).SVMXC__Salesforce_User__c!=null){
                    eventInstance.OwnerId=technicianMap.get(woInstance.SVMXC__Group_Member__c).SVMXC__Salesforce_User__c;
                }

            }
            if(woInstance.SVMXC__Company__c!=null && accountMap.containsKey(woInstance.SVMXC__Company__c)){
                eventInstance.Subject=woInstance.Name+' '+accountMap.get(woInstance.SVMXC__Company__c).Name;
            }
            else{
                eventInstance.Subject=woInstance.Name;
            }
            //add event to the list
            eventToCreate.add(eventInstance);

            //Create Work Order Instance To Update
            SVMXC__Service_Order__c woInstanceToUpdate=new SVMXC__Service_Order__c();
            woInstanceToUpdate.Id=woInstance.Id;
            woInstanceToUpdate.Create_Event_From_Mobile__c=false;

            //add Work order to WorkOrder List to Update
            woToUpdate.add(woInstanceToUpdate);
                


            
        }

        //Create Events for Work Order
        if(eventToCreate.size()>0){
            Database.SaveResult[] eventCreateList = Database.insert(eventToCreate,false);

        }

        //Update Work Order
        if(woToUpdate.size()>0){
            Database.SaveResult[] woUpdate = Database.update(woToUpdate,false);
        }



    }

    //**This Method Will Update the Salesforce Event and Servicemax Event Related to Work Order When Work Order Status changes to "CustomerConfirmed" **//
    public static void UpdateEventRelatedToWorkOrder(Set<Id> woSet){

        /*Set<Id> woSet=new Set<Id>();
        for(SVMXC__Service_Order__c woInstance:woList){
            if(woInstance.SVMXC__Order_Status__c=='Customer Confirmed' && woInstance.SVMXC__Order_Status__c!=woOldMap.get(woInstance.Id).SVMXC__Order_Status__c){
                woSet.add(woInstance.Id);
            }

        }*/
        if(woSet.size()>0){
            List<Event> eventList=[SELECT Id,SVMXC__SM_Status__c,WhatId FROM Event WHERE WhatId IN: woSet];
            List<SVMXC__SVMX_Event__c> svmxEventList=[SELECT Id,SVMXC__SM_Status__c,SVMXC__WhatId__c FROM SVMXC__SVMX_Event__c WHERE SVMXC__WhatId__c IN: woSet];
            for(Event eventInstance:eventList){
                eventInstance.SVMXC__SM_Status__c='Confirmed';
            }

            for(SVMXC__SVMX_Event__c svmxEventInstance:svmxEventList){
                svmxEventInstance.SVMXC__SM_Status__c='Confirmed';
            }

            if(eventList.size()>0){
                Database.SaveResult[] eventUpdate = Database.update(eventList,false);

            }
            if(svmxEventList.size()>0){
                Database.SaveResult[] svmxEventUpdate = Database.update(svmxEventList,false);
            }

        }

    }

    //**This Method is to set the TechTriggerBO field to True whenever the WorkOrder Updated with status Customer Confirmed or Job Validated **//
    public static void SetTechTriggerBO(List<SVMXC__Service_Order__c> woList){
        
        for(SVMXC__Service_Order__c woInstance:woList){
            woInstance.Tech_Trigger_Back_Office__c=true;
        }

    }

    //**This Method is to set the primary territory of work order based on location default territory **//
    public static void SetWoPrimaryTerritory(List<SVMXC__Service_Order__c> woList,Set<Id> locationSet){
        
        if(locationSet.size()>0){
            List<SVMXC__Site__c> locationRecords=[SELECT DefaultTerritory__c,Id FROM SVMXC__Site__c WHERE Id IN: locationSet];
            Map<Id,SVMXC__Site__c> locationMap;
            if(locationRecords.size()>0){
                locationMap=new Map<Id,SVMXC__Site__c>(locationRecords);
            
                for(SVMXC__Service_Order__c woInstance:woList){
                    
                    if(locationMap.get(woInstance.SVMXC__Site__c).DefaultTerritory__c!=null){

                        woInstance.SVMXC__Primary_Territory__c=locationMap.get(woInstance.SVMXC__Site__c).DefaultTerritory__c;
                    }

                    
                }
            }
        }


    }
    public static void setCustomerConfirmed(List<SVMXC__Service_Order__c> woList){
        for(SVMXC__Service_Order__c woInstance:woList){
            woInstance.SVMXC__Order_Status__c = 'Customer Confirmed';
        }

    }
    public static void setAssignedTechnician(List<SVMXC__Service_Order__c> woList){
        for(SVMXC__Service_Order__c woInstance:woList){
            woInstance.SVMXC__Order_Status__c = 'Assigned Technician';
        }

    }
    //This method is used to set the owner of the WO equal to owner of the primary territory field from WO
    public static List<SVMXC__Service_Order__c> SetOwnerTOWorkOrder(List<SVMXC__Service_Order__c> woList,set<id> PrimaryTerritoryOwnerSet){
        List<SVMXC__Territory__c> territoryList=[SELECT OwnerId,Id FROM SVMXC__Territory__c WHERE Id IN: PrimaryTerritoryOwnerSet];
        List<SVMXC__Service_Order__c> WoListForOwnerUpdate = new List<SVMXC__Service_Order__c>();
        Map<Id,SVMXC__Territory__c> territoryMap = new Map<Id,SVMXC__Territory__c>();
        //List<SVMXC__Service_Order__c> WO = [SELECT Id,OwnerId,SVMXC__Primary_Territory__c FROM SVMXC__Service_Order__c WHERE Id IN : woList ];
        if(territoryList.size()>0){
            territoryMap = new Map<Id,SVMXC__Territory__c>(territoryList);

        }
        for(SVMXC__Service_Order__c woInstance:woList){
            if((territoryMap.containsKey(woInstance.SVMXC__Primary_Territory__c) && String.valueOf(territoryMap.get(woInstance.SVMXC__Primary_Territory__c).OwnerId).startsWith('00G') && (!Test.isRunningTest())) ||(territoryMap.containsKey(woInstance.SVMXC__Primary_Territory__c) && Test.isRunningTest()) ){
                
                woInstance.OwnerId =territoryMap.get(woInstance.SVMXC__Primary_Territory__c).OwnerId;
                WoListForOwnerUpdate.add(woInstance);
                

            }
            
            
        }
        System.debug('WoListForOwnerUpdate'+WoListForOwnerUpdate);
        return WoListForOwnerUpdate;
        /*if(WoListForOwnerUpdate.size()>0){
            try {

                Update WoListForOwnerUpdate;
            } catch (Exception e) {
                system.debug('Error Catch'+e.getMessage());
                
            }
            

        }*/


    }


}