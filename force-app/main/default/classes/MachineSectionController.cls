public with sharing class MachineSectionController {
    @AuraEnabled(cacheable=true)
    public static List<Machine_Section__c> getSectionList(string mac_id) {
        return [SELECT Id, Name FROM Machine_Section__c WHERE Machine__c = :mac_id ORDER BY Name];
    } 
    
    @AuraEnabled(cacheable=true)
    public static List<Machine_Mapping_Cleaning__c> getCleaningList(string sec_id) {
        return [SELECT Id, Application__c FROM Machine_Mapping_Cleaning__c WHERE Machine_Section__c = :sec_id ORDER BY Application__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Machine_Mapping_Doctor__c> getDoctorList(string sec_id) {
        return [SELECT Id, Label_Name__c FROM Machine_Mapping_Doctor__c WHERE Machine_Section__c = :sec_id ORDER BY Label_Name__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Machine_Mapping_Filter__c> getFilterList(string sec_id) {
        return [SELECT Id, Application__c FROM Machine_Mapping_Filter__c WHERE Machine_Section__c = :sec_id ORDER BY Application__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Machine_Mapping_Drainage__c> getDrainageList(string sec_id) {
        return [SELECT Id, Application__c FROM Machine_Mapping_Drainage__c WHERE Machine_Section__c = :sec_id ORDER BY Application__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Machine_Mapping_Roll__c> getRollsList(string sec_id) {
        return [SELECT Id, Label__c FROM Machine_Mapping_Roll__c WHERE Machine_Section__c = :sec_id ORDER BY Label__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Machine_Mapping_Belt__c> getBeltList(string sec_id) {
        return [SELECT Id, Postion__c FROM Machine_Mapping_Belt__c WHERE Machine_Section__c = :sec_id ORDER BY Postion__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<RecordType> getRecordType() {
        return [SELECT id, Name FROM RecordType WHERE SobjectType = 'Service_Report_Item__c'];
    }

    @AuraEnabled(cacheable=true)
    public static String getDoctorType(String id) {
        String docType = null;
        if (String.isNotBlank(id))
        {
            List<Machine_Mapping_Doctor__c> docTypes = [SELECT RecordType.Name FROM Machine_Mapping_Doctor__c WHERE Id = :id LIMIT 1];
            docType = docTypes[0].RecordType.Name;
        }
        return docType;
    }

    @AuraEnabled(cacheable=true)
    public static String getCleaningType(String id) {
        String clnType = null;
        if (String.isNotBlank(id))
        {
            List<Machine_Mapping_Cleaning__c> clnTypes = [SELECT RecordType.Name FROM Machine_Mapping_Cleaning__c WHERE Id = :id LIMIT 1];
            clnType = clnTypes[0].RecordType.Name;
            if (clnType == 'Traversing Shower')
            {
                clnType = 'Mclean';
            }
        }
        return clnType;
    }

    @AuraEnabled(cacheable=true)
    public static String getLastBladeChange(String id) {        
        String lastChange = 'Unknown';
        if (String.isNotBlank(id))
        {            
            List<Service_Report_Item__c> backingBlades = [SELECT Last_Backing_Blade_Change__c FROM Service_Report_Item__c WHERE Machine_Mapping_Doctor__c = :id AND RecordType.Name = 'Yankee' AND Last_Backing_Blade_Change__c <> '' ORDER BY CreatedDate DESC LIMIT 1];
            if (!backingBlades.isEmpty())
            {
                lastChange = backingBlades[0].Last_Backing_Blade_Change__c;
            }            
        }
        return lastChange;
    }

    @AuraEnabled(cacheable=true)
    public static String getLastComformaticChange(String id) {        
        String lastChange = 'Unknown';
        if (String.isNotBlank(id))
        {            
            List<Service_Report_Item__c> conformaticBlades = [SELECT Last_Conformatic_Tube_Change__c FROM Service_Report_Item__c WHERE Machine_Mapping_Doctor__c = :id AND RecordType.Name = 'Yankee' AND Last_Conformatic_Tube_Change__c  <> '' ORDER BY CreatedDate DESC LIMIT 1];
            if (!conformaticBlades.isEmpty())
            {
                lastChange = conformaticBlades[0].Last_Conformatic_Tube_Change__c;
            }            
        }
        return lastChange;
    }

    @AuraEnabled(cacheable=true)
    public static String getTopicCategory(String id) {
        String topType = null;
        if (String.isNotBlank(id))
        {
            List<Service_Report_Item__c> topTypes = [SELECT Topic_Category__c FROM Service_Report_Item__c WHERE Id = :id LIMIT 1];
            topType = topTypes[0].Topic_Category__c;
        }
        return topType;
    }

    @AuraEnabled(cacheable=true)
    public static List<sharinpix__SharinPixImage__c> getImageList(string sri_id) {
        return [SELECT Id, Name, sharinpix__Title__c, Fit_to_Size__c, sharinpix__Description__c, sharinpix__ImageURLMini__c, sharinpix__ImageFull__c FROM sharinpix__SharinPixImage__c WHERE Service_Report_Item__c = :sri_id];
    }
    
    private static Map<Object,List<String>> getDependentPicklistValues(Schema.sObjectField dependToken)
    {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if ( controlToken == null ) return null;
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries =
        (   control.getType() == Schema.DisplayType.Boolean
        ?   null
        :   control.getPicklistValues()
        );
    
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        for ( Schema.PicklistEntry entry : depend.getPicklistValues() ) if ( entry.isActive() )
        {
            List<String> base64chars =
                String.valueOf
                (   ((Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( entry ) )).get( 'validFor' )
                ).split( '' );
            for ( Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++ )
            {
                Object controlValue =
                (   controlEntries == null
                ?   (Object) (index == 1)
                :   (Object) (controlEntries[ index ].isActive() ? controlEntries[ index ].getLabel() : null)
                );
                Integer bitIndex = index / 6, bitShift = 5 - Math.mod( index, 6 );
                if  (   controlValue == null
                    ||  (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0
                    ) continue;
                if ( !dependentPicklistValues.containsKey( controlValue ) )
                {
                    dependentPicklistValues.put( controlValue, new List<String>() );
                }
                dependentPicklistValues.get( controlValue ).add( entry.getLabel() );
            }
        }
        return dependentPicklistValues;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getListValues(String cat)
    {
        Map<Object,List<String>> result = getDependentPicklistValues(Service_Topic_Item__c.Topic__c);        
        List<String> resultList = result.get(cat);
        return resultList;
    }    

    @AuraEnabled(cacheable=true)
    public static List<Service_Topic_Item__c> getOpenTopicsList(string id, string objName) {
        List<Service_Topic_Item__c> stiList = null;
        if (objName == 'Service_Report_Item__c')
        {
            //System.Debug('SRI ID passed in:' + id);
            List<Service_Report_Item__c> sr = [SELECT Id, Machine_Category__c, Machine_Mapping_Cleaning__c, Machine_Mapping_Doctor__c, Machine_Mapping_Drainage__c, Machine_Mapping_Filter__c FROM Service_Report_Item__c WHERE Id = :id LIMIT 1];
            //System.Debug('SRI Machine Category from Query:' + sr[0].Machine_Category__c);
            String mac_cat = sr[0].Machine_Category__c;            
            String cl_id = sr[0].Machine_Mapping_Cleaning__c;
            String dr_id = sr[0].Machine_Mapping_Doctor__c;
            String dn_id = sr[0].Machine_Mapping_Drainage__c;
            String fl_id = sr[0].Machine_Mapping_Filter__c;

            if (mac_cat == 'Cleaning')
            {
                stiList = [SELECT Id, CreatedDate, Position__c, Priority__c, Topic__c, Customer_Action_Summary__c, Status__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Cleaning__r.Id = :cl_id AND Status__c = 'Open'];
            }

            if (mac_cat == 'Doctor')
            {
                stiList = [SELECT Id, CreatedDate, Position__c, Priority__c, Topic__c, Customer_Action_Summary__c, Status__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Doctor__r.Id = :dr_id AND Status__c = 'Open'];
            }

            if (mac_cat == 'Drainage')
            {
                stiList = [SELECT Id, CreatedDate, Position__c, Priority__c, Topic__c, Customer_Action_Summary__c, Status__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Drainage__r.Id = :dn_id AND Status__c = 'Open'];
            }

            if (mac_cat == 'Filter')
            {
                stiList = [SELECT Id, CreatedDate, Position__c, Priority__c, Topic__c, Customer_Action_Summary__c, Status__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Machine_Mapping_Filter__r.Id = :fl_id AND Status__c = 'Open'];
            }            
        }
        else 
        {
            stiList = [SELECT Id, CreatedDate, Position__c, Priority__c, Topic__c, Customer_Action_Summary__c, Status__c FROM Service_Topic_Item__c WHERE Service_Report_Item__r.Service_Report__r.Machine__c = :id AND Status__c = 'Open'];
        }
        return stiList;
    }

    @AuraEnabled(cacheable=true)
    public static Service_Topic_Item__c getOpenTopic(String id) {
        return [SELECT Id, CreatedDate, Position__c, Status__c, Priority__c, Topic__c, Customer_Action_Summary__c, Summary__c, Owner.Name, Service_Report_Item__r.Machine_Category__c FROM Service_Topic_Item__c WHERE Id = :id LIMIT 1];
    }
}