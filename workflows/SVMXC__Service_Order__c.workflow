<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>DEF_IT_Notify Customer of Assigned Technician</fullName>
        <actions>
            <name>DEF_IT_Send_email_to_customer_when_Assigned_Technician</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.DEF_Company__c</field>
            <operation>equals</operation>
            <value>IT_DEF</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Confirmation_Request_Status__c</field>
            <operation>equals</operation>
            <value>Request Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Scheduled_Duration_in_hours__c</field>
            <operation>lessThan</operation>
            <value>24</value>
        </criteriaItems>
        <description>Notify the Customer of the Assigned Work Order and ask for confirmation of the appointment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
