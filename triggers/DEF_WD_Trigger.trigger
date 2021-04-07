/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 20-01-2021
* @last modified by  : Devendra
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
trigger DEF_WD_Trigger on SVMXC__Service_Order_Line__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
    if(DEF_WW_Utils_PAD_Methodology.canBypass('DEF_WD_Trigger')){
        new DEF_WD_TriggerHandler().run();
    }
}