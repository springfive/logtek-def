/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-07-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   01-06-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class DEF_PM_WorkOrderBatch implements Database.Batchable<SVMXC__PM_Schedule__c>, Database.Stateful {
    public Boolean executeBatch=false;
    SVMXC.PREV_Engine_Batch EngObj;


    public List<SVMXC__PM_Schedule__c> start(Database.BatchableContext bc) {
        //Get Shedule Days from Custom Labels
        String labelValue= Label.DEF_PM_SheduleDays;
        Integer daysCount;
        Integer pmSheduleCount;
        List<SVMXC__PM_Schedule__c> pmSheduleList=new List<SVMXC__PM_Schedule__c>();
        if(!String.isBlank(labelValue) && labelValue.isNumeric()){
            daysCount=Integer.valueOf(labelValue);
            pmSheduleList=[SELECT Name FROM SVMXC__PM_Schedule__c WHERE SVMXC__Scheduled_On__c <=: Date.today().addDays(daysCount) AND SVMXC__PM_Plan__r.SVMXC__Status__c =: 'Active' LIMIT 1];
        }
        else{
            System.debug('Custom Label DEF_PM_SheduleDays is Empty or holding non-numeric value');

        }
        return pmSheduleList;

    }
    public void execute(Database.BatchableContext bc, List<SVMXC__PM_Schedule__c> scope){
        // process each batch of records

        if(scope.size()>0){
            String pmProcessRecordTypeId = Schema.SObjectType.SVMXC__ServiceMax_Processes__c.getRecordTypeInfosByName().get('PM Process').getRecordTypeId();
            if (!String.isBlank(pmProcessRecordTypeId)) {
                //Query PM Process to Trigger
                List<SVMXC__ServiceMax_Processes__c> svmxProcesslist=[SELECT Id,Name,RecordTypeId,SVMXC__Active__c,SVMXC__Name__c FROM SVMXC__ServiceMax_Processes__c WHERE RecordTypeId =:pmProcessRecordTypeId AND SVMXC__Active__c = true];
                if(svmxProcesslist.size()>0){

                    //Create Instance of Batch Class of Work Order Generation
                    EngObj = new SVMXC.PREV_Engine_Batch();
                    //add PM Process Id to The set Variable
                    for(SVMXC__ServiceMax_Processes__c processInstance:svmxProcesslist){
                        EngObj.setProcessIds.add(String.valueOf(processInstance.Id)); 
                    }
                    executeBatch=true;
                    System.debug('Execute batch set to TRUE'+executeBatch);
                    //ID Batch = database.executebatch(EngObj, 1);
                
                }
                else {
                    System.debug('No PM Process Records Satifies the Criteria');
                }
            }
            else {
                System.debug('No record type named PM Process Exist on SVMXC__ServiceMax_Processes__c');
            }

        }
        else {
            System.debug('No Records on PM shedule satifies the critera');
        }

    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug('Inside finish method ');
        System.debug('value of executeBatch'+executeBatch);
        if(executeBatch==true){
            if(!(Test.isRunningTest())){  //this batch should not be executed since we are using test SVMX process record, It will throw error
            ID Batch = database.executebatch(EngObj, 1);
            }
        }

        DEF_PM_WorkOrderBatch batchInstance=new DEF_PM_WorkOrderBatch();
        //Get BatchInterval Duration from Custom Labels
        String labelDurationValue= Label.DEF_PM_WOBatchInterval;
        Integer batchInterval;
        if(!String.isBlank(labelDurationValue) && labelDurationValue.isNumeric()){
            batchInterval=Integer.valueOf(labelDurationValue);
            //Shedule Next Execution in Minutes
            ID nextBatchId=system.scheduleBatch(batchInstance,'DEF_PM_WorkOrderBatch '+System.currentTimeMillis(), batchInterval);
            System.debug('Next Batch Id '+nextBatchId);
        }
    }
    

}