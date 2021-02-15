<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>SVMX_PS - Set Installed Product ID %28Serial - Product%29</fullName>
        <actions>
            <name>SVMX_PS_Set_Installed_Product_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow is used to update the Installed Product field to be &quot;&lt;Serial/Lot Number&gt; - &lt;Product&gt;&quot;.</description>
        <formula>Name &lt;&gt; (SVMXC__Serial_Lot_Number__c &amp; &quot;-&quot; &amp; SVMXC__Product__r.Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
