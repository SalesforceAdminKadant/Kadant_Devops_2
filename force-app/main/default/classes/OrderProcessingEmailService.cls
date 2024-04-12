global class OrderProcessingEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String ccemails = null;
        String toEmails = null;
        String strEmailBody = '';
        final String strEmailBodyName = 'emailbody';
        Boolean boolKSD = false;
        Boolean boolKJ = false;
        EmailMessage createKSDEmail = null;
        EmailMessage createKJEmail = null;

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

            Order_Processing__c op = null;
            Contact[] c = null;
            User[] users = null;
        
            //Retrieve each "To" email address and determine which Kadant division it was sent to
            if(email.toAddresses != null && email.toAddresses.size() > 0)
            {
                for(string emailAddress : email.toAddresses)
                {
                    //Check to see if this is a KSD Email
                    if(emailAddress != null && (emailAddress == 'ksd_order_processing@1yxgtdlqjzrp2lsnhyjmv1d0xdkj1g166cg9bokanylzzat8ha.3-6ftleae.na139.apex.salesforce.com' || emailAddress == 'orders.kadantsolutions@kadant.com'))
                    {
                        boolKSD = true;
                    }
                    //Check to see if this is a KJ Email
                    if(emailAddress != null && (emailAddress == 'kj_order_processing@n-2qwpznbqnhl3otphqpbtenc5n3394io1rg7fba43wnqnbknu7r.3-6ftleae.na139.apex.salesforce.com' || emailAddress == 'orders.tr@kadant.com' || emailAddress == 'customerserviceorders.threerivers@kadant.com' ))
                    {
                        boolKJ = true;
                    }
                }
            }

            if(boolKSD == false)
            {
                //Retrieve each "CC" email address and determine which Kadant division it was sent to
                if(email.ccAddresses != null && email.ccAddresses.size() > 0)
                {
                    for(string emailAddress : email.ccAddresses)
                    {
                        //Check to see if this is a KSD Email
                        if(emailAddress != null && (emailAddress == 'ksd_order_processing@1yxgtdlqjzrp2lsnhyjmv1d0xdkj1g166cg9bokanylzzat8ha.3-6ftleae.na139.apex.salesforce.com' || emailAddress == 'orders.kadantsolutions@kadant.com'))
                        {
                            boolKSD = true;
                        }
                    }
                }
            }
        
            if(boolKJ == false)
            {
                //Retrieve each "CC" email address and determine which Kadant division it was sent to
                if(email.ccAddresses != null && email.ccAddresses.size() > 0)
                {
                    for(string emailAddress : email.ccAddresses)
                    {
                        //Check to see if this is a KJ Email
                        if(emailAddress != null && (emailAddress == 'kj_order_processing@n-2qwpznbqnhl3otphqpbtenc5n3394io1rg7fba43wnqnbknu7r.3-6ftleae.na139.apex.salesforce.com' || emailAddress == 'orders.tr@kadant.com'))
                        {
                            boolKJ = true;
                        }
                    }
                }
            }

            if(boolKSD == true || boolKJ == true)
            {
                if(email.htmlBody == null || email.htmlBody.Length() > 131072)
                    strEmailBody = null;
                else
                    strEmailBody = email.htmlBody;
                if(boolKSD == true)
                {
                    op = new Order_Processing__c(Division__c='KSD',Email_Address_of_Sender__c=email.fromAddress,Email_Subject__c=email.Subject,Sent_To__c=toEmails);
                    c = [select Id, AccountId from Contact WHERE Email = :email.fromAddress And Employment_Status__c = 'Active' And Account.RecordType.Name = 'US Account'];
                    if (c != null && c.size() == 1) {
                        //If the email is sent from a KSD user, don't include contact and account info
                        users = new List<User>();
                        users = [select Id From User WHERE Email = '" & :email.fromAddress.trim() & "' And Profile.Name Like 'KSD%'];
                        if (users.size() >= 1 || email.fromAddress.trim().toLowerCase() == 'staci.fitzsimons@kadant.com' || email.fromAddress.trim().toLowerCase() == 'lorraine.jason@kadant.com')
                        {
                            //Do nothing
                        }
                        else
                        {
                            op.Contact__c = c[0].Id;
                            op.Account__c = c[0].AccountId;
                        }
                    }
                    insert op;
                    createKSDEmail = new EmailMessage(
                         Subject                        = email.Subject
                        ,RelatedToId                    = op.Id
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
                    insert createKSDEmail;
                    users = new List<User>();
                    //users = [select Id, Email From User WHERE UserName = 'allison.gerrish@kadant.com' And IsActive = True];
                    users = [select Id, Email From User WHERE Profile.Name = 'KSD Customer Service' And IsActive = True];
                    if (users.size() > 0) {
                        for(User u : users)
                        {
                                EmailMessageRelation createEmailRelation = new EmailMessageRelation(
                                 EmailMessageId                 = createKSDEmail.Id
                                ,RelationAddress                = u.Email
                                ,RelationId                     = u.Id
                                ,RelationType                   = 'BccAddress'
                                );
                            insert createEmailRelation;
                        }
                    }
                }
                if(boolKJ == true)
                {
                    op = new Order_Processing__c(Division__c='KJ',Email_Address_of_Sender__c=email.fromAddress,Email_Subject__c=email.Subject,Sent_To__c=toEmails);
                    c = [select Id, AccountId from Contact WHERE Email = :email.fromAddress And Employment_Status__c = 'Active' And Account.RecordType.Name = 'US Account'];
                    if (c != null && c.size() == 1) {
                        //If the email is sent from a KJ user, don't include contact and account info
                        users = new List<User>();
                        users = [select Id From User WHERE Email = '" & :email.fromAddress.trim() & "' And Profile.Name Like 'KJ%'];
                        if (users.size() >= 1)
                        {
                            //Do nothing
                        }
                        else
                        {
                            op.Contact__c = c[0].Id;
                            op.Account__c = c[0].AccountId;
                        }
                    }
                    insert op;
                    createKJEmail = new EmailMessage(
                         Subject                        = email.Subject
                        ,RelatedToId                    = op.Id
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
                    insert createKJEmail;
                    users = new List<User>();
                    users = [select Id, Email From User WHERE UserRole.Name = 'KJ Marketing & Customer Service' And IsActive = True];
                    if (users.size() > 0) {
                        for(User u : users)
                        {
                                EmailMessageRelation createEmailRelation = new EmailMessageRelation(
                                 EmailMessageId                 = createKJEmail.Id
                                ,RelationAddress                = u.Email
                                ,RelationId                     = u.Id
                                ,RelationType                   = 'BccAddress'
                                );
                            insert createEmailRelation;
                        }
                    }
                }

                List<ContentVersion>cvList = new List<ContentVersion>();
                List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                List<Object_Activity_Log__c> oals = new List<Object_Activity_Log__c>();
                ContentVersion contentInsert = null;
                ContentDocumentLink cl = null;

                if(email.htmlBody != null && email.htmlBody.Length() > 0 && Blob.valueOf(email.htmlBody).Size() > 0)
                {
                    contentInsert = new ContentVersion();
                    contentInsert.Title = strEmailBodyName;
                    contentInsert.VersionData = Blob.valueOf(email.htmlBody);
                    contentInsert.PathOnClient = '/emailbody.html';
                    cvList.add(contentInsert);
                }
                else
                {
                    if(email.plainTextBody != null && email.plainTextBody.Length() > 0)
                    {
                        contentInsert = new ContentVersion();
                        contentInsert.Title = strEmailBodyName;
                        contentInsert.VersionData = Blob.valueOf('<html><body><p style="font-size:11px">' + email.plainTextBody.Replace('\r\n', '<br>').Replace('\n', '<br>') + '</p></body></html>');
                        contentInsert.PathOnClient = '/emailbody.html';
                        cvList.add(contentInsert);
                    }
                }
 
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

                    if (boolKSD == true || boolKJ == true)
                    {
                        List<ContentVersion>cvDivList = [select id, Title, PathOnClient, ContentDocumentId from ContentVersion WHERE Id in :cvList];
                        for (ContentVersion cv : cvDivList) {
                            if(cv.Title != strEmailBodyName)
                            {
                                cl = new ContentDocumentLink();
                                cl.ContentDocumentId = cv.ContentDocumentId;
                                if (boolKSD == true)
                                    cl.LinkedEntityId = createKSDEmail.Id;
                                if (boolKJ == true)
                                    cl.LinkedEntityId = createKJEmail.Id;
                                cl.ShareType = 'V';
                                cl.Visibility = 'AllUsers';
                                cdlList.add(cl);
                            }

                            cl = new ContentDocumentLink();
                            cl.ContentDocumentId = cv.ContentDocumentId;
                            cl.LinkedEntityId = op.Id;
                            cl.ShareType = 'V';
                            cl.Visibility = 'AllUsers';
                            cdlList.add(cl);
                        
                            if(cv.PathOnClient.EndsWithIgnoreCase('.htm') || cv.PathOnClient.EndsWithIgnoreCase('.html'))
                            {
                                Object_Activity_Log__c oal = new Object_Activity_Log__c(Name='RUN',
                                    Division__c = 'KAI',
                                    Object_Id__c = cv.Id,
                                    Operation__c = 'HTML2PDF',
                                    Processed__c = False,
                                    Date_Processed__c = Null,
                                    Key_Value__c = op.Id);
                                oals.add(oal);
                            }
                        }
                    }

                    if(!oals.isEmpty()){
                        insert oals;
                        oals.clear();
                    }

                    if(!cdlList.isEmpty())
                    {
                        insert cdlList;
                        cdlList.clear();
                    }
                }
            }
        }

        return result;

    }
}