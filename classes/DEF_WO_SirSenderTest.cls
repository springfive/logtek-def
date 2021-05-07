/**
* @author: Sofiane Bazizen (SpringFive)
* @description: Test Class for the DEF_WO_SirSender and DEF_WO_SirSender_Helper classes methods.
* @last modified on  : 2020-01-11
* @last modified by  : Sofiane Bazizen
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   2020-01-11   Sofiane Bazizen					  Initial Version
*/ 
@isTest
private class DEF_WO_SirSenderTest {

    @TestSetup static void dataGenerator() {
        
        //Product
        Product2 p = DEF_TestDataFactory.CreateProduct('testProduct');
        insert p;

        //Installed Product
        SVMXC__Installed_Product__c ip = DEF_TestDataFactory.CreateInstalledProduct('testIP', p, null);

        //Account
        Account acc = DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;

        //Contact
        Contact con = DEF_TestDataFactory.CreateContact('TestContact');
        con.Email = 'test@abc.com';
        insert con;

        //Contract header + Line
        SVMXC__Service_Contract__c contractHeader = DEF_TestDataFactory.CreateServiceContractHeader('header', acc, system.today(), system.today()+1);
        insert contractHeader;
        SVMXC__Service_Contract__c contractLine = DEF_TestDataFactory.CreateServiceContractLine('header', contractHeader, acc, ip);
        insert contractLine;

        //Entitled Contacts
        SVMXC__Service_Contract_Contacts__c entCt = new SVMXC__Service_Contract_Contacts__c();
        entCt.SVMXC__Contact__c = con.Id;
        entCt.SVMXC__Service_Contract__c = contractLine.Id;
        entCt.Must_Receive_Report__c = true;
        insert entCt;

        //Work Order
        SVMXC__Service_Order__c workOrderInstance = DEF_TestDataFactory.CreateWorkOrder(acc, con, 'Navision', 'GB');
        workOrderInstance.SVMXC__Order_Status__c = 'New';
        workOrderInstance.DEF_Company__c = 'IT_DEF';
        workOrderInstance.SVMXC__Service_Contract__c = contractLine.Id;
        insert workOrderInstance;

        ContentVersion contentVersion = new ContentVersion(
                                                           Title = 'DEF_SIR_1234',
                                                           PathOnClient = 'DEF_SIR_1234.pdf',
                                                           VersionData = Blob.valueOf('Test Content'),
                                                           IsMajorVersion = true);
        insert contentVersion;
        system.debug('Content ' + contentVersion.Id);
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Where LatestPublishedVersionId = :contentVersion.Id];
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = workOrderInstance.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        
    }

    @isTest
    private static void testSendEmailToContacts() {
        
        List<SVMXC__Service_Order__c> woToTest = new List<SVMXC__Service_Order__c>();
        for (SVMXC__Service_Order__c workOrderInstance: [SELECT Id, SVMXC__Order_Status__c FROM SVMXC__Service_Order__c]){
            workOrderInstance.SVMXC__Order_Status__c='Job Complete';
            woToTest.add(workOrderInstance);
        }
        
        Test.startTest();
        update woToTest;
        Test.stopTest();

    }
}