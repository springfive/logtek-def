/**
* @author: Sofiane Bazizen (SpringFive)
* @description: Helper for the DEF_WO_SirSender class, handles:
*		- Wrapper Class and query structure
*		- retrieval of SIR and creation of attachments for the SIR emails
*		- Sending of SIR emails
* @last modified on  : 06-04-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   2020-01-11   Sofiane Bazizen					  Initial Version
* 1.0   2021-01-29   Sofiane Bazizen					  Added null check + functionality to log email sent as activities.
*/
public class DEF_WO_SirSender_Helper {
    
    public static string woQuery = 'SELECT Id, OwnerId, DEF_Company__c, SVMXC__Service_Contract__c, SVMXC__Service_Contract__r.SVMX_PS_Parent_Contract__c, SVMXC__Group_Member__r.SVMXC__Email__c, SVMXC__Contact__c'
        + ' FROM SVMXC__Service_Order__c'
        + ' WHERE Id In :workOrderSet'
        + ' AND DEF_Company__c != null'
        + '';
    
    public static string scQuery = 'SELECT Id'
        + ', (SELECT Id, Full_Name__c, SVMXC__Contact__r.Email FROM R00N70000001hzcxEAA WHERE Must_Receive_Report__c = true AND SVMXC__Contact__r.Email!=null)'
        + ' FROM SVMXC__Service_Contract__c'
        + ' WHERE Id In :serviceContractIdSet'
        + '';

    public static string attQuery= 'SELECT Id, Name, Work_Order__c, Technician_Equipment__r.SVMXC__Email__c'
        + ' FROM Assigned_Tools_Technician__c'
        + ' WHERE Technician_Equipment__r.SVMXC__Email__c!=null AND Work_Order__c IN: workOrderSet';
    
    /*-------------------  WRAPPER CLASSES ---------------------*/
    public class woWrapper {
        
        private SVMXC__Service_Order__c wo { get; Set; }
        private Set<Id> contractIdSet { get; set; }
        private Set<String> emailSet { get; set; }
        private Set<String> techEmail { get; set; }
        private List<ContentVersion> attachmentList { get; set; }
        private Boolean isSuccess { get; set; }
        Private String errorLog { get; set; }
        
        
        public woWrapper(SVMXC__Service_Order__c wo) {
            
            this.isSuccess = true;
            this.errorLog = '';
            this.wo = wo;
            this.contractIdSet = new Set<Id> { wo.SVMXC__Service_Contract__c };
                this.contractIdSet.add(wo.SVMXC__Service_Contract__r.SVMX_PS_Parent_Contract__c);
            this.techEmail = new Set<String>();
            this.emailSet = new Set<String>();
            
        }
        
        
        /******** Getter and Setters *********/
        
        // isSuccess getter and setter
        public Boolean getIsSuccess() {
            return this.isSuccess;
        }
        
        public void setIsSuccess(Boolean isSuccess) {
            this.isSuccess = isSuccess;
        }
        
        // errorLog getter and setter
        public String getErrorLog() {
            return this.errorLog;
        }
        
        public void setErrorLog(String ErrorLog) {
            this.ErrorLog += '-' + ErrorLog + '\n';
        }
        
        // wo getter and setter
        public SVMXC__Service_Order__c getWo() {
            return this.wo;
        }
        
        public void setWo(SVMXC__Service_Order__c wo) {
            this.wo = wo;
        }
        
        
        //contractIdSet getter and setter
        public Set<Id> getcontractIdSet() {
            return this.contractIdSet;
        }
        
        public void setcontractIdSet(Set<Id> contractIdSet) {
            this.contractIdSet = contractIdSet;
        }
        
        public Set<Id> addItemTocontractIdSet(Id scId) {
            if (this.contractIdSet.isEmpty()) {
                
                this.contractIdSet = new Set<Id> { scId };
                    
                    } else {
                        
                        this.contractIdSet.add(scId);
                        
                    }
            
            return this.contractIdSet;
            
        }
        
        //emailSet getter and setter
        public Set<String> getEmailSet() {
            return this.emailSet;
        }
        
        public void setEmailSet(Set<String> emailSet) {
            if(this.emailSet==null){
                this.emailSet=emailSet.clone();
            }
            else{
            this.emailSet.addAll(emailSet);
            }
        }
        
        public Set<String> addItemsToEmailSet(List<SVMXC__Service_Contract_Contacts__c> entCtList) {
            
            Set<String> tempEmailSet = new Set<String> ();
            
            for (SVMXC__Service_Contract_Contacts__c entCt : entCtList) {
                tempEmailSet.add(entCt.SVMXC__Contact__r.Email);
            }
            
            if (this.emailSet == null) {
                
                this.emailSet = tempEmailSet.clone();
                
            } else {
                
                this.emailSet.addAll(tempEmailSet);
                
            }
			//this.emailSet.addAll(tempEmailSet);            
            return this.emailSet;
        }
        
