/*
* @author Naveen Sakhamuri
* @date 27/05/20
* @name: TimeZoneUtility
* @description: 
* @Change History
*
*   Tag         Author              Date         Incident No.   Requested-BY      Description
* *****************************************************************************************************************
*   1.0.0       Naveen Sakhamuri    27/05/20                                       Initial Version
* *****************************************************************************************************************/
public with sharing class TimeZoneUtility {
    //@description: convert datetime from one timezone to another timezone
    public static Datetime convertTimezone(Datetime dateTimeToConvert, String fromTimeZone, String toTimeZone) {
        Integer offset = getOffsetInMinutes(fromTimeZone, toTimeZone);
        Datetime convertedDateTime = dateTimeToConvert.addMinutes(offset);
        return convertedDateTime;
    }

    //description: Get time difference in minutes between two timezones
    public static Integer getOffsetInMinutes(String fromTimeZoneString, String toTimeZoneString) {
        if (fromTimeZoneString != null && toTimeZoneString != null) {
            Integer totalOffset = 0;
            String fromTZStr;
            String temp = fromTimeZoneString.replace('/','') + toTimeZoneString.replace('/','');
            String key = temp.replaceAll('_','');
            if(Cache.Org.contains(key)) {
                totalOffset = (Integer) Cache.Org.get(key);
            } else {
                Datetime nowDatetime = System.Now();
                TimeZone fromTimeZone = TimeZone.getTimeZone(fromTimeZoneString);
                if (fromTimeZoneString != 'GMT' && fromTimeZone.getID() == 'GMT') {
                    fromTimeZone = UserInfo.getTimeZone();
                }
                TimeZone toTimeZone = TimeZone.getTimeZone(toTimeZoneString);
                if (toTimeZoneString != 'GMT' && toTimeZone.getID() == 'GMT') {
                    toTimeZone = UserInfo.getTimeZone();
                }
                Integer fromOffset = fromTimeZone.getOffset(nowDatetime);
                Integer toOffset = toTimeZone.getOffset(nowDatetime);
                totalOffset = (toOffset - fromOffset) / (60 * 1000);
                Cache.Org.put(key, totalOffset);
            }
            return totalOffset;
        } else {
            return 0;
        }
    }
}