/**
 * @description       : 
 * @author            : jawahar
 * @group             : 
 * @last modified on  : 10-25-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-25-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
global class DEF_MockHttpResponseGenerator implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        //System.debug('Inside Respond method '+JSON.serialize(req));
        String sendWOEndpoint=System.Label.DEF_WO_Interface_SendWOToBO_EndPoint;
        HttpResponse res = new HttpResponse();
        //Check whether the end point and method is for send work order to back office interface
        if (String.valueOf(req.getEndpoint())==sendWOEndpoint && String.valueOf(req.getMethod())=='POST') {
            System.debug('Inside if stmt in mockhttpresponsegenerator');
            // Create a fake response
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"RespCommand": "WorkOrder","RespId": "testResponseId"}');
            res.setStatusCode(200);
           
        }
        return res;
    }
}