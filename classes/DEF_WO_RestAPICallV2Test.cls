/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-22-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class DEF_WO_RestAPICallV2Test {
    static testMethod void getPMWorkOrder() {
        
        //*****Making Test Data******//
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        Contact con=DEF_TestDataFactory.CreateContact('TestContact');
        insert con;
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
        workOrderInstance.SVMXC__Order_Type__c = 'Maintenance';
        workOrderInstance.PM_WO_Sent_To_DEX__c=false;
        insert workOrderInstance;
        
        //Create Work Detail Of Part Line Type
        SVMXC__Service_Order_Line__c partInstance=DEF_TestDataFactory.CreateWorkDetailPart(workOrderInstance,product,2,2,2);
        insert partInstance;
        SVMXC__Service_Order_Line__c partInstance02=DEF_TestDataFactory.CreateWorkDetailPart(workOrderInstance,product,2,2,2);
        insert partInstance02;
        
        //Create Work Detail Of Labor Line Type
        SVMXC__Service_Order_Line__c LaborInstance=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now(),technician);
        insert LaborInstance;
        SVMXC__Service_Order_Line__c LaborInstance02=DEF_TestDataFactory.CreateWorkDetailLabor(workOrderInstance,'Installation',Datetime.now(),Datetime.now(),technician);
        insert LaborInstance02;
       
        //Create Work Detail of Expense Line Type
        SVMXC__Service_Order_Line__c ExpenseInstance=DEF_TestDataFactory.CreateWorkDetailExpense(workOrderInstance);
        insert ExpenseInstance;
        SVMXC__Service_Order_Line__c ExpenseInstance02=DEF_TestDataFactory.CreateWorkDetailExpense(workOrderInstance);
        insert ExpenseInstance02;
       
        //Create Work Detail of Travel Line Type
        SVMXC__Service_Order_Line__c TravelInstance=DEF_TestDataFactory.CreateWorkDetailTravel(workOrderInstance,Datetime.now(),Datetime.now(),technician);
        insert TravelInstance;
        SVMXC__Service_Order_Line__c TravelInstance02=DEF_TestDataFactory.CreateWorkDetailTravel(workOrderInstance,Datetime.now(),Datetime.now(),technician);
        insert TravelInstance02;
        
        //Create Work Detail of Product Serviced Record Type
        SVMXC__Service_Order_Line__c psInstance=DEF_TestDataFactory.CreateWorkDetailProductServiced(workOrderInstance,installedProduct,true,false,false);
        insert psInstance;
        SVMXC__Service_Order_Line__c psInstance02=DEF_TestDataFactory.CreateWorkDetailProductServiced(workOrderInstance,installedProduct,true,false,false);
        insert psInstance02;

        
        //Get Request Work Order
        RestRequest contractRequest = new RestRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        contractRequest.requestUri = baseUrl+'/services/apexrest/v2/workorder/';
        contractRequest.httpMethod = 'GET';
        RestContext.request = contractRequest;
       
        String responseString=String.valueOf(DEF_WO_RestAPICallV2.getPMWorkOrder());

    }
    
}