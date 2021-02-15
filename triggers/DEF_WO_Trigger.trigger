/**
* @description       : Trigger for the Work Order Object.
* @author            : Sofiane Bazizen (SpringFive)
* @group             : 
* @last modified on  : 07-11-2020
* @last modified by  : Sofiane Bazizen (SpringFive)
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   07-11-2020   Sofiane Bazizen (SpringFive)   Initial Version
**/
trigger DEF_WO_Trigger on SVMXC__Service_Order__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
    if(DEF_WW_Utils_PAD_Methodology.canBypass('DEF_WO_Trigger')){
        new DEF_WO_TriggerHandler().run();
    }
}