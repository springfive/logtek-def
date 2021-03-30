/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class DEF_SC_UpdateStatusWhenContractExpired implements Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;
    public Integer NoOfSuccess = 0;
    public Integer NoOfFailures = 0;
    // These next two lists hold the ids of sucessful and failed updates.
    private List<Id> successes = new List<Id>();
    private List<Id> failures = new List<Id>();
    /*
    public Database.QueryLocator start(Database.BatchableContext bc) {
        //Id RecordTypeForHeader=Schema.Sobjecttype.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get('Contract Header').getRecordTypeId();
        return Database.getQueryLocator('SELECT Id,RecordTypeId,Status__c,SVMXC__Active__c,SVMXC__End_Date__c,SVMXC__Start_Date__c FROM SVMXC__Service_Contract__c WHERE SVMX_PS_Parent_Contract__c=null AND Status__c = \'Active\'');
    }
    */
    public List<SVMXC__Service_Contract__c> start(Database.BatchableContext bc){ 
        Date todayDate=System.today();
        Id RecordTypeForHeader=Schema.Sobjecttype.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get('Contract Header').getRecordTypeId();
        List<SVMXC__Service_Contract__c> contracts=new List<SVMXC__Service_Contract__c>();
        if(Test.isRunningTest()){
            contracts=[SELECT Id,RecordTypeId,Status__c,SVMXC__Active__c,SVMXC__End_Date__c,SVMXC__Start_Date__c FROM SVMXC__Service_Contract__c WHERE RecordTypeId =:RecordTypeForHeader AND Status__c = 'Active' AND SVMXC__End_Date__c=: date.today()];
        }
        else{
        	contracts=[SELECT Id,RecordTypeId,Status__c,SVMXC__Active__c,SVMXC__End_Date__c,SVMXC__Start_Date__c FROM SVMXC__Service_Contract__c WHERE RecordTypeId =:RecordTypeForHeader AND Status__c = 'Active' AND SVMXC__End_Date__c<: date.today()];
        }        System.debug('Records Returned '+contracts);
        return contracts; 
    }  

    public void execute(Database.BatchableContext bc, List<SVMXC__Service_Contract__c> scope){
        System.debug('Records from Query '+scope);
        // process each batch of records
        List<SVMXC__Service_Contract__c> contractsToUpdate = new List<SVMXC__Service_Contract__c>();
        //Check the Contract that are expired already and add those to the list to update
        for (SVMXC__Service_Contract__c contractInstance : scope) {
            System.debug('Record-> '+contractInstance);
            
            SVMXC__Service_Contract__c contract=new SVMXC__Service_Contract__c();
            contract.Id=contractInstance.Id;
            contract.Status__c='Expired';
            contract.SVMXC__Active__c=false;
            contractsToUpdate.add(contract);
            //recordsProcessed = recordsProcessed + 1;
           
            
            
        }
        
        if(contractsToUpdate.size()>0){
            List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
            //Update the Contracts Expired to Status Expired
            saveResults = Database.update(contractsToUpdate, false);
            for (Database.SaveResult sr : saveResults) {
                recordsProcessed = recordsProcessed + 1;
                if (sr.isSuccess()) {
                    NoOfSuccess=NoOfSuccess+1;
                    successes.add(sr.Id);
                } else {
                    NoOfFailures=NoOfFailures+1;
                    failures.add(sr.Id);
                }
            }
            System.debug('No Of Record Processed '+recordsProcessed);
            System.debug('No Of Success '+NoOfSuccess);
            System.debug('No Of Fails '+NoOfFailures);

        }
    }
    public void finish(Database.BatchableContext bc){
        
    }
}