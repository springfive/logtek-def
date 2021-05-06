@isTest
public class DEF_WO_ToSynchWithSB_Test {
    static testmethod void WO_UpdateWOToSynchWithSBTest() {
        
        //Create Account
        Account acc=DEF_TestDataFactory.CreateAccount('TestAccount');
        acc.Status__c = 'Active';
        //acc.Tech_StatusIsChanged__c = TRUE;
        Database.insert(acc);
        System.assertEquals(acc.name, 'TestAccount');
        Contact con = DEF_TestDataFactory.CreateContact('TestContact');
        Database.insert(con);
        System.assertEquals(con.LastName, 'TestContact');
        SVMXC__Service_Order__c wo = DEF_TestDataFactory.CreateWorkOrder(acc,con,'Navision','IT');
        wo.SVMXC__Order_Status__c='Unschedule';
        wo.SVMXC__SM_Version_Number__c = 1;
        Database.insert(wo);
        System.assertEquals(wo.SVMXC__Order_Status__c, 'Unschedule');
		List<Id> accIds = new List<Id>();
        accIds.add(acc.Id);
        Test.startTest();
        DEF_WO_ToSynchWithSB.updateWorkOrders(accIds);
        Test.stopTest();
    }
}