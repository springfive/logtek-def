/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-13-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-11-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class DEF_WO_SendEmailToContacts {
    @InvocableMethod(label='Send Email To Contacts With Related Files')
    public static void SendEmailToContacts(List<SVMXC__Service_Order__c> workorderRecord){
       
        //Getting The Email Template Id using SOQL
        EmailTemplate template=[SELECT DeveloperName,Id,Name FROM EmailTemplate WHERE Name = 'SVMX_PS - Work Order Service Report Email' LIMIT 1];
        Set<Id> workOrderSet=new Set<Id>();
        //Create Map of WorkOrder Id-->WorkOrder
        Map<Id,SVMXC__Service_Order__c> workOrderMap=new Map<Id,SVMXC__Service_Order__c>(workorderRecord);
        //Create Set with List of WorkOrder Id
        workOrderSet=workOrderMap.keySet();
        //Getting List of Related Document link
        List<ContentDocumentLink> contentDocumentLinkList = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: workOrderSet]; 
        if(contentDocumentLinkList.size()>0){
            Map<Id,Id> contentDocumentToLinkedEntityMap=new Map<Id,Id>();
            Set<Id> contentDocumentSet=new Set<Id>();
            for(ContentDocumentLink contentDocumentLinkInstance:contentDocumentLinkList){
                contentDocumentToLinkedEntityMap.put(contentDocumentLinkInstance.ContentDocumentId, contentDocumentLinkInstance.LinkedEntityId);
                contentDocumentSet.add(contentDocumentLinkInstance.ContentDocumentId);
            }
            //SOQL to get ContentVersion related to DocumentLink
            List<ContentVersion> contentVersionList = [SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId FROM ContentVersion WHERE FileType=:'PDF' AND  Title LIKE 'SIR%' AND ContentDocumentId IN: contentDocumentSet];
            if(contentVersionList.size()>0){
                Map<Id,List<ContentVersion>> workOrderToContentVersionMap=new Map<Id,List<ContentVersion>>();
                //Create a Map of WorkOrderId-->List<ContentVersion>
                for(ContentVersion contentVersionInstance:contentVersionList){
                    if(contentDocumentToLinkedEntityMap.get(contentVersionInstance.ContentDocumentId)!=null){
                        if(workOrderToContentVersionMap.containsKey(contentDocumentToLinkedEntityMap.get(contentVersionInstance.ContentDocumentId))){
                            List<ContentVersion> contentVersionListInstance=workOrderToContentVersionMap.get(contentDocumentToLinkedEntityMap.get(contentVersionInstance.ContentDocumentId));
                            contentVersionListInstance.add(contentVersionInstance);
                            workOrderToContentVersionMap.put(contentDocumentToLinkedEntityMap.get(contentVersionInstance.ContentDocumentId),contentVersionListInstance);
                        }
                        else{

                            List<ContentVersion> contentVersionListInstance=new List<ContentVersion>();
                            contentVersionListInstance.add(contentVersionInstance);
                            workOrderToContentVersionMap.put(contentDocumentToLinkedEntityMap.get(contentVersionInstance.ContentDocumentId),contentVersionListInstance);
                        }

                    }


                }
                List<Messaging.SingleEmailMessage> mailToSend=new List<Messaging.SingleEmailMessage>();
                //Iterate Map and Generate SingleEmailMessage List for All workOrders
                for(Id workOrderId:workOrderToContentVersionMap.keyset()){
                    List<ContentVersion> contentVersionListInstance=workOrderToContentVersionMap.get(workOrderId);
                    List<Messaging.EmailFileAttachment> attachments=new List<Messaging.EmailFileAttachment>();
                    for(ContentVersion cv:contentVersionListInstance){
                        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                        attachment.setBody(cv.VersionData);
                        string fileName =cv.Title;
                        attachment.setFileName(fileName);
                        attachment.setContentType('application/'+cv.FileType);
                        attachments.add(attachment);
                    }
                        
                        //Apex Single email message
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(template.Id);
                    mail.setTargetObjectId(workOrderMap.get(workOrderId).SVMXC__Contact__c);
                    mail.setWhatId(workOrderId);
                    mail.setUseSignature(false);
                    mail.setToAddresses(new String[] { workOrderMap.get(workOrderId).Contact_Email_SF__c });//Set To Email Address
                    mail.setFileAttachments(attachments);//Set File Attachment
                    //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email

                    //Add the List of Mail to be sended based on work orders to the List
                    mailToSend.add(mail);


                }
                //Send Email
                if(mailToSend.size()>0){
                    Messaging.sendEmail(mailToSend);
                }


            }

        }

    }

}