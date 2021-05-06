/**
 * @description       : Handler for the Work Order berfore insert trigger.
 * @author            : Sofiane Bazizen (SpringFive)
 * @group             : 
 * @last modified on  : 05-06-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-11-2020   Sofiane Bazizen (SpringFive)   Initial Version
**/
public class DEF_StringHelper {
    
    public static String WO_ORDERTYPE_MAINTENANCE = 'Maintenance';
    public static String WO_REPORT_PREFIX = 'SIR';
    public static String SC_RecordType='Contract Line';
    public static String WO_RT_DailySIR='New Works';
    public static string soQuery = 'SELECT Id,SVMXC__Included_Units__c,SVMXC__Expense_Discount_Not_Covered__c,SVMXC__Expense_Discount_Covered__c,SVMXC__Labor_Discount_Not_Covered__c,SVMXC__Labor_Discount_Covered__c,SVMXC__Parts_Discount_Not_Covered__c,SVMXC__Parts_Discount_Covered__c,SVMXC__Available_Services__c,SVMXC__Travel_Discount_Not_Covered__c,SVMXC__Travel_Discount_Covered__c,SVMXC__Service_Plan__c'
	+ ' FROM SVMXC__Service_Offerings__c'
	+ ' WHERE SVMXC__Service_Plan__c In: servicePlanSet'
	+ '';
    public static String type_DailySIR='DailyInterventionReport';
    public static string type_RegularSIR='InterventionReport';

}