        //TechEmail getter and setter
        public Set<String> getTechEmail() {
            return this.techEmail;
        }
        
        public void setTechEmail(Set<String> techEmail) {
            
                this.techEmail.addAll(techEmail);
            
            System.debug('@this.techEmail '+this.techEmail);
        }
        
        
        //attachmentList getter and setter
        public List<ContentVersion> getAttachmentList() {
            return this.attachmentList;
        }
        
        public void addItemToAttachmentList(ContentVersion cv) {
            if (this.attachmentList == null) {
                
                this.attachmentList = new List<ContentVersion> { cv };
                    
                    } else {
                        
                        this.attachmentList.add(cv);
                        
                    }
        }
    }
    /*------------------- END WRAPPER CLASSES ---------------------*/
    
    public static Map<Id, DEF_WO_SirSender_Helper.woWrapper> retrieveSirAttachments(Map<Id, DEF_WO_SirSender_Helper.woWrapper> woWrapperMap) {
        
        System.debug('@In DEF_WO_SirSender_Helper.retrieveSirAttachments method...');
        
        //Getting List of Related Document link
        Set<Id> woIdSet = woWrapperMap.keySet();
        List<ContentDocumentLink> contentDocumentLinkList = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :woIdSet];
        
        System.debug('contentDocumentLinkList size: ' + contentDocumentLinkList.size());
        if (contentDocumentLinkList.size() > 0) {
            Map<Id, Id> contentDocumentToLinkedEntityMap = new Map<Id, Id> ();
            Set<Id> contentDocumentSet = new Set<Id> ();
            for (ContentDocumentLink contentDocumentLinkInstance : contentDocumentLinkList) {
                contentDocumentToLinkedEntityMap.put(contentDocumentLinkInstance.ContentDocumentId, contentDocumentLinkInstance.LinkedEntityId);
                contentDocumentSet.add(contentDocumentLinkInstance.ContentDocumentId);
            }
            if (!String.isBlank(system.Label.DEF_WO_SIRNamePrefix)) {
                String sirNamePrefix = system.Label.DEF_WO_SIRNamePrefix + '%';
                
                //SOQL to get ContentVersion related to DocumentLink
                List<ContentVersion> contentVersionList = [SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId FROM ContentVersion WHERE FileType = :'PDF' AND Title LIKE :sirNamePrefix AND ContentDocumentId IN :contentDocumentSet];
                
                System.debug('@contentVersionList: ' + contentVersionList);
                
                if (contentVersionList.size() > 0) {
                    
                    //Map<Id, List<ContentVersion>> workOrderToContentVersionMap = new Map<Id, List<ContentVersion>> ();
                    
                    //Populating wo wrapper with the relevant SIR attachments.
                    String woId = null;
                    for (ContentVersion contentVersionInstance : contentVersionList) {
                        
                        woId = contentDocumentToLinkedEntityMap.get(contentVersionInstance.ContentDocumentId);
                        
                        System.debug('@contentVersionInstance: ' + contentVersionInstance);
                        System.debug('@woId: ' + woId);
                        
                        if (woId != null) {
                            
                            if (woWrapperMap.containsKey(woId)) {
                                
                                System.debug('@adding cv to wrapper...');
                                woWrapperMap.get(woId).addItemToAttachmentList(contentVersionInstance);
                                
                            }
                            else {
                                
                                //Nothing
                                System.debug('@wo Id NOT found...');
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
            }
            
        }
        
        System.debug('@woWrapperMap: ' + woWrapperMap);
        
        return woWrapperMap;
        
    }
    
    
    public static void sendSirEmails(Map<Id, DEF_WO_SirSender_Helper.woWrapper> woWrapperMap) {
        
        //getting all the comapny involved in the transaction (to retrieve the relevant email templates)
        Set<String> defCompanySet = new Set<String> ();
        for (DEF_WO_SirSender_Helper.woWrapper woWrapper : woWrapperMap.values()) {
            defCompanySet.add(woWrapper.getWo().DEF_Company__c);
        }
        
        //Key: email tempalte name, Value: SIR_Config__mdt (contains info about email template to use and sender email)
        Map<String, SIR_Config__mdt> sirMapping = new Map<String, SIR_Config__mdt> ();
        
        //Key: Def Company, Value: SIR_Config__mdt (contains info about email template to use and sender email)
        Map<String, SIR_Config__mdt> sirConfigMap = new Map<String, SIR_Config__mdt> ();
        //Below empty check added by Devendra [10 May 2021]:
        List<SIR_Config__mdt> cnfigSIRList = [SELECT Type__c,MasterLabel, DeveloperName, EmailTemplateName__c, OrgWideEmailAddress__c 
                                              FROM SIR_Config__mdt 
                                              WHERE MasterLabel IN :defCompanySet 
                                              AND Type__c=:DEF_StringHelper.type_RegularSIR];
        if(!cnfigSIRList.isEmpty()){
            for (SIR_Config__mdt sConf :cnfigSIRList) { //@dev
                sirMapping.put(sConf.EmailTemplateName__c, sConf);
                sirConfigMap.put(sConf.MasterLabel, sConf); //@dev
            }
            System.debug('@sirMapping: ' + sirMapping);
        
        
            //Key: Def Company, Value: Email Template
            Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate> ();
            for (EmailTemplate template :[SELECT DeveloperName, Id, Name FROM EmailTemplate WHERE DeveloperName In :sirMapping.keySet()]) {
                System.debug('@template.DeveloperName: ' + template.DeveloperName);
                templateMap.put(sirMapping.get(template.DeveloperName).MasterLabel, template); //@dev
            }
            
            System.debug('@templateMap: ' + templateMap);
            
            //retrieving Org Wide Email Address for each company.
            //Key: OrgWideEmailAddress , Value: OrgWideEmailAddress ID
            Map<String, String> SenderEmailMap = new Map<String, String> ();
            
            String addr = null;
            for (OrgWideEmailAddress owa :[select id, Address, DisplayName from OrgWideEmailAddress]) {
                addr = owa.Address.toLowerCase();
                SenderEmailMap.put(addr, owa.Id);
                
            }
            
            List<Messaging.SingleEmailMessage> mailToSend = new List<Messaging.SingleEmailMessage> ();
            
            //Iterate Map and Generate SingleEmailMessage List for All workOrders
            String defCompany;
            String metaAddr; //address retrieved from the custom metadata types.
            Set<String> techEmail=new Set<String>();
            for (Id workOrderId : woWrapperMap.keyset()) {
                
                defCompany = null;
                metaAddr = null;
                if(techEmail.size()>0){
                    techEmail.clear();
                }
                
                List<ContentVersion> contentVersionListInstance = woWrapperMap.get(workOrderId).getAttachmentList();
                List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment> ();
                
                if (contentVersionListInstance != null && contentVersionListInstance.size() > 0) {
                    
                    for (ContentVersion cv : contentVersionListInstance) {
                        
                        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                        attachment.setBody(cv.VersionData);
                        string fileName = cv.Title;
                        attachment.setFileName(fileName);
                        attachment.setContentType('application/' + cv.FileType);
                        attachments.add(attachment);
                        
                    }
                    
                    //Apex Single email message
                    defCompany = woWrapperMap.get(workOrderId).getWo().DEF_Company__c;
                    String templateId;
                    if(templateMap.containsKey(defCompany)){
                        templateId=templateMap.get(defCompany).Id;
                    }
                    String userId = woWrapperMap.get(workOrderId).getWo().OwnerId;
                    String whatId = workOrderId;
                    
                    if(templateId!=null){
                        Messaging.SingleEmailMessage mail=Messaging.renderStoredEmailTemplate(templateId, userId, whatId);
                        mail.setTreatTargetObjectAsRecipient(false);
                        mail.setUseSignature(false);
                        if(woWrapperMap.get(workOrderId).getEmailSet().size()>0){
                        mail.setToAddresses(new List<String> (woWrapperMap.get(workOrderId).getEmailSet()));
                        }
                        techEmail = woWrapperMap.get(workOrderId).getTechEmail();
                        if (techEmail.size()>0) { mail.setCcAddresses(new List<String> (techEmail)); }
                        System.debug('@sirConfigMap.get(defCompany): ' + sirConfigMap.get(defCompany));
                        metaAddr = sirConfigMap.get(defCompany).OrgWideEmailAddress__c.toLowerCase();
                        if(SenderEmailMap.containsKey(metaAddr)){
                        mail.setOrgWideEmailAddressId(SenderEmailMap.get(metaAddr));
                        }
                        mail.setFileAttachments(attachments); //Set File Attachment
                        mail.setSaveAsActivity(true);

                         //Add the List of Mail to be sended based on work orders to the List
                        if(templateId!=null && woWrapperMap.get(workOrderId).getEmailSet().size()>0){
                            mailToSend.add(mail);
                        }
                    }
                    
                   
                }
                else {
                    
                    woWrapperMap.get(workOrderId).setIsSuccess(false);
                    woWrapperMap.get(workOrderId).setErrorLog('No relevant SIR attachement found.');
                    
                }
            }
            
            
            //Send Email
            if (mailToSend.size() > 0) {
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(mailToSend);
                }
            }
        }
    }
    
}