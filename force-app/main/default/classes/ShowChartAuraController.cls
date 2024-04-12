/*
* @author Naveen Sakhamuri
* @date 2/6/2020 
*
* @group Community
*
* @description: Controller class to provide data for the rule charts.
* @Change History
*
*   Tag         Author              Date         Incident No.   Requested-BY      Description     
* *****************************************************************************************************************              
*   1.0.0       Naveen Sakhamuri    2/6/2020                                        Initial Version 
* *****************************************************************************************************************/
public class ShowChartAuraController {
    //Attribute to pass the data to the aura component
    @AuraEnabled
    public List<LineChartVar> myLineChartVarList;
    
    //Wrapper class to pass the rule detail data.
    public class LineChartVar {
        String label;
        Decimal firstValue;
        
        public LineChartVar(String a, Decimal b) {
            label = a;
            firstValue = b;
        }
    }
    
    //Get the list of tags for the charts page
    @AuraEnabled
    public static List<String> getTagsList(String ruleId) {
        Set<String> tagsSet = new Set<String>();
        List<String> tagsList = new List<String>();
        Map<String, Map<String,Decimal>> tagMap = new Map<String, Map<String,Decimal>>();
        
        String cacheKey = ruleId;
        cacheKey = cacheKey.replaceAll('[|,|\\-|/| |.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
        
        if(Cache.Org.contains(cacheKey)) {
            tagMap = (Map<String, Map<String,Decimal>>) Cache.Org.get(cacheKey);
            tagsList.addAll(tagMap.keySet());
        } else {
            for(AggregateResult  ar: [SELECT COUNT(Id), Tag__c 
                                      FROM Rule_Detail__c 
                                      WHERE Rule__c = :ruleId 
                                      GROUP BY Tag__c ]) 
            {
                tagsSet.add((String)ar.get('Tag__c'));
            }
            tagsList.addAll(tagsSet);
        }
        return tagsList;
    }
    
    //Get the triggered data for the bar chart
    @AuraEnabled
    public static String getChartMap(String ruleId, String timeZone) {
        List<String> dates = new List<String>();
        List<String> backgroundColor = new List<String>();
        List<Integer> active = new List<Integer>();
        Map<String, String> valueMap = new Map<String, String>();
        Map<String, Integer> priorityMap = new Map<String, Integer>();
        Map<String, Map<String,Decimal>> tagMap = new Map<String, Map<String,Decimal>>();
        
        priorityMap.put('TRIGGERED', 3);
        priorityMap.put('ACTIVE', 2);
        priorityMap.put('INACTIVE', 1);
        String userTimezone = UserInfo.getTimeZone().getID();
        Boolean timeConvert = (timeZone != userTimezone);
        Integer offset = 0;
        if(timeConvert) {
            offset = TimeZoneUtility.getOffsetInMinutes(userTimezone, timeZone);
        }
        List<Rule_Detail__c> details = [
            SELECT Id, RuleExecutionDtTm__c, AlertStatusLevel__c, AlertStatus__c, TelemetryDtTm__c, Tag__c, TagValue__c
            FROM Rule_Detail__c
            WHERE Rule__c = :ruleId
            AND TelemetryDtTm__c != null
            ORDER BY TelemetryDtTm__c DESC LIMIT 4999
        ];
        
        for (Rule_Detail__c rd : details)
        {
            if(timeConvert)
            {
                rd.TelemetryDtTm__c = rd.TelemetryDtTm__c.addMinutes(offset);
            }
            String ruleExeDate = rd.TelemetryDtTm__c.format('MMM dd, H:mm');
            if(!valueMap.containsKey(ruleExeDate))
            {
                valueMap.put(ruleExeDate, rd.AlertStatus__c);
            }
            else
            {
                Integer existingValue = priorityMap.get(valueMap.get(ruleExeDate));
                Integer newValue = priorityMap.get(rd.AlertStatus__c);
                if(newValue > existingValue)
                {
                    valueMap.put(ruleExeDate, rd.AlertStatus__c);
                }
            }
            
            if(!tagMap.containsKey(rd.Tag__c))
            {
                tagMap.put(rd.Tag__c, new Map<String,Decimal>());
            }
            tagMap.get(rd.Tag__c).put(ruleExeDate, rd.TagValue__c);
        }
        
        for(String ruleExeDate: valueMap.keySet())
        {
            dates.add(ruleExeDate);
            String value = valueMap.get(ruleExeDate);
            if(value == 'ACTIVE')
            {
                active.add(1);
                backgroundColor.add('#FF5733');
            }
            else if(value == 'INACTIVE')
            {
                active.add(-1);
                backgroundColor.add('#70BDD8');
            }
            else if (value == 'TRIGGERED')
            {
                active.add(2);
                backgroundColor.add('#070707');
            }
        }
        
        String cacheKey = ruleId;
        cacheKey = cacheKey.replaceAll('[|,|\\-|/| |.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
        Cache.Org.put(cacheKey, tagMap);
        
        barWrapper bw = new barWrapper();
        bw.labels = new List<String>();
        bw.datasets = new List<dataset>();
        bw.labels.addAll(dates);
        
        dataset ds1 = new dataset();
        ds1.backgroundColor = backgroundColor;
        ds1.data = active;
        bw.datasets.add(ds1);
        
        return JSON.serialize(bw);
    }
    
    //Get the rule detail data for a specific tag to show on the 48 hr chart
    @AuraEnabled
    public static String getLineChartMap(String ruleId, String tagName, String timeZone) {
        
        List<LineChartVar> myLineChartVarList = new List<LineChartVar>();
        Map<String, Map<String,Decimal>> tagMap = new Map<String, Map<String,Decimal>>();
        String userTimezone = UserInfo.getTimeZone().getID();
        Boolean timeConvert = (timeZone != userTimezone);
        Integer offset = 0;
        if(timeConvert) {
            offset = TimeZoneUtility.getOffsetInMinutes(userTimezone, timeZone);
        }
        String cacheKey = ruleId;
        cacheKey = cacheKey.replaceAll('[|,|\\-|/| |.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
        
        if(Cache.Org.contains(cacheKey)) {
            tagMap = (Map<String, Map<String,Decimal>>) Cache.Org.get(cacheKey);
            if(tagMap.containsKey(tagName)) {
                for(String telemetryDate: tagMap.get(tagName).keySet()) {
                    myLineChartVarList.add(new LineChartVar(telemetryDate, tagMap.get(tagName).get(telemetryDate)));
                }
            }
        } else {
            List<Rule_Detail__c> details = [
                SELECT TelemetryDtTm__c, Tag__c, TagValue__c
                FROM Rule_Detail__c
                WHERE Tag__c = :tagName AND TelemetryDtTm__c != null AND Rule__c = :ruleId
                ORDER BY TelemetryDtTm__c DESC LIMIT 4999
            ];
            for (Rule_Detail__c rd : details) {
                if(timeConvert) {
                    rd.TelemetryDtTm__c = rd.TelemetryDtTm__c.addMinutes(offset);
                }
                myLineChartVarList.add(new LineChartVar(rd.TelemetryDtTm__c.format('MMM dd, H:mm'), rd.TagValue__c));
            }
        }
        return JSON.serialize(myLineChartVarList);
    }                                                  
    
    //Wrapper to pass the rule data information for the bar chart
    public class barWrapper {
        public List<String> labels;
        public List<dataset> datasets;
    }
    
    //Wrapper to store each value in the bar chart wrapper
    public class dataset{
        public list<String> backgroundColor;
        public List<Integer> data;
    }
}