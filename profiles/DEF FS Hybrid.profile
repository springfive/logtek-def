<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <custom>true</custom>
    <layoutAssignments>
        <layout>SVMXC__Service_Group__c-DEF_WW_Service Group Layout</layout>
        <recordType>SVMXC__Service_Group__c.SVMXC__Technician</recordType>
    </layoutAssignments>
    <loginIpRanges>
        <endAddress>255.255.255.255</endAddress>
        <startAddress>0.0.0.0</startAddress>
    </loginIpRanges>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>SVMXC__Service_Group__c.SVMXC__Equipment</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>false</default>
        <recordType>SVMXC__Service_Group__c.SVMXC__Technician</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <tabVisibilities>
        <tab>SVMXC__Service_Contract__c</tab>
        <visible>DefaultOn</visible>
    </tabVisibilities>
    <tabVisibilities>
        <tab>ServiceProject__c</tab>
        <visible>DefaultOn</visible>
    </tabVisibilities>
    <userLicense>Salesforce Platform</userLicense>
</Profile>
