/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-25-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

global class DEF_SC_ShedulerForBatchContractStatus implements Schedulable{

    public static String sched = '0 00 00 * * ?';  //Every Day at Midnight 

    global static String scheduleBatch() {
        DEF_SC_ShedulerForBatchContractStatus SC = new DEF_SC_ShedulerForBatchContractStatus(); 
        return System.schedule('Contract Expiry job' +system.now(), sched, SC);
    }

    global void execute(SchedulableContext sc) {

        DEF_SC_UpdateStatusWhenContractExpired batch = new DEF_SC_UpdateStatusWhenContractExpired();
        ID batchprocessid = Database.executeBatch(batch,100);           
    }
}