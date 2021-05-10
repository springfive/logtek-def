@IsTest
public class  DemoGetIPTreeData_UT { 

    @testsetup
    static void createTestData(){
        Account acc = new Account();    
        acc.Name = generateRandomString(10);
        acc.ShippingStreet = generateRandomString(5);
        acc.ShippingCity = generateRandomString(5);
        acc.ShippingState = generateRandomString(5);
        acc.ShippingPostalCode = generateRandomString(5);
        acc.ShippingCountry = generateRandomString(5);
        acc.BillingStreet = generateRandomString(5);
        acc.BillingCity = generateRandomString(5);
        acc.BillingState = generateRandomString(5);
        acc.BillingPostalCode = generateRandomString(5);
        acc.BillingCountry = generateRandomString(5);
        insert acc;

        Contact con = new Contact();
        con.FirstName = generateRandomString(10);
        con.LastName = generateRandomString(10);
        con.AccountId = acc.Id;
        con.Email = generateRandomEmail('servicemax.com');
        insert con;

        SVMXC__Site__c loc = new SVMXC__Site__c();
        loc.Name = generateRandomString(10);
        loc.SVMXC__Account__c = acc.Id;
        loc.SVMXC__City__c = generateRandomString(10);
        loc.SVMXC__Location_Type__c = 'Customer';
        loc.SVMXC__State__c = generateRandomString(5);
        loc.SVMXC__Street__c = generateRandomString(5);
        loc.SVMXC__Zip__c = generateRandomString(5);
        loc.SVMXC__Country__c = generateRandomString(5);
        insert loc;

        Product2 prod1 = new Product2(name = 'Main Product',IsActive = TRUE,ProductCode = 'Prod1234',Family = 'Manufacturing');
        Product2 prod2 = new Product2(name = 'Main Part1',IsActive = TRUE,ProductCode = 'PL1432',Family = 'Equipment'); 
        Product2 prod3 = new Product2(name = 'Main Part2',IsActive = TRUE,ProductCode = 'PL2456',Family = 'Equipment');     
        Product2 prod4 = new Product2(name = 'Main Part3',IsActive = TRUE,ProductCode = 'PL3215',Family = 'Equipment'); 
        Product2 prod5 = new Product2(name = 'Main Part4',IsActive = TRUE,ProductCode = 'PL4132',Family = 'Equipment'); 
        Product2 prod6 = new Product2(name = 'Main Part5',IsActive = TRUE,ProductCode = 'PL5632',Family = 'Equipment'); 
        Product2 prod7 = new Product2(name = 'Main Part6',IsActive = TRUE,ProductCode = 'PL6132',Family = 'Equipment'); 
        Product2 prod8 = new Product2(name = 'Main Part7',IsActive = TRUE,ProductCode = 'PL7332',Family = 'Equipment'); 
        Product2 prod9 = new Product2(name = 'Main Part8',IsActive = TRUE,ProductCode = 'PL8232',Family = 'Equipment');     
        list<Product2> products = new list<Product2> {Prod1,Prod2,Prod3,Prod4,Prod5,Prod6,Prod7,Prod8,Prod9};          
        insert products;
      
        SVMXC__Installed_Product__c ip = new SVMXC__Installed_Product__c();
        ip.Name='123456';
        ip.SVMXC__Company__c = acc.Id;
        ip.SVMXC__Contact__c = con.Id;
        ip.SVMXC__Serial_Lot_Number__c = 'UL234365';
        ip.SVMXC__Site__c = loc.Id;
        ip.SVMXC__Product__c = prod1.Id;
        insert ip;

        SVMXC__Installed_Product__c ip1 = new SVMXC__Installed_Product__c(Name='IP13456',SVMXC__Company__c=acc.Id,SVMXC__Contact__c=con.Id,SVMXC__Serial_Lot_Number__c='UL234365',SVMXC__Site__c=loc.Id,SVMXC__Product__c=Prod1.Id,SVMXC__Top_Level__c=ip.Id);
        SVMXC__Installed_Product__c ip2 = new SVMXC__Installed_Product__c(Name='IP23456',SVMXC__Company__c=acc.Id,SVMXC__Contact__c=con.Id,SVMXC__Serial_Lot_Number__c='UL125343',SVMXC__Site__c=loc.Id,SVMXC__Product__c=Prod2.Id,SVMXC__Top_Level__c=ip.Id);
        SVMXC__Installed_Product__c ip3 = new SVMXC__Installed_Product__c(Name='IP34156',SVMXC__Company__c=acc.Id,SVMXC__Contact__c=con.Id,SVMXC__Serial_Lot_Number__c='UL731234',SVMXC__Site__c=loc.Id,SVMXC__Product__c=Prod3.Id,SVMXC__Top_Level__c=ip.Id);  
        SVMXC__Installed_Product__c ip4 = new SVMXC__Installed_Product__c(Name='IP42453',SVMXC__Company__c=acc.Id,SVMXC__Contact__c=con.Id,SVMXC__Serial_Lot_Number__c='UL654323',SVMXC__Site__c=loc.Id,SVMXC__Product__c=Prod4.Id,SVMXC__Top_Level__c=ip.Id);
        SVMXC__Installed_Product__c ip5 = new SVMXC__Installed_Product__c(Name='IP543221',SVMXC__Company__c=acc.Id,SVMXC__Contact__c=con.Id,SVMXC__Serial_Lot_Number__c='UL265436',SVMXC__Site__c=loc.Id,SVMXC__Product__c=Prod5.Id,SVMXC__Top_Level__c=ip.Id);
        SVMXC__Installed_Product__c ip6 = new SVMXC__Installed_Product__c(Name='IP62326',SVMXC__Company__c=acc.Id,SVMXC__Contact__c=con.Id,SVMXC__Serial_Lot_Number__c='UL2673765',SVMXC__Site__c=loc.Id,SVMXC__Product__c=Prod6.Id,SVMXC__Top_Level__c=ip.Id);  
        List<SVMXC__Installed_Product__c> ipList = new list<SVMXC__Installed_Product__c> {ip1,ip2,ip3,ip4,ip5,ip6};
        insert ipList;
       
        ip2.SVMXC__Parent__c = ip1.id;
        ip3.SVMXC__Parent__c = ip1.id;
        ip5.SVMXC__Parent__c = ip4.id;
        ip6.SVMXC__Parent__c = ip4.id;
        List<SVMXC__Installed_Product__c> updateIpList = new list<SVMXC__Installed_Product__c> {ip1,ip2,ip3,ip4,ip5,ip6};
        update updateIpList; 

        SVMXC__Service_Order__c wo = new SVMXC__Service_Order__c();           
        wo.SVMXC__Company__c = acc.Id;
        wo.SVMXC__Contact__c = con.Id;
        wo.SVMXC__Site__c = loc.Id;
        wo.SVMXC__Component__c = ip.Id;
        wo.SVMXC__Product__c = prod1.Id; 
        wo.SVMXC__Priority__c = 'High';
        wo.SVMXC__Order_Type__c = 'Field Service';
        wo.SVMXC__Order_Status__c = 'Open';
        wo.SVMXC__Problem_Description__c = 'Device reporting multiple system failures. Need quick attention.';
        wo.SVMXC__City__c = acc.BillingCity;
        wo.SVMXC__State__c = acc.BillingState;
        wo.SVMXC__Street__c = acc.BillingStreet;
        wo.SVMXC__Country__c = acc.BillingCountry;
        wo.SVMXC__Zip__c = acc.BillingPostalCode;
        wo.SVMXC__Purpose_of_Visit__c = 'Repair';   
        insert wo;

        Case cs = new Case();
        cs.Status ='New';
        cs.Priority = 'Medium';
        cs.Origin = 'Email';
        cs.ContactId = con.Id;
        cs.AccountId = acc.Id;
        cs.SVMXC__Component__c = ip.id;         
        insert cs; 
        
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

        SVMXC__Service_Request__c sr = new SVMXC__Service_Request__c();
        sr.SVMXC__Account__c = acc.id;
        sr.SVMXC__Contact__c = con.id;
        sr.SVMXC__Priority__c = 'High';
        sr.SVMXC__Product__c = prod1.Id;
        sr.SVMXC__Serial_Number__c = ip.Id;
        sr.SVMXC__Status__c = 'Open';
        sr.SLA_Terms__c = slaTerm.Id;
        insert sr;
    }

    @isTest
    static void validateIPHieratchy() {      
        List<SVMXC__Installed_Product__c> ip = new List<SVMXC__Installed_Product__c>([SELECT Id,Name,SVMXC__Parent__c,SVMXC__Top_Level__c,SVMXC__Product__c,SVMXC__Product__r.Name,SVMXC__Date_Installed__c FROM SVMXC__Installed_Product__c WHERE SVMXC__Top_Level__c != NULL]);  
        Id ipId = ip[0].Id;
        Id topLevelId = ip[0].SVMXC__Top_Level__c;
        String objName;             
        DemoGetIPTreeData.getIPs(topLevelId );        
        DemoGetIPTreeData.getRoot(ipId);
        DemoGetIPTreeData.getParentHash(ipId);
        List<SVMXC__Installed_Product__c> iptest1 = new List<SVMXC__Installed_Product__c>([SELECT Id,Name,SVMXC__Parent__c,SVMXC__Top_Level__c,SVMXC__Product__c,SVMXC__Product__r.Name,SVMXC__Date_Installed__c FROM SVMXC__Installed_Product__c WHERE Id != NULL and SVMXC__Parent__c != NULL]);  
        iptest1[0].SVMXC__Top_Level__c = NULL;
        update iptest1;
        ipId = iptest1[0].Id;
        DemoGetIPTreeData.getRoot(ipId);  
        DemoGetIPTreeData.getParentHash(ipId);          
        List<SVMXC__Installed_Product__c> ips = new List<SVMXC__Installed_Product__c>([SELECT Id,Name,SVMXC__Parent__c,SVMXC__Top_Level__c,SVMXC__Product__c,SVMXC__Product__r.Name,SVMXC__Date_Installed__c FROM SVMXC__Installed_Product__c WHERE SVMXC__Top_Level__c != NULL]);  
        topLevelId = ips[0].SVMXC__Top_Level__c;
        DemoGetIPTreeData.getIPs(topLevelId);
    }

    @isTest
    static void validateWorkOrder() {        
        List<SVMXC__Service_Order__c> wo = new List<SVMXC__Service_Order__c>([SELECT Id,SVMXC__Component__c FROM SVMXC__Service_Order__c WHERE Id != NUll]);
        Id woId = wo[0].Id;
        DemoGetIPTreeData.getRoot(woId);                
    }

    @isTest
    static void validateCase() {      
        List<Case> cs = new List<Case>([SELECT Id,SVMXC__Component__c FROM Case WHERE Id != Null]);
        SVMXC__Installed_Product__c caseIp = [SELECT Id,Name,SVMXC__Top_Level__c FROM SVMXC__Installed_Product__c WHERE Id = :cs[0].SVMXC__Component__c];
        caseIp.SVMXC__Top_Level__c = NULL;
        update caseIp; 
        Id csId = cs[0].Id;
        DemoGetIPTreeData.getRoot(csId);  
    }

    @isTest
    static void validateServiceRequest() {    
        List<SVMXC__Service_Request__c> sr = new List<SVMXC__Service_Request__c>([SELECT Id,SVMXC__Serial_Number__c FROM SVMXC__Service_Request__c WHERE Id != NUll]);
        SVMXC__Installed_Product__c srIp = [SELECT Id,Name,SVMXC__Top_Level__c FROM SVMXC__Installed_Product__c WHERE Id =:sr[0].SVMXC__Serial_Number__c];
        srIp.SVMXC__Top_Level__c = NULL;
        update srIp;
        Id srId = sr[0].Id;
        DemoGetIPTreeData.getRoot(srId);            
    }

    public static String generateRandomEmail(String domain){
        if(domain == null || domain == '')
            domain = generateRandomString(8) + '.com';
        return generateRandomString(3) + System.now().getTime() + '@' + domain; // use timestamp to ensure usernames are unique
    }

    private static Set<String> priorRandoms;
    public static String generateRandomString(Integer length){
        if(priorRandoms == null)
            priorRandoms = new Set<String>();

        if(length == null) length = 1+Math.round( Math.random() * 8 );
        String characters = 'abcdefghijklmnopqrstuvwxyz1234567890';
        String returnString = '';
        while(returnString.length() < length){
            Integer charpos = Math.round( Math.random() * (characters.length()-1) );
            returnString += characters.substring( charpos , charpos+1 );
        }
        if(priorRandoms.contains(returnString)) {
            return generateRandomString(length);
        } else {
            priorRandoms.add(returnString);
            return returnString;
        }
    }
}