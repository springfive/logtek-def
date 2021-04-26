/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   01-06-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class DEF_PM_WorkOrderBatchTest {
    static testmethod void PM_WorkOrderBatch() {
        Test.startTest();
        //Create Account
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        //Create Service Contract 
        SVMXC__Service_Contract__c testContract=DEF_TestDataFactory.CreateServiceContractHeader('ContractHeader',acc,Date.today(),Date.today().addYears(1));
        insert testContract;
        //Create Product
        Product2 product=DEF_TestDataFactory.CreateProduct('TestProduct');
        insert product;
        //Create Installed Product
        SVMXC__Installed_Product__c installedProduct=DEF_TestDataFactory.CreateInstalledProduct('TestIP',product,'Installed');
        insert installedProduct;
        //Create Service Contract Line
        SVMXC__Service_Contract__c testContractLine=DEF_TestDataFactory.CreateServiceContractLine('ContractLine',testContract,acc,installedProduct);
        insert testContractLine;

        //Create Task Template
        SVMXC__Task_Template__c taskTemplateInstance=DEF_TestDataFactory.CreateTaskTemplate('Test Task Template','Preventive Maintenance','Test Description');
        insert taskTemplateInstance;

        //Create PM Plan Template
        SVMXC__PM_Plan_Template__c pmPlanTemplateInstance=DEF_TestDataFactory.CreatePMTemplate('Test PM Plan Template','Account (Visit Only)',5,'Days');

        insert pmPlanTemplateInstance;
        
        //Create Shedule Template
        SVMXC__PM_Schedule_Template__c pmScheduleTemplateInstance=DEF_TestDataFactory.CreatePMScheduleTemplate(1,'Time Based',pmPlanTemplateInstance,'Test Description',1,'Months',false,60);
        pmScheduleTemplateInstance.SVMXC__Work_Order_Purpose__c=taskTemplateInstance.Id;
        insert pmScheduleTemplateInstance;

        //Create PM Plan
        SVMXC__PM_Plan__c pmPlanInstance=DEF_TestDataFactory.CreatePMPlan('Test PM Plan','Active',testContractLine,Date.today(),Date.today().addYears(1));
        pmPlanInstance.SVMXC__PM_Plan_Template__c=pmPlanTemplateInstance.Id;
        insert pmPlanInstance;

        //activate Contract and contract Line
        testContract.Status__c='Active';
        update testContract;
        testContractLine.Status__c='Active';
        update testContractLine;

        //Create Pm Plan Schedule Definition
        SVMXC__PM_Schedule_Definition__c pmScheduleDefinitionInstance=DEF_TestDataFactory.CreatePmScheduleDefinition(pmPlanInstance,taskTemplateInstance,'Test Schedule',1,'Months',false,60);
        insert pmScheduleDefinitionInstance;

        //Create Pm plan Shedule
        SVMXC__PM_Schedule__c pmScheduleInstance=DEF_TestDataFactory.CreatePMSchedule(Date.today().addDays(1),pmPlanInstance,pmScheduleDefinitionInstance);
        insert pmScheduleInstance;

        //Create Servicemax Processes
        String pmProcessRecordTypeId = Schema.SObjectType.SVMXC__ServiceMax_Processes__c.getRecordTypeInfosByName().get('PM Process').getRecordTypeId();
        SVMXC__ServiceMax_Processes__c svmxProcess=new SVMXC__ServiceMax_Processes__c(SVMXC__Name__c='TestProcess',RecordTypeId=pmProcessRecordTypeId,SVMXC__Active__c=true);
        insert svmxProcess;
        DEF_PM_WorkOrderBatch woBatch = new DEF_PM_WorkOrderBatch();
        ID Batch = database.executebatch(woBatch);
        System.debug('batch job id '+Batch);

        Test.stopTest();
    }
    
}