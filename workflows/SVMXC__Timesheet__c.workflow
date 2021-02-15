<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Timesheet_Approved_Email_Alert</fullName>
        <description>Timesheet Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DEF_WW_Timesheet_Approved</template>
    </alerts>
    <alerts>
        <fullName>Timesheet_Rejection_Email_Alert</fullName>
        <description>Timesheet Rejection Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DEF_WW_Timesheet_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Approved</fullName>
        <field>SVMXC__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected</fullName>
        <field>SVMXC__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
