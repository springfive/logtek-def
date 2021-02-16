global with sharing class DEF_WO_ToSynchWithSB {
     
    @InvocableMethod
    public static void updateWorkOrders(List<Id> accountIds){
        System.debug('DEF_WO_ToSynchWithSB called:');
        List<SVMXC__Service_Order__c> woProcessedList = new List<SVMXC__Service_Order__c>();
        For(SVMXC__Service_Order__c wo:[SELECT Id,SVMXC__SM_Version_Number__c, SVMXC__Company__r.Status__c FROM SVMXC__Service_Order__c 
                                        WHERE SVMXC__Company__c IN : accountIds 
                                        AND SVMXC__Order_Status__c = 'Unschedule'])
        {
            //wo.Tech_Account_Activation_Status__c = wo.SVMXC__Company__r.Status__c;
            wo.SVMXC__SM_Version_Number__c = wo.SVMXC__SM_Version_Number__c+1;
            woProcessedList.add(wo);
         }
        
        if(!woProcessedList.isEmpty()){
            //Perform and Store the update dml operation result
            system.debug('WO to update,list size '+woProcessedList.size());
            Database.SaveResult[] woUpdateResults = Database.update(woProcessedList, false);
            Set<id> allFailedId=new Set<id>();
            Set<id> allSuccessId=new Set<id>();
            for(Integer i=0; i < woUpdateResults.size(); i++) {
                if(woUpdateResults.get(i).isSuccess()) {
                    //System.debug(woUpdateResults.get(i).Id+' Record updated Successfully');
                    allSuccessId.add(woUpdateResults.get(i).Id);
                }else if(!woUpdateResults.get(i).isSuccess()) {
                    Database.Error errors =  woUpdateResults.get(i).getErrors().get(0);
                    System.debug('Error Occurs While Processing The Record-->'+errors.getMessage());
                    System.debug('Failure Record Ids While Updating-->'+woProcessedList[i].Id);
                    //Uncomment below line to get all the failure ids:
                    //allFailedId.add(woProcessedList.get(i).Id);
                }
            }
        }
    }
}