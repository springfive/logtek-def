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
@isTest
public with sharing class DEF_WD_TriggerHandlerTest {
    static testMethod void beforeInsert_OverlapTimeEntryTest(){
        //Preparing Test Data
        //Account Create
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        //Contact create
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        //Work Order Create
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        insert workOrderInstance;
        //Service Team Create
        String recordTypeTechnicianST = String.valueOf(Schema.SObjectType.SVMXC__Service_Group__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group__c serviceTeam=DEF_TestDataFactory.CreateServiceTeam('TestServiceTeam',recordTypeTechnicianST);
        insert serviceTeam;
        //Technician/Equiment Create
        String recordTypeTechnicianTE = String.valueOf(Schema.SObjectType.SVMXC__Service_Group_Members__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group_Members__c technician=DEF_TestDataFactory.CreateTechnicianOrEquipment('TestTechnician',serviceTeam,recordTypeTechnicianTE);
        insert technician;
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c LaborInstance1=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now().addHours(1),technician);
        insert LaborInstance1;
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c LaborInstance2=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now().addHours(1),Datetime.now().addHours(2),technician);
        insert LaborInstance2;
        Test.startTest();
        try{
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c NewLaborInstance=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now().addHours(2),technician);
        insert NewLaborInstance;
        }
        catch(Exception e){
            System.debug('Exception Thrown '+e);
        }
        Test.stopTest();
        
    }

    static testMethod void beforeUpdate_OverlapTimeEntryTest(){
         //Preparing Test Data
        //Account Create
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        //Contact create
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        //Work Order Create
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        insert workOrderInstance;
        //Service Team Create
        String recordTypeTechnicianST = String.valueOf(Schema.SObjectType.SVMXC__Service_Group__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group__c serviceTeam=DEF_TestDataFactory.CreateServiceTeam('TestServiceTeam',recordTypeTechnicianST);
        insert serviceTeam;
        //Technician/Equiment Create
        String recordTypeTechnicianTE = String.valueOf(Schema.SObjectType.SVMXC__Service_Group_Members__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group_Members__c technician=DEF_TestDataFactory.CreateTechnicianOrEquipment('TestTechnician',serviceTeam,recordTypeTechnicianTE);
        insert technician;
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c LaborInstance1=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now().addHours(1),technician);
        insert LaborInstance1;
        SVMXC__Service_Order_Line__c LaborInstance2=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now().addHours(1),Datetime.now().addHours(2),technician);
        insert LaborInstance2;
        SVMXC__Service_Order_Line__c LaborInstance3=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now().addHours(2),Datetime.now().addHours(3),technician);
        insert LaborInstance3;
        SVMXC__Service_Order_Line__c LaborInstance4=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now().addHours(3),Datetime.now().addHours(4),technician);
        insert LaborInstance4;
        SVMXC__Service_Order_Line__c LaborInstance5=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now().addHours(4),Datetime.now().addHours(5),technician);
        insert LaborInstance5;
        Test.startTest();
        try{
        //Create Work Detail Of Labor Line Type
        update LaborInstance4;
        LaborInstance5.SVMXC__Start_Date_and_Time__c=Datetime.now().addDays(-1);
        LaborInstance5.SVMXC__End_Date_and_Time__c=Datetime.now().addDays(-1);
        update LaborInstance5;
        LaborInstance3.SVMXC__Start_Date_and_Time__c=Datetime.now();
        LaborInstance3.SVMXC__End_Date_and_Time__c=Datetime.now().addHours(2);
        update LaborInstance3;
        
        }
        catch(Exception e){
            System.debug('Exception Thrown '+e);
        }
        Test.stopTest();
        
    }
    
}