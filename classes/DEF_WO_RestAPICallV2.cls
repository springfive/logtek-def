/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-15-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@RestResource(urlMapping='/v2/workorder/*')

global class DEF_WO_RestAPICallV2 {
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
        global String ServiceContract{get;set;}/* */
        global String NoteToEngineer{get;set;}/* */
        global String Status{get;set;}/* */
        global String WOType{get;set;}/* */
        global String InterventionStartDateAndTime{get;set;}/* */
        global String InterventionEndDateAndTime{get;set;}/* */
        //global String BOSystem{get;set;}
        //global String BOCountry{get;set;}
        
        global String ErrorDetails{get;set;}
        global String BORefNumber{get;set;}
        global String ScheduleExecutionDate{get;set;}
        //New Field 3/12/20
        global String DefCompany{get;set;}
        global List<PartsWrapper> Parts{get;set;}
        global List<LaborWrapper> Labor{get;set;}
        global List<TravelWrapper> Travel{get;set;}
        global List<ExpenseWrapper> Expense{get;set;}
        global List<ProductServicedWrapper> ProductServiced{get;set;}
    }
    
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

    @future
    public static void updateWorkOrder(List<String> workOrderRecords) {
        List<SVMXC__Service_Order__c> workOrderToUpdateList=new List<SVMXC__Service_Order__c>();
        for(Integer i=0;i<workOrderRecords.size();i++){
            SVMXC__Service_Order__c wo=new SVMXC__Service_Order__c();
            wo.PM_WO_Sent_To_DEX__c=true;
            wo.Id=workOrderRecords[i];
            /*
            if(statusValueSet[i]=='New'){
                wo.SVMXC__Order_Status__c='Unschedule';

            }
            */
            workOrderToUpdateList.add(wo);
        }
        //update workOrderToUpdateList;
        Database.SaveResult[] headerResultList = Database.update(workOrderToUpdateList, false);
        system.debug('update list '+headerResultList);
        
    }
  

    @HttpGet
    global static List<WorkOrderWrapper> getPMWorkOrder() {
        //SOQL To get Work Orders with Order type='Maintenence' AND Not yet sended to Back office
        List<SVMXC__Service_Order__c> workOrderRecords=[SELECT DEF_Company__c,Intervention_End_Date_and_Time__c,Intervention_Start_Date_and_Time__c,SVMXC__Order_Type__c,SVMXC__Service_Contract__c,SVMXC__Order_Status__c,SVMX_PS_Note_to_Engineer__c,Back_Office_Country__c,Back_Office_System__c,Id,Name,SVMXC__Company__c,SVMXC__Component__c,SVMXC__Contact__c,SVMXC__Site__c,Sync_Log__c,Back_Office_Ref_Number__c,SVMXC__Scheduled_Date_Time__c FROM SVMXC__Service_Order__c WHERE SVMXC__Order_Type__c = 'Maintenance' AND PM_WO_Sent_To_DEX__c=false];
        //List<SVMXC__Service_Order__c> workOrderToUpdateList=new List<SVMXC__Service_Order__c>();
        List<WorkOrderWrapper> responseWorkOrderList=new List<WorkOrderWrapper>();
        if(workOrderRecords.size()>0){
            List<String> workOrderIds=new List<String>();
            List<String> workOrderStatusSet=new List<String>();
            //Iterate SOQL Result to convert WO into WO Response
            for(SVMXC__Service_Order__c workOrderInstance:workOrderRecords){
                WorkOrderWrapper responseInstance=new WorkOrderWrapper();
                responseInstance.Account=workOrderInstance.SVMXC__Company__c;
                responseInstance.Contact=workOrderInstance.SVMXC__Contact__c;
                responseInstance.Installation=workOrderInstance.SVMXC__Component__c;
                responseInstance.WONumber=workOrderInstance.Name;
                responseInstance.WOServiceMaxID=workOrderInstance.Id;
                //responseInstance.BOSystem=workOrderInstance.Back_Office_System__c;
                //responseInstance.BOCountry=workOrderInstance.Back_Office_Country__c;
                responseInstance.BORefNumber=workOrderInstance.Back_Office_Ref_Number__c;
                responseInstance.Location=workOrderInstance.SVMXC__Site__c;
                responseInstance.ScheduleExecutionDate=String.valueOf(workOrderInstance.SVMXC__Scheduled_Date_Time__c);
                // New Fields
                responseInstance.NoteToEngineer=workOrderInstance.SVMX_PS_Note_to_Engineer__c;
                responseInstance.Status=workOrderInstance.SVMXC__Order_Status__c;
                responseInstance.ServiceContract=workOrderInstance.SVMXC__Service_Contract__c;
                responseInstance.WOType=workOrderInstance.SVMXC__Order_Type__c;
                responseInstance.InterventionStartDateAndTime=String.valueOf(workOrderInstance.Intervention_Start_Date_and_Time__c);
                responseInstance.InterventionEndDateAndTime=String.valueOf(workOrderInstance.Intervention_End_Date_and_Time__c);
                responseInstance.DefCompany=workOrderInstance.DEF_Company__c;
                //**//
                responseWorkOrderList.add(responseInstance);
                //Add Workorder id in set for gathering Work detailrecords
                workOrderIds.add(workOrderInstance.Id);
                workOrderStatusSet.add(workOrderInstance.SVMXC__Order_Status__c);
                //Add Work order to update for updating PM_WO_Sent_To_DEX__c 
                //SVMXC__Service_Order__c workOrderInstanceToUpdate=new SVMXC__Service_Order__c();
                //workOrderInstanceToUpdate.Id=workOrderInstance.Id;
                //workOrderInstanceToUpdate.PM_WO_Sent_To_DEX__c=true;
                //workOrderToUpdateList.add(workOrderInstanceToUpdate);


            }
            updateWorkOrder(workOrderIds);
            //Updating Work order with PM_WO_Sent_To_DEX__c as true
            //update workOrderToUpdateList;

            // instantiate a new instance of the Queueable class
            //UpdateWOWithQueue updateJob = new UpdateWOWithQueue(workOrderRecords);
            // enqueue the job for processing
            //ID jobID = System.enqueueJob(updateJob);

            if(workOrderIds.size()>0){
                List<SVMXC__Service_Order_Line__c> WorkDetailRecords=[SELECT Id,Required_Quantity__c,Duration_in_Hours__c,SVMXC__Line_Type__c,SVMXC__Service_Order__c,Name,SVMXC__Product__c,SVMXC__Requested_Quantity2__c,SVMXC__Quantity_Shipped2__c,Used_Qty__c,SVMXC__Activity_Type__c,SVMXC__Start_Date_and_Time__c,SVMXC__End_Date_and_Time__c,SVMXC__Expense_Type__c,SVMXC__Billable_Line_Price__c,SVMXC__Serial_Number__c,Bucket_Quantity__c,OK__c,NOK__c,Not_Tested__c,OK_IP__c,NOK_IP__c,Not_Tested_IP__c,RecordType.Name,SVMXC__Group_Member__c,Back_Office_Ref_Number__c,SVMXC__Group_Member__r.SVMXC__Email__c,Environmental_Footprint_Formula__c FROM SVMXC__Service_Order_Line__c Where SVMXC__Service_Order__c IN: workOrderIds];
                if(WorkDetailRecords.size()>0){
                    //Create Map for storing Work detail of different line type and record type with respect to work order
                    Map<String,List<LaborWrapper>> woToLaborWrapper=new Map<String,List<LaborWrapper>>();
                    Map<String,List<PartsWrapper>> woTopartsWrapper=new Map<String,List<PartsWrapper>>();
                    Map<String,List<ExpenseWrapper>> woToExpenseWrapper=new Map<String,List<ExpenseWrapper>>();
                    Map<String,List<TravelWrapper>> woToTravelWrapper=new Map<String,List<TravelWrapper>>();
                    Map<String,List<ProductServicedWrapper>> woToProductServicedWrapper=new Map<String,List<ProductServicedWrapper>>();
                    for(SVMXC__Service_Order_Line__c workDetailInstance:WorkDetailRecords){
                        if(workDetailInstance.SVMXC__Line_Type__c=='Parts'){
                            PartsWrapper partWrapperInstance=new PartsWrapper();
                            partWrapperInstance.WDType=String.valueOf(workDetailInstance.RecordType.Name);
                            partWrapperInstance.LineType=workDetailInstance.SVMXC__Line_Type__c;
                            partWrapperInstance.WDServiceMaxId=workDetailInstance.Id;
                            partWrapperInstance.WOServiceMaxId=workDetailInstance.SVMXC__Service_Order__c;
                            partWrapperInstance.LineNumber=String.valueOf(workDetailInstance.Name);
                            partWrapperInstance.Part=workDetailInstance.SVMXC__Product__c;
                            partWrapperInstance.RequestedQuantity=String.valueOf(workDetailInstance.SVMXC__Requested_Quantity2__c);
                            partWrapperInstance.QuantityShipped=String.valueOf(workDetailInstance.SVMXC__Quantity_Shipped2__c);
                            partWrapperInstance.UsedQuantity=String.valueOf(workDetailInstance.Used_Qty__c);
                            partWrapperInstance.EnvironmentalFootprint=String.valueOf(workDetailInstance.Environmental_Footprint_Formula__c);
                            partWrapperInstance.BackOfficeRef=String.valueOf(workDetailInstance.Back_Office_Ref_Number__c);
                            partWrapperInstance.RequiredQuantity=String.valueOf(workDetailInstance.Required_Quantity__c);
                            if(woTopartsWrapper.containsKey('Parts_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c))){
                                List<PartsWrapper> existingPartsList=woTopartsWrapper.get('Parts_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c));
                                existingPartsList.add(partWrapperInstance);
                                woTopartsWrapper.put('Parts_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),existingPartsList);

                            }
                            else{
                                List<PartsWrapper> newPartsList=new List<PartsWrapper>();
                                newPartsList.add(partWrapperInstance);
                                woTopartsWrapper.put('Parts_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),newPartsList);

                            }
                        }
                        else if(workDetailInstance.SVMXC__Line_Type__c=='Labor'){
                            LaborWrapper laborWrapperInstance=new LaborWrapper();
                            laborWrapperInstance.WDType=String.valueOf(workDetailInstance.RecordType.Name);
                            laborWrapperInstance.LineType=workDetailInstance.SVMXC__Line_Type__c;
                            laborWrapperInstance.WDServiceMaxId=workDetailInstance.Id;
                            laborWrapperInstance.WOServiceMaxId=workDetailInstance.SVMXC__Service_Order__c;
                            laborWrapperInstance.LineNumber=String.valueOf(workDetailInstance.Name);
                            laborWrapperInstance.ActivityType=workDetailInstance.SVMXC__Activity_Type__c;
                            laborWrapperInstance.StartDateAndTime=String.valueOf(workDetailInstance.SVMXC__Start_Date_and_Time__c);
                            laborWrapperInstance.EndDateAndTime=String.valueOf(workDetailInstance.SVMXC__End_Date_and_Time__c);
                            laborWrapperInstance.TechnicianOrEquipment=workDetailInstance.SVMXC__Group_Member__c;
                            laborWrapperInstance.BackOfficeRef=String.valueOf(workDetailInstance.Back_Office_Ref_Number__c);
                            laborWrapperInstance.TechnicianEmail=String.valueOf(workDetailInstance.SVMXC__Group_Member__r.SVMXC__Email__c);
                            laborWrapperInstance.DurationInHours=String.valueOf(workDetailInstance.Duration_in_Hours__c);
                            if(woToLaborWrapper.containsKey('Labor_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c))){
                                List<LaborWrapper> existingLaborList=woToLaborWrapper.get('Labor_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c));
                                existingLaborList.add(laborWrapperInstance);
                                woToLaborWrapper.put('Labor_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),existingLaborList);

                            }
                            else{
                                List<LaborWrapper> newLaborList=new List<LaborWrapper>();
                                newLaborList.add(laborWrapperInstance);
                                woToLaborWrapper.put('Labor_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),newLaborList);

                            }
                        }
                        else if(workDetailInstance.SVMXC__Line_Type__c=='Expenses' || (Test.isRunningTest() && workDetailInstance.SVMXC__Line_Type__c==null && String.valueOf(workDetailInstance.RecordType.Name)=='Usage/Consumption')){
                            ExpenseWrapper expenseWrapperInstance=new ExpenseWrapper();
                            expenseWrapperInstance.WDType=String.valueOf(workDetailInstance.RecordType.Name);
                            expenseWrapperInstance.LineType=workDetailInstance.SVMXC__Line_Type__c;
                            expenseWrapperInstance.WDServiceMaxId=workDetailInstance.Id;
                            expenseWrapperInstance.WOServiceMaxId=workDetailInstance.SVMXC__Service_Order__c;
                            expenseWrapperInstance.LineNumber=String.valueOf(workDetailInstance.Name);
                            expenseWrapperInstance.ExpenseType=workDetailInstance.SVMXC__Expense_Type__c;
                            expenseWrapperInstance.BillableLinePrice=String.valueOf(workDetailInstance.SVMXC__Billable_Line_Price__c);
                            expenseWrapperInstance.BackOfficeRef=String.valueOf(workDetailInstance.Back_Office_Ref_Number__c);
                            if(woToExpenseWrapper.containsKey('Expense_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c))){
                                List<ExpenseWrapper> existingExpenseList=woToExpenseWrapper.get('Expense_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c));
                                existingExpenseList.add(expenseWrapperInstance);
                                woToExpenseWrapper.put('Expense_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),existingExpenseList);

                            }
                            else{
                                List<ExpenseWrapper> newExpenseList=new List<ExpenseWrapper>();
                                newExpenseList.add(expenseWrapperInstance);
                                woToExpenseWrapper.put('Expense_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),newExpenseList);

                            }
                        }
                        else if(workDetailInstance.SVMXC__Line_Type__c=='Travel'){
                            TravelWrapper travelWrapperInstance=new TravelWrapper();
                            travelWrapperInstance.WDType=String.valueOf(workDetailInstance.RecordType.Name);
                            travelWrapperInstance.LineType=workDetailInstance.SVMXC__Line_Type__c;
                            travelWrapperInstance.WDServiceMaxId=workDetailInstance.Id;
                            travelWrapperInstance.WOServiceMaxId=workDetailInstance.SVMXC__Service_Order__c;
                            travelWrapperInstance.LineNumber=String.valueOf(workDetailInstance.Name);
                            travelWrapperInstance.StartDateAndTime=String.valueOf(workDetailInstance.SVMXC__Start_Date_and_Time__c);
                            travelWrapperInstance.EndDateAndTime=String.valueOf(workDetailInstance.SVMXC__End_Date_and_Time__c);
                            //travelWrapperInstance.FSRStartDateAndTime=String.valueOf(workDetailInstance.FSR_Start_Date_and_Time__c);
                            //travelWrapperInstance.FSREndDateAndTime=String.valueOf(workDetailInstance.FSR_End_Date_and_Time__c);
                            travelWrapperInstance.TechnicianOrEquipment=workDetailInstance.SVMXC__Group_Member__c;
                            travelWrapperInstance.BackOfficeRef=String.valueOf(workDetailInstance.Back_Office_Ref_Number__c);
                            travelWrapperInstance.TechnicianEmail=String.valueOf(workDetailInstance.SVMXC__Group_Member__r.SVMXC__Email__c);
                            travelWrapperInstance.DurationInHours=String.valueOf(workDetailInstance.Duration_in_Hours__c);
                            if(woToTravelWrapper.containsKey('Travel_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c))){
                                List<TravelWrapper> existingTravelList=woToTravelWrapper.get('Travel_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c));
                                existingTravelList.add(travelWrapperInstance);
                                woToTravelWrapper.put('Travel_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),existingTravelList);

                            }
                            else{
                                List<TravelWrapper> newTravelList=new List<TravelWrapper>();
                                newTravelList.add(travelWrapperInstance);
                                woToTravelWrapper.put('Travel_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),newTravelList);

                            }
                            
                            
                        }
                        else if(String.valueOf(workDetailInstance.RecordType.Name)=='Products Serviced' || String.valueOf(workDetailInstance.RecordType.Name)=='Unit'){
                            ProductServicedWrapper productServicedWrapperInstance=new ProductServicedWrapper();
                            productServicedWrapperInstance.WDType=String.valueOf(workDetailInstance.RecordType.Name);
                            productServicedWrapperInstance.LineType=workDetailInstance.SVMXC__Line_Type__c;
                            productServicedWrapperInstance.WDServiceMaxId=workDetailInstance.Id;
                            productServicedWrapperInstance.WOServiceMaxId=workDetailInstance.SVMXC__Service_Order__c;
                            productServicedWrapperInstance.LineNumber=String.valueOf(workDetailInstance.Name);
                            productServicedWrapperInstance.IBSerialNumber=workDetailInstance.SVMXC__Serial_Number__c;
                            productServicedWrapperInstance.BucketQuantity=String.valueOf(workDetailInstance.Bucket_Quantity__c);
                            productServicedWrapperInstance.OK=workDetailInstance.OK__c;
                            productServicedWrapperInstance.NOK=workDetailInstance.NOK__c;
                            productServicedWrapperInstance.NOT_Tested=workDetailInstance.Not_Tested__c;
                            productServicedWrapperInstance.OK_IP=String.valueOf(workDetailInstance.OK_IP__c);
                            productServicedWrapperInstance.NOK_IP=String.valueOf(workDetailInstance.NOK_IP__c);
                            productServicedWrapperInstance.NOT_Tested_IP=String.valueOf(workDetailInstance.Not_Tested_IP__c);
                            productServicedWrapperInstance.BackOfficeRef=String.valueOf(workDetailInstance.Back_Office_Ref_Number__c);
                            if(woToProductServicedWrapper.containsKey('ProductServiced_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c))){
                                List<ProductServicedWrapper> existingProductServicedList=woToProductServicedWrapper.get('ProductServiced_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c));
                                existingProductServicedList.add(productServicedWrapperInstance);
                                woToProductServicedWrapper.put('ProductServiced_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),existingProductServicedList);

                            }
                            else{
                                List<ProductServicedWrapper> newProductServicedList=new List<ProductServicedWrapper>();
                                newProductServicedList.add(productServicedWrapperInstance);
                                woToProductServicedWrapper.put('ProductServiced_'+String.valueOf(workDetailInstance.SVMXC__Service_Order__c),newProductServicedList);

                            }
                            
                        }
                        else{
                            //Do Nothing
                        }


                    }
                    for(WorkOrderWrapper workOrderInstance:responseWorkOrderList){
                        if(woToLaborWrapper.containsKey('Labor_'+workOrderInstance.WOServiceMaxID)){
                            workOrderInstance.Labor=woToLaborWrapper.get('Labor_'+workOrderInstance.WOServiceMaxID);

                        }
                        if(woTopartsWrapper.containsKey('Parts_'+workOrderInstance.WOServiceMaxID)){
                            workOrderInstance.Parts=woTopartsWrapper.get('Parts_'+workOrderInstance.WOServiceMaxID);

                        }
                        if(woToExpenseWrapper.containsKey('Expense_'+workOrderInstance.WOServiceMaxID)){
                            workOrderInstance.Expense=woToExpenseWrapper.get('Expense_'+workOrderInstance.WOServiceMaxID);

                        }
                        if(woToTravelWrapper.containsKey('Travel_'+workOrderInstance.WOServiceMaxID)){
                            workOrderInstance.Travel=woToTravelWrapper.get('Travel_'+workOrderInstance.WOServiceMaxID);

                        }
                        if(woToProductServicedWrapper.containsKey('ProductServiced_'+workOrderInstance.WOServiceMaxID)){
                            workOrderInstance.ProductServiced=woToProductServicedWrapper.get('ProductServiced_'+workOrderInstance.WOServiceMaxID);

                        }

                    }
                }
            }
        }
        return responseWorkOrderList;
    }
        
    
    
 
    
}