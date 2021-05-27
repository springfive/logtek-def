<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>DEF_BE_Notify Account Owner of Field Feedback with quote</fullName>
        <actions>
            <name>DEF_BE_Notify_Account_owner_of_new_field_feedback_requiring_a_quote</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Feedback__c.Needs_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Feedback__c.DEF_Company__c</field>
            <operation>equals</operation>
            <value>BE_DEF</value>
        </criteriaItems>
        <description>Send email to Account owner when a New Field Feedback requiring a quote has been created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_GB_Notify Account Owner of Field Feedback with quote</fullName>
        <actions>
            <name>DEF_GB_Notify_Account_owner_of_new_field_feedback_requiring_a_quote</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Feedback__c.Needs_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Feedback__c.DEF_Company__c</field>
            <operation>equals</operation>
            <value>GB_Clarkson</value>
        </criteriaItems>
        <description>When a Field Feedack requiring a quote is created, an email is sent to the Field Feedback 	Account owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_IT_Notify Account Owner of Field Feedback with quote</fullName>
        <actions>
            <name>DEF_IT_Notify_Account_owner_of_new_field_feedback_requiring_a_quote</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Field_Feedback__c.Needs_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Feedback__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Field_Feedback__c.DEF_Company__c</field>
            <operation>equals</operation>
            <value>IT_DEF</value>
        </criteriaItems>
        <description>When a Field Feedack requiring a quote is created, an email is sent to the Field Feedback 	Account owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
