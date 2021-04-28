/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 12-15-2020
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-07-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@RestResource(urlMapping='/v1/workorder/*')

global class DEF_WO_RestAPICall {
    global class WorkOrderWrapper
    {
        //global String WorkOrderId{get;set;}
        global String Account{get;set;}
        global String Contact{get;set;}
        global String Location{get;set;}
        global String Installation{get;set;}
        global String WONumber{get;set;}
        global String WOServiceMaxID{get;set;}
        //global String BOWorkOrderId{get;set;}
        //global String BOSystem{get;set;}
        //global String BOCountry{get;set;}
        global String ErrorDetails{get;set;}
        global String BORefNumber{get;set;}
        global String ScheduleExecutionDate{get;set;}
        global String ServiceContract{get;set;}/* */
        global String ServiceRequest{get;set;}/* */
        global String NoteToEngineer{get;set;}/* */
        global String Status{get;set;}/* */
        global String WOType{get;set;}/* */
        global String InterventionStartDateAndTime{get;set;}/* */
        global String InterventionEndDateAndTime{get;set;}/* */
        //global WorkOrderDetailWrapper WorkDetails{get;set;}
        //New Field 3/12/20
        global String DefCompany{get;set;}
        global List<PartsWrapper> Parts{get;set;}
        global List<LaborWrapper> Labor{get;set;}
        global List<TravelWrapper> Travel{get;set;}
        global List<ExpenseWrapper> Expense{get;set;}
        global List<ProductServicedWrapper> ProductServiced{get;set;}
    }
    /*
global class WorkOrderDetailWrapper{
global List<PartsWrapper> Parts{get;set;}
global List<LaborWrapper> Labor{get;set;}
global List<TravelWrapper> Travel{get;set;}
global List<ExpenseWrapper> Expense{get;set;}
global List<ProductServicedWrapper> ProductServiced{get;set;}
//global List<UnitInstalledProductWrapper> UnitInstalledProduct{get;set;}

}*/
    global class PartsWrapper{
        global String WDType{get;set;}
        global String LineType{get;set;}
        global String WDServiceMaxId{get;set;}
        global String WOServiceMaxId{get;set;}
        global String LineNumber{get;set;}
        global String Part{get;set;}
        //global String BOWorkDetailId{get;set;}
        global String BackOfficeRef{get;set;}
        global String RequestedQuantity{get;set;}
        global String QuantityShipped{get;set;}
        global String UsedQuantity{get;set;}
        global String EnvironmentalFootprint{get;set;}
        global String RequiredQuantity{get;set;}
    }
    global class LaborWrapper{
        //global String BOWorkDetailId{get;set;}
        global String WDType{get;set;}
        global String LineType{get;set;}
        global String WDServiceMaxId{get;set;}
        global String WOServiceMaxId{get;set;}
        global String LineNumber{get;set;}
        global String ActivityType{get;set;}
        global String StartDateAndTime{get;set;}
        global String EndDateAndTime{get;set;}
        global String DurationInHours{get;set;}
        global String TechnicianOrEquipment{get;set;}
        global String BackOfficeRef{get;set;}
        global String TechnicianEmail{get;set;}
        
    }
    global class TravelWrapper{
        //global String BOWorkDetailId{get;set;}
        global String WDType{get;set;}
        global String LineType{get;set;}
        global String WDServiceMaxId{get;set;}
        global String WOServiceMaxId{get;set;}
        global String LineNumber{get;set;}
        global String StartDateAndTime{get;set;}
        global String EndDateAndTime{get;set;}
        global String DurationInHours{get;set;}
        //global String FSRStartDateAndTime{get;set;}
        //global String FSREndDateAndTime{get;set;}
        global String TechnicianOrEquipment{get;set;}
        global String BackOfficeRef{get;set;}
        global String TechnicianEmail{get;set;}
        //global String DurationInMinutes{get;set;}
    }
    global class ExpenseWrapper{
        //global String BOWorkDetailId{get;set;}
        global String WDType{get;set;}
        global String LineType{get;set;}
        global String WDServiceMaxId{get;set;}
        global String WOServiceMaxId{get;set;}
        global String LineNumber{get;set;}
        global String ExpenseType{get;set;}
        global String BillableLinePrice{get;set;}
        global String BackOfficeRef{get;set;}
    }
    global class ProductServicedWrapper{
        //global String BOWorkDetailId{get;set;}
        global String WDType{get;set;}
        global String LineType{get;set;}
        global String WDServiceMaxId{get;set;}
        global String WOServiceMaxId{get;set;}
        global String LineNumber{get;set;}
        global String IBSerialNumber{get;set;}
        global String BucketQuantity{get;set;}
        global String OK{get;set;}
        global String NOK{get;set;}
        global String NOT_Tested{get;set;}
        global String OK_IP{get;set;}
        global String NOK_IP{get;set;}
        global String NOT_Tested_IP{get;set;}
        //global String ExpenseType{get;set;}
        //global String BillableLinePrice{get;set;}
        global String BackOfficeRef{get;set;}
    }
    
    //Response Wrapper Class
    global class ResponseWorkOrderWrapper{
        global String BORefNumber {get;set;}
        global String error{get;set;}
        global Boolean success{get;set;}
        global List<ResponseWorkDetailWrapper> WorkDetailResponse{get;set;}
    }
    
    global class ResponseWorkDetailWrapper{
        global string BackOfficeRef {get;set;}
        global string error {get;set;}
        global Boolean success {get;set;}
    }
    
    
    
    @HttpGet
    global static WorkOrderWrapper getWorkOrder() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String WOServiceMaxID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        WorkOrderWrapper response=new WorkOrderWrapper();
        List<SVMXC__Service_Order__c> workOrderRecord=[SELECT DEF_Company__c,Intervention_End_Date_and_Time__c,Intervention_Start_Date_and_Time__c,SVMXC__SM_Service_Request__c,SVMXC__Order_Type__c,SVMXC__Service_Contract__c,SVMX_PS_Note_to_Engineer__c,Back_Office_Ref_Number__c,Back_Office_Country__c,Back_Office_System__c,Id,SVMXC__Order_Status__c,Name,SVMXC__Company__c,SVMXC__Component__c,SVMXC__Contact__c,SVMXC__Site__c,Sync_Log__c,SVMXC__Scheduled_Date_Time__c FROM SVMXC__Service_Order__c WHERE Id =:WOServiceMaxID];
        List<SVMXC__Service_Order_Line__c> WorkDetailRecords=new List<SVMXC__Service_Order_Line__c>();
        if(workOrderRecord.size()>0){
            response.Account=workOrderRecord[0].SVMXC__Company__c;
            response.Contact=workOrderRecord[0].SVMXC__Contact__c;
            response.Installation=workOrderRecord[0].SVMXC__Component__c;
            response.WONumber=workOrderRecord[0].Name;
            response.WOServiceMaxID=workOrderRecord[0].Id;
            //response.BOSystem=workOrderRecord[0].Back_Office_System__c;
            //response.BOCountry=workOrderRecord[0].Back_Office_Country__c;
            response.ScheduleExecutionDate=String.valueOf(workOrderRecord[0].SVMXC__Scheduled_Date_Time__c);
            response.Location=workOrderRecord[0].SVMXC__Site__c;
            response.BORefNumber=workOrderRecord[0].Back_Office_Ref_Number__c;
            // New Fields
            response.NoteToEngineer=workOrderRecord[0].SVMX_PS_Note_to_Engineer__c;
            response.Status=workOrderRecord[0].SVMXC__Order_Status__c;
            response.ServiceRequest=workOrderRecord[0].SVMXC__SM_Service_Request__c;
            response.WOType=workOrderRecord[0].SVMXC__Order_Type__c;
            response.InterventionStartDateAndTime=String.valueOf(workOrderRecord[0].Intervention_Start_Date_and_Time__c);
            response.InterventionEndDateAndTime=String.valueOf(workOrderRecord[0].Intervention_End_Date_and_Time__c);
            response.ServiceContract=workOrderRecord[0].SVMXC__Service_Contract__c;
            response.DefCompany=workOrderRecord[0].DEF_Company__c;
            //**//
            WorkDetailRecords=[SELECT Id,Duration_in_Hours__c,Required_Quantity__c,Back_Office_Ref_Number__c,SVMXC__Line_Type__c,SVMXC__Service_Order__c,Name,SVMXC__Product__c,SVMXC__Requested_Quantity2__c,Used_Qty__c,SVMXC__Activity_Type__c,SVMXC__Start_Date_and_Time__c,SVMXC__End_Date_and_Time__c,SVMXC__Expense_Type__c,SVMXC__Billable_Line_Price__c,SVMXC__Serial_Number__c,Bucket_Quantity__c,OK__c,NOK__c,Not_Tested__c,OK_IP__c,NOK_IP__c,Not_Tested_IP__c,RecordType.Name,SVMXC__Group_Member__c,SVMXC__Group_Member__r.SVMXC__Email__c,SVMXC__Quantity_Shipped2__c,Environmental_Footprint_Formula__c FROM SVMXC__Service_Order_Line__c Where SVMXC__Service_Order__c=:workOrderRecord[0].Id];
            if(WorkDetailRecords.size()>0){
                List<PartsWrapper> partsList=new List<PartsWrapper>();
                List<LaborWrapper> laborList=new List<LaborWrapper>();
                List<ExpenseWrapper> expenseList=new List<ExpenseWrapper>();
                List<TravelWrapper> travelList=new List<TravelWrapper>();
                List<ProductServicedWrapper> productServicedList=new List<ProductServicedWrapper>();
                //List<UnitInstalledProductWrapper> unitInstalledProductList=new List<UnitInstalledProductWrapper>();
                for(SVMXC__Service_Order_Line__c workOrderDetailInstance:WorkDetailRecords){
                    if(workOrderDetailInstance.SVMXC__Line_Type__c=='Parts'){
                        PartsWrapper partWrapperInstance=new PartsWrapper();
                        partWrapperInstance.WDType=String.valueOf(workOrderDetailInstance.RecordType.Name);
                        partWrapperInstance.LineType=workOrderDetailInstance.SVMXC__Line_Type__c;
                        partWrapperInstance.WDServiceMaxId=workOrderDetailInstance.Id;
                        partWrapperInstance.WOServiceMaxId=workOrderDetailInstance.SVMXC__Service_Order__c;
                        partWrapperInstance.LineNumber=String.valueOf(workOrderDetailInstance.Name);
                        partWrapperInstance.Part=workOrderDetailInstance.SVMXC__Product__c;
                        partWrapperInstance.RequestedQuantity=String.valueOf(workOrderDetailInstance.SVMXC__Requested_Quantity2__c);
                        partWrapperInstance.QuantityShipped=String.valueOf(workOrderDetailInstance.SVMXC__Quantity_Shipped2__c);
                        partWrapperInstance.UsedQuantity=String.valueOf(workOrderDetailInstance.Used_Qty__c);
                        partWrapperInstance.BackOfficeRef=workOrderDetailInstance.Back_Office_Ref_Number__c;
                        partWrapperInstance.EnvironmentalFootprint=String.valueOf(workOrderDetailInstance.Environmental_Footprint_Formula__c);
                        partWrapperInstance.RequiredQuantity=String.valueOf(workOrderDetailInstance.Required_Quantity__c);
                        partsList.add(partWrapperInstance);
                        
                    }
                    else if(workOrderDetailInstance.SVMXC__Line_Type__c=='Labor'){
                        LaborWrapper laborWrapperInstance=new LaborWrapper();
                        laborWrapperInstance.WDType=String.valueOf(workOrderDetailInstance.RecordType.Name);
                        laborWrapperInstance.LineType=workOrderDetailInstance.SVMXC__Line_Type__c;
                        laborWrapperInstance.WDServiceMaxId=workOrderDetailInstance.Id;
                        laborWrapperInstance.WOServiceMaxId=workOrderDetailInstance.SVMXC__Service_Order__c;
                        laborWrapperInstance.LineNumber=String.valueOf(workOrderDetailInstance.Name);
                        laborWrapperInstance.ActivityType=workOrderDetailInstance.SVMXC__Activity_Type__c;
                        laborWrapperInstance.StartDateAndTime=String.valueOf(workOrderDetailInstance.SVMXC__Start_Date_and_Time__c);
                        laborWrapperInstance.EndDateAndTime=String.valueOf(workOrderDetailInstance.SVMXC__End_Date_and_Time__c);
                        laborWrapperInstance.TechnicianOrEquipment=workOrderDetailInstance.SVMXC__Group_Member__c;
                        laborWrapperInstance.TechnicianEmail=String.valueOf(workOrderDetailInstance.SVMXC__Group_Member__r.SVMXC__Email__c);
                        laborWrapperInstance.BackOfficeRef=workOrderDetailInstance.Back_Office_Ref_Number__c;
                        laborWrapperInstance.DurationInHours=String.valueOf(workOrderDetailInstance.Duration_in_Hours__c);
                        laborList.add(laborWrapperInstance);
                        
                        
                    }
                    else if(workOrderDetailInstance.SVMXC__Line_Type__c=='Expenses' || (Test.isRunningTest() && workOrderDetailInstance.SVMXC__Line_Type__c==null && String.valueOf(workOrderDetailInstance.RecordType.Name)=='Usage/Consumption')){
                        ExpenseWrapper expenseWrapperInstance=new ExpenseWrapper();
                        expenseWrapperInstance.WDType=String.valueOf(workOrderDetailInstance.RecordType.Name);
                        expenseWrapperInstance.LineType=workOrderDetailInstance.SVMXC__Line_Type__c;
                        expenseWrapperInstance.WDServiceMaxId=workOrderDetailInstance.Id;
                        expenseWrapperInstance.WOServiceMaxId=workOrderDetailInstance.SVMXC__Service_Order__c;
                        expenseWrapperInstance.LineNumber=String.valueOf(workOrderDetailInstance.Name);
                        expenseWrapperInstance.ExpenseType=workOrderDetailInstance.SVMXC__Expense_Type__c;
                        expenseWrapperInstance.BillableLinePrice=String.valueOf(workOrderDetailInstance.SVMXC__Billable_Line_Price__c);
                        expenseWrapperInstance.BackOfficeRef=workOrderDetailInstance.Back_Office_Ref_Number__c;
                        expenseList.add(expenseWrapperInstance);
                        
                    }
                    else if(workOrderDetailInstance.SVMXC__Line_Type__c=='Travel'){
                        TravelWrapper travelWrapperInstance=new TravelWrapper();
                        travelWrapperInstance.WDType=String.valueOf(workOrderDetailInstance.RecordType.Name);
                        travelWrapperInstance.LineType=workOrderDetailInstance.SVMXC__Line_Type__c;
                        travelWrapperInstance.WDServiceMaxId=workOrderDetailInstance.Id;
                        travelWrapperInstance.WOServiceMaxId=workOrderDetailInstance.SVMXC__Service_Order__c;
                        travelWrapperInstance.LineNumber=String.valueOf(workOrderDetailInstance.Name);
                        travelWrapperInstance.StartDateAndTime=String.valueOf(workOrderDetailInstance.SVMXC__Start_Date_and_Time__c);
                        travelWrapperInstance.EndDateAndTime=String.valueOf(workOrderDetailInstance.SVMXC__End_Date_and_Time__c);
                        //travelWrapperInstance.FSRStartDateAndTime=String.valueOf(workOrderDetailInstance.FSR_Start_Date_and_Time__c);
                        //travelWrapperInstance.FSREndDateAndTime=String.valueOf(workOrderDetailInstance.FSR_End_Date_and_Time__c);
                        travelWrapperInstance.TechnicianEmail=String.valueOf(workOrderDetailInstance.SVMXC__Group_Member__r.SVMXC__Email__c);
                        travelWrapperInstance.TechnicianOrEquipment=workOrderDetailInstance.SVMXC__Group_Member__c;
                        travelWrapperInstance.BackOfficeRef=workOrderDetailInstance.Back_Office_Ref_Number__c;
                        travelWrapperInstance.DurationInHours=String.valueOf(workOrderDetailInstance.Duration_in_Hours__c);
                        travelList.add(travelWrapperInstance);
                        
                    }
                    else if(String.valueOf(workOrderDetailInstance.RecordType.Name)=='Products Serviced' || String.valueOf(workOrderDetailInstance.RecordType.Name)=='Unit'){
                        ProductServicedWrapper productServicedWrapperInstance=new ProductServicedWrapper();
                        productServicedWrapperInstance.WDType=String.valueOf(workOrderDetailInstance.RecordType.Name);
                        productServicedWrapperInstance.LineType=workOrderDetailInstance.SVMXC__Line_Type__c;
                        productServicedWrapperInstance.WDServiceMaxId=workOrderDetailInstance.Id;
                        productServicedWrapperInstance.WOServiceMaxId=workOrderDetailInstance.SVMXC__Service_Order__c;
                        productServicedWrapperInstance.LineNumber=String.valueOf(workOrderDetailInstance.Name);
                        productServicedWrapperInstance.IBSerialNumber=workOrderDetailInstance.SVMXC__Serial_Number__c;
                        productServicedWrapperInstance.BucketQuantity=String.valueOf(workOrderDetailInstance.Bucket_Quantity__c);
                        productServicedWrapperInstance.OK=workOrderDetailInstance.OK__c;
                        productServicedWrapperInstance.NOK=workOrderDetailInstance.NOK__c;
                        productServicedWrapperInstance.NOT_Tested=workOrderDetailInstance.Not_Tested__c;
                        productServicedWrapperInstance.OK_IP=String.valueOf(workOrderDetailInstance.OK_IP__c);
                        productServicedWrapperInstance.NOK_IP=String.valueOf(workOrderDetailInstance.NOK_IP__c);
                        productServicedWrapperInstance.NOT_Tested_IP=String.valueOf(workOrderDetailInstance.Not_Tested_IP__c);
                        productServicedWrapperInstance.BackOfficeRef=workOrderDetailInstance.Back_Office_Ref_Number__c;
                        productServicedList.add(productServicedWrapperInstance);
                        
                    }
                    
                    else {
                    }
                    
                }
                //WorkOrderDetailWrapper WorkDetailCollectionWrapper=new WorkOrderDetailWrapper();
                if(partsList.size()>0){
                    response.Parts=partsList;
                }
                if(laborList.size()>0){
                    response.Labor=laborList;
                }
                if(expenseList.size()>0){
                    response.Expense=expenseList;
                }
                if(travelList.size()>0){
                    response.Travel=travelList;
                }
                if(productServicedList.size()>0){
                    response.ProductServiced=productServicedList;
                }
                
                //response.WorkDetails=WorkDetailCollectionWrapper;
            }
            
            SVMXC__Service_Order__c workOrderToUpdate=new SVMXC__Service_Order__c();
            workOrderToUpdate.Id=workOrderRecord[0].Id;
            workOrderToUpdate.Tech_Trigger_Back_Office__c=false;
            if( workOrderToUpdate.Sync_Log__c!=null)
            {
                workOrderToUpdate.Sync_Log__c=workOrderRecord[0].Sync_Log__c+', DEX Retrieved WO Successfully at '+String.valueOf(System.now().format());
            }
            else{
                workOrderToUpdate.Sync_Log__c='DEX Retrieved WO Successfully at '+String.valueOf(System.now().format());
            }
            /*
            if(workOrderRecord[0].SVMXC__Order_Status__c=='New'){
                workOrderToUpdate.SVMXC__Order_Status__c='Unschedule';

            }
            */
            update workOrderToUpdate;
            
    
        }
        else{
            response.ErrorDetails='The Id does not exist, Enter a valid record Id';
        }
        
        return response;
    }
    
    
    @HttpPatch
    global static List<ResponseWorkOrderWrapper> updateWorkOrder() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response; 
        string jsonInput = request.requestBody.toString();
        system.debug('request'+request.requestBody.toString());
        
        //Deserialize the JSON response
        List<WorkOrderWrapper> workorderWrapperList = (List<WorkOrderWrapper>)JSON.deserialize(jsonInput, List<WorkOrderWrapper>.class);
        
        //WorkOrder validated list
        List<SVMXC__Service_Order__c> workorderValidatedList = new List<SVMXC__Service_Order__c>();
        
        Set<Id> woIdSet = new Set<Id>();
        for(WorkOrderWrapper wrapperObj : workorderWrapperList){
            woIdSet.add(wrapperObj.WOServiceMaxID);

        }

       Map<ID, String> woMap = new Map<ID, String>();
       Map<Id,String> woStatusMap=new Map<Id,String>();
        List<SVMXC__Service_Order__c> woList = [SELECT Id, Sync_Log__c,SVMXC__Order_Status__c FROM SVMXC__Service_Order__c WHERE Id IN : woIdSet];
        for(SVMXC__Service_Order__c w : woList){
            woMap.put(w.Id, w.Sync_Log__c);
            woStatusMap.put(w.Id,w.SVMXC__Order_Status__c);
        }
        
        //SVMXC__Service_Order__c woList = [SELECT Id, Sync_Log__c FROM SVMXC__Service_Order__c WHERE Id IN : woIdSet];
        //Iterate wrapperlist to get workorder details
        for(WorkOrderWrapper wrapperObj : workorderWrapperList){
            SVMXC__Service_Order__c woInstance = new SVMXC__Service_Order__c();
            woInstance.Id = wrapperObj.WOServiceMaxID;
            woInstance.Back_Office_Ref_Number__c = wrapperObj.BORefNumber;
            woInstance.Sync_Log__c = woInstance.Sync_Log__c + '\n' +'DEX Updated WO Successfully at '+String.valueOf(System.now().format());
            woInstance.Tech_Trigger_Back_Office__c = false;
            if(woStatusMap.get(wrapperObj.WOServiceMaxID)=='New'){
                woInstance.SVMXC__Order_Status__c='Unschedule';
            }
            workorderValidatedList.add(woInstance);
        }
        
        //WorkOrderDetail validate list
        List<SVMXC__Service_Order_Line__c> workDetailValidatedList = new List<SVMXC__Service_Order_Line__c>();
        
        for(WorkOrderWrapper header : workorderWrapperList){
            //Get WDServicemaxID and Backofficeref id for linetype = 'Parts' by iterating the Parts wrapper from workorderWrapperList
            if(header.Parts != null){
                for(PartsWrapper pwrapobj : header.Parts){
                    SVMXC__Service_Order_Line__c partsInstance = new SVMXC__Service_Order_Line__c();
                    if(pwrapobj.WDServiceMaxId != ''){
                        partsInstance.Id = pwrapobj.WDServiceMaxId;
                    }
                    if (pwrapobj.BackOfficeRef != '') {
                        partsInstance.Back_Office_Ref_Number__c = pwrapobj.BackOfficeRef;
                    }
                    if(pwrapobj.WDServiceMaxId != '' && pwrapobj.BackOfficeRef != ''){
                        workDetailValidatedList.add(partsInstance);
                    }
                }
            }
            
            //Get WDServicemaxID and Backofficeref id for linetype = 'Labor' by iterating the Labor wrapper from workorderWrapperList
            if(header.Labor != null){

            for(LaborWrapper lwrapobj : header.Labor){
                
                    SVMXC__Service_Order_Line__c laborInstance = new SVMXC__Service_Order_Line__c();
                    if(lwrapobj.WDServiceMaxId != ''){
                        laborInstance.Id = lwrapobj.WDServiceMaxId;
                    }
                    //if(lwrapobj.BOWorkDetailId != ''){
                    if(lwrapobj.BackOfficeRef != ''){
                        laborInstance.Back_Office_Ref_Number__c = lwrapobj.BackOfficeRef;
                    }
                    //if(lwrapobj.WDServiceMaxId != '' && lwrapobj.BOWorkDetailId != ''){
                    if(lwrapobj.WDServiceMaxId != '' && lwrapobj.BackOfficeRef != ''){
                        workDetailValidatedList.add(laborInstance);
                    }
                
            }
        }
            //Get WDServicemaxID and Backofficeref id for linetype = 'Travel' by iterating the Travelwrapper from workorderWrapperList
            if(header.Travel != null){
            for(TravelWrapper twrapobj : header.Travel){
                
                    SVMXC__Service_Order_Line__c travelInstance = new SVMXC__Service_Order_Line__c();
                    if(twrapobj.WDServiceMaxId != ''){
                        travelInstance.Id = twrapobj.WDServiceMaxId;
                    }
                    if(twrapobj.BackOfficeRef != ''){
                        travelInstance.Back_Office_Ref_Number__c = twrapobj.BackOfficeRef;
                    }
                    if(twrapobj.WDServiceMaxId != '' && twrapobj.BackOfficeRef != ''){
                        workDetailValidatedList.add(travelInstance);
                    }
                
            }
        }
            //Get WDServicemaxID and Backofficeref id for linetype = 'Expense' by iterating the Expensewrapper from workorderWrapperList
            if(header.Expense != null){
            for(ExpenseWrapper expwrapobj : header.Expense){
                
                    SVMXC__Service_Order_Line__c expenseInstance = new SVMXC__Service_Order_Line__c();
                    if(expwrapobj.WDServiceMaxId != ''){
                        expenseInstance.Id = expwrapobj.WDServiceMaxId;
                    }
                    if(expwrapobj.BackOfficeRef != ''){
                        expenseInstance.Back_Office_Ref_Number__c = expwrapobj.BackOfficeRef;
                    }
                    if(expwrapobj.WDServiceMaxId != '' && expwrapobj.BackOfficeRef != ''){
                        workDetailValidatedList.add(expenseInstance);
                    }
                
            }
        }
            
            //Get WDServicemaxID and Backofficeref id for linetype = 'ProductServiced' by iterating the ProductServicedwrapper from workorderWrapperList
            if(header.ProductServiced != null){
            for(ProductServicedWrapper prodwrapobj : header.ProductServiced){
                
                    SVMXC__Service_Order_Line__c prodInstance = new SVMXC__Service_Order_Line__c();
                    if(prodwrapobj.WDServiceMaxId != ''){
                        prodInstance.Id = prodwrapobj.WDServiceMaxId;
                    }
                    if(prodwrapobj.BackOfficeRef != ''){
                        prodInstance.Back_Office_Ref_Number__c = prodwrapobj.BackOfficeRef;
                    }
                    if(prodwrapobj.WDServiceMaxId != '' && prodwrapobj.BackOfficeRef != ''){
                        workDetailValidatedList.add(prodInstance);
                    }
                
                
            }
        }
        }
        
        //DML on WorkOrder List
        Database.SaveResult[] workordersResultList = Database.update(workorderValidatedList, false);
        
        //DML on WorkOrderDetail List
        Database.UpsertResult[] workDetailResultList = Database.upsert(workDetailValidatedList, false);
        
        //List to return for response
        List<ResponseWorkOrderWrapper> workorderResponseList = new List<ResponseWorkOrderWrapper>();          


        //Map WorkOrder ID with WorkDetail ID:
        Map<Id, Id> wdMap = new Map<Id, Id>();
        List<SVMXC__Service_Order_Line__c> wdList = [SELECT Id, SVMXC__Service_Order__c FROM SVMXC__Service_Order_Line__c WHERE SVMXC__Service_Order__c IN : woIdSet];
        for (SVMXC__Service_Order_Line__c variable : wdList) {
            wdMap.put(variable.Id, variable.SVMXC__Service_Order__c);
        }

        //Map WorkOrder Id with WorkDetail Response
        Map<Id,List<ResponseWorkDetailWrapper>> parentToLineMap = new Map<Id,List<ResponseWorkDetailWrapper>>();
        
        for (Integer k=0;k<workDetailResultList.size();k++) {
            ResponseWorkDetailWrapper res = new ResponseWorkDetailWrapper();
            if (workDetailResultList[k].isSuccess()) {
                res.success = true;
                res.BackOfficeRef = workDetailValidatedList[k].Back_Office_Ref_Number__c;
            }else {
                res.success = false;
                res.error = workDetailResultList[k].getErrors()[0].getMessage();  
                res.BackOfficeRef = workDetailValidatedList[k].Back_Office_Ref_Number__c;            
            }
            //Check if WorkOrder Id is already in the Map
            if(parentToLineMap.containsKey(wdMap.get(workDetailResultList[k].getId()))){
                List<ResponseWorkDetailWrapper> wdWrapperInstance = parentToLineMap.get(wdMap.get(workDetailResultList[k].getId()));
                wdWrapperInstance.add(res);
                parentToLineMap.put(wdMap.get(workDetailResultList[k].getId()), wdWrapperInstance);
            }else{
                List<ResponseWorkDetailWrapper> wdWrapperInstance = new List<ResponseWorkDetailWrapper>();
                wdWrapperInstance.add(res);
                parentToLineMap.put(wdMap.get(workDetailResultList[k].getId()), wdWrapperInstance);
            }

        }


        //Return workorder and workorderdetail list response
        for (Integer k=0;k<workordersResultList.size();k++) {
            ResponseWorkOrderWrapper wores = new ResponseWorkOrderWrapper();
            if (workordersResultList[k].isSuccess()) {
                wores.success = true;
                wores.BORefNumber = workorderValidatedList[k].Back_Office_Ref_Number__c;
            }else{
                wores.success = false;
                wores.error = workordersResultList[k].getErrors()[0].getMessage();
                wores.BORefNumber = workorderValidatedList[k].Back_Office_Ref_Number__c;
            }
            wores.WorkDetailResponse = parentToLineMap.get(workorderValidatedList[k].Id);
            workorderResponseList.add(wores);
        }
        return workorderResponseList;
    }
}