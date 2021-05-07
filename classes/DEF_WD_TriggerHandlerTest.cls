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
        Date tdy = Date.today();
		Time Time1 = Time.newInstance(0, 0, 0, 0);
        Time Time2 = Time.newInstance(1, 0, 0, 0);
        DateTime dt1 = DateTime.newInstance(tdy, Time1);
        DateTime dt2 = DateTime.newInstance(tdy, Time2);
        SVMXC__Service_Order_Line__c LaborInstance1=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt1,dt2,technician);
        insert LaborInstance1;
        //Create Work Detail Of Labor Line Type
        Time Time3 = Time.newInstance(1, 0, 0, 0);
        Time Time4 = Time.newInstance(2, 0, 0, 0);
        DateTime dt3 = DateTime.newInstance(tdy, Time3);
        DateTime dt4 = DateTime.newInstance(tdy, Time4);
        SVMXC__Service_Order_Line__c LaborInstance2=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt3,dt4,technician);
        insert LaborInstance2;
        Test.startTest();
        try{
        //Create Work Detail Of Labor Line Type
        Time Time5 = Time.newInstance(0, 0, 0, 0);
        Time Time6 = Time.newInstance(2, 0, 0, 0);
        DateTime dt5 = DateTime.newInstance(tdy, Time5);
        DateTime dt6 = DateTime.newInstance(tdy, Time6);
        SVMXC__Service_Order_Line__c NewLaborInstance=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt5,dt6,technician);
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
        Date tdy = Date.today();
		Time Time1 = Time.newInstance(0, 0, 0, 0);
        Time Time2 = Time.newInstance(1, 0, 0, 0);
        DateTime dt1 = DateTime.newInstance(tdy, Time1);
        DateTime dt2 = DateTime.newInstance(tdy, Time2);
        SVMXC__Service_Order_Line__c LaborInstance1=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt1,dt2,technician);
        insert LaborInstance1;
        Time Time3 = Time.newInstance(1, 0, 0, 0);
        Time Time4 = Time.newInstance(2, 0, 0, 0);
        DateTime dt3 = DateTime.newInstance(tdy, Time3);
        DateTime dt4 = DateTime.newInstance(tdy, Time4);
        SVMXC__Service_Order_Line__c LaborInstance2=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt3,dt4,technician);
        insert LaborInstance2;
        Time Time5 = Time.newInstance(2, 0, 0, 0);
        Time Time6 = Time.newInstance(3, 0, 0, 0);
        DateTime dt5 = DateTime.newInstance(tdy, Time5);
        DateTime dt6 = DateTime.newInstance(tdy, Time6);
        SVMXC__Service_Order_Line__c LaborInstance3=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt5,dt6,technician);
        insert LaborInstance3;
        Time Time7 = Time.newInstance(3, 0, 0, 0);
        Time Time8 = Time.newInstance(4, 0, 0, 0);
        DateTime dt7 = DateTime.newInstance(tdy, Time7);
        DateTime dt8 = DateTime.newInstance(tdy, Time8);
        SVMXC__Service_Order_Line__c LaborInstance4=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt7,dt8,technician);
        insert LaborInstance4;
        Time Time9 = Time.newInstance(4, 0, 0, 0);
        Time Time10 = Time.newInstance(5, 0, 0, 0);
        DateTime dt9 = DateTime.newInstance(tdy, Time9);
        DateTime dt10 = DateTime.newInstance(tdy, Time10);
        SVMXC__Service_Order_Line__c LaborInstance5=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',dt9,dt10,technician);
        insert LaborInstance5;
        Test.startTest();
        try{
        //Create Work Detail Of Labor Line Type
        update LaborInstance4;
        LaborInstance5.SVMXC__Start_Date_and_Time__c=LaborInstance5.SVMXC__Start_Date_and_Time__c.addDays(-1);
        LaborInstance5.SVMXC__End_Date_and_Time__c=LaborInstance5.SVMXC__End_Date_and_Time__c.addDays(-1);
        update LaborInstance5;
        LaborInstance3.SVMXC__Start_Date_and_Time__c=dt1;
        LaborInstance3.SVMXC__End_Date_and_Time__c=dt2;
        update LaborInstance3;
        
        }
        catch(Exception e){
            System.debug('Exception Thrown '+e);
        }
        Test.stopTest();
        
    }
    
}