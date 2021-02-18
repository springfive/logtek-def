trigger DEF_WO_PE_Trigger on DEF_WorkOrderPlatformEvent__e (after insert) {
System.debug('inside Platform Event');

    List<SVMXC__Service_Order__c> WOList= new List<SVMXC__Service_Order__c>();
    List<SVMXC__Territory__c> PrimaryTerritoryList = new List<SVMXC__Territory__c>();
    Set<Id> WOIdSet = new  Set<Id>();
    Set<Id> PrimaryTerritorySet = new Set<Id>();

    for(DEF_WorkOrderPlatformEvent__e PEInstance :Trigger.new){
         WOIdSet.add(PEInstance.WorkOrderId__c);
        
     }
     
     List<SVMXC__Service_Order__c> WoListForOwnerUpdate= [SELECT Id,OwnerId,SVMXC__Primary_Territory__c FROM SVMXC__Service_Order__c WHERE Id IN : WOIdSet];
     for(SVMXC__Service_Order__c WOInstance : WoListForOwnerUpdate){
         PrimaryTerritorySet.add(WOInstance.SVMXC__Primary_Territory__c);
     }
     System.debug('PrimaryTerritorySet'+PrimaryTerritorySet);
     WOList=DEF_WO_TriggerHelper.SetOwnerTOWorkOrder(WoListForOwnerUpdate,PrimaryTerritorySet);
     
     System.debug('WOListToUpdate'+WOList);
     
     Update WOList;
}