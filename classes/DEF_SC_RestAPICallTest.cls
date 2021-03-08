/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 12-15-2020
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-08-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class DEF_SC_RestAPICallTest {
    /*
public static String getUUID()
{
Blob b = Crypto.GenerateAESKey(128);
String h = EncodingUtil.ConvertTohex(b);
String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
system.debug(guid);
return guid;
}
*/
    static testMethod void testPost() {
        Profile p = [SELECT Id FROM Profile WHERE Name='DEF Integration']; 
        User u = new User(Alias = 'intet', Email='test.user@testorg.com', 
                          EmailEncodingKey='UTF-8',FirstName='Test',LastName='User', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='Europe/Paris', UserName='test.user@def-fs.com');
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            
            //Preparing Test Data
            List<DEF_SC_RestAPICall.contractHeaderWrapper> headerList=new List<DEF_SC_RestAPICall.contractHeaderWrapper>();
            Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
            insert acc;
            Contact con=DEF_TestDataFactory.CreateContact('TestContact');
            insert con;
            Product2 product=DEF_TestDataFactory.CreateProduct('TestProduct');
            insert product;
            SVMXC__Installed_Product__c installedProduct=DEF_TestDataFactory.CreateInstalledProduct('TestIP',product,'Installed');
            insert installedProduct;
            SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
            insert location;
            DEF_SC_RestAPICall.contractHeaderWrapper headerInstance1=new DEF_SC_RestAPICall.contractHeaderWrapper();
            headerInstance1.BOContractId='TD_SCH-001';
            headerInstance1.BOSystem='Navision';
            headerInstance1.BOCountry='San Francisco';
            headerInstance1.Status='Open';
            headerInstance1.Name='ContractHeader';
            headerInstance1.AccountId=acc.Id;
            headerInstance1.DefCompany='IT_DEF';
            headerInstance1.InstallationDiscipline='ID0001';
            headerInstance1.StartDate=Datetime.now().format('MM/dd/yyyy');
            headerInstance1.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            headerInstance1.Contact=con.Id;
            headerInstance1.BillTo=acc.Id;
            headerInstance1.Description='Test';
            headerInstance1.IsEvergreen='true';
            //contract Line segment
            List<DEF_SC_RestAPICall.contractLineWrapper> contractLineList=new List<DEF_SC_RestAPICall.contractLineWrapper>();
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance1=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance1.Name='ContractLine';
            contractLineInstance1.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance1.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance1.Status='Open';
            contractLineInstance1.Installation=installedProduct.Id;
            contractLineInstance1.BOContractLineId='TD_SCL-001';
            contractLineInstance1.BOParentContractId=headerInstance1.BOContractId;
            contractLineInstance1.Location=location.Id;
            contractLineInstance1.InstallationDiscipline='ID0001';
            
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance2=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance2.Name='ContractLine';
            contractLineInstance2.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance2.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance2.Status='Open';
            contractLineInstance2.Installation=installedProduct.Id;
            contractLineInstance2.BOContractLineId='TD_SCL-002';
            contractLineInstance2.BOParentContractId=headerInstance1.BOContractId;
            contractLineInstance2.Location=location.Id;
            contractLineInstance2.InstallationDiscipline='ID0001';
            contractLineList.add(contractLineInstance1);
            contractLineList.add(contractLineInstance2);
            
            
            //assign Contract Line to header
            headerInstance1.ContractLines=contractLineList;
            //add header to header list
            headerList.add(headerInstance1);
            DEF_SC_RestAPICall.contractHeaderWrapper headerInstance2=new DEF_SC_RestAPICall.contractHeaderWrapper();
            headerInstance2.BOContractId='TD_SCH-002';
            headerInstance2.BOSystem='Navision';
            headerInstance2.BOCountry='San Francisco';
            headerInstance2.Status='Open';
            headerInstance2.Name='ContractHeader';
            headerInstance2.AccountId=acc.Id;
            headerInstance2.DefCompany='IT_DEF';
            headerInstance2.InstallationDiscipline='ID0001';
            headerInstance2.StartDate=Datetime.now().format('MM/dd/yyyy');
            headerInstance2.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            headerInstance2.Contact=con.Id;
            headerInstance2.Description='Test';
            headerInstance2.IsEvergreen='false';
            List<DEF_SC_RestAPICall.contractLineWrapper> contractLineList2=new List<DEF_SC_RestAPICall.contractLineWrapper>();
            //contract Line segment
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance3=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance3.Name='ContractLine1';
            contractLineInstance3.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance3.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance3.Status='Open';
            contractLineInstance3.Installation=installedProduct.Id;
            contractLineInstance3.BOContractLineId='TD_SCL-003';
            contractLineInstance3.BOParentContractId=headerInstance2.BOContractId;
            contractLineInstance3.Location=location.Id;
            contractLineInstance3.InstallationDiscipline='ID0001';
            contractLineList2.add(contractLineInstance3);
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance4=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance4.Name='ContractLine2';
            contractLineInstance4.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance4.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance4.Status='Cancel';
            contractLineInstance4.Installation=installedProduct.Id;
            contractLineInstance4.BOContractLineId='TD_SCL-004';
            contractLineInstance4.BOParentContractId=headerInstance2.BOContractId;
            contractLineInstance4.Location=location.Id;
            contractLineInstance4.InstallationDiscipline='ID0001';
            contractLineList2.add(contractLineInstance4);
            //assign Contract Line to header
            headerInstance2.ContractLines=contractLineList2;
            headerList.add(headerInstance2);
            
            
            //List<DEF_TestDataFactory.contractHeaderWrapper> headerList=DEF_TestDataFactory.CreateServiceContractWrapperForInsert();
            RestRequest contractRequest = new RestRequest();
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            contractRequest.requestUri = baseUrl+'/services/apexrest/v2/servicecontract/';
            contractRequest.httpMethod = 'POST';
            contractRequest.requestBody = Blob.valueOf(JSON.serialize(headerList));
            RestContext.request = contractRequest;
            // Testing the API
            Test.startTest();
            String responseString=String.valueOf(DEF_SC_RestAPICall.createContract());
            Test.stopTest();
        }
        
    }
    
    static testMethod void testPatch() {
        Profile p = [SELECT Id FROM Profile WHERE Name='DEF Integration']; 
        User u = new User(Alias = 'intet', Email='test.user@testorg.com', 
                          EmailEncodingKey='UTF-8',FirstName='Test',LastName='User', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='Europe/Paris', UserName='test.user@def-fs.com');
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            List<DEF_SC_RestAPICall.contractHeaderWrapper> headerList=new List<DEF_SC_RestAPICall.contractHeaderWrapper>();
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
            //Create Service Contract Line
            SVMXC__Service_Contract__c testContractLine2=DEF_TestDataFactory.CreateServiceContractLine('ContractLine2',testContract,acc,installedProduct);
            insert testContractLine2;
            SVMXC__Service_Contract__c testContractLine3=DEF_TestDataFactory.CreateServiceContractLine('ContractLine3',testContract,acc,installedProduct);
            insert testContractLine3;
            SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
            insert location;
            DEF_SC_RestAPICall.contractHeaderWrapper headerInstance1=new DEF_SC_RestAPICall.contractHeaderWrapper();
            headerInstance1.contractId=testContract.Id;
            headerInstance1.BOContractId='TD_SCH-003';
            headerInstance1.BOSystem='Navision';
            headerInstance1.BOCountry='San Francisco';
            headerInstance1.Status='Open';
            headerInstance1.Name='ContractHeader';
            headerInstance1.AccountId=acc.Id;
            headerInstance1.DefCompany='IT_DEF';
            headerInstance1.InstallationDiscipline='ID0001';
            headerInstance1.StartDate=Datetime.now().format('MM/dd/yyyy');
            headerInstance1.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            headerInstance1.Contact=con.Id;
            headerInstance1.BillTo=acc.Id;
            headerInstance1.Description='Test';
            headerInstance1.IsEvergreen='true';
            //contract Line segment
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance1=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance1.contractLineId=testContractLine1.Id;
            contractLineInstance1.Name='ContractLine1';
            contractLineInstance1.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance1.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance1.Status='Open';
            contractLineInstance1.Installation=installedProduct.Id;
            contractLineInstance1.BOContractLineId='TD_SCL-005';
            contractLineInstance1.Location=location.Id;
            contractLineInstance1.InstallationDiscipline='ID0001';
            contractLineInstance1.BOParentContractId=headerInstance1.BOContractId;
            
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance2=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance2.contractLineId=testContractLine2.Id;
            contractLineInstance2.Name='ContractLine2';
            contractLineInstance2.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance2.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance2.Status='Open';
            contractLineInstance2.Installation=installedProduct.Id;
            contractLineInstance2.BOContractLineId='TD_SCL-006';
            contractLineInstance2.Location=location.Id;
            contractLineInstance2.InstallationDiscipline='ID0001';
            contractLineInstance2.BOParentContractId=headerInstance1.BOContractId;
            //Negative Data
            DEF_SC_RestAPICall.contractLineWrapper contractLineInstance3=new DEF_SC_RestAPICall.contractLineWrapper();
            contractLineInstance3.contractLineId=testContractLine3.Id;
            contractLineInstance3.Name='ContractLine2';
            contractLineInstance3.StartDate=Datetime.now().format('MM/dd/yyyy');
            contractLineInstance3.EndDate=Datetime.now().addYears(1).format('MM/dd/yyyy');
            contractLineInstance3.Status='Cancel'; //Invalid status
            contractLineInstance3.Installation=installedProduct.Id;
            contractLineInstance3.BOContractLineId='TD_SCL-007';
            contractLineInstance3.Location=location.Id;
            contractLineInstance3.InstallationDiscipline='ID0001';
            contractLineInstance3.BOParentContractId=headerInstance1.BOContractId;
            
            List<DEF_SC_RestAPICall.contractLineWrapper> contractLineList=new List<DEF_SC_RestAPICall.contractLineWrapper>();
            contractLineList.add(contractLineInstance1);
            contractLineList.add(contractLineInstance2);
            contractLineList.add(contractLineInstance3);
            //assign Contract Line to header
            headerInstance1.ContractLines=contractLineList;
            headerList.add(headerInstance1);
            //List<DEF_TestDataFactory.contractHeaderWrapper> headerList=DEF_TestDataFactory.CreateServiceContractWrapperForUpdate();
            RestRequest contractRequest = new RestRequest();
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            contractRequest.requestUri = baseUrl+'/services/apexrest/v2/servicecontract/';
            contractRequest.httpMethod = 'PATCH';
            contractRequest.requestBody = Blob.valueOf(JSON.serialize(headerList));
            RestContext.request = contractRequest;
            // Testing the API
            Test.startTest();
            String responseString=String.valueOf(DEF_SC_RestAPICall.updateContract());
            Test.stopTest();
        }
    }
    
    static testMethod void test_doInvoice(){
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
        //Create Service Contract Line
        SVMXC__Service_Contract__c testContractLine2=DEF_TestDataFactory.CreateServiceContractLine('ContractLine2',testContract,acc,installedProduct);
        insert testContractLine2;
        SVMXC__Service_Contract_Services__c services = new SVMXC__Service_Contract_Services__c();
        services.SVMXC__Service_Contract__c = testContractLine1.id;
        insert services;
        SVMXC__Service_Contract__c testContractLine3=DEF_TestDataFactory.CreateServiceContractLine('ContractLine3',testContract,acc,installedProduct);
        insert testContractLine3;
        SVMXC__Site__c location=DEF_TestDataFactory.CreateLocation('TestLocation');
        insert location;
        SVMXC__Service_Contract__c sc = [SELECT Id FROM SVMXC__Service_Contract__c LIMIT 1];
        RestRequest contractRequest = new RestRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        contractRequest.requestUri = baseUrl+'/services/apexrest/v2/servicecontract/'+sc.Id;
        contractRequest.httpMethod = 'GET';
        RestContext.request = contractRequest;
        Test.startTest();
        String responseString=String.valueOf(DEF_SC_RestAPICall.getServiceContract());
        Test.stopTest();
        
    }
    
}