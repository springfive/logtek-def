/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-21-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class DEF_WO_RestAPICallTest {
    static testMethod void getWorkOrder() {
        //Preparing Test Data
        //Account Create
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        //Contact create
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
        //Product Create
        Product2 product=DEF_TestDataFactory.CreateProduct('TestProduct');
        insert product;
        //Installed Product Create
        SVMXC__Installed_Product__c installedProduct=DEF_TestDataFactory.CreateInstalledProduct('TestIP',product,'Installed');
        insert installedProduct;
        //Service Team Create
        String recordTypeTechnicianST = String.valueOf(Schema.SObjectType.SVMXC__Service_Group__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group__c serviceTeam=DEF_TestDataFactory.CreateServiceTeam('TestServiceTeam',recordTypeTechnicianST);
        insert serviceTeam;
        //Technician/Equiment Create
        String recordTypeTechnicianTE = String.valueOf(Schema.SObjectType.SVMXC__Service_Group_Members__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
        SVMXC__Service_Group_Members__c technician=DEF_TestDataFactory.CreateTechnicianOrEquipment('TestTechnician',serviceTeam,recordTypeTechnicianTE);
        insert technician;
        //Work Order Create
        SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
        insert workOrderInstance;
        
        //Create Work Detail Of Part Line Type
        SVMXC__Service_Order_Line__c partInstance=DEF_TestDataFactory.CreateWorkDetailPart(workOrderInstance,product,2,2,2);
        insert partInstance;
        
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c LaborInstance=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now(),technician);
        insert LaborInstance;
        
        //Create Work Detail of Expense Line Type
        SVMXC__Service_Order_Line__c ExpenseInstance=DEF_TestDataFactory.CreateWorkDetailExpense(workOrderInstance);
        insert ExpenseInstance;
        
       
        //Create Work Detail of Travel Line Type
        SVMXC__Service_Order_Line__c TravelInstance=DEF_TestDataFactory.CreateWorkDetailTravel(workOrderInstance,Datetime.now(),Datetime.now(),technician);
        insert TravelInstance;
        
        //Create Work Detail of Product Serviced Record Type
        SVMXC__Service_Order_Line__c psInstance=DEF_TestDataFactory.CreateWorkDetailProductServiced(workOrderInstance,installedProduct,true,false,false);
        insert psInstance;

    
        //String WorkOrderId=DEF_TestDataFactory.CreateWorkOrderWithWorkDetail();
        // Set mock callout class for handling http callout
        Test.setMock(HttpCalloutMock.class, new DEF_MockHttpResponseGenerator());
        RestRequest contractRequest = new RestRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        contractRequest.requestUri = baseUrl+'/services/apexrest/v1/workorder/'+workOrderInstance.Id;
        system.debug('url '+baseUrl+'/services/apexrest/v1/workorder/'+workOrderInstance.Id);
        contractRequest.httpMethod = 'GET';
        RestContext.request = contractRequest;
        Test.startTest();
        String responseString=String.valueOf(DEF_WO_RestAPICall.getWorkOrder());
        Test.stopTest();
    }

    static testMethod void updateWorkOrder() {
        //Preparing Test Data
         //Account Create
         Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
         insert acc;
         //Contact create
         Contact con=DEF_TestDataFactory.CreateContact('TestContact');
         insert con;
         //Product Create
         Product2 product=DEF_TestDataFactory.CreateProduct('TestProduct');
         insert product;
         //Installed Product Create
         SVMXC__Installed_Product__c installedProduct=DEF_TestDataFactory.CreateInstalledProduct('TestIP',product,'Installed');
         insert installedProduct;
         //Service Team Create
         String recordTypeTechnicianST = String.valueOf(Schema.SObjectType.SVMXC__Service_Group__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
         SVMXC__Service_Group__c serviceTeam=DEF_TestDataFactory.CreateServiceTeam('TestServiceTeam',recordTypeTechnicianST);
         insert serviceTeam;
         //Technician/Equiment Create
         String recordTypeTechnicianTE = String.valueOf(Schema.SObjectType.SVMXC__Service_Group_Members__c.getRecordTypeInfosByName().get('Technician').getRecordTypeId());
         SVMXC__Service_Group_Members__c technician=DEF_TestDataFactory.CreateTechnicianOrEquipment('TestTechnician',serviceTeam,recordTypeTechnicianTE);
         insert technician;
         //Work Order Create
         SVMXC__Service_Order__c workOrderInstance=DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','GB');
         insert workOrderInstance;
         
         //Create Work Detail Of Part Line Type
         SVMXC__Service_Order_Line__c partInstance=DEF_TestDataFactory.CreateWorkDetailPart(workOrderInstance,product,2,2,2);
         insert partInstance;
         //Create Work Detail Of Labor Line Type
         SVMXC__Service_Order_Line__c LaborInstance=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now(),technician);
         insert LaborInstance;

         //Create Work Detail Of Labor Line Type
         SVMXC__Service_Order_Line__c LaborInstanceNeg=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now(),technician);
         insert LaborInstanceNeg;
         //delete LaborInstanceNeg;
         
         //Create Work Detail of Expense Line Type
         SVMXC__Service_Order_Line__c ExpenseInstance=DEF_TestDataFactory.CreateWorkDetailExpense(workOrderInstance);
         insert ExpenseInstance;
        
        
         //Create Work Detail of Travel Line Type
         SVMXC__Service_Order_Line__c TravelInstance=DEF_TestDataFactory.CreateWorkDetailTravel(workOrderInstance,Datetime.now(),Datetime.now(),technician);
         insert TravelInstance;
         //Create Work Detail of Product Serviced Record Type
         SVMXC__Service_Order_Line__c psInstance=DEF_TestDataFactory.CreateWorkDetailProductServiced(workOrderInstance,installedProduct,true,false,false);
         insert psInstance;
 
         //Preparing Wrapper Data
         DEF_WO_RestAPICall.WorkOrderWrapper  woWrapperInstance=new DEF_WO_RestAPICall.WorkOrderWrapper();
         woWrapperInstance.WOServiceMaxID=workOrderInstance.Id;
         woWrapperInstance.BORefNumber='TD_BOWO-00001';
         List<DEF_WO_RestAPICall.PartsWrapper> partsWrapperList=new List<DEF_WO_RestAPICall.PartsWrapper>();
         List<DEF_WO_RestAPICall.LaborWrapper> laborWrapperList=new List<DEF_WO_RestAPICall.LaborWrapper>();
         List<DEF_WO_RestAPICall.TravelWrapper> travelWrapperList=new List<DEF_WO_RestAPICall.TravelWrapper>();
         List<DEF_WO_RestAPICall.ExpenseWrapper> expenseWrapperList=new List<DEF_WO_RestAPICall.ExpenseWrapper>();
         List<DEF_WO_RestAPICall.ProductServicedWrapper> psWrapperList=new List<DEF_WO_RestAPICall.ProductServicedWrapper>();
         DEF_WO_RestAPICall.PartsWrapper partRecord=new DEF_WO_RestAPICall.PartsWrapper();
         partRecord.BackOfficeRef='TD_BOWD-P0001';
         partRecord.WDServiceMaxId=partInstance.Id;
         partsWrapperList.add(partRecord);
         DEF_WO_RestAPICall.LaborWrapper laborRecord=new DEF_WO_RestAPICall.LaborWrapper();
         laborRecord.BackOfficeRef='TD_BOWD-L0001';
         laborRecord.WDServiceMaxId=LaborInstance.Id;
         laborWrapperList.add(laborRecord);

         DEF_WO_RestAPICall.LaborWrapper laborRecordNeg=new DEF_WO_RestAPICall.LaborWrapper();
         laborRecordNeg.BackOfficeRef='TD_BOWD-L0002';
         laborRecordNeg.WDServiceMaxId=LaborInstanceNeg.Id;
         laborWrapperList.add(laborRecordNeg);
         DEF_WO_RestAPICall.TravelWrapper travelRecord=new DEF_WO_RestAPICall.TravelWrapper();
         travelRecord.WDServiceMaxId=TravelInstance.Id;
         travelRecord.BackOfficeRef='TD_BOWD-T0001';
         travelWrapperList.add(travelRecord);
         
         DEF_WO_RestAPICall.ExpenseWrapper expenseRecord=new DEF_WO_RestAPICall.ExpenseWrapper();
         expenseRecord.WDServiceMaxId=ExpenseInstance.Id;
         expenseRecord.BackOfficeRef='TD_BOWD-E0001';
         expenseWrapperList.add(expenseRecord);
         
         DEF_WO_RestAPICall.ProductServicedWrapper psRecord=new DEF_WO_RestAPICall.ProductServicedWrapper();
         psRecord.WDServiceMaxId=psInstance.Id;
         psRecord.BackOfficeRef='TD_BOBD-PS0001';
         psWrapperList.add(psRecord);
 
         //add parts,labor,expense,travel and product serviced list to work order
         woWrapperInstance.Parts=partsWrapperList;
         woWrapperInstance.Labor=laborWrapperList;
         woWrapperInstance.Expense=expenseWrapperList;
         woWrapperInstance.Travel=travelWrapperList;
         woWrapperInstance.ProductServiced=psWrapperList;
         //Add wo instance to Wo List
         List<DEF_WO_RestAPICall.WorkOrderWrapper> woList=new List<DEF_WO_RestAPICall.WorkOrderWrapper>();
         woList.add(woWrapperInstance);
         //return woList;


		// Set mock callout class for handling http callout
        Test.setMock(HttpCalloutMock.class, new DEF_MockHttpResponseGenerator());
        //List<DEF_TestDataFactory.WorkOrderWrapper> WOList=DEF_TestDataFactory.CreateWorkOrderWrapper();
        RestRequest contractRequest = new RestRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        contractRequest.requestUri = baseUrl+'/services/apexrest/v1/workorder/';
        contractRequest.httpMethod = 'PATCH';
        contractRequest.requestBody = Blob.valueOf(JSON.serialize(woList));
        RestContext.request = contractRequest;
        // Testing the API
        Test.startTest();
        String responseString=String.valueOf(DEF_WO_RestAPICall.updateWorkOrder());
        Test.stopTest();


    }
}