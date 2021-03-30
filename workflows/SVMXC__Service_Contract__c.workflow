<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activate_The_Contract</fullName>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Activate The Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DEF_WW_Active_Checkbox_to_False</fullName>
        <field>SVMXC__Active__c</field>
        <literalValue>0</literalValue>
        <name>DEF_WW_Active Checkbox to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DEF_WW_Set_The_Active_Checkbox_To_True</fullName>
        <field>SVMXC__Active__c</field>
        <literalValue>1</literalValue>
        <name>DEF_WW_Set The Active Checkbox To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DEF_WW_Update_ContractAccount_Name</fullName>
        <field>Account_Name__c</field>
        <formula>SVMXC__Company__r.Name</formula>
        <name>DEF_WW_Update ContractAccount Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Activate Contract Status</fullName>
        <actions>
            <name>Activate_The_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SVMXC__Service_Contract__c.SVMXC__Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_WW_Set Active Checkbox to False</fullName>
        <actions>
            <name>DEF_WW_Active_Checkbox_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SVMXC__Service_Contract__c.Status__c</field>
            <operation>equals</operation>
            <value>Expired,Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DEF_WW_Set Active Checkbox to True</fullName>
        <actions>
            <name>DEF_WW_Set_The_Active_Checkbox_To_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SVMXC__Service_Contract__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DEF_WW_Update Account Name</fullName>
        <actions>
            <name>DEF_WW_Update_ContractAccount_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(SVMXC__Company__r.Name))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
