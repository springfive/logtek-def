/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 03-10-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   09-24-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@RestResource(urlMapping='/v2/servicecontract/*')
global class DEF_SC_RestAPICall {
    global class contractHeaderWrapper{
        global string Name{get;set;}
        global string AccountId{get;set;}
        global string StartDate{get;set;}
        global string EndDate{get;set;}
        global string Contact{get;set;}
        global string BOContractId{get;set;}
        global string BOCountry{get;set;}
        global string BOSystem{get;set;}
        global string Status{get;set;}
        global string ErrorDetails{get;set;}
        global string contractId{get;set;}
        global string BillTo{get;set;}
        global String Description{get;set;}
        global String IsEvergreen{get;set;}
        // global String Company{get;set;}
        global String DefCompany{get;set;}
        global String InstallationDiscipline{get;set;}
        global String BillingSchedule{get;set;}
        global List<contractLineWrapper> ContractLines{get;set;}
    }
    global class contractLineWrapper {
        global string Name {get; set;}
        global string contractLineName {get; set;}
        global string AccountId{get;set;}
        global string StartDate {get; set;}
        global string EndDate {get; set;}
        global string Installation {get; set;}
        global string BOContractLineId{get;set;}
        global string BOParentContractId{get;set;}
        global string Location {get; set;}
        global string Status{get;set;}
        global string contractLineId{get;set;}
        global String InstallationDiscipline{get;set;}
        global List<IncludedServicesWrapper> IncludedServices{get;set;}
    }
    global class IncludedServicesWrapper {
        global String IncludedServiceId;
        global String ServiceType;
    }
    
    global class ResponseContractWrapper{
        
        global id contractId {get;set;}
        global string BOContractId {get;set;}
        global string contractName {get;set;}
        global String errorDetails{get;set;}
        global List<ResponseContractLineWrapper> ContractLineResponse{get;set;}
        
    }
    global class ResponseContractLineWrapper{
        global id contractLineId{get;set;}
        global string BOContractLineId {get;set;}
        global string contractLineName {get;set;}
        global String errorDetails{get;set;}
    }
    
    public static List<SVMXC__Service_Contract__c> getHeaderContractFromWrapper(List<contractHeaderWrapper> serviceContracts,String actionName){
        List<SVMXC__Service_Contract__c> headerContractList=new List<SVMXC__Service_Contract__c>();
        
        String headerRecordTypeId = String.valueOf(Schema.SObjectType.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get('Contract Header').getRecordTypeId());
        for(contractHeaderWrapper header:serviceContracts)
        {
            SVMXC__Service_Contract__c headerInstance=new SVMXC__Service_Contract__c();
            headerInstance.Name=header.Name;
            
            if(!String.isBlank(header.contractId)){
                headerInstance.Id=header.contractId;
            }
            if(!String.isBlank(header.AccountId)){
                headerInstance.SVMXC__Company__c=header.AccountId;
            }
            headerInstance.Back_Office_Country__c=header.BOCountry;
            headerInstance.Back_Office_System__c=header.BOSystem;
            if(!String.isBlank(header.StartDate)){
                headerInstance.SVMXC__Start_Date__c=date.parse(header.StartDate);
            }
            if(!String.isBlank(header.EndDate)){
                headerInstance.SVMXC__End_Date__c=date.parse(header.EndDate);
            }
            if(headerRecordTypeId!=null)
            {
                headerInstance.RecordTypeId=headerRecordTypeId;
            }
            System.debug('Contact value '+header.Contact);
            System.debug('Isblank check '+!String.isBlank(header.Contact));
            if(!String.isBlank(header.Contact)){
                System.debug('Contact value '+header.Contact);
                headerInstance.SVMXC__Contact__c=header.Contact;
            }
            headerInstance.SVMX_PS_External_ID__c=header.BOContractId;
            if(!String.isBlank(header.Status)){
                headerInstance.Status__c=header.Status;
            }
            if(!String.isBlank(header.BillTo)){
                headerInstance.Bill_to__c=header.BillTo;
            }
            headerInstance.Description__c=header.Description;
            
            if(header.IsEvergreen=='true'){
                headerInstance.Is_Evergreen__c=true;
            }
            else {
                headerInstance.Is_Evergreen__c=false;
            }
            if(!String.isBlank(header.DefCompany)){
                headerInstance.DEF_Company__c=header.DefCompany;
            }
            if(!String.isBlank(header.InstallationDiscipline)){
                headerInstance.Installation_Discipline__c=header.InstallationDiscipline;
            }
            
            
            headerContractList.add(headerInstance);
        }
        return headerContractList;
    }
    public static List<SVMXC__Service_Contract__c> getContractLineFromWrapper(List<contractLineWrapper> lineContractList,String actionName,Map<String,Id> externalToIdMap,Map<Id,SVMXC__Site__c> locationMap,Map<String,SVMXC__Service_Contract__c> extIdToSC){
        List<SVMXC__Service_Contract__c> contractLineValidatedList=new List<SVMXC__Service_Contract__c>();
        
        String lineRecordTypeId = String.valueOf(Schema.SObjectType.SVMXC__Service_Contract__c.getRecordTypeInfosByName().get('Contract Line').getRecordTypeId());
        
        //Below Code updated by Devendra:
        
        //Set to collect the ids of installed product 
        Set<Id> ipIdSet = new Set<Id>();
        for(contractLineWrapper wrapInstance:lineContractList){
            if(!String.isBlank(wrapInstance.Installation)){
                ipIdSet.add(wrapInstance.Installation);
            }
        }
        
        //Map that will have IP Id as key and Top-level as value
        Map<Id,String> ipToplevelMap = new Map<Id,String>();
        //Loop to put values into ipToplevelMap
        if(!ipIdSet.isEmpty()){
            for(SVMXC__Installed_Product__c ip : [SELECT Id,SVMXC__Top_Level__c FROM SVMXC__Installed_Product__c WHERE Id IN : ipIdSet]){
                ipToplevelMap.put(ip.Id,ip.SVMXC__Top_Level__c);
            }
        }
        
        for(contractLineWrapper contractLineInstance:lineContractList)
        {
            if(externalToIdMap.containsKey(String.valueOf(contractLineInstance.BOParentContractId)))
            {
                SVMXC__Service_Contract__c cl=new SVMXC__Service_Contract__c();
                cl.Name=contractLineInstance.Name;
                
                if(ipToplevelMap.containsKey(contractLineInstance.Installation)){
                    cl.Top_Level__c = ipToplevelMap.get(contractLineInstance.Installation);
                }
                
                if(!String.isBlank(contractLineInstance.contractLineId)){
                    cl.Id=contractLineInstance.contractLineId;
                    
                }
                
                cl.SVMX_PS_External_ID__c=contractLineInstance.BOContractLineId;
                if(externalToIdMap.containsKey(contractLineInstance.BOParentContractId)){
                    cl.SVMX_PS_Parent_Contract__c=externalToIdMap.get(contractLineInstance.BOParentContractId);
                }
                if(externalToIdMap.containsKey(contractLineInstance.BOParentContractId)){
                    cl.Service_Maintenance_Contract_Line__c=externalToIdMap.get(contractLineInstance.BOParentContractId);
                }
                if(!String.isBlank(contractLineInstance.StartDate)){
                    cl.SVMXC__Start_Date__c=date.parse(contractLineInstance.StartDate);
                }
                if(!String.isBlank(contractLineInstance.EndDate)){
                    cl.SVMXC__End_Date__c=date.parse(contractLineInstance.EndDate);
                }
                if(!String.isBlank(contractLineInstance.Installation)){
                    cl.Installation__c=contractLineInstance.Installation;
                }
                if(!String.isBlank(contractLineInstance.Location)){
                    cl.Location__c=contractLineInstance.Location;
                }
                if(!String.isBlank(contractLineInstance.InstallationDiscipline)){
                    cl.Installation_Discipline__c=contractLineInstance.InstallationDiscipline;
                }
                //***Add Dependent Fields of location in Contract Line***/
                if(!String.isBlank(contractLineInstance.Location)){
                    
                    if(locationMap.containsKey(contractLineInstance.Location)){
                        SVMXC__Site__c siteInstance=locationMap.get(contractLineInstance.Location);
                        cl.Accreditation__c=siteInstance.Accreditation__c;
                        cl.Preferred_Technician__c=siteInstance.SVMX_PS_Preferred_Technician__c ;
                        cl.SVMXC__Business_Hours__c=siteInstance.SVMXC__Preferred_Business_Hours__c;
                        
                        
                    }
                }
                if(lineRecordTypeId!=null)
                {
                    cl.RecordTypeId=lineRecordTypeId;
                }
                if(!String.isBlank(contractLineInstance.Status)){
                    cl.Status__c=contractLineInstance.Status;
                }
                if(extIdToSC.containsKey(contractLineInstance.BOParentContractId)){
                    if(extIdToSC.get(contractLineInstance.BOParentContractId).SVMXC__Company__c!=null){
                        cl.SVMXC__Company__c=extIdToSC.get(contractLineInstance.BOParentContractId).SVMXC__Company__c;
                        
                    }
                    if(extIdToSC.get(contractLineInstance.BOParentContractId).DEF_Company__c!=null){
                        cl.DEF_Company__c=extIdToSC.get(contractLineInstance.BOParentContractId).DEF_Company__c;
                        
                    }
                    
                }
                
                contractLineValidatedList.add(cl);
            }
        }
        return contractLineValidatedList;
        
    }
    
    
    public static List<contractLineWrapper> getLineContractWrapper(List<contractHeaderWrapper> serviceContracts){
        List<contractLineWrapper> lineContractList=new List<contractLineWrapper>();
        for(contractHeaderWrapper header:serviceContracts)
        {
            
            lineContractList.addAll(header.ContractLines);
        }
        return lineContractList;
    }
    
    @HttpPost
    global static List<ResponseContractWrapper> createContract() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response; 
        string jsonInput = request.requestBody.toString();
        system.debug('request'+request.requestBody.toString());
        List<contractHeaderWrapper> serviceContracts = (List<contractHeaderWrapper>)JSON.deserialize(jsonInput, List<contractHeaderWrapper>.class);
        List<SVMXC__Service_Contract__c> headerContractList=new List<SVMXC__Service_Contract__c>();
        List<contractLineWrapper> lineContractList=new List<contractLineWrapper>();
        
        //Converting Wrapper type of contracts into Sobject Type List
        headerContractList=getHeaderContractFromWrapper(serviceContracts,'Create');
        //Getting line contracts
        lineContractList=getLineContractWrapper(serviceContracts);
        
        //DML Insert on header contracts
        Database.SaveResult[] headerResultList = Database.insert(headerContractList, false);
        
        //Map of successfull Dml of header contract from external id to salesforce id
        Map<String,Id> externalToIdMap=new Map<String,Id>();
        for (Integer k=0;k<headerResultList.size();k++) {
            if (headerResultList[k].isSuccess()) {
                
                externalToIdMap.put(headerContractList[k].SVMX_PS_External_ID__c,headerResultList[k].getId());
            }
        }
        Map<String,SVMXC__Service_Contract__c> extIdToSC=new Map<String,SVMXC__Service_Contract__c>();
        for (Integer k=0;k<headerResultList.size();k++) {
            if (headerResultList[k].isSuccess()) {
                headerContractList[k].Id=headerResultList[k].getId();
                extIdToSC.put(headerContractList[k].SVMX_PS_External_ID__c,headerContractList[k]);
            }
        }
        
        
        
        //Converting Wrapper contract line list into Sobject List those have created header contract
        List<SVMXC__Service_Contract__c> contractLineValidatedList=new List<SVMXC__Service_Contract__c>();
        //Get The Location details using SOQL Query and Create a Map of Location Id-> Sobject Record Location
        List<SVMXC__Site__c> locationList=[SELECT Accreditation__c,Id,Name,SVMXC__Preferred_Business_Hours__c,SVMX_PS_Preferred_Technician__c FROM SVMXC__Site__c];
        Map<Id,SVMXC__Site__c> locationMap=new Map<Id,SVMXC__Site__c>(locationList);
        
        contractLineValidatedList=getContractLineFromWrapper(lineContractList,'Create',externalToIdMap,locationMap,extIdToSC);
        
        
        //DML Insert of contract lines
        Database.SaveResult[] lineResultList = Database.insert(contractLineValidatedList, false);
        
        
        List<SVMXC__Service_Contract__c> headerContractToDelete=new List<SVMXC__Service_Contract__c>();
        Set<String> headerContractToDeleteSet=new Set<String>();
        
        //converting line result into response and create map between header id and line records
        Map<Id,List<ResponseContractLineWrapper>> parentToLineMap=new Map<Id,List<ResponseContractLineWrapper>>();
        List<ResponseContractLineWrapper> lineResultWrapperList=new List<ResponseContractLineWrapper>();
        for(Integer k=0;k<lineResultList.size();k++)
        {
            ResponseContractLineWrapper lineInstance=new ResponseContractLineWrapper();
            if(lineResultList[k].isSuccess())
            {
                lineInstance.contractLineId=lineResultList[k].getId();
                lineInstance.BOContractLineId=contractLineValidatedList[k].SVMX_PS_External_ID__c;
                lineInstance.contractLineName=contractLineValidatedList[k].Name;
            }
            else {
                lineInstance.errorDetails=lineResultList[k].getErrors()[0].getMessage()+' :: Due to this Error, The header and its related contracts will be deleted';
                /*SVMXC__Service_Contract__c contractInstance=new SVMXC__Service_Contract__c();
                contractInstance.Id=contractLineValidatedList[k].SVMX_PS_Parent_Contract__c;
                headerContractToDelete.add(contractInstance);*/
                headerContractToDeleteSet.add(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c);
            }
            lineResultWrapperList.add(lineInstance);
            if(parentToLineMap.containsKey(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c))
            {
                List<ResponseContractLineWrapper> wrapperInstance=parentToLineMap.get(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c);
                wrapperInstance.add(lineInstance);
                parentToLineMap.put(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c, wrapperInstance);
            }
            else {
                List<ResponseContractLineWrapper> wrapperInstance=new List<ResponseContractLineWrapper>();
                wrapperInstance.add(lineInstance);
                parentToLineMap.put(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c, wrapperInstance);
            }
        }
        
        //Converting Header result into response and synchronise header and line records
        List<ResponseContractWrapper> contractResponseList=new List<ResponseContractWrapper>();
        for (Integer k=0;k<headerResultList.size();k++) {
            ResponseContractWrapper res=new ResponseContractWrapper();
            if (headerResultList[k].isSuccess()) {
                res.contractId=String.valueOf(headerResultList[k].getId());
                res.BOContractId=headerContractList[k].SVMX_PS_External_ID__c;
                res.contractName=headerContractList[k].Name;
                res.ContractLineResponse=parentToLineMap.get(headerContractList[k].Id);
            }
            else {
                res.errorDetails=headerResultList[k].getErrors()[0].getMessage()+' :: Due to this error No Line Contract Will be Created for this record';              
                
            }
            contractResponseList.add(res);
        }
        
        //Rollback On Error
        
        //System.debug('@headerContractToDeleteSet:'+headerContractToDeleteSet);
        List<SVMXC__Service_Contract__c> contractLineToDelete=new List<SVMXC__Service_Contract__c>();
        if(headerContractToDeleteSet.size()>0){
            for(String headerId:headerContractToDeleteSet){
                SVMXC__Service_Contract__c headerInstance=new SVMXC__Service_Contract__c();
                headerInstance.Id=headerId;
                headerContractToDelete.add(headerInstance);
            }
            System.debug('@headerContractToDelete:'+headerContractToDelete);
            contractLineToDelete=[SELECT Id FROM SVMXC__Service_Contract__c WHERE SVMX_PS_Parent_Contract__c IN: headerContractToDeleteSet];
        }
        
        System.debug('@contractLineToDelete:'+contractLineToDelete);
        if(contractLineToDelete.size()>0){
            headerContractToDelete.addAll(contractLineToDelete);
        }
        System.debug('@AllContractToDelete:'+headerContractToDelete);
        if(headerContractToDelete.size()>0){
            delete headerContractToDelete;
        }
        
        
        
        
        
        return contractResponseList;
        
        
    }
    
    @HttpPatch
    global static List<ResponseContractWrapper> updateContract() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response; 
        string jsonInput = request.requestBody.toString();
        system.debug('request'+request.requestBody.toString());
        List<contractHeaderWrapper> serviceContracts = (List<contractHeaderWrapper>)JSON.deserialize(jsonInput, List<contractHeaderWrapper>.class);
        List<SVMXC__Service_Contract__c> headerContractList=new List<SVMXC__Service_Contract__c>();
        List<contractLineWrapper> lineContractList=new List<contractLineWrapper>();
        
        //Converting Wrapper type of contracts into Sobject Type List
        headerContractList=getHeaderContractFromWrapper(serviceContracts,'Update');
        //Getting line contracts
        lineContractList=getLineContractWrapper(serviceContracts);
        
        //DML Insert on header contracts
        Database.SaveResult[] headerResultList = Database.update(headerContractList, false);
        
        //Map of successfull Dml of header contract from external id to salesforce id
        Map<String,Id> externalToIdMap=new Map<String,Id>();
        for (Integer k=0;k<headerResultList.size();k++) {
            if (headerResultList[k].isSuccess()) {
                
                externalToIdMap.put(headerContractList[k].SVMX_PS_External_ID__c,headerResultList[k].getId());
            }
        }
        //Get The Location details using SOQL Query and Create a Map of Location Id-> Sobject Record Location
        List<SVMXC__Site__c> locationList=[SELECT Accreditation__c,Id,Name,SVMXC__Preferred_Business_Hours__c,SVMX_PS_Preferred_Technician__c FROM SVMXC__Site__c];
        Map<Id,SVMXC__Site__c> locationMap=new Map<Id,SVMXC__Site__c>(locationList);
        
        Map<String,SVMXC__Service_Contract__c> extIdToSC=new Map<String,SVMXC__Service_Contract__c>();
        for (Integer k=0;k<headerResultList.size();k++) {
            if (headerResultList[k].isSuccess()) {
                headerContractList[k].Id=headerResultList[k].getId();
                extIdToSC.put(headerContractList[k].SVMX_PS_External_ID__c,headerContractList[k]);
            }
        }
        
        
        //Converting Wrapper contract line list into Sobject List those have created header contract
        List<SVMXC__Service_Contract__c> contractLineValidatedList=new List<SVMXC__Service_Contract__c>();
        contractLineValidatedList=getContractLineFromWrapper(lineContractList,'Update',externalToIdMap,locationMap,extIdToSC);
        
        
        //DML Insert of contract lines
        Database.upsertResult[] lineResultList = Database.upsert(contractLineValidatedList, false);
        
        
        //converting line result into response and create map between header id and line records
        Map<Id,List<ResponseContractLineWrapper>> parentToLineMap=new Map<Id,List<ResponseContractLineWrapper>>();
        List<ResponseContractLineWrapper> lineResultWrapperList=new List<ResponseContractLineWrapper>();
        for(Integer k=0;k<lineResultList.size();k++)
        {
            ResponseContractLineWrapper lineInstance=new ResponseContractLineWrapper();
            if(lineResultList[k].isSuccess())
            {
                
                lineInstance.contractLineId=lineResultList[k].getId();
                lineInstance.BOContractLineId=contractLineValidatedList[k].SVMX_PS_External_ID__c;
                lineInstance.contractLineName=contractLineValidatedList[k].Name;
            }
            else {
                lineInstance.errorDetails=lineResultList[k].getErrors()[0].getMessage()+' :: Due to this Error, The header and its related contracts will be deleted';
            }
            lineResultWrapperList.add(lineInstance);
            if(parentToLineMap.containsKey(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c))
            {
                List<ResponseContractLineWrapper> wrapperInstance=parentToLineMap.get(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c);
                wrapperInstance.add(lineInstance);
                parentToLineMap.put(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c, wrapperInstance);
            }
            else {
                List<ResponseContractLineWrapper> wrapperInstance=new List<ResponseContractLineWrapper>();
                wrapperInstance.add(lineInstance);
                parentToLineMap.put(contractLineValidatedList[k].SVMX_PS_Parent_Contract__c, wrapperInstance);
            }
        }
        
        //Converting Header result into response and synchronise header and line records
        List<ResponseContractWrapper> contractResponseList=new List<ResponseContractWrapper>();
        for (Integer k=0;k<headerResultList.size();k++) {
            ResponseContractWrapper res=new ResponseContractWrapper();
            if (headerResultList[k].isSuccess()) {
                res.contractId=String.valueOf(headerResultList[k].getId());
                res.BOContractId=headerContractList[k].SVMX_PS_External_ID__c;
                res.contractName=headerContractList[k].Name;
                res.ContractLineResponse=parentToLineMap.get(headerContractList[k].Id);
            }
            else {
                res.errorDetails=headerResultList[k].getErrors()[0].getMessage()+' :: Due to this error No Line Contract Will be Created for this record';              
                
            }
            contractResponseList.add(res);
        }
        return contractResponseList;
        
    }
    
    @HttpGet
    global static List<contractHeaderWrapper> getServiceContract(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //get id from the requested url
        String ServiceContractID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(String.isNotBlank(ServiceContractID)){
            //instance for wrapper
            List<contractHeaderWrapper> response = new List<contractHeaderWrapper>();
            ID recordId = ServiceContractID;	
            DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe();	
            //retrieve the names of all fields for Header Contract
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
            String query =	  ' SELECT ' +	      String.join( fieldNames, ',' ) +	  ' FROM ' +	      describeResult.getName() +	  ' WHERE ' +	      ' id = :recordId ' +	  ' LIMIT 1 '	;	
            // return generic list of sobjects or typecast to expected type	
            List<SVMXC__Service_Contract__c> headercontractList = Database.query( query );
            
            //List of ContractLine:
            List<SVMXC__Service_Contract__c> contractLineList = [SELECT ID,Name,SVMX_PS_Parent_Contract__c,
                                                                 SVMXC__Company__c,Location__c, Installation__c, SVMXC__End_Date__c,
                                                                 SVMXC__Start_Date__c,SVMX_PS_External_ID__c
                                                                 FROM SVMXC__Service_Contract__c 
                                                                 WHERE SVMX_PS_Parent_Contract__c =: recordId];
            if(!headercontractList.isEmpty()){
                //List of Included Service:
                List<SVMXC__Service_Contract_Services__c> incserviceList= [SELECT Id, SVMXC__Service__r.Name,SVMXC__Service_Contract__c 
                                                                           FROM SVMXC__Service_Contract_Services__c
                                                                           WHERE SVMXC__Service_Contract__c IN : contractLineList];
                
                //Create Map where key--> ContractLineId and value--> list<IncludedServicesWrapper>:
                Map<Id,List<IncludedServicesWrapper>> lineServiceWrapperMap = new Map<Id,List<IncludedServicesWrapper>>();
                for(SVMXC__Service_Contract_Services__c serObj : incserviceList){
                    List<IncludedServicesWrapper> serviceWrapperList = new List<IncludedServicesWrapper>();
                    IncludedServicesWrapper incWrapper = new IncludedServicesWrapper();
                    incWrapper.IncludedServiceId = serObj.Id;
                    incWrapper.ServiceType = serObj.SVMXC__Service__r.Name;
                    serviceWrapperList.add(incWrapper);
                    if(lineServiceWrapperMap.containsKey(serObj.SVMXC__Service_Contract__c)){
                        lineServiceWrapperMap.get(serObj.SVMXC__Service_Contract__c).addAll(serviceWrapperList);
                    }else{
                        lineServiceWrapperMap.put(serObj.SVMXC__Service_Contract__c,serviceWrapperList);
                    }
                }
                
                //Create Map where key-->ParentContractId and values -->List<ContractLineWrapper>
                Map<Id,List<contractLineWrapper>> headerLineWrapperMap = new Map<Id,List<contractLineWrapper>>();
                for(SVMXC__Service_Contract__c lineObj : contractLineList){
                    List<contractLineWrapper> lineWrapperList = new List<contractLineWrapper>();
                    contractLineWrapper lineWrapperObj = new contractLineWrapper();
                    lineWrapperObj.contractLineId = lineObj.Id;
                    lineWrapperObj.contractLineName = lineObj.Name;
                    lineWrapperObj.AccountId = lineObj.Id;
                    lineWrapperObj.Location = lineObj.Id;
                    lineWrapperObj.Installation = String.valueOf(lineObj.Installation__c);
                    lineWrapperObj.StartDate = String.valueOf(lineObj.SVMXC__Start_Date__c);
                    lineWrapperObj.EndDate = String.valueOf(lineObj.SVMXC__End_Date__c);
                    lineWrapperObj.BOContractLineId = lineObj.SVMX_PS_External_ID__c;
                    lineWrapperObj.IncludedServices = lineServiceWrapperMap.get(lineObj.Id);
                    lineWrapperList.add(lineWrapperObj);
                    if(headerLineWrapperMap.containsKey(lineObj.SVMX_PS_Parent_Contract__c)){
                        headerLineWrapperMap.get(lineObj.SVMX_PS_Parent_Contract__c).addAll(lineWrapperList);
                    }else{
                        headerLineWrapperMap.put(lineObj.SVMX_PS_Parent_Contract__c,lineWrapperList);
                    }
                }
                
                for(SVMXC__Service_Contract__c headerInstance : headercontractList){
                    List<contractHeaderWrapper> headerWrapperList = new List<contractHeaderWrapper>();
                    contractHeaderWrapper headerWrapperObj = new contractHeaderWrapper();
                    headerWrapperObj.Name = headerInstance.Name;
                    headerWrapperObj.AccountId = headerInstance.SVMXC__Company__c;
                    headerWrapperObj.IsEvergreen = String.valueof(headerInstance.Is_Evergreen__c);
                    headerWrapperObj.BillingSchedule = headerInstance.SVMXC__Billing_Schedule__c;
                    headerWrapperObj.StartDate = String.valueOf(headerInstance.SVMXC__Start_Date__c);
                    headerWrapperObj.EndDate = String.valueOf(headerInstance.SVMXC__End_Date__c);
                    headerWrapperObj.Status = headerInstance.Status__c;
                    headerWrapperObj.BOContractId = headerInstance.SVMX_PS_External_ID__c;
                    headerWrapperObj.BOSystem = headerInstance.Back_Office_System__c;
                    headerWrapperObj.BOCountry = headerInstance.Back_Office_Country__c;
                    headerWrapperObj.ContractLines = headerLineWrapperMap.get(headerInstance.Id);
                    response.add(headerWrapperObj);
                }
                return response;
            }
            return null;
        }else{
            return null;
        }
        
    }
    
}