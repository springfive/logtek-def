@IsTest
public class SVMX_PS_ZincMessage_UT {

    @testsetup
    static void createTestData(){
        Account acc = new Account();    
        acc.Name = SVMX_PS_Utility.generateRandomString(5);
        acc.ShippingStreet = SVMX_PS_Utility.generateRandomString(5);
        acc.ShippingCity = SVMX_PS_Utility.generateRandomString(5);
        acc.ShippingState = 'CA';
        acc.ShippingPostalCode = SVMX_PS_Utility.generateRandomString(5);
        acc.ShippingCountry = 'USA';
        acc.BillingStreet = SVMX_PS_Utility.generateRandomString(5);
        acc.BillingCity = SVMX_PS_Utility.generateRandomString(5);
        acc.BillingState = 'CA';
        acc.BillingPostalCode = SVMX_PS_Utility.generateRandomString(5);
        acc.BillingCountry = 'USA';
        insert acc;

        SVMXC__Site__c loc = new SVMXC__Site__c();
        loc.Name = SVMX_PS_Utility.generateRandomString(10);
        loc.SVMXC__Account__c = acc.Id;
        loc.SVMXC__City__c = SVMX_PS_Utility.generateRandomString(10);
        loc.SVMXC__Location_Type__c = 'Customer';
        loc.SVMXC__State__c = 'CA';
        loc.SVMXC__Street__c = SVMX_PS_Utility.generateRandomString(5);
        loc.SVMXC__Zip__c = SVMX_PS_Utility.generateRandomString(5);
        loc.SVMXC__Country__c = 'USA';
        loc.SVMXC__Latitude__c = 37.6970231;
        loc.SVMXC__Longitude__c = -121.8861106;
        insert loc;

        Product2 prod = new Product2(name = 'Main Product',IsActive = TRUE,ProductCode = 'Prod1234',Family = 'Manufacturing');              
        insert prod;
      
        List<SVMXC__Installed_Product__c> ipList = new List<SVMXC__Installed_Product__c>();
        SVMXC__Installed_Product__c ip1 = new SVMXC__Installed_Product__c();
        ip1.Name='123456';
        ip1.SVMXC__Company__c = acc.Id;
        ip1.SVMXC__Serial_Lot_Number__c = 'UL234365';
        ip1.SVMXC__Site__c = loc.Id;
        ip1.SVMXC__Product__c = prod.Id;
        ip1.SVMXC__Street__c = SVMX_PS_Utility.generateRandomString(5);
        ip1.SVMXC__City__c = SVMX_PS_Utility.generateRandomString(5);
        ip1.SVMXC__State__c = 'CA';
        ip1.SVMXC__Zip__c = SVMX_PS_Utility.generateRandomString(5);
        ip1.SVMXC__Status__c = 'Installed';
        ip1.SVMXC__Latitude__c = 37.6970231;
        ip1.SVMXC__Longitude__c = -121.8861106;
        ipList.add(ip1);
        insert ipList;
        
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Default' LIMIT 1];
        
        SVMXC__Service_Level__c slaTerm = new SVMXC__Service_Level__c();
        slaTerm.Name = 'Test';
        slaTerm.SVMXC__Business_Hours__c = bh.Id;
        insert slaTerm;
        
        SVMXC__SLA_Detail__c slaDetails = new SVMXC__SLA_Detail__c();
        slaDetails.SVMXC__Service_Name__c = 'Test';
        slaDetails.SVMXC__Select__c = TRUE;
        slaDetails.SVMXC__Commitment_Type__c = 'InitialResponse';
        slaDetails.SVMXC__SLA_Terms__c = slaTerm.Id;
        slaDetails.SVMXC__Priority__c = 'High';
        slaDetails.SVMXC__Business_Hours_Source__c='SLA';
        slaDetails.SVMXC__Customer_Commitment__c=10;
        insert slaDetails;

        List<SVMXC__Service_Request__c> srList = new List<SVMXC__Service_Request__c>();
        SVMXC__Service_Request__c sr1 = new SVMXC__Service_Request__c();
        sr1.SVMXC__Account__c = acc.id;
        sr1.SVMXC__Priority__c = 'High';
        sr1.SVMXC__Product__c = prod.Id;
        sr1.SVMXC__Serial_Number__c = ip1.Id;
        sr1.SVMXC__Status__c = 'Open';
        sr1.SVMXC__Problem_Description__c = 'Test';
        sr1.SLA_Terms__c = slaTerm.Id; 
        srList.add(sr1);
        insert srList;
    }

    @isTest
    static void testGenerateMessageFormat() {   
        SVMXC__Service_Request__c sr = [SELECT Id, Name, SVMXC__Priority__c, SVMXC__Status__c, SVMXC__Problem_Description__c FROM SVMXC__Service_Request__c LIMIT 1];
        Test.startTest();
            Map<String,SVMX_PS_ZincMessage.Values> mapPrvwValue = new Map<String,SVMX_PS_ZincMessage.Values>();
            Map<String,SVMX_PS_ZincMessage.Values> mapDtlsValue = new Map<String,SVMX_PS_ZincMessage.Values>();
            SVMX_PS_ZincMessage.Values zmValue = new SVMX_PS_ZincMessage.Values('Service Request',sr.Name);
            mapDtlsValue.put('ServiceRequest',zmValue);
            mapPrvwValue.put('ServiceRequest',zmValue);
            zmValue = new SVMX_PS_ZincMessage.Values('Priority',(sr.SVMXC__Priority__c!=NULL ? sr.SVMXC__Priority__c :''));
            mapDtlsValue.put('Priority',zmValue);
            mapPrvwValue.put('Priority',zmValue);
            zmValue = new SVMX_PS_ZincMessage.Values('Status',(sr.SVMXC__Status__c!=NULL ? sr.SVMXC__Status__c : ''));
            mapDtlsValue.put('Status',zmValue);
            zmValue = new SVMX_PS_ZincMessage.Values('Problem Description',(sr.SVMXC__Problem_Description__c!=NULL ? sr.SVMXC__Problem_Description__c : ''));
            mapDtlsValue.put('ProblemDescription',zmValue);
            //Create Details sections
            List<SVMX_PS_ZincMessage.Sections> zmDtlsSections = new List<SVMX_PS_ZincMessage.Sections>();
            zmDtlsSections.add(new SVMX_PS_ZincMessage.Sections('key_value',mapDtlsValue.Values()));
            //Create Preview sections
            List<SVMX_PS_ZincMessage.Sections> zmPrvwSections = new List<SVMX_PS_ZincMessage.Sections>();
            zmPrvwSections.add(new SVMX_PS_ZincMessage.Sections('key_value',mapPrvwValue.Values()));
            List<SVMX_PS_ZincMessage.Actions> zmDtlsActions = new List<SVMX_PS_ZincMessage.Actions>();
            List<SVMX_PS_ZincMessage.Actions> zmPrvwActions = new List<SVMX_PS_ZincMessage.Actions>();
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            zmDtlsActions.add(new SVMX_PS_ZincMessage.Actions(baseUrl + '/' +sr.Id,'View Service Request','web_url'));
            zmPrvwActions.add(new SVMX_PS_ZincMessage.Actions(baseUrl + '/' +sr.Id,'View Service Request','web_url'));
            String zmImageUrl = 'https://fonts.gstatic.com/s/i/materialiconsround/notification_important/v1/24px.svg';
            SVMX_PS_ZincMessage.Header zmDtlsHeader = new SVMX_PS_ZincMessage.Header ('Alert','High Priority Service Request created',zmImageUrl);    
            SVMX_PS_ZincMessage.Header zmPrvwHeader = new SVMX_PS_ZincMessage.Header ('Alert','High Priority Service Request created',zmImageUrl);
            SVMX_PS_ZincMessage.Details zmDetails = new SVMX_PS_ZincMessage.Details (zmDtlsHeader, zmDtlsSections, zmDtlsActions);
            SVMX_PS_ZincMessage.Preview zmPreview = new SVMX_PS_ZincMessage.Preview (zmPrvwHeader, zmPrvwSections, zmPrvwActions);
            String zmlink;
            SVMX_PS_ZincMessage.Template zmTemplate = new SVMX_PS_ZincMessage.Template(zmlink, zmPreview, zmDetails);         
            String zmBody = '-'.repeat(20);           
            String zmChat;
            //List of addresses for Zinc Message
            List<String> zmSendTo = new list<String>();
            SVMX_PS_ZincMessage Zmsg = new SVMX_PS_ZincMessage(zmbody, zmTemplate, zmChat, zmSendTo);
        Test.stopTest();
    }
}