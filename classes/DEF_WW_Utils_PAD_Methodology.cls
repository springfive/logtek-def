public class DEF_WW_Utils_PAD_Methodology {
    //List of Apex code that has already been run. Keep this list empty.
    private static Set<String> hasRun = new Set<String>();
    private static Map<String,List<String>> hasRunMap = new Map<String,List<String>>();
    //List of Apex codes that should run only once. Add trigger name to the Metadata accordingly
    private static List<String> requiredOnce = new List<String>();
    
    public static boolean canBypass(String triggerName){
        //Get logged in user's profile id:
        Id profileId=userinfo.getProfileId();
        DEF_CS_BypassComponents__c bypassComponents = DEF_CS_BypassComponents__c.getInstance(profileId);
        Boolean bypassTrigger = bypassComponents.Bypass_Triggers__c;
        String triggernames = bypassComponents.TriggerNames__c;
        List<String> triggerNamesToBypass = new List<String>();
        if(!String.isBlank(triggernames) || triggernames != null){
            triggerNamesToBypass = triggernames.split(',');
        }
        
        //Check for bypassing the trigger:
        if(bypassTrigger || triggerNamesToBypass.contains(triggerName)){
            return false;
        }else{
            return true;
        }
    }
    
    
    public static boolean canTrigger(String triggerName){
        //Get Map from Custom Metadatatype (DEF_RunTrigger__mdt) where we have stored Trigger name and it's Count
        //Map<String,DEF_RunTrigger__mdt> triggerMap = DEF_RunTrigger__mdt.getAll();
        Map<String,Integer> triggerMap = new Map<String,Integer>();
        for(DEF_RunTrigger__mdt obj : [SELECT MasterLabel, Count__c FROM DEF_RunTrigger__mdt]){
            requiredOnce.add(obj.MasterLabel);
            triggerMap.put(obj.MasterLabel,Integer.valueOf(obj.Count__c));
        }
        if(!triggerMap.isEmpty()){
            
            //check if 'requiredOnce' list has the trigger name, if not --> do not allow trigger to run
            if(requiredOnce.contains(triggername)){
                //Add trigger name if Map already has the key
                if(hasRunMap.containsKey(triggername)){
                    hasRunMap.get(triggername).add(triggername);
                }else{
                    //Add new Key and Value if it doesn't have the key
                    hasRunMap.put(triggername, new List<String> {triggerName});
                }
                
                if(hasRunMap.get(triggername).size() > triggerMap.get(triggername)){
                    //return false if Count is Equal to List Size of Map
                    System.debug(triggername+' already ran!');
                    return false;
                }
                //Allow trigger to run
                System.debug(triggername+' ran first time!');
                return true;
            }
            return false;
        }
        return false;
    }
}