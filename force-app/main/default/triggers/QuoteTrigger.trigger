trigger QuoteTrigger on Quote (before insert, before update, after insert, after update) {

    //Before trigger
    if(trigger.isBefore){
        //Insert or update
        if(trigger.isInsert || trigger.isUpdate){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }
    }

    //After trigger
    if(trigger.isAfter){
        /******************************************************/
        /* Call method to do after stuff                      */
        /******************************************************/
        if(trigger.isInsert){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }
        if(trigger.isUpdate){
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
        }
        
    }

    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<Quote> lstQuotesNew, map<Id,Quote> mapQuotesNew, Map<Id,Quote> mapQuotesOld){
    
        List<Opportunity> lstOpps = new List<Opportunity>();
        Map<Id, Id> mapOpps = new Map<Id, Id>();
        Opportunity opp;
        List<Division__c> div;
        decimal intHighestSequence;
        boolean boolUpdateOpp = false;
        boolean boolKJSpecialQuote = false;
        string strReportToOfficePicklistValue;
        
        for(Quote q : lstQuotesNew){

            if(q.Report_To_Company_Picklist__c == 'KJFR')
                strReportToOfficePicklistValue = 'KL';
            else
                strReportToOfficePicklistValue = q.Report_To_Company_Picklist__c;

            if(q.Sold_To_Account__c == null)
                q.Sold_To_Account__c = q.AccountId;
                
            if(q.OpportunityId != null)
            {
                opp = [SELECT Id, Account.ShippingCity, Account.Country_ID__c, Account.Incoterms__c, Account.Industry, Account.Default_Language__c, Account.Payment_Terms_Description__c, Account.Type, Pricebook2Id,
                    Opportunity_Type__c, RecordType.Name, OwnerId, Opportunity_Number__c, Account.AccountNumber, Highest_Quote_Sequence_No__c, Machine__c, Account.KSD_RISA__c, Account.KSD_DSM__c
                    FROM Opportunity
                    Where Id = :q.OpportunityId LIMIT 1];
                q.KSD_RISA__c = opp.Account.KSD_RISA__c;
                q.KSD_DSM__c = opp.Account.KSD_DSM__c;
                if (opp.Machine__c != null && q.Machine__c == null)
                    q.Machine__c = opp.Machine__c;
                if (q.Sales_Office_Picklist__c == 'KJ' && (opp.Opportunity_Type__c == 'Tech Support' || opp.Opportunity_Type__c == 'Training'  || opp.Opportunity_Type__c == 'Measurement' || opp.Opportunity_Type__c == 'Corrugating Capital'))
                    boolKJSpecialQuote = true;
                if (q.Sales_Office_Picklist__c == 'SMH' && q.Lead_Time__c == null)
                {
                    if (!String.IsEmpty(q.SMH_Product_Group__c))
                    {
                        List<Product_Leadtime__c> pl = [Select Leadtime__c, Leadtime_UOM__c From Product_Leadtime__c Where Name = :q.SMH_Product_Group__c LIMIT 1];
                        if(pl != null && pl.size() > 0)
                        {
                            q.Lead_Time__c = pl[0].Leadtime__c;
                            q.Lead_Time_UOM__c = pl[0].Leadtime_UOM__c;
                        }
                        else
                        {
                            q.Lead_Time__c = 3;
                            q.Lead_Time_UOM__c = 'weeks';
                        }
                    }
                    else
                    {
                        q.Lead_Time__c = 3;
                        q.Lead_Time_UOM__c = 'weeks';
                    }
                }
            }
            else
            {
                continue;
            }
            
            //Get the Label value of the Payment Terms picklist value
            if(q.Payment_Terms__c != null)
            {
                List<Schema.PicklistEntry> values = Quote.Payment_Terms__c.getDescribe().getPicklistValues();
                Map<String,String> statusApiToLabelMap = new Map<String,String>();
                For(Schema.PicklistEntry sp : values){
                    statusApiToLabelMap.put(sp.getValue(), sp.getLabel());
                }
                q.Payment_Terms_Label__c = statusApiToLabelMap.get(q.Payment_Terms__c);
            }
            else
                q.Payment_Terms_Label__c = ' ';
            
            
            if(q.Sales_Office_Picklist__c != null)
            {
                div = [SELECT Id, Name, Division_Picklist__c, Default_ShippingCity__c, Default_Incoterms__c, Standard_Quote_Validity__c, Sales_Office_Approver_Paper__c, Sales_Office_Approver_Industrial__c FROM Division__c where Division_Picklist__c = :q.Sales_Office_Picklist__c LIMIT 1]; 
            }
            else
            {
                div = null;
            }
            
            if(trigger.isInsert)
            {
                if(q.Quote_Number__c == null || q.Uploaded__c != true)
                {
                    if(q.Revision__c == 0 || q.Revision__c == null)
                    {
                        if(opp.Highest_Quote_Sequence_No__c == null)
                            intHighestSequence = 0;
                        else
                            intHighestSequence = opp.Highest_Quote_Sequence_No__c;
                        q.Sequence_no__c = intHighestSequence + 1;
                        if (q.Sales_Office_Picklist__c == 'SMH')
                            q.Quote_Number__c = 'SF'+ opp.Opportunity_Number__c.mid(2, 8) + '-' + string.valueOf(q.Sequence_no__c);
                        else
                            q.Quote_Number__c = 'QT'+ opp.Opportunity_Number__c.mid(2, 8) + '-' + string.valueOf(q.Sequence_no__c);
                        if(opp.Highest_Quote_Sequence_No__c == null)
                            opp.Highest_Quote_Sequence_No__c = 1;
                        else
                            opp.Highest_Quote_Sequence_No__c = opp.Highest_Quote_Sequence_No__c + 1;
                        boolUpdateOpp = true;
                    }
                    else
                    {
                        if (q.Sequence_No__c == null)
                            q.Quote_Number__c = opp.Opportunity_Number__c + '-R1';   
                        else 
                            if (q.Sales_Office_Picklist__c == 'SMH')
                                q.Quote_Number__c = 'SF'+ opp.Opportunity_Number__c.mid(2, 8) + '-' + string.valueOf(q.Sequence_No__c.intvalue()) + 'R' + string.valueOf(q.Revision__c.intvalue());
                            else
                                q.Quote_Number__c = 'QT'+ opp.Opportunity_Number__c.mid(2, 8) + '-' + string.valueOf(q.Sequence_No__c.intvalue()) + 'R' + string.valueOf(q.Revision__c.intvalue());
                    }
                }
                
                if(opp.Pricebook2Id == null)
                {
                    q.Pricebook2Id = q.User_Default_Pricebook_ID__c;
                    opp.Pricebook2Id = q.Pricebook2Id;
                    boolUpdateOpp = true;
                }
            }
        
            q.Quote_Owner__c = q.OwnerId;
            if(q.AccountId != null)
                q.Account__c = q.AccountId;

            if(q.Contact != Null && q.Email == Null)
            {
                q.Email = q.Contact_Email__c;
            }
            if(q.Contact != Null && q.Phone == Null)
            {
                q.Phone = q.Contact_Phone__c;
            }
            if(q.Contact != Null && q.Fax == Null)
            {
                q.Fax = q.Contact_Fax__c;
            }
            
            if(trigger.isInsert && q.Division__c == Null)
            {
                q.Division__c = q.Owner_Division__c;
            }

            if(q.ExpirationDate == Null)
            {
                if(q.Quote_Date__c == Null)
                    q.Quote_Date__c = system.today();
                if(q.Division__c == 'KJ' && q.ExpirationDate == null && (q.Quote_Date__c.year() + '-' + q.Quote_Date__c.month() + '-' + q.Quote_Date__c.day()) >= '2023-12-01' && (q.Quote_Date__c.year() + '-' + q.Quote_Date__c.month() + '-' + q.Quote_Date__c.day()) <= '2023-12-30')
                    q.ExpirationDate = date.valueOf('2023-12-30');
                else
                {
                    if(div != null && div.size() > 0)
                        q.ExpirationDate = q.Quote_Date__c + Integer.valueof(div[0].Standard_Quote_Validity__c);
                }
            }

            if(q.Sales_Office_Picklist__c != Null && ((trigger.isInsert && q.Sales_Office__c == Null) || (trigger.isUpdate && (q.Sales_Office_Picklist__c != mapQuotesOld.get(q.Id).Sales_Office_Picklist__c))))
            {
                if(div != null && div.size() > 0)
                    q.Sales_Office__c = div[0].Id;
            }
            if(q.Report_To_Company_Picklist__c != Null && ((trigger.isInsert && q.Mfg_Facility__c == Null) || (trigger.isUpdate && (q.Report_To_Company_Picklist__c != mapQuotesOld.get(q.Id).Report_To_Company_Picklist__c))))
            {
                q.Mfg_Facility__c = [Select Id From Division__c Where Division_Picklist__c = :q.Report_To_Company_Picklist__c LIMIT 1].Id;
            }
            
            if(q.Language__c == null || (trigger.isInsert && q.Language__c == 'Default')){
                if(q.Contact_Language__c != null && q.Contact_Language__c != 'Default'){
                    q.Language__c = q.Contact_Language__c;
                }else{
                    if(opp.Account.Default_Language__c != null && opp.Account.Default_Language__c != 'Default'){
                        q.Language__c = opp.Account.Default_Language__c;
                    }else{
                        q.Language__c = q.Quote_Author_Language__c;
                    }
                }
            }
            if(boolKJSpecialQuote == false && ((trigger.isInsert && q.Sales_Office__c != Null) || (trigger.isUpdate && (q.Sales_Office_Picklist__c != mapQuotesOld.get(q.Id).Sales_Office_Picklist__c))||(trigger.isUpdate && (q.Language__c != mapQuotesOld.get(q.Id).Language__c))))
            {
                Quote_Default_Message__c[] qdf = null;
                qdf = [Select Id, Footer_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Account_Type__c = Null and Opportunity_Type__c = Null LIMIT 1];
                if(qdf != null && qdf.size() > 0)
                    {
                        q.Footer_Message__c = qdf[0].Footer_Message__c;
                    }   
            }
            
            if(boolKJSpecialQuote == false && (q.Uploaded__c == False && q.Sales_Office__c != Null && (q.Pre_Message__c == Null || q.Pre_Message__c == '(leave blank for default)')))
            {
                if(opp.Account.Type != Null || opp.Opportunity_Type__c != Null)
                {
                    Quote_Default_Message__c[] qdf = null;
                    if(opp.Account.Type != Null && opp.Opportunity_Type__c != Null)
                    {
                        qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Account_Type__c = :opp.Account.Type and Opportunity_Type__c = :opp.Opportunity_Type__c LIMIT 1];
                    }
                    if((qdf == null || qdf.size() == 0) && opp.Account.Type != Null)
                    {
                        qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Account_Type__c = :opp.Account.Type and Opportunity_Type__c = Null LIMIT 1];
                    }
                    if((qdf == null || qdf.size() == 0) && opp.Opportunity_Type__c != Null)
                    {
                        qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Opportunity_Type__c = :opp.Opportunity_Type__c and Account_Type__c = Null LIMIT 1];
                    }
                    if(qdf != null && qdf.size() > 0)
                    {
                        q.Pre_Message__c = qdf[0].Pre_Message__c;
                    }else{
                        qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Default_Message__c = true LIMIT 1];
                        if(qdf.size() > 0)
                        {
                            q.Pre_Message__c = qdf[0].Pre_Message__c;
                        }else{
                            qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c LIMIT 1];
                            if(qdf.size() > 0)
                            {
                                q.Pre_Message__c = qdf[0].Pre_Message__c;
                            }else{
                                qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Default_Message__c = true LIMIT 1];
                                if(qdf.size() > 0)
                                {
                                    q.Pre_Message__c = qdf[0].Pre_Message__c;
                                }
                            }
                        }
                    }
                }else{
                    Quote_Default_Message__c[] qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c LIMIT 1];
                    if(qdf.size() > 0)
                    {
                        q.Pre_Message__c = qdf[0].Pre_Message__c;
                    }else{
                        qdf = [Select Id, Pre_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Default_Message__c = true LIMIT 1];
                        if(qdf.size() > 0)
                        {
                            q.Pre_Message__c = qdf[0].Pre_Message__c;
                        }
                    }
                }
            }

            if(boolKJSpecialQuote == false && (q.Uploaded__c == False && q.Sales_Office__c != Null && (q.End_Message__c == Null || q.End_Message__c == '(leave blank for default)')))
            {
                if(opp.Account.Type != Null || opp.Opportunity_Type__c != Null)
                {
                    Quote_Default_Message__c[] qdf = null;
                    if(opp.Account.Type != Null && opp.Opportunity_Type__c != Null)
                    {
                        qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Account_Type__c = :opp.Account.Type and Opportunity_Type__c = :opp.Opportunity_Type__c LIMIT 1];
                    }
                    if((qdf == null || qdf.size() == 0) && opp.Account.Type != Null)
                    {
                        qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Account_Type__c = :opp.Account.Type and Opportunity_Type__c = Null LIMIT 1];
                    }
                    if((qdf == null || qdf.size() == 0) && opp.Opportunity_Type__c != Null)
                    {
                        qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Opportunity_Type__c = :opp.Opportunity_Type__c and Account_Type__c = Null LIMIT 1];
                    }
                    if(qdf != null && qdf.size() > 0)
                    {
                        q.End_Message__c = qdf[0].End_Message__c;
                    }else{
                        qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c and Default_Message__c = true LIMIT 1];
                        if(qdf.size() > 0)
                        {
                            q.End_Message__c = qdf[0].End_Message__c;
                        }else{
                            qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c LIMIT 1];
                            if(qdf.size() > 0)
                            {
                                q.End_Message__c = qdf[0].End_Message__c;
                            }else{
                                qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Default_Message__c = true LIMIT 1];
                                if(qdf.size() > 0)
                                {
                                    q.End_Message__c = qdf[0].End_Message__c;
                                }
                            }
                        }
                    }
                }else{
                    Quote_Default_Message__c[] qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Language__c = :q.Language__c LIMIT 1];
                    if(qdf.size() > 0)
                    {
                        q.End_Message__c = qdf[0].End_Message__c;
                    }else{
                        qdf = [Select Id, End_Message__c From Quote_Default_Message__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c and Default_Message__c = true LIMIT 1];
                        if(qdf.size() > 0)
                        {
                            q.End_Message__c = qdf[0].End_Message__c;
                        }
                    }
                }
            }

            if(q.Sales_Office__c != Null && (trigger.isInsert || (trigger.isUpdate && (q.Sales_Office__c != mapQuotesOld.get(q.Id).Sales_Office__c))))
            {
                if(opp.RecordType.Name == 'KL Fiberline Capital')
                {
                    q.Sales_Office_Approver__c = opp.OwnerId;
                }else{
                    if(opp.Account.Industry == 'Paper')
                    {
                        if(div != null && div.size() > 0)
                            q.Sales_Office_Approver__c = div[0].Sales_Office_Approver_Paper__c;
                    }else{
                        if(div != null && div.size() > 0)
                            q.Sales_Office_Approver__c = div[0].Sales_Office_Approver_Industrial__c;
                    }
                }
            }
            if(q.Mfg_Facility__c != Null && (trigger.isInsert || (trigger.isUpdate && (q.Mfg_Facility__c != mapQuotesOld.get(q.Id).Mfg_Facility__c))))
            {
                if(opp.Account.Industry == 'Paper')
                {
                    q.Mfg_Office_Approver__c = [select Id, Mfg_Office_Approver_Paper__c from Division__c where Id = :q.Mfg_Facility__c LIMIT 1].Mfg_Office_Approver_Paper__c;
                }else{
                    q.Mfg_Office_Approver__c = [select Id, Mfg_Office_Approver_Industrial__c from Division__c where Id = :q.Mfg_Facility__c LIMIT 1].Mfg_Office_Approver_Industrial__c;
                }
            }

            if(boolKJSpecialQuote == false && trigger.isInsert && q.Pre_Message__c != Null)
            {
                q.Pre_Message__c = q.Pre_Message__c.replace('[Kadant User]', UserInfo.getName());
                if(userInfo.getUserName() == 'christoph.sima@kadant.com' || userInfo.getUserName() == 'michael.ampletzer@kadant.com' || userInfo.getUserName() == 'marc.victor@kadant.com' || userInfo.getUserName() == 'joerg.krischer@kadant.com')
                {
                    q.Pre_Message__c = q.Pre_Message__c.replace('i.A. ', 'i.V. ');
                }
            }
            if(boolKJSpecialQuote == false && trigger.isInsert && q.End_Message__c != Null)
            {
                q.End_Message__c = q.End_Message__c.replace('[Kadant User]', UserInfo.getName());
                if(userInfo.getUserName() == 'christoph.sima@kadant.com' || userInfo.getUserName() == 'michael.ampletzer@kadant.com' || userInfo.getUserName() == 'marc.victor@kadant.com' || userInfo.getUserName() == 'joerg.krischer@kadant.com')
                {
                    q.End_Message__c = q.End_Message__c.replace('i.A. ', 'i.V. ');
                }
            }
            if(q.ContactId != Null)
            {
                if(q.Pre_Message__c != Null)
                    if(q.Division__c == 'KJD')
                    {
                        q.Pre_Message__c = q.Pre_Message__c.replace('[contact]', q.Contact_Last_Name__c);
                    }else{
                        q.Pre_Message__c = q.Pre_Message__c.replace('[contact]', q.Contact_Name__c);
                    }
                if(q.End_Message__c != Null)
                    if(q.Division__c == 'KJD')
                    {
                        q.End_Message__c = q.End_Message__c.replace('[contact]', q.Contact_Last_Name__c);
                    }else{
                        q.End_Message__c = q.End_Message__c.replace('[contact]', q.Contact_Name__c);
                    }
                if(q.Contact_Salutation__c != Null)
                {
                    if(q.Pre_Message__c != Null)
                    {
                        q.Pre_Message__c = q.Pre_Message__c.replace('[salutation]', q.Contact_Salutation__c);
                        q.Pre_Message__c = q.Pre_Message__c.replace('Sehr geehrter Frau', 'Sehr geehrte Frau');
                        q.Pre_Message__c = q.Pre_Message__c.replace('Cher Mme', 'Chère Mme');
                    }
                    if(q.End_Message__c != Null)
                    {
                        q.End_Message__c = q.End_Message__c.replace('[salutation]', q.Contact_Salutation__c);
                        q.End_Message__c = q.End_Message__c.replace('Sehr geehrter Frau', 'Sehr geehrte Frau');
                        q.End_Message__c = q.End_Message__c.replace('Cher Mme', 'Chère Mme');
                    }
                }
            }

            if(q.Pre_Message__c == '(leave blank for default)')
                q.Pre_Message__c = Null;
            if(q.End_Message__c == '(leave blank for default)')
                q.End_Message__c = Null;

            //The following section is used only to populate certain Quote fields, using corresponding fields from the Account Division object.
            List<Account_Division__c> objADs = new List<Account_Division__c>();
            if(q.Report_To_Company_Picklist__c == Null)
            {
                User u = [Select Division From User Where id = :UserInfo.getUserId()];
                q.Report_To_Company_Picklist__c = u.Division;
            }
            if(q.Report_To_Company_Picklist__c != Null)
            { 
                objADs = [Select Id, Incoterms__c, Standard_Discount__c, Payment_Terms_Description__c, Account_Number__c, FOB__c From Account_Division__c Where Account__c = :q.Account_ID__c And Name = :strReportToOfficePicklistValue and Active__c=true Order By Primary__c DESC LIMIT 1];
            }
                
            //Populate FOB field
            if(!objADs.isEmpty() && (trigger.isInsert || q.FOB__c == Null))
            {
                q.FOB__c = objADs[0].FOB__c; 
            }

            //Populate incoterms field on Quote.
            if(q.Incoterms__c == Null || q.Incoterms__c == 'Default')
            {   
                if(objADs.isEmpty()) 
                {
                    if(div != null && div.size() > 0 && div[0].Default_Incoterms__c != Null)
                    {
                        q.Incoterms__c = div[0].Default_Incoterms__c; 
                    }
                    if(opp.Account.Incoterms__c != Null)
                    {
                        system.debug('do I get evaluated? Account');
                        q.Incoterms__c = opp.Account.Incoterms__c;
                    }
                }
                else if(!objADs.isEmpty())
                {
                    if(div != null && div.size() > 0 && div[0].Default_Incoterms__c != Null)
                    {
                        q.Incoterms__c = div[0].Default_Incoterms__c; 
                    }
                    if(objADs[0].Incoterms__c != Null)
                    {
                        q.Incoterms__c = objADs[0].Incoterms__c;  
                    }
                }
                else
                {
                    q.Incoterms__c = 'Default';
                }
            }
            if(q.Agreed_City__c == Null)
            {
                if(q.Incoterms__c == 'FCA' || q.Incoterms__c == 'EXW')
                {
                    if(div != null && div.size() > 0)
                        q.Agreed_City__c = div[0].Default_ShippingCity__c;
                    if(q.KJE_Only__c==true){q.Agreed_City__c = 'Weesp';}
                    if(q.KL_Only__c==true){q.Agreed_City__c = 'Vitry-le-François';}    
                    if(q.KN_Only__c==true){q.Agreed_City__c = 'Huskvarna';}
                    if(q.KUK_Only__c==true){q.Agreed_City__c = 'Bury';}
                    if(q.JF_Only__c==true){q.Agreed_City__c = 'Pero (MI)';}                 
                }
                else
                {
                    q.Agreed_City__c = opp.Account.ShippingCity;
                }
            }
            if(trigger.isUpdate && (q.Incoterms__c != mapQuotesOld.get(q.Id).Incoterms__c))
            {
              if(q.Incoterms__c == 'FCA' || q.Incoterms__c == 'EXW')
              {
                    if(div != null && div.size() > 0)
                        q.Agreed_City__c = div[0].Default_ShippingCity__c;
                    if(q.KJE_Only__c==true){q.Agreed_City__c = 'Weesp';}
                    if(q.KL_Only__c==true){q.Agreed_City__c = 'Vitry-le-François';}    
                    if(q.KN_Only__c==true){q.Agreed_City__c = 'Huskvarna';}
                    if(q.KUK_Only__c==true){q.Agreed_City__c = 'Bury';}
                    if(q.JF_Only__c==true){q.Agreed_City__c = 'Pero (MI)';}                 
                }
            }

            //Populate standard discount field on Quote.
            if(q.Report_To_Company_Picklist__c != Null && (q.Account_Standard_Discount__c == Null || q.Account_Standard_Discount__c == 0))
            {
                if(objADs.size() > 0 && objADs[0].Standard_Discount__c != Null)
                {
                    q.Account_Standard_Discount__c = objADs[0].Standard_Discount__c;
                }
            }
            //Populate payment terms description field on Quote.
            if(q.Payment_Terms_Description__c == Null || q.Payment_Terms_Description__c == 'Default')
            {
                if(q.Report_To_Company_Picklist__c != Null)
                {
                    if(objADs.size() > 0)
                    {
                        q.Payment_Terms_Description__c = objADs[0].Payment_Terms_Description__c;
                    }else{
                        if(opp.Account.Payment_Terms_Description__c != Null)
                            q.Payment_Terms_Description__c = opp.Account.Payment_Terms_Description__c;
                    }
                }else{
                    if(opp.Account.Payment_Terms_Description__c != Null)
                        q.Payment_Terms_Description__c = opp.Account.Payment_Terms_Description__c;
                }
            }
            //Populate account number field on Quote.
           if(q.Account_Number__c == Null || (trigger.isUpdate && (q.Report_To_Company_Picklist__c != mapQuotesOld.get(q.Id).Report_To_Company_Picklist__c || (q.Status != mapQuotesOld.get(q.Id).Status && (q.Status != 'Presented' && mapQuotesOld.get(q.Id).Status != 'Presented')))))
            {
                if(q.Report_To_Company_Picklist__c != Null)
                {
                    if(objADs.size() > 0)
                    {
                        q.Account_Number__c = objADs[0].Account_Number__c;
                    }else{
                        if(opp.Account.AccountNumber != Null)
                            q.Account_Number__c = opp.Account.AccountNumber;
                    }
                }else{
                    if(opp.Account.AccountNumber != Null)
                        q.Account_Number__c = opp.Account.AccountNumber;
                }
            }

            //Lock the Quote when status is changed to Presented
         if(q.Uploaded__c == False && ((trigger.isInsert && q.Status == 'Presented') || (trigger.isUpdate && q.Status == 'Presented' && mapQuotesOld.get(q.Id).Status != 'Presented')))
            {
                q.Locked__c = True;
            }

            //Unapprove quote when status is changed to Lost, Canceled or Revised Quote
            if(q.Approved__c == True && (q.Status == 'Lost' || q.Status == 'Canceled' || q.Status == 'Revised Quote'))
            {
                q.Approved__c = False;
            }
            
            //I.K 10/05/2022 Code Change for Daan on new field
            if(q.Status == 'Presented')
            {
                DateTime dt = date.today();
                  q.Quotes_Presented_Date__c = dt;         
                //System.debug('Todays Date: IK' + date.today().format());
            }    
            
             if(q.Status == 'Draft' || q.Status == 'Needs Review' || q.Status == 'In Review' || q.Status == 'Approved')
            {
          q.Quotes_Presented_Date__c = NULL;     
            }    

        }

        if(boolUpdateOpp == true && !mapOpps.containsKey(opp.Id))
        {
            mapOpps.put(opp.Id, opp.Id);
            lstOpps.add(opp);
        }

        if(!lstOpps.isEmpty())
            update lstOpps;
    }
    
    private static void doAfterStuff(list<Quote> lstQuotesNew, map<Id,Quote> mapQuotesNew, Map<Id,Quote> mapQuotesOld, String strTriggerType) {
    
        List<QuoteLineItem> lstQLIforUpdate = new List<QuoteLineItem>();//List of QuoteLineItems
        List<QuoteLineItem> lstQLIforInsert = new List<QuoteLineItem>();//List of QuoteLineItems
        List<Mfg_Cost_Price__c> lstMCP = new List<Mfg_Cost_Price__c>();//List of Mfg. Cost Prices
        List<Opportunity> lstOpps1 = new List<Opportunity>();//List of Opportunities
        List<Opportunity> lstOpps2 = new List<Opportunity>();//List of Opportunities
        List<Task> lstTask = new List<Task>();//List of Tasks
        Map<Id, Id> quoteMap = new Map<Id, Id>();
        Map<Id, Id> mapOpps1 = new Map<Id, Id>();
        Map<Id, Id> mapOpps2 = new Map<Id, Id>();
        integer intSyncedQuotes = 0;

        for(Quote q : lstQuotesNew){

            // Synchronize the Sales Office Picklist with the Opportunity.
            if(trigger.isInsert || (trigger.isUpdate && q.Sales_Office_Picklist__c != mapQuotesOld.get(q.Id).Sales_Office_Picklist__c))
            {
                for(Opportunity objOpp : [SELECT Id, Sales_Office__c FROM Opportunity Where Id = :q.OpportunityId])
                {
                    if(objOpp.Sales_Office__c != q.Sales_Office_Picklist__c)
                    {
                        objOpp.Sales_Office__c = q.Sales_Office_Picklist__c;
                        if(mapOpps1.containsKey(objOpp.Id)==false)
                        {
                            mapOpps1.put(objOpp.Id, objOpp.Id);
                            lstOpps1.add(objOpp);
                        }
                    }
                }
            }

            // Synchronize the first quote entered.
            if(trigger.isInsert && q.Uploaded__c != True)
            {
                for(Opportunity objOpp : [SELECT Id, SyncedQuoteId FROM Opportunity Where Id = :q.OpportunityId And Detail_Count__C = 0])
                {
                    if(objOpp.SyncedQuoteId == null)
                    {
                        quoteMap.put(q.Id, objOpp.Id);
                        intSyncedQuotes += 1;
                    }
                }
            }

            // For divisions that want this, close the Opportunity when Quote is Won.
            if(trigger.isUpdate && q.Division_Auto_Close_Won_Opp__c == true && q.Status != mapQuotesOld.get(q.Id).Status && q.Status == 'Won')
            {
                for(Opportunity objOpp : [SELECT Id, StageName, Reason__c, Competitor__c, No_of_Quotes__c FROM Opportunity Where Id = :q.OpportunityId])
                {
                    if(q.Status == 'Won')
                    {
                        if(q.Sales_Office_Picklist__c == 'KJ' && q.Opportunity_Record_Type__c == 'KJ Opportunity')
                            objOpp.StageName = 'Closed-Won - 100%';
                        else if(q.Sales_Office_Picklist__c == 'SMH' && q.Opportunity_Record_Type__c.StartsWith('SMH'))
                        {
                            objOpp.StageName = 'Result - Won';
                            Approval.LockResult qLock = Approval.Lock(q.Id, false);
                            if (qLock.isSuccess())
                            {
                                System.debug('Successfully locked Quote with ID: ' + qLock.getId());
                            }
                            else {
                                //Operation failed, so get all errors                
                                for(Database.Error err : qLock .getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Quote fields that affected this error: ' + err.getFields());
                                }
                            }
                            Approval.LockResult oLock = Approval.Lock(objOpp.Id, false);
                            if (oLock.isSuccess())
                            {
                                System.debug('Successfully locked Opportunity with ID: ' + oLock.getId());
                            }
                            else {
                                //Operation failed, so get all errors                
                                for(Database.Error err : oLock .getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Opportunity fields that affected this error: ' + err.getFields());
                                }
                            }
                        }
                        else
                            objOpp.StageName = 'Closed-Won - 100%';
                        for(Task objTask : [SELECT Id, Status FROM Task Where WhatId = :q.OpportunityId And Subject = 'Opportunity Follow-up' And Status != 'Completed'])
                        {
                            objTask.Status = 'Completed';
                            lstTask.add(objTask);
                        }
                    }
                    if(mapOpps2.containsKey(objOpp.Id)==false)
                    {
                        mapOpps2.put(objOpp.Id, objOpp.Id);
                        lstOpps2.add(objOpp);
                    }
                }

                // Mark the "Send Quote to Customer" task as complete when Quote closes (Won/Lost/Canceled) or is marked as "Presented".
                for(Task objTask : [SELECT Id, Status FROM Task Where WhatId = :q.Id And Subject = 'Send Quote to Customer' And Status != 'Completed'])
                {
                    objTask.Status = 'Completed';
                    lstTask.add(objTask);
                }                      

            }

            // For divisions that want this, close the Opportunity when Quote closes Lost or Canceled.
            if(trigger.isUpdate && q.Status != mapQuotesOld.get(q.Id).Status && (q.Status == 'Lost' || q.Status == 'Canceled' || q.Status == 'Presented'))
            {
                for(Opportunity objOpp : [SELECT Id, StageName, Reason__c, Competitor__c, No_of_Quotes__c FROM Opportunity Where Id = :q.OpportunityId])
                {
                    if(q.Division_Auto_Close_Opportunity__c==true && q.Status == 'Lost' && q.IsSyncing == true)
                    {
                        if(q.Sales_Office_Picklist__c == 'KJ' && q.Opportunity_Record_Type__c == 'KJ Opportunity')
                            objOpp.StageName = 'Closed-Lost - 0%';
                        else if(q.Sales_Office_Picklist__c == 'SMH' && q.Opportunity_Record_Type__c.StartsWith('SMH'))
                            objOpp.StageName = 'Result - Lost';
                        else
                            objOpp.StageName = 'Closed-Lost - 0%';
                        objOpp.Reason__c = q.Reason__c;
                        objOpp.Competitor__c = q.Competitor__c;
                    }
                    if(q.Division__c != 'KJ' && q.Status == 'Canceled' && q.IsSyncing == true)
                    {
                        if(q.Sales_Office_Picklist__c == 'KJ' && q.Opportunity_Record_Type__c == 'KJ Opportunity')
                            objOpp.StageName = 'Closed-Canceled - 0%';
                        else if(q.Sales_Office_Picklist__c == 'SMH' && q.Opportunity_Record_Type__c.StartsWith('SMH'))
                            objOpp.StageName = 'Result - Lost';
                        else
                            objOpp.StageName = 'Inactive';
                        objOpp.Reason__c = q.Reason__c;
                        objOpp.Competitor__c = q.Competitor__c;
                    }
                    if(q.Status == 'Presented' && q.Sales_Office_Picklist__c == 'KJ' && q.Opportunity_Record_Type__c == 'KJ Opportunity')
                    {
                        objOpp.StageName = '25% - Quote Issued';
                    }
                    if(q.Status == 'Presented' && objOpp.No_of_Quotes__c == 1 && q.Uploaded__c == false && (q.PSG_E_or_KL_Quote__c == true || q.Sales_Office_Picklist__c == 'KCD' || q.Sales_Office_Picklist__c == 'KSA'))
                    {
                        objOpp.StageName = '25%';              
                    }
                    if(mapOpps2.containsKey(objOpp.Id)==false)
                    {
                        mapOpps2.put(objOpp.Id, objOpp.Id);
                        lstOpps2.add(objOpp);
                    }
                }

                // Mark the "Send Quote to Customer" task as complete when Quote closes (Won/Lost/Canceled) or is marked as "Presented".
                for(Task objTask : [SELECT Id, Status FROM Task Where WhatId = :q.Id And Subject = 'Send Quote to Customer' And Status != 'Completed'])
                {
                    objTask.Status = 'Completed';
                    lstTask.add(objTask);
                }                      

            }

            if(trigger.isInsert || string.isblank(q.Management_Info__c))
            {
                Mfg_Cost_Price__c objMCP = new Mfg_Cost_Price__c(RecordTypeId = Schema.SObjectType.Mfg_Cost_Price__c.getRecordTypeInfosByName().get('Quotes').getRecordTypeId(), Quote__c = q.id, OwnerId = q.OwnerId);
                lstMCP.Add(objMCP);
            }

            //If a Quote is moved beyond the "Draft" stage and the Account record does not yet exist in the ERP, send a request to the integration to create the customer record in the appropriate ERP.
            if(trigger.isUpdate && q.Uploaded__c == False && q.Division_Auto_Create_ERP_Account__c== true &&
                q.Status != mapQuotesOld.get(q.Id).Status && mapQuotesOld.get(q.Id).Status == 'Draft' && (q.Status == 'Needs Review' || q.Status == 'In Review' || q.Status == 'Approved' || q.Status == 'Presented' || q.Status == 'Won')) {

                List<Division__c> div;
                if(q.Sales_Office_Picklist__c == 'KJPO')
                    div = [Select Id, Parent_Division__c FROM Division__c Where Division_Picklist__c = :q.Report_To_Company_Picklist__c LIMIT 1];
                else
                    div = [Select Id, Parent_Division__c FROM Division__c Where Division_Picklist__c = :q.Sales_Office_Picklist__c LIMIT 1];
                if(div.size() > 0)
                {
                    List<Account_Division__c> ad = [Select Id FROM Account_Division__c Where Account__c = :q.Account__c And Name = :div[0].Parent_Division__c And Active__c = true LIMIT 1];
                    if(ad.size() == 0)
                    {
                        if(q.Sales_Office_Picklist__c == 'KJPO')
                            KadantHelperClasses.WriteObjectActivityLog('Account', q.Report_To_Company_Picklist__c, q.Account_ID__c, 'Insert', q.Id);
                        else
                            KadantHelperClasses.WriteObjectActivityLog('Account', q.Sales_Office_Picklist__c, q.Account_ID__c, 'Insert', q.Id);
                    }
                }
            }

            if(trigger.isUpdate && !(q.Sales_Office_Picklist__c == 'KJ' && (q.Opportunity_Type__c == 'Tech Support' || q.Opportunity_Type__c == 'Training'  || q.Opportunity_Type__c == 'Measurement' || q.Opportunity_Type__c == 'Corrugating Capital')) && (q.Language__c != mapQuotesOld.get(q.Id).Language__c || q.Division__c != mapQuotesOld.get(q.Id).Division__c))
            {
                List<QuoteLineItem> QuoteLinesToUpdate = [Select Id, Description, Specifications__c, Quote_Division__c FROM QuoteLineItem where QuoteId = :q.Id];
                for(QuoteLineItem objQLI : QuoteLinesToUpdate)
                {
                    objQLI.Description = Null;
                    objQLI.Specifications__c = Null;
                    objQLI.Quote_Division__c = q.Division__c;
                    lstQLIforUpdate.Add(objQLI);
                }
            }

            if(trigger.isInsert && q.Order_Created_From__c != Null)
            {
                List<OrderItem> QuoteLinesToInsert = [Select Id, Quantity, UnitPrice, Description, Product2Id, PriceBookEntryId, Customer_Item_Number__c, ICP_Price__c, Line_No__c, Our_Item_Number__c, Specifications__c FROM OrderItem where OrderId = :q.Order_Created_From__c And PriceBookEntry.IsActive = True Order By Line_No__c];
                for(OrderItem objOI : QuoteLinesToInsert)
                {
                    QuoteLineItem objQLI = new QuoteLineItem(QuoteId=q.Id, ServiceDate=q.Quote_Date__c, Description=objOI.Description, Product2Id=objOI.Product2Id,
                        Quantity=objOI.Quantity, UnitPrice=objOI.UnitPrice, Customer_Item_Number__c=objOI.Customer_Item_Number__c, ICP_Price__c=objOI.ICP_Price__c,
                        Line_No__c=objOI.Line_No__c, Our_Item_Number__c=objOI.Our_Item_Number__c, Specifications__c=objOI.Specifications__c, PriceBookEntryId=objOI.PriceBookEntryId);
                    lstQLIforInsert.Add(objQLI);
                }
            }

            if(trigger.isInsert && q.Quote_Created_From__c != Null)
            {
                //Changed this part of the trigger to clone the quote lines via a batch process.  This is needed as quotes that have a lot of lines will hit a limit of over 100 SOQL queries.
                CloneQuoteLineItemsBatch cqli = new CloneQuoteLineItemsBatch(q.Quote_Created_From__c, q.Id);
                Database.executebatch(cqli, 1);
            }

            //Send to the integration to have an Order created when the Quote is "Won"
            if(trigger.isUpdate && q.Convert_to_Order_when_Won__c == true && q.Division_Create_Order_when_Won__c == true && q.Purchase_Order_No__c != null && q.Status != mapQuotesOld.get(q.Id).Status && q.Status == 'Won')
            {
                if(q.Sales_Office_Picklist__c=='KJPO')
                    KadantHelperClasses.WriteObjectActivityLog('Quote', q.Report_To_Company_Picklist__c, q.Id, strTriggerType, q.Name);
                else
                    KadantHelperClasses.WriteObjectActivityLog('Quote', q.Sales_Office_Picklist__c, q.Id, strTriggerType, q.Name);
            }

            //For KSA quotes, send to the integration to have the tax recalculated for all lines
            if(trigger.isUpdate && q.Division__c == 'KSA' && q.Approved__c == true && mapQuotesOld.get(q.Id).Approved__c != true)
            {
                KadantHelperClasses.WriteObjectActivityLog('QuoteTax', q.Division__c, q.Id, 'Update', q.LastModifiedById);
            }

            //For KSA, send to the integration when Quotes are marked as "Lost" or "Canceled"
            if(trigger.isUpdate && q.Sales_Office_Picklist__c=='KSA' && q.Status != mapQuotesOld.get(q.Id).Status && (q.Status == 'Lost' || q.Status == 'Canceled'))
            {
                KadantHelperClasses.WriteObjectActivityLog('Quote', q.Sales_Office_Picklist__c, q.Id, strTriggerType, q.Name);
            }

        }

        if(!lstQLIforUpdate.isEmpty())
            update lstQLIforUpdate;
        if(!lstQLIforInsert.isEmpty())
            insert lstQLIforInsert;
        if(!lstMCP.isEmpty())
            insert lstMCP;
        if(!lstOpps1.isEmpty())
            update lstOpps1;
        if(!lstOpps2.isEmpty())
            update lstOpps2;
        if(!lstTask.isEmpty())
            update lstTask;
        if(intSyncedQuotes > 0)            
            QuoteAutoSyncUtil.syncQuote(quoteMap);

    }
    
}