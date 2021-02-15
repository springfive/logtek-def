/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class DEF_TestDataFactory {
    //Create Account
    public static Account CreateAccount(String accName) {
        Account acc=new Account(Name=accName);
        //insert acc;
        return acc;
    }
    //Create Contact
    public static Contact CreateContact(String conName) {
        Contact con=new Contact(LastName=conName);
        //insert con;
        return con;
    }
    //Create Product
    public static Product2 CreateProduct(String prodName) {
        Product2 product=new Product2(Name=prodName);
        //insert product;
        return product;
    }
    //Create Location
    public static SVMXC__Site__c CreateLocation(String locationName){
        SVMXC__Site__c location=new SVMXC__Site__c(Name=locationName);
        return location;
    }
    //Create Installed Product
    public static SVMXC__Installed_Product__c CreateInstalledProduct(String ipName,Product2 product,String status) {
        SVMXC__Installed_Product__c installedProduct=new SVMXC__Installed_Product__c(Name=ipName,SVMXC__Product__c=product.Id,SVMXC__Status__c=status);
        //insert installedProduct;
        return installedProduct;
    }
    //Create Territory
    public static SVMXC__Territory__c CreateTerritory(String Name) {
        SVMXC__Territory__c territory=new SVMXC__Territory__c(Name=Name);
        //insert installedProduct;
        return territory;
    }
    //Create Service Team
    public static SVMXC__Service_Group__c CreateServiceTeam(String teamName,String recordType) {
        SVMXC__Service_Group__c serviceTeam=new SVMXC__Service_Group__c();
        serviceTeam.Name=teamName;
        serviceTeam.RecordTypeId=recordType;
        //insert serviceTeam;
        return serviceTeam;
    }
    //Create Technician/Equipment
    public static SVMXC__Service_Group_Members__c CreateTechnicianOrEquipment(String techName,SVMXC__Service_Group__c serviceTeam,String recordType) {
        SVMXC__Service_Group_Members__c technician=new SVMXC__Service_Group_Members__c();
        technician.Name='testTech';
        technician.SVMXC__Service_Group__c=serviceTeam.Id;
        technician.RecordTypeId=recordType;
        return technician;
        
    }
    //Create Event
    public static Event CreateEvent(String userId,datetime startDate,datetime endDate,String whatId,String subject) {
        Event eventInstance=new Event(OwnerId=userId,EndDateTime=endDate,StartDateTime=startDate,WhatId=whatId,Subject=subject);
        return eventInstance;
    }
    //Create SVMX Event
    public static SVMXC__SVMX_Event__c CreateSVMXEvent(String userId,datetime startDate,datetime endDate,String whatId,String subject,String technicianId) {
        SVMXC__SVMX_Event__c svmxEventInstance=new SVMXC__SVMX_Event__c(OwnerId=userId,SVMXC__EndDateTime__c=endDate,SVMXC__StartDateTime__c=startDate,SVMXC__WhatId__c=whatId,Name=subject,SVMXC__Technician__c=technicianId);
        return svmxEventInstance;
    }
    //Create Work Order
    public static SVMXC__Service_Order__c CreateWorkOrder(Account acc,Contact con,String BOSystem,String BOCountry) {
        SVMXC__Service_Order__c workOrderInstance=new SVMXC__Service_Order__c();
        workOrderInstance.SVMXC__Company__c=acc.Id;
        workOrderInstance.SVMXC__Contact__c=con.Id;
        workOrderInstance.Back_Office_System__c=BOSystem;
        workOrderInstance.Back_Office_Country__c=BOCountry;
        //insert workOrderInstance;
        return workOrderInstance;
        
        
    }
    //Create Work Detail of Part Type 
    public static SVMXC__Service_Order_Line__c CreateWorkDetailPart(SVMXC__Service_Order__c workOrderInstance,Product2 product,Integer RequestedQuantity,Integer QuantityShipped,Integer UsedQuantity) {
        //Get Usage/Consumption Record type Id
        String recordTypeUC = String.valueOf(Schema.SObjectType.SVMXC__Service_Order_Line__c.getRecordTypeInfosByName().get('Usage/Consumption').getRecordTypeId());
        //Create Work Detail Of Part Line Type
        SVMXC__Service_Order_Line__c partInstance=new SVMXC__Service_Order_Line__c();
        partInstance.SVMXC__Line_Type__c='Parts';
        partInstance.RecordTypeId=recordTypeUC;
        partInstance.SVMXC__Service_Order__c=workOrderInstance.Id;
        partInstance.SVMXC__Product__c=product.Id;
        partInstance.SVMXC__Requested_Quantity2__c=RequestedQuantity;
        partInstance.SVMXC__Quantity_Shipped2__c=QuantityShipped;
        partInstance.Used_Qty__c=UsedQuantity;
        //partInstance.Environmental_Footprint__c=EnvironmentalFootprint;
        //insert partInstance;
        return partInstance;
    }
    //Create Work Detail of Labor Type
    public static SVMXC__Service_Order_Line__c CreateWorkDetailLabor(SVMXC__Service_Order__c workOrderInstance,String ActivityType,Datetime StartDate,Datetime EndDate,SVMXC__Service_Group_Members__c technician) {
        //Get Usage/Consumption Record type Id
        String recordTypeUC = String.valueOf(Schema.SObjectType.SVMXC__Service_Order_Line__c.getRecordTypeInfosByName().get('Usage/Consumption').getRecordTypeId());
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c LaborInstance=new SVMXC__Service_Order_Line__c();
        LaborInstance.SVMXC__Line_Type__c='Labor';
        LaborInstance.RecordTypeId=recordTypeUC;
        LaborInstance.SVMXC__Service_Order__c=workOrderInstance.Id;
        LaborInstance.SVMXC__Activity_Type__c=ActivityType;
        LaborInstance.SVMXC__Start_Date_and_Time__c=StartDate;
        LaborInstance.SVMXC__End_Date_and_Time__c=EndDate;
        LaborInstance.SVMXC__Group_Member__c=technician.Id;
        //insert LaborInstance;
        return LaborInstance;
       
    }
    //Create Work Detail of Expense Type
    public static SVMXC__Service_Order_Line__c CreateWorkDetailExpense(SVMXC__Service_Order__c workOrderInstance) {
        //Get Usage/Consumption Record type Id
        String recordTypeUC = String.valueOf(Schema.SObjectType.SVMXC__Service_Order_Line__c.getRecordTypeInfosByName().get('Usage/Consumption').getRecordTypeId());
        //Create Work Detail of Expense Line Type
        SVMXC__Service_Order_Line__c ExpenseInstance=new SVMXC__Service_Order_Line__c();
        //ExpenseInstance.SVMXC__Line_Type__c='Expenses';
        ExpenseInstance.RecordTypeId=recordTypeUC;
        ExpenseInstance.SVMXC__Service_Order__c=workOrderInstance.Id;
        //ExpenseInstance.SVMXC__Expense_Type__c='Airfare';
        //insert ExpenseInstance;
        return ExpenseInstance;
       
    }

    //Create Work Detail of Travel Type
    public static SVMXC__Service_Order_Line__c CreateWorkDetailTravel(SVMXC__Service_Order__c workOrderInstance,Datetime StartDate,Datetime EndDate,SVMXC__Service_Group_Members__c technician) {
        //Get Usage/Consumption Record type Id
        String recordTypeUC = String.valueOf(Schema.SObjectType.SVMXC__Service_Order_Line__c.getRecordTypeInfosByName().get('Usage/Consumption').getRecordTypeId());
        SVMXC__Service_Order_Line__c TravelInstance=new SVMXC__Service_Order_Line__c();
        TravelInstance.SVMXC__Line_Type__c='Travel';
        TravelInstance.RecordTypeId=recordTypeUC;
        TravelInstance.SVMXC__Service_Order__c=workOrderInstance.Id;
        TravelInstance.SVMXC__Start_Date_and_Time__c=StartDate;
        TravelInstance.SVMXC__End_Date_and_Time__c=EndDate;
        //TravelInstance.FSR_Start_Date_and_Time__c=date.parse(FSRStartDate);
        //TravelInstance.FSR_End_Date_and_Time__c=date.parse(FSREndDate);
        TravelInstance.SVMXC__Group_Member__c=technician.Id;
        //insert TravelInstance;
        return TravelInstance;
       
    }

    //Create Work Detail of Product Serviced Type
    public static SVMXC__Service_Order_Line__c CreateWorkDetailProductServiced(SVMXC__Service_Order__c workOrderInstance,SVMXC__Installed_Product__c installedProduct,Boolean OK_IP,Boolean NOK_IP,Boolean NOT_Tested) {
         //Create Work Detail of Product Serviced Record Type
         String recordTypePS = String.valueOf(Schema.SObjectType.SVMXC__Service_Order_Line__c.getRecordTypeInfosByName().get('Products Serviced').getRecordTypeId());
         SVMXC__Service_Order_Line__c psInstance=new SVMXC__Service_Order_Line__c();
         psInstance.RecordTypeId=recordTypePS;
         psInstance.SVMXC__Service_Order__c=workOrderInstance.Id;
         psInstance.SVMXC__Serial_Number__c=installedProduct.Id;
         psInstance.OK_IP__c=OK_IP;
         psInstance.NOK_IP__c=NOK_IP;
         psInstance.Not_Tested_IP__c=NOT_Tested;
         //insert psInstance;
        return psInstance;
       
    }
    //Create Service Contract with record type Header
    public static SVMXC__Service_Contract__c CreateServiceContractHeader(String contractName,Account acc,Date StartDate,Date EndDate) {
        String headerRecordTypeId = String.valueOf(Schema.SObjectType.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get('Contract Header').getRecordTypeId());
        SVMXC__Service_Contract__c testContract=new SVMXC__Service_Contract__c();
        testContract.RecordTypeId=headerRecordTypeId;
        testContract.Name=contractName;
        testContract.SVMXC__Company__c=acc.Id;
        testContract.SVMXC__Start_Date__c=StartDate;
        testContract.SVMXC__End_Date__c=EndDate;
        //insert testContract;
        return testContract;
    }

    //Create Service Contract with record type Line 
    public static SVMXC__Service_Contract__c CreateServiceContractLine(String contractName,SVMXC__Service_Contract__c header,Account acc,SVMXC__Installed_Product__c installedProduct) {
        String lineRecordTypeId = String.valueOf(Schema.SObjectType.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get('Contract Line').getRecordTypeId());
        SVMXC__Service_Contract__c testContractLine=new SVMXC__Service_Contract__c();
        testContractLine.RecordTypeId=lineRecordTypeId;
        testContractLine.Name=contractName;
        testContractLine.SVMXC__Company__c=acc.Id;
        testContractLine.SVMX_PS_Parent_Contract__c=header.Id;
        testContractLine.Installation__c=installedProduct.Id;
        //insert testContractLine;
        return testContractLine;
    }

    //Create Preventive maintenance plan
    public static SVMXC__PM_Plan__c CreatePMPlan(String pmName,String status,SVMXC__Service_Contract__c contract,Date StartDate,Date EndDate){
        SVMXC__PM_Plan__c pmInstance=new SVMXC__PM_Plan__c(Name=pmName,SVMXC__Status__c=status,SVMXC__Service_Contract__c=contract.Id,SVMXC__Start_Date__c=StartDate,SVMXC__End_Date__c=EndDate);
        return pmInstance;

    }

    //Create PM Template
    public static SVMXC__PM_Plan_Template__c CreatePMTemplate(String templateName,String coverageType,Integer startDateDelay,String startDateDelayUnit){
        //add Pm plan
        SVMXC__PM_Plan_Template__c pmTemplateInstance=new SVMXC__PM_Plan_Template__c(Name=templateName,SVMXC__Coverage_Type__c=coverageType,SVMXC__SM_Unit_Value__c=startDateDelay,SVMXC__SM_Unit_Type__c=startDateDelayUnit);
        return pmTemplateInstance;

    }

    //Create PM Schedule Template
    public static SVMXC__PM_Schedule_Template__c CreatePMScheduleTemplate(Integer sequence,String scheduleType,SVMXC__PM_Plan_Template__c pmTemplate,String visitDescription,Integer frequency,String frequencyUnit,Boolean recurring,Integer woEstimatedDuration){
        //add WO Purpose
        SVMXC__PM_Schedule_Template__c pmScheduleTemplateInstance=new SVMXC__PM_Schedule_Template__c(SVMXC__Sequence__c=sequence,SVMXC__Schedule_Type__c=scheduleType,SVMXC__PM_Plan_Template__c=pmTemplate.Id,SVMXC__Visit_Description__c=visitDescription,SVMXC__Frequency__c=frequency,SVMXC__Frequency_Unit__c=frequencyUnit,SVMXC__Recurring__c=recurring,WoDefaultEstimatedDuration__c=woEstimatedDuration);
        return pmScheduleTemplateInstance;

    }

    //Create Task Template
    public static SVMXC__Task_Template__c CreateTaskTemplate(String templateName,String templateType,String description){
        SVMXC__Task_Template__c taskInstance=new SVMXC__Task_Template__c(SVMXC__Template_Name__c=templateName,SVMXC__Template_Type__c=templateType,SVMXC__Description__c=description);
        return taskInstance;
        
    }

    //Create PM Schedule Definition
    public static SVMXC__PM_Schedule_Definition__c CreatePmScheduleDefinition(SVMXC__PM_Plan__c pmPlan,SVMXC__Task_Template__c workOrderPurpose,String description,Integer frequency,String frequencyUnit,Boolean recurring,Integer woDuration){
        SVMXC__PM_Schedule_Definition__c pmScheduleDefinitionInstance=new SVMXC__PM_Schedule_Definition__c(SVMXC__PM_Plan__c=pmPlan.Id,SVMXC__Work_Order_Purpose__c=workOrderPurpose.Id,SVMXC__Visit_Description__c=description,SVMXC__Frequency__c=frequency,SVMXC__Frequency_Unit__c=frequencyUnit,SVMXC__Recurring__c=recurring,WO_Duration_In_Minutes__c=woDuration);
        return pmScheduleDefinitionInstance;
    }

    //Create PM Schedule
    public static SVMXC__PM_Schedule__c CreatePMSchedule(Date scheduledOn,SVMXC__PM_Plan__c pmPlan,SVMXC__PM_Schedule_Definition__c pmScheduleDefinitionInstance){
        SVMXC__PM_Schedule__c pmScheduleInstance=new SVMXC__PM_Schedule__c(SVMXC__Scheduled_On__c=scheduledOn,SVMXC__PM_Plan__c=pmPlan.Id,SVMXC__PM_Schedule_Definition__c=pmScheduleDefinitionInstance.Id);
        return pmScheduleInstance;
    }


}