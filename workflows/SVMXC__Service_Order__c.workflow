<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DEF_IT_Send_email_to_customer_when_Assigned_Technician_Multi_Day</fullName>
        <description>DEF_IT_Send email to customer when Assigned Technician Multi-Day</description>
        <protected>false</protected>
        <recipients>
            <field>SVMXC__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SVMX_PS_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>assistenza@def-online.it</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DEF_IT_Assigned_Technician_Template_Multi_Day</template>
    </alerts>
    <alerts>
        <fullName>DEF_IT_Send_email_when_Appointment_confirmed_with_the_Customer_Multi_Day</fullName>
        <description>DEF_IT_Send email when Appointment confirmed with the Customer Multi-Day</description>
        <protected>false</protected>
        <recipients>
            <field>SVMXC__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SVMX_PS_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>assistenza@def-online.it</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DEF_IT_Customer_Confirmed_Template_Multi_Day</template>
    </alerts>
    <rules>
        <fullName>DEF_IT_Notify Customer Of Appointment Confirmation</fullName>
        <actions>
            <name>DEF_IT_Send_email_to_customer_when_Customer_Confirmed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Order_Status__c</field>
            <operation>equals</operation>
            <value>Customer Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Country__c</field>
            <operation>equals</operation>
            <value>IT</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Multiple_day_intervention__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Send e-mail confirmation to customer when a WO is scheduled and confirmed ( the email is automatically sent after the WO status changes to &quot;Customer Confirmed&quot;).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_IT_Notify Customer Of Appointment Confirmation Multi-Day</fullName>
        <actions>
            <name>DEF_IT_Send_email_when_Appointment_confirmed_with_the_Customer_Multi_Day</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Order_Status__c</field>
            <operation>equals</operation>
            <value>Customer Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Country__c</field>
            <operation>equals</operation>
            <value>IT</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Multiple_day_intervention__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send e-mail confirmation to customer when a WO is scheduled and confirmed ( the email is automatically sent after the WO status changes to &quot;Customer Confirmed&quot;).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
            <value>CRS0002</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Multiple_day_intervention__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notify the Customer of the Assigned Work Order and ask for confirmation of the appointment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_IT_Notify Customer of Assigned Technician Multi-Day</fullName>
        <actions>
            <name>DEF_IT_Send_email_to_customer_when_Assigned_Technician_Multi_Day</name>
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
            <value>CRS0002</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Multiple_day_intervention__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notify the Customer of the Assigned Work Order and ask for confirmation of the appointment when WO lasts more than one day</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
