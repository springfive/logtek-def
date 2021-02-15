/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-10-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   12-10-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class DEF_API_WO_RequestCallBack implements Queueable,Database.AllowsCallouts{
    public class RequestData{
        public string COMMAND;
        public string USER;
        public string PASS;
        public VariablesData VARIABLES;
    }
    public class VariablesData{
        
        public NameData Name;
        
    }
    public class NameData{
        public string NAME;
        public string VALUE;
        
    }
    public List<SVMXC__Service_Order__C> woList ; 
    public DEF_API_WO_RequestCallBack(List<SVMXC__Service_Order__C> sendwoList){
        woList = sendwoList ;
        
    }
    public void execute(QueueableContext qc){
        try {
            for(SVMXC__Service_Order__C woRecord : woList) {
                RequestData requestParameter=new RequestData();
                VariablesData reqVariableParam=new VariablesData();
                NameData reqNameParam=new NameData();
                if(Schema.SObjectType.SVMXC__Service_Order__c.getRecordTypeInfosById().get(woRecord.RecordTypeId).getname() == 'Preventive Maintenance' )
                {
                    requestParameter.COMMAND=System.Label.DEF_WO_Interface_Command_PM;
                }
                else{
                    requestParameter.COMMAND=System.Label.DEF_WO_Interface_Command;
                }
                requestParameter.USER=System.Label.DEF_WO_Interface_User;
                requestParameter.PASS=System.Label.DEF_WO_Interface_Pass;
                reqNameParam.NAME=System.Label.DEF_WO_Interface_SendWOToBO_WOName;
                reqNameParam.VALUE=String.valueOf(woRecord.Id);
                reqVariableParam.Name=reqNameParam;
                requestParameter.VARIABLES=reqVariableParam;
                System.debug('The request '+JSON.serialize(requestParameter));
                
                //Http Callout to Interface
                String InterfaceEndPoint=System.Label.DEF_WO_Interface_SendWOToBO_EndPoint;
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(InterfaceEndPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type','application/json');
                request.setBody(JSON.serialize(requestParameter));
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200){
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    System.debug('Response '+JSON.serialize(results));
                }
                else{
                    System.debug('The Response code is '+response.getStatusCode());
                }
                    
                
            }
        }

        catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            
        }
    }

 

}