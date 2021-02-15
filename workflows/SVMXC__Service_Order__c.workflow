<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DEF_IT_Notify_Customer_On_Rescheduling</fullName>
        <description>DEF_IT_Notify Customer Of Rescheduled Work Order</description>
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
        <template>unfiled$public/DEF_IT_Rescheduling_WO_Template</template>
    </alerts>
    <alerts>
        <fullName>DEF_IT_Reminder_to_Customer_about_Appointment</fullName>
        <description>DEF_IT_Reminder to Customer about Appointment</description>
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
        <template>unfiled$public/DEF_IT_Reminder_Email_to_Customer</template>
    </alerts>
    <alerts>
        <fullName>DEF_IT_Send_Email_to_Planner_on_High_Priority_WO</fullName>
        <description>DEF_IT_Send Email to Planner on High Priority WO</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>ps.servicemax@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DEF_IT_High_Priority_WO_Template</template>
    </alerts>
    <alerts>
        <fullName>DEF_IT_Send_email_to_customer_when_Assigned_Technician</fullName>
        <description>DEF_IT_Send email to customer when Assigned Technician</description>
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
        <template>unfiled$public/DEF_IT_Assigned_Technician_Template</template>
    </alerts>
    <alerts>
        <fullName>DEF_IT_Send_email_to_customer_when_Customer_Confirmed</fullName>
        <description>DEF_IT_Send email to customer when the Appointment has been confirmed with the Customer (WO status = Customer Confirmed)</description>
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
        <template>unfiled$public/DEF_IT_Customer_Confirmed_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>DEF_UK_Set_WO_to_Customer_Confirmed</fullName>
        <description>For UK Work Orders, set the Status to customer confirmed after dispatch</description>
        <field>SVMXC__Order_Status__c</field>
        <literalValue>Customer Confirmed</literalValue>
        <name>DEF_UK_Set WO to Customer Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DEF_WW_Set_Status_to_Customer_Confirmed</fullName>
        <field>SVMXC__Order_Status__c</field>
        <literalValue>Customer Confirmed</literalValue>
        <name>DEF_WW_Set Status to Customer Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SVMX_PS_Set_WO_to_Assigned</fullName>
        <description>Updates WO status to Assigned when Dispatch Status equals Assigned and WO Status is of a particular status.</description>
        <field>SVMXC__Order_Status__c</field>
        <literalValue>Assigned Technician</literalValue>
        <name>SM Catalyst - Set WO to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>DEF_IT_Notify Customer Of Appointment Confirmation</fullName>
        <actions>
            <name>DEF_IT_Send_email_to_customer_when_Customer_Confirmed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
        <description>Send e-mail confirmation to customer when a WO is scheduled and confirmed ( the email is automatically sent after the WO status changes to &quot;Customer Confirmed&quot;).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_IT_Notify Customer of Assigned Technician</fullName>
        <actions>
            <name>DEF_IT_Send_email_to_customer_when_Assigned_Technician</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Country__c</field>
            <operation>equals</operation>
            <value>IT</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Order_Status__c</field>
            <operation>equals</operation>
            <value>Assigned Technician</value>
        </criteriaItems>
        <description>Notify the Customer of the Assigned Work Order and ask for confirmation of the appointment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_IT_Notify Planner on High Priority WO</fullName>
        <actions>
            <name>DEF_IT_Send_Email_to_Planner_on_High_Priority_WO</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Priority__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.Alert__c</field>
            <operation>notEqual</operation>
            <value>Account Blocked 🚨</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_IT_Reminder Email to Customer</fullName>
        <active>true</active>
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
        <description>Send reminder email to customer 1 week before intervention</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DEF_IT_Reminder_to_Customer_about_Appointment</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>SVMXC__Service_Order__c.SVMXC__Scheduled_Date_Time__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DEF_IT_Set WO to Customer Confirmed</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Order_Status__c</field>
            <operation>equals</operation>
            <value>Assigned Technician</value>
        </criteriaItems>
        <criteriaItems>
            <field>SVMXC__Service_Order__c.SVMXC__Country__c</field>
            <operation>equals</operation>
            <value>IT</value>
        </criteriaItems>
        <description>For Italy Work Orders, set the WO status to Assigned Technician after dispatching</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_UK_Set WO to Customer Confirmed</fullName>
        <actions>
            <name>DEF_UK_Set_WO_to_Customer_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>For UK Work Orders, set the status to Customer Confirmed after dispatching</description>
        <formula>AND( ISPICKVAL(SVMXC__Order_Status__c, &apos;Assigned Technician&apos;), ISPICKVAL(SVMXC__Country__c, &apos;GB&apos;), NOT($Setup.DEF_CS_BypassComponents__c.Bypass_Workflow__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_WW_Set WO to Customer Confirmed</fullName>
        <actions>
            <name>DEF_WW_Set_Status_to_Customer_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Customer_Confirmed__c = true, 			NOT($Setup.DEF_CS_BypassComponents__c.Bypass_Workflow__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SVMX_PS - Set WO to Assigned</fullName>
        <actions>
            <name>SVMX_PS_Set_WO_to_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Used to set the Work Order Status to Assigned after the Dispatch Console is used to dispatch the Technician.</description>
        <formula>AND( 				SVMXC__Dispatch_Status__c = &apos;Assigned&apos;, 				NOT($Setup.DEF_CS_BypassComponents__c.Bypass_Workflow__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
