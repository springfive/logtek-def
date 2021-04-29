trigger DEF_SC_Trigger on SVMXC__Service_Contract__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
	if(DEF_WW_Utils_PAD_Methodology.canBypass('DEF_SC_Trigger')){
        new DEF_SC_TriggerHandler().run();
    }
}