/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   12-11-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class DEF_WO_TriggerHandlerTest {
    @isTest
    static void beforeInsert_setWoDesignationYear(){
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        Product2 product=DEF_TestDataFactory.CreateProduct('TestProduct');
        insert product;
        SVMXC__Installed_Product__c installedProduct=DEF_TestDataFactory.CreateInstalledProduct('TestIP',product,'Installed');
        insert installedProduct;
        //Create Service Contract 
        SVMXC__Service_Contract__c testContract=DEF_TestDataFactory.CreateServiceContractHeader('ContractHeader',acc,Date.today(),Date.today().addYears(1));
        insert testContract;
        //Create Service Contract Line
        SVMXC__Service_Contract__c testContractLine1=DEF_TestDataFactory.CreateServiceContractLine('ContractLine1',testContract,acc,installedProduct);
        insert testContractLine1;
        //Create PM Plan
        SVMXC__PM_Plan__c pmInstance=DEF_TestDataFactory.CreatePMPlan('TestPMPlan','Active',testContractLine1,Date.today(),Date.today().addYears(1));
        insert pmInstance;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        String recordTypeMaintenance = String.valueOf(Schema.SObjectType.SVMXC__Service_Order__c.getRecordTypeInfosByName().get('Preventive Maintenance').getRecordTypeId());
        workOrderInstance.RecordTypeId=recordTypeMaintenance;
        workOrderInstance.SVMXC__Order_Type__c='Maintenance';
        workOrderInstance.SVMXC__Order_Status__c='New';
        workOrderInstance.SVMXC__Preferred_Start_Time__c=Datetime.now().addDays(2);
        workOrderInstance.SVMXC__PM_Plan__c=pmInstance.Id;
        Test.startTest();
        insert workOrderInstance;
        Test.stopTest();

    }
    @isTest
    static void beforeInsert_SetWOTerritory() {
        //Preparing Test Data
        //Create Territory
        SVMXC__Territory__c territory=DEF_TestDataFactory.CreateTerritory('TestTerritory');
        insert territory;
        //Create Location 
        SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
        location.DefaultTerritory__c=territory.Id;
        insert location;
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workOrderInstance.SVMXC__Order_Status__c='New';
        workOrderInstance.SVMXC__Site__c=location.Id;
        Test.startTest();
        insert workOrderInstance;
        Test.stopTest();
    }

    @isTest
    static void beforeInsert_SetLocationInformation() {
        //Create Location 
        SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
        location.SVMXC__City__c='Milano';
        location.SVMXC__State__c='Lombardia';
        location.SVMXC__Street__c='Via Borgonuovo 2';
        location.SVMXC__Zip__c='21021';
        location.SVMXC__Country__c='GB';
        location.SVMXC__Latitude__c=45.4706203;
        location.SVMXC__Longitude__c=9.1918034;
        insert location;
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workOrderInstance.SVMXC__Site__c=location.Id;
        Test.startTest();
        insert workOrderInstance;
        Test.stopTest();
    }

    @isTest
    static void beforeUpdate_SetWoTerritory() {
        //Preparing Test Data
        //Create Territory
        SVMXC__Territory__c territory=DEF_TestDataFactory.CreateTerritory('TestTerritory');
        insert territory;
        //Create Location 
        SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
        location.DefaultTerritory__c=territory.Id;
        insert location;
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workOrderInstance.SVMXC__Order_Status__c='New';
        workOrderInstance.SVMXC__Site__c=location.Id;
        insert workOrderInstance;

        //Create New Location 
        SVMXC__Site__c newLocation=DEF_TestDataFactory.CreateLocation('TestLocation2');
        newLocation.DefaultTerritory__c=territory.Id;
        insert newLocation;
        SVMXC__Service_Order__c workOrderInstanceToUpdate=new SVMXC__Service_Order__c();
        workOrderInstanceToUpdate.Id=workOrderInstance.Id;
        workOrderInstanceToUpdate.SVMXC__Site__c=newLocation.Id;
        Test.startTest();
        update workOrderInstanceToUpdate;
        Test.stopTest();
    }

    @isTest
    static void beforeUpdate_SetTechTriggerBO() {
        //Preparing Test Data
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        insert workOrderInstance;

        workOrderInstance.SVMXC__Order_Status__c='Job Validated';
        Test.startTest();
        update workOrderInstance;
        Test.stopTest();


         
    }

    @isTest
    static void beforeUpdate_UpdateLocationInformation() {
        //Create Location 
        SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
        location.SVMXC__City__c='Milano';
        location.SVMXC__State__c='Lombardia';
        location.SVMXC__Street__c='Via Borgonuovo 2';
        location.SVMXC__Zip__c='21021';
        location.SVMXC__Country__c='GB';
        location.SVMXC__Latitude__c=45.4706203;
        location.SVMXC__Longitude__c=9.1918034;
        insert location;
        //Create New Location 
        SVMXC__Site__c newLocation=DEF_TestDataFactory.CreateLocation('TestLocation2');
        newLocation.SVMXC__City__c='Milano';
        newLocation.SVMXC__State__c='Lombardia';
        newLocation.SVMXC__Street__c='Via Borgonuovo 2';
        newLocation.SVMXC__Zip__c='21021';
        newLocation.SVMXC__Country__c='GB';
        newLocation.SVMXC__Latitude__c=45.4706203;
        newLocation.SVMXC__Longitude__c=9.1918034;
        insert newLocation;
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workOrderInstance.SVMXC__Site__c=location.Id;
        insert workOrderInstance;

        workOrderInstance.SVMXC__Site__c=newLocation.Id;
        Test.startTest();
        update workOrderInstance;
        Test.stopTest();

    }
    
    @isTest
    static void afterInsert_SendWOToBO() {
        //Preparing Test Data
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        

        // Set mock callout class for handling http callout
        Test.setMock(HttpCalloutMock.class, new DEF_MockHttpResponseGenerator());
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workorderInstance.Tech_Trigger_Back_Office__c=true;
        Test.startTest();
        insert workOrderInstance;
        Test.stopTest();

    }
    @isTest
    static void afterInsert_CreateWDFromPlannedParts() {
        //Preparing Test Data
        SVMXC__PM_Plan__c pmPlan = new SVMXC__PM_Plan__c();
        pmPlan.Name='Test Plan';
        insert pmPlan;
        SVMXC__PM_Schedule_Definition__c scDef = new SVMXC__PM_Schedule_Definition__c();
        scDef.SVMXC__PM_Plan__c=pmPlan.Id;
        insert scDef;
        Product2 product=new Product2();
        product.Name='product 1';
        insert product;
        Planned_Parts__c plannedPart = new Planned_Parts__c();
        plannedPart.Part__c=product.Id;
        plannedPart.PM_Schedule_Definition__c=scDef.Id;
        insert plannedPart;
        SVMXC__Service_Order__c workorder = new SVMXC__Service_Order__c();
        workorder.PM_Schedule_Definition__c=scDef.Id;
        workorder.SVMXC__Order_Type__c='Maintenance';
        Test.startTest();
        insert workorder;
        Test.stopTest();

    }

    @isTest
    static void afterUpdate_CreateEventFromMobile() {
        //Preparing Test Data
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        //Service Team Create
        String recordTypeTechnicianST = String.valueOf(Schema.SObjectType.SVMXC__Service_Group__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group__c serviceTeam=DEF_TestDataFactory.CreateServiceTeam('TestServiceTeam',recordTypeTechnicianST);
        insert serviceTeam;
        //Technician/Equiment Create
        String recordTypeTechnicianTE = String.valueOf(Schema.SObjectType.SVMXC__Service_Group_Members__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group_Members__c technician=DEF_TestDataFactory.CreateTechnicianOrEquipment('TestTechnician',serviceTeam,recordTypeTechnicianTE);
        insert technician;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        insert workOrderInstance;

        workOrderInstance.Create_Event_From_Mobile__c=true;
        workorderInstance.SVMXC__Preferred_End_Time__c=datetime.now();
        workorderInstance.SVMXC__Preferred_Start_Time__c=datetime.now();
        workorderInstance.SVMXC__Group_Member__c=technician.Id;
        Test.startTest();
        update workorderInstance;
        Test.stopTest();




    }

    @isTest
    static void afterUpdate_UpdateEventRelatedToWO() {
        //Preparing Test Data
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workOrderInstance.SVMXC__Order_Status__c='New';
        insert workOrderInstance;
        //Service Team Create
        String recordTypeTechnicianST = String.valueOf(Schema.SObjectType.SVMXC__Service_Group__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group__c serviceTeam=DEF_TestDataFactory.CreateServiceTeam('TestServiceTeam',recordTypeTechnicianST);
        insert serviceTeam;
        //Technician/Equiment Create
        String recordTypeTechnicianTE = String.valueOf(Schema.SObjectType.SVMXC__Service_Group_Members__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group_Members__c technician=DEF_TestDataFactory.CreateTechnicianOrEquipment('TestTechnician',serviceTeam,recordTypeTechnicianTE);
        insert technician;

        //Create Event
        Event eventInstance=DEF_TestDataFactory.CreateEvent(UserInfo.getUserId(),datetime.now(),datetime.now().addHours(2),workOrderInstance.Id,workOrderInstance.Name);
        insert eventInstance;
        //Create SVMX Event
        SVMXC__SVMX_Event__c svmxEvent=DEF_TestDataFactory.CreateSVMXEvent(UserInfo.getUserId(),datetime.now(),datetime.now().addHours(2),workOrderInstance.Id,workOrderInstance.Name,technician.Id);
        insert svmxEvent;

        workOrderInstance.SVMXC__Order_Status__c='Customer Confirmed';
        Test.startTest();
        update workOrderInstance;
        Test.stopTest();
    }

    @isTest
    static void afterUpdate_SendEmailToContacts() {
        
        //Preparing Test Data
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        con.Email='test@abc.com';
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workOrderInstance.SVMXC__Order_Status__c='New';
        insert workOrderInstance;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'SIR_1234',
            PathOnClient = 'SIR_1234.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert contentVersion; 
        system.debug('Content '+contentVersion.Id);
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Where LatestPublishedVersionId=:contentVersion.Id];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId =workOrderInstance.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        workOrderInstance.SVMXC__Order_Status__c='Job Complete';
        //workorderInstance.Contact_Email_SF__c='test@abc.com';
        Test.startTest();
        update workOrderInstance;
        Test.stopTest();
        
    }

    @isTest
    static void afterUpdate_SendWOToBO() {
        //Preparing Test Data
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        workorderInstance.Tech_Trigger_Back_Office__c=false;
        insert workOrderInstance;
        

        // Set mock callout class for handling http callout
        Test.setMock(HttpCalloutMock.class, new DEF_MockHttpResponseGenerator());
        workorderInstance.Tech_Trigger_Back_Office__c=true;
        Test.startTest();
        update workOrderInstance;
        Test.stopTest();
    }
    
}