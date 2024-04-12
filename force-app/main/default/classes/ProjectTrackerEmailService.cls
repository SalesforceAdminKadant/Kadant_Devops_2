global class ProjectTrackerEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String strEmailBody = '';
        String strEmailSubject = '';
        Date dateDueDate = System.Today() + 1;

        Project_Tracker__c pt = null;
        Project_Tracker__c[] pts = null;
        Task t = null;
        User[] users = [select Id, Division From User WHERE Email = :email.fromAddress.trim() And IsActive=True];
        if (users.size() >= 1)
        {

            if(email.plainTextBody == null)
                strEmailBody = null;
            else
                strEmailBody = email.plainTextBody;
            if(strEmailBody.Length() > 131072)
                strEmailBody = strEmailBody.SubString(0, 131072);
            strEmailSubject = email.Subject;
            if(email.Subject.Length() > 100)
                strEmailSubject = strEmailSubject.SubString(0, 100);
            
            if(!strEmailSubject.toUppercase().StartsWith('TASK:') && !strEmailSubject.toUppercase().StartsWith('PT-'))
            {
                pt = new Project_Tracker__c(Division__c=users[0].Division, OwnerId=users[0].Id, CreatedById=users[0].Id, Name__c=strEmailSubject, Description__c=strEmailbody);
                insert pt;
            }
            else
            {
                if(strEmailSubject.Length() > 11 && strEmailSubject.toUppercase().StartsWith('PT-') && strEmailSubject.Substring(11,12) == ':')
                {
                    pts = [select Id, Name From Project_Tracker__c WHERE Name = :strEmailSubject.toUppercase().Substring(0, 11) LIMIT 1];
                    if(pts.size() >= 1)
                    {
                        pt = pts[0];
                    }
                }
                if(pt != null)
                {
                    if (strEmailSubject.Length() <= 12)
                        strEmailSubject = pt.name;
                    else
                        strEmailSubject = strEmailSubject.Substring(13).Trim();
                    t = new Task(OwnerId=users[0].Id, CreatedById=users[0].Id, Subject=strEmailSubject, WhatId=pt.Id, Description=strEmailbody, ActivityDate=dateDueDate);
                    insert t;
                }
                else
                {
                    pts = [select Id, Name From Project_Tracker__c WHERE OwnerId = :users[0].Id And Status__c='Tasks' And Division__c=:users[0].Division];
                    if(pts.size() >= 1)
                    {
                        pt = pts[0];
                    }
                    else
                    {
                        pt = new Project_Tracker__c(Division__c=users[0].Division, OwnerId=users[0].Id, CreatedById=users[0].Id, Name__c='My Tasks', Status__c='Tasks');
                        insert pt;
                    }
                    if (strEmailSubject.Length() <= 5)
                        strEmailSubject = email.Subject;
                    else
                        strEmailSubject = strEmailSubject.Substring(6).Trim();
                    t = new Task(OwnerId=users[0].Id, CreatedById=users[0].Id, Subject=strEmailSubject, WhatId=pt.Id, Description=strEmailbody, ActivityDate=dateDueDate);
                    insert t;
                }
            }
            
            pt = [select Id, Name From Project_Tracker__c WHERE Id =:pt.Id Limit 1];
     
            if(pt != null || t != null)
            {
            
                List<ContentVersion>cvList = new List<ContentVersion>();
                List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                ContentVersion contentInsert = null;
                ContentDocumentLink cl = null;

                if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                    for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments) {
                        contentInsert = new ContentVersion();
                        contentInsert.Title = binAttach.fileName;
                        contentInsert.VersionData = binAttach.body;
                        contentInsert.PathOnClient = '/' + binAttach.fileName;
                        cvList.add(contentInsert);
                    }
                }

                if (email.textAttachments != null && email.textAttachments.size() > 0) {
                    for (Messaging.InboundEmail.TextAttachment txtAttach : email.textAttachments) {
                        contentInsert = new ContentVersion();
                        contentInsert.Title = txtAttach.fileName;
                        contentInsert.VersionData = Blob.valueOf(txtAttach.body);
                        contentInsert.PathOnClient = '/' + txtAttach.fileName;
                        cvList.add(contentInsert);
                    }
                }
            
                if(!cvList.isEmpty())
                {
                    try
                    {
                        insert cvList;
                    }
                    catch(Exception ex)
                    {
                    }

                    List<ContentVersion>cvDivList = [select id, Title, PathOnClient, ContentDocumentId from ContentVersion WHERE Id in :cvList];
                    for (ContentVersion cv : cvDivList) {
                        cl = new ContentDocumentLink();
                        cl.ContentDocumentId = cv.ContentDocumentId;
                        if(t != null)
                            cl.LinkedEntityId = t.Id;
                        else
                            cl.LinkedEntityId = pt.Id;
                        cl.ShareType = 'V';
                        cl.Visibility = 'AllUsers';
                        cdlList.add(cl);
                    }
                }

                if(!cdlList.isEmpty())
                {
                    insert cdlList;
                    cdlList.clear();
                }

                Send_Custom_Notification__c scn = new Send_Custom_Notification__c(Title__c='Project Tracker Notification', Target_ID__c=pt.id, Body__c='Project or Task successfully created - project ' + pt.Name + '. Tap or click to view', Notification_Type__c='0ML0z0000008OI5GAM', Recipients__c=users[0].Id);
                insert scn;
                
            }
        }

        return result;

    }
}