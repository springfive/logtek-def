/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-17-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-17-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class DEF_WO_PE_TriggerTest {
    @isTest
    static void afterInsert_SetOwnerOnWorkOrder () {
    

    SVMXC__Territory__c territory=new SVMXC__Territory__c();
    territory.Name='Test Territory';
    //territory.OwnerId=gr.id;
    insert territory;

    SVMXC__Service_Order__c workOrder=new SVMXC__Service_Order__c();
    workOrder.SVMXC__Primary_Territory__c=territory.Id;
    insert workOrder;

    DEF_WorkOrderPlatformEvent__e platformEvent=new DEF_WorkOrderPlatformEvent__e();
    platformEvent.WorkOrderId__c= String.valueOf(workOrder.id);
    Test.startTest();
    EventBus.publish(platformEvent);
    Test.stopTest();

    }
}