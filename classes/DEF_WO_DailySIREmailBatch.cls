/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-16-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class DEF_WO_DailySIREmailBatch implements Database.Batchable<SVMXC__Service_Order__c>,Database.Stateful {

    public List<SVMXC__Service_Order__c> start(Database.BatchableContext bc) {

        Date tdy=date.today();
        String WO_RecordType=DEF_StringHelper.WO_RT_DailySIR;
        String WO_RT_Id=Schema.SObjectType.SVMXC__Service_Order__c.getRecordTypeInfosByName().get(WO_RecordType).getRecordTypeId();
        List<SVMXC__Service_Order__c> woList=new List<SVMXC__Service_Order__c>();
        if(!String.isBlank(WO_RecordType)){
        woList=[SELECT Id,DEF_Company__c,OwnerId,ServiceProject__r.Project_Manager__r.Email  FROM SVMXC__Service_Order__c where ServiceProject__r.Project_Manager__r.Email != null AND DEF_Company__c!=null AND RecordTypeId=:WO_RT_Id AND (SVMXC__Order_Status__c='Job In Progress' OR (SVMXC__Order_Status__c='Job Complete' AND DAY_ONLY(SVMXC__Completed_Date_Time__c)=:tdy))];
        }
        return woList;

    }
    global void execute(Database.BatchableContext bc,List<SVMXC__Service_Order__c> scope){
        
        //Map=> Key:Work Order ID, Value: Work Order Sobject
        Map<Id, SVMXC__Service_Order__c> woMap = new Map<Id, SVMXC__Service_Order__c>(scope);
        //Set=> Key: Work Order ID
        Set<Id> woSet=woMap.keySet();

        //Set=> Key: DEF Company
        Set<string> defCompanySet=new Set<String>();
        for(SVMXC__Service_Order__c woInstance:scope){
            defCompanySet.add(woInstance.DEF_Company__c);

        }
        system.debug('defCompanySet'+JSON.serialize(defCompanySet)); //@dev
        List<ContentDocumentLink> contentDocumentLinkList = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :woSet];
        
        if(contentDocumentLinkList.size()>0){
            //Map=> Key: Content Document Id, Value: Work Order Id
            Map<Id,Id> cdlToWo=new Map<Id,Id>();
            //Set=> Key: Content Document Id
            Set<Id> cdIdSet=new Set<Id>();
            for(ContentDocumentLink cdlInstance:contentDocumentLinkList){
                cdlToWo.put(cdlInstance.ContentDocumentId,cdlInstance.LinkedEntityId);
                cdIdSet.add(cdlInstance.ContentDocumentId);
            }
            if (!String.isBlank(system.Label.DEF_WO_DailySIRNamePrefix)) {
				String sirNamePrefix = system.Label.DEF_WO_DailySIRNamePrefix+'%';
                List<ContentVersion> contentVersionList = [SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId FROM ContentVersion WHERE FileType = :'PDF' AND IsLatest=true AND Title LIKE :sirNamePrefix AND ContentDocumentId IN :cdIdSet];
                if(contentVersionList.size()>0){
                    //Map=> Key:Work Order Id, Value: List<Attachment>
                    Map<Id,List<Messaging.EmailFileAttachment>> woToAttachmentMap=new Map<Id,List<Messaging.EmailFileAttachment>>();
                    Id currRecWOId;

                    //Create List of Attachment respect to the work orders
                    for(ContentVersion cvInstance:contentVersionList){
                        //Get Work Order for this content version from map based on content document id
                        currRecWOId=cdlToWo.get(cvInstance.ContentDocumentId);
                        //Create Attachment for the Current Content Version
                        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                        attachment.setBody(cvInstance.VersionData);
                        string fileName = cvInstance.Title;
                        attachment.setFileName(fileName);
                        attachment.setContentType('application/' + cvInstance.FileType);

                        //Store the Attachment in Map based on Work Order Id
                        if(woToAttachmentMap.containsKey(currRecWOId)){
                            List<Messaging.EmailFileAttachment> existingAttachmentList=woToAttachmentMap.get(currRecWOId);
                            existingAttachmentList.add(attachment);
                            woToAttachmentMap.put(currRecWOId, existingAttachmentList);
                        }
                        else{
                            List<Messaging.EmailFileAttachment> newAttachmentList=new List<Messaging.EmailFileAttachment>();
                            newAttachmentList.add(attachment);
                            woToAttachmentMap.put(currRecWOId, newAttachmentList);

                        }

                    }

                    //Key: email tempalte name, Value: SIR_Config__mdt (contains info about email template to use and sender email)
                    Map<String, SIR_Config__mdt> sirMapping = new Map<String, SIR_Config__mdt> ();

                    //Key: Def Company, Value: SIR_Config__mdt (contains info about email template to use and sender email)
                    Map<String, SIR_Config__mdt> sirConfigMap = new Map<String, SIR_Config__mdt> ();

                    for (SIR_Config__mdt sConf :[SELECT Type__c,MasterLabel, DeveloperName, EmailTemplateName__c, OrgWideEmailAddress__c FROM SIR_Config__mdt WHERE MasterLabel IN :defCompanySet AND Type__c=:DEF_StringHelper.type_DailySIR]) { //@dev
                        sirMapping.put(sConf.EmailTemplateName__c, sConf);
                        sirConfigMap.put(sConf.MasterLabel, sConf);  //@dev
                    }
                    System.debug('sirMapping'+JSON.serialize(sirMapping)); //@dev
                    System.debug('sirConfigMap'+JSON.serialize(sirConfigMap)); //@dev

                    System.debug('@sirMapping: ' + sirMapping);


                    //Key: Def Company, Value: Email Template
                    Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate> ();
                    for (EmailTemplate template :[SELECT DeveloperName, Id, Name FROM EmailTemplate WHERE DeveloperName In :sirMapping.keySet()]) {
                        System.debug('@template.DeveloperName: ' + template.DeveloperName);
                        templateMap.put(sirMapping.get(template.DeveloperName).MasterLabel, template);  //@dev
                    }
                    System.debug('templateMap'+JSON.serialize(templateMap)); //@dev
                    System.debug('@templateMap: ' + templateMap);

                    //retrieving Org Wide Email Address for each company.
                    //Key: OrgWideEmailAddress , Value: OrgWideEmailAddress ID
                    Map<String, String> SenderEmailMap = new Map<String, String> ();

                    String addr = null;
                    for (OrgWideEmailAddress owa :[select id, Address, DisplayName from OrgWideEmailAddress]) {
                        addr = owa.Address.toLowerCase();
                        SenderEmailMap.put(addr, owa.Id);

                    }

               
                    List<Messaging.SingleEmailMessage> mailToSend = new List<Messaging.SingleEmailMessage>();
                    Set<Id> woToSend=woToAttachmentMap.keySet();
                    String defCompany;
                    String metaAddr;
                    //Create Single Email Message Instance respect to each work orders
                    for(Id woId:woToSend){
                        //Apex Single email message
                        defCompany = woMap.get(woId).DEF_Company__c;
                        String templateId = templateMap.get(defCompany).Id;
                        String userId = woMap.get(woId).OwnerId;
                        String whatId = woId;

                        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
                        mail.setTreatTargetObjectAsRecipient(false);
                        mail.setUseSignature(false);
                        mail.setToAddresses(new List<String> {woMap.get(woId).ServiceProject__r.Project_Manager__r.Email});
                        metaAddr = sirConfigMap.get(defCompany).OrgWideEmailAddress__c.toLowerCase();
                        mail.setOrgWideEmailAddressId(SenderEmailMap.get(metaAddr));
                        mail.setFileAttachments(woToAttachmentMap.get(woId)); //Set File Attachment
                        mail.setSaveAsActivity(true);

                        //add mail instance(for each work order) to the list to handle bulk
                        mailToSend.add(mail);

                    }
                    //send Email in bulk 
                    if(mailToSend.size()>0){
                        Messaging.sendEmail(mailToSend);
                    }


                }
            }
        }
    }
    global void finish(Database.BatchableContext bc){

        //calculate next fire time 6PM in current timezone
        Date currDate=date.today();
        Time fireTime = Time.newInstance(18, 0, 0, 0);
        DateTime nextFireOn = DateTime.newInstance(currDate.addDays(1), fireTime);
        System.debug('Datetime tmrw '+nextFireOn);
        Integer offsetTZ = UserInfo.getTimezone().getOffset(nextFireOn);
        Datetime nextFireTZ = nextFireOn.addSeconds(offsetTZ/1000);
        system.debug('Next fire time french '+nextFireTZ);


        //Get Current time in current time zone
        DateTime dateTimeGMT=DateTime.now();
        system.debug('time now GMT'+dateTimeGMT);
        Integer offset = UserInfo.getTimezone().getOffset(dateTimeGMT);
        Datetime localeCurrentFR = dateTimeGMT.addSeconds(offset/1000);
        system.debug('time now french '+localeCurrentFR);
        

        //Difference b/w now and next fire time
        Long milliseconds = nextFireTZ.getTime()-localeCurrentFR.getTime();
        //System.debug('Datetime now '+datetime.now());
        System.debug('Datetime tmrw '+nextFireOn);
        system.debug('milli seconds '+milliseconds);
        Long seconds = milliseconds / 1000;
        system.debug('seconds '+seconds);
        Long minutes = seconds / 60;
        system.debug('minutes '+minutes);
        Long hours = minutes / 60;
        system.debug('hours '+hours);
        Long days = hours / 24;
        system.debug('days '+days);

        DEF_WO_DailySIREmailBatch batchInstance=new DEF_WO_DailySIREmailBatch();

        //Schedule the batch for tomorrow 6 PM
        ID nextBatchId=system.scheduleBatch(batchInstance,'DEF_WO_DailySIREmailBatch '+System.currentTimeMillis(), minutes.intValue());
        System.debug('Next Batch Id '+nextBatchId);



        
    }    
 
}