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
public with sharing class DEF_SC_UpdateStatusContractExpiredTest {
    static testMethod void ShedulerAndBatchTest() {
        Test.startTest();
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        insert acc;
        List<SVMXC__Service_Contract__c> contractList=new List<SVMXC__Service_Contract__c>();
        for(Integer i=0;i<10;i++){
            SVMXC__Service_Contract__c testContract=DEF_TestDataFactory.CreateServiceContractHeader('ContractHeader'+i,acc,Date.today().addYears(-1),Date.today());
            testContract.Status__c = 'Active';
            contractList.add(testContract);
        }
        insert contractList;
        DEF_SC_ShedulerForBatchContractStatus.scheduleBatch();
        //ID batchprocessid = Database.executeBatch(batch,100); 
        Test.stopTest();
    }
}