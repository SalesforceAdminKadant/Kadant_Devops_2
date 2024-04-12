global class KadantInboxEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String ccemails = null;
        String toEmails = null;
        String strEmailBody = '';
        final String strEmailBodyName = 'emailbody';
        EmailMessage createEmail = null;

        if(email.fromAddress.toUpperCase() != 'SALESFORCE.ADMIN@KADANT.COM')
        {
            if(email.toAddresses != null)
            {
                for(string str : email.toAddresses)
                {
                    if(toEmails == null)
                        toEmails = str;
                    else
                    {
                        toEmails += ';' + str;
                    }
                }
            }

            if(email.ccAddresses != null)
            {
                for(string str : email.ccAddresses)
                {
                    if(ccemails == null)
                        ccemails = str;
                    else
                        ccemails += ';\n' + str;
                }
            }

            Kadant_Info_Inbox__c inb = null;
            User[] users = null;
            
            if(email.htmlBody == null || email.htmlBody.Length() > 131072)
                strEmailBody = null;
            else
                strEmailBody = email.htmlBody;

            inb = new Kadant_Info_Inbox__c(Email_Address_of_Sender__c=email.fromAddress,Email_Subject__c=email.Subject,Email_Body_HTML__c=strEmailBody,Email_Body_Text__c=email.plainTextBody);
            try
            {
                insert inb;
            }
            catch(Exception ex)
            {
                inb = new Kadant_Info_Inbox__c(Email_Address_of_Sender__c=email.fromAddress,Email_Subject__c=email.Subject,Email_Body_Text__c=email.plainTextBody);
                insert inb;
            }
            createEmail = new EmailMessage(
                 Subject                        = email.Subject
                ,RelatedToId                    = inb.Id
                ,Status                         = '1'
                ,ToAddress                      = toEmails
                ,CcAddress                      = ccemails
                ,FromAddress                    = email.fromAddress
                ,FromName                       = email.fromName
                ,Headers                        = JSON.serialize(email.headers)
                ,HtmlBody                       = strEmailBody
                ,TextBody                       = email.plainTextBody
                ,Incoming                       = true
                ,MessageDate                    = DateTime.now()
            );
            insert createEmail;

            users = new List<User>();
            users = [select Id, Email From User WHERE IsActive = True And (Profile.Name = 'KJ Marketing' Or Username like 'danielle.rohrer%')];
            if (users.size() > 0) {
                for(User u : users)
                {
                    EmailMessageRelation createEmailRelation = new EmailMessageRelation(
                        EmailMessageId                 = createEmail.Id
                        ,RelationAddress                = u.Email
                        ,RelationId                     = u.Id
                        ,RelationType                   = 'BccAddress'
                        );
                    insert createEmailRelation;
                }
            }

            ContentVersion contentInsert = null;
            ContentDocumentLink cl = null;

            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0)
            {
                for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments)
                {
                    contentInsert = new ContentVersion();
                    contentInsert.Title = binAttach.fileName;
                    contentInsert.VersionData = binAttach.body;
                    contentInsert.PathOnClient = '/' + binAttach.fileName;
                    insert contentInsert;
                    contentInsert = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentInsert.Id LIMIT 1];

                    cl = new ContentDocumentLink();
                    cl.ContentDocumentId = contentInsert.ContentDocumentId;
                    cl.LinkedEntityId = inb.Id;
                    cl.ShareType = 'V';
                    cl.Visibility = 'AllUsers';
                    insert cl;

                    cl = new ContentDocumentLink();
                    cl.ContentDocumentId = contentInsert.ContentDocumentId;
                    cl.LinkedEntityId = createEmail.Id;
                    cl.ShareType = 'V';
                    cl.Visibility = 'AllUsers';
                    insert cl;
                }
            }

            if (email.textAttachments != null && email.textAttachments.size() > 0)
            {
                for (Messaging.InboundEmail.TextAttachment txtAttach : email.textAttachments)
                {
                    contentInsert = new ContentVersion();
                    contentInsert.Title = txtAttach.fileName;
                    contentInsert.VersionData = Blob.valueOf(txtAttach.body);
                    contentInsert.PathOnClient = '/' + txtAttach.fileName;
                    insert contentInsert;
                    contentInsert = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentInsert.Id LIMIT 1];

                    cl = new ContentDocumentLink();
                    cl.ContentDocumentId = contentInsert.ContentDocumentId;
                    cl.LinkedEntityId = inb.Id;
                    cl.ShareType = 'V';
                    cl.Visibility = 'AllUsers';
                    insert cl;

                    cl = new ContentDocumentLink();
                    cl.ContentDocumentId = contentInsert.ContentDocumentId;
                    cl.LinkedEntityId = createEmail.Id;
                    cl.ShareType = 'V';
                    cl.Visibility = 'AllUsers';
                    insert cl;
                }
            }
        }

        return result;

    }
}