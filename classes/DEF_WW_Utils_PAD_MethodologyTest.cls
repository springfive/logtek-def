@isTest
public class DEF_WW_Utils_PAD_MethodologyTest {
    @isTest
    static void canBypass_Test(){
        DEF_CS_BypassComponents__c cs = new DEF_CS_BypassComponents__c();
        cs.Bypass_Triggers__c = true;
        cs.TriggerNames__c = 'test1';
        insert cs;
        System.assertEquals(cs.TriggerNames__c, 'test1');
        DEF_WW_Utils_PAD_Methodology.canBypass('test1');
    }
    
    @isTest
    static void canTrigger_Test(){
        DEF_WW_Utils_PAD_Methodology.canTrigger('DEF_WO_BI');
        DEF_WW_Utils_PAD_Methodology.canTrigger('Test');
    }
}