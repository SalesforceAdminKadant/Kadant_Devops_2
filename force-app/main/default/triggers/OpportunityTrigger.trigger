trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, before delete) {

    //Before trigger
    if(trigger.isBefore){
        //Insert
        if(trigger.isInsert){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }

        //Delete
        if(trigger.isDelete){
            doDeletionStuff(trigger.old);
        }
        
        if(trigger.isUpdate){
            initializeBeforeValues(trigger.new, trigger.newMap, trigger.oldMap);
        }
    }

    //After trigger
    if(trigger.isAfter){
        if(trigger.isInsert){
            updateOpportunityStage(trigger.new); //Update opportunity stage
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Insert');
        }
        if(trigger.isUpdate){
            buildOpportunityStageList(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
            doAfterStuff(trigger.new, trigger.newMap, trigger.oldMap, 'Update');
        }
    }


    //Helper methods follow

    //Following method is to initialize "before" values
    private static void initializeBeforeValues(list<Opportunity> lstOpportunitiesNew, map<Id,Opportunity> mapOpportunitiesNew, Map<Id,Opportunity> mapOpportunitiesOld){
    
        List<Account_Division__c> objADs = new List<Account_Division__c>();

        for(Opportunity opp : lstOpportunitiesNew){
            
            string strRecordTypeName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.RecordTypeId).getName();
            
            if (trigger.isInsert && opp.IsClone() == True)
                opp.Opportunity_Cloned_From__c = opp.GetCloneSourceID();
            
            if (!string.isblank(opp.KWS_Quote_Number__c))
            {
                List<Quote_Request__c> qrs= [SELECT Id, Name, Quote_No__c, Opportunity__c, CI_TCO_New_Business_White_Space__c
                    FROM Quote_Request__c WHERE Name = :opp.KWS_Quote_Number__c And Quote_No__c = null];
                if(!qrs.isEmpty())
                {
                    List<Quote_Request__c> qrUpdateList = new List<Quote_Request__c>();
                    for(Quote_Request__c qr: qrs)
                    {
                        qr.Quote_No__c = opp.Quote_Number__c;
                        qr.Opportunity__c = opp.Id;
                        qrUpdateList.add(qr);
                        opp.CI_TCO_New_Business_White_Space__c = qr.CI_TCO_New_Business_White_Space__c;
                    }

                    if(qrUpdateList.size() > 0)
                    {
                        update qrUpdateList;
                    }
                }
            }

            //Get default Pricebook, if needed
            if((trigger.isInsert || (trigger.isUpdate && opp.No_of_Quotes__c == 0)) && opp.Pricebook2Id == Null) {
                opp.Pricebook2Id = opp.User_Default_Pricebook_ID__c;
            }

            //Make sure that Management Info is cleared when creating a new Opportunity.  That is because, if a user clones an Opportunity, it will attempt to bring in the same value from the Cloned record,
            //causing an error.
            if(trigger.isInsert && opp.Management_Info__c != null) {
                opp.Management_Info__c = null;
            }
            
            //Populate the Account Division field
            if(!trigger.isDelete && opp.Division__c != null && (trigger.isInsert || (trigger.isUpdate && (opp.Account_Division__c == null || mapOpportunitiesOld.get(opp.Id).AccountId != opp.AccountId || mapOpportunitiesOld.get(opp.Id).Division__c == null || mapOpportunitiesOld.get(opp.Id).Division__c != opp.Division__c)))) {
                objADs = [Select Id, Agent__c From Account_Division__c Where Account__c = :opp.AccountId And Name = :opp.Division__c and Active__c=true Order By Primary_for_Division__c DESC, Primary__c DESC, Credit_Hold__c DESC, CreatedDate DESC LIMIT 1];
                if(objADs.size() > 0)
                {
                    opp.Account_Division__c = objADs[0].Id;
                    
                    //Auto-populate the Opportunity Agent field with the value from the corresponding field in the Account Division record.
                    if (objADs[0].Agent__c != null)
                    {
                        opp.Agent__c =objADs[0].Agent__c;
                    }
                }
                else
                {
                    objADs = [Select Id, Agent__c From Account_Division__c Where Account__c = :opp.AccountId And Name = :opp.Division__c Order By Primary_for_Division__c DESC, Primary__c DESC, Credit_Hold__c DESC, CreatedDate DESC LIMIT 1];
                    if(objADs.size() > 0)
                    {
                        opp.Account_Division__c = objADs[0].Id;
                    
                        //Auto-populate the Opportunity Agent field with the value from the corresponding field in the Account Division record.
                        if (objADs[0].Agent__c != null)
                        {
                            opp.Agent__c =objADs[0].Agent__c;
                        }
                    }
                }
            }

            //Auto-populate the Account Custom Terms Id field with the value from either the parent or the account specific terms field in the Account record.
            if(!trigger.isDelete && opp.Account_Custom_Terms_Id__c == null || (trigger.isUpdate && (mapOpportunitiesOld.get(opp.Id).AccountId != opp.AccountId))) {
                Account[] acc = [Select Id, Parent_Custom_Terms_Id__c, Custom_Terms_Id__c From Account Where id = :opp.AccountId And (Parent_Custom_Terms_Id__c != null OR Custom_Terms_Id__c != null) Limit 1];
                if(acc.size() > 0)
                {
                    if(acc[0].Parent_Custom_Terms_Id__c != null){
                    opp.Account_Custom_Terms_Id__c = acc[0].Parent_Custom_Terms_Id__c;
                    }
                    if(acc[0].Custom_Terms_Id__c != null){
                    opp.Account_Custom_Terms_Id__c = acc[0].Custom_Terms_Id__c;
                    }
                    
                }
                else{
                    opp.Account_Custom_Terms_Id__c = null; 
                    }
            }

            //For KJ Opportunities, change the Owner to the KJ RSM.
            if(trigger.isInsert && opp.RecordTypeId == '0120z000000M5RIAA0') {
                Account[] acc = [Select Id, KJ_RSM__c From Account Where Id = :opp.AccountId And KJ_RSM__c != null Limit 1];
                if(acc.size() > 0)
                {
                    opp.OwnerId = acc[0].KJ_RSM__c;
                }
            }
            
            if(trigger.isInsert && opp.Description_hidden__c != null && opp.Description == null) {
                opp.Description = opp.Description_hidden__c;
            }

            //Initialize Sales Office field, if needed
            if(!trigger.isDelete && opp.Sales_Office__c == Null && opp.Division__c != null) {
                opp.Sales_Office__c = opp.Division__c;
            }

            //Initialize the "Order_Active_Quote_Inactive_Quote__c" field
            if(opp.Order_Active_Quote_Inactive_Quote__c!=null){
                if(opp.Order_Active_Quote_Inactive_Quote__c=='Order')
                    opp.Order_Lookup__c=opp.AccountId;
                else
                    opp.Order_Lookup__c=null;   
                if(opp.Order_Active_Quote_Inactive_Quote__c=='Active')
                    opp.Active_Quote_Lookup__c=opp.AccountId;
                else
                    opp.Active_Quote_Lookup__c=null;   
                if(opp.Order_Active_Quote_Inactive_Quote__c=='Inactive')
                    opp.Inactive_Quote_Lookup__c=opp.AccountId;
                else
                    opp.Inactive_Quote_Lookup__c=null;   
                if(opp.Order_Active_Quote_Inactive_Quote__c=='Unmanaged')
                    opp.Unmanaged_Quote_Lookup__c=opp.AccountId;
                else
                    opp.Unmanaged_Quote_Lookup__c=null;   
            }

            //Initialize the "Close Date" field - KJ, KCC and KSD only
            if(trigger.isInsert && opp.CloseDate != null && opp.CloseDate <= date.today() &&
                (strRecordTypeName == 'KCC, KJI & KSD Quotes' || strRecordTypeName.startsWith('KSD')) &&
                (opp.Order_Active_Quote_Inactive_Quote__c=='Active' || opp.Order_Active_Quote_Inactive_Quote__c=='Unmanaged')){
                if(opp.Expiration_Date__c != null)
                    opp.CloseDate = opp.Expiration_Date__c;
                else
                {
                    if(strRecordTypeName.startsWith('KSD'))
                        opp.CloseDate = date.today() + 30;
                    else
                    {
                        if(opp.Amount >= 10000)
                            opp.CloseDate = date.today() + 180;
                        else
                            opp.CloseDate = date.today() + 30;
                    }
                }
            }

            //Initialize the "Kadant_Receives_Probability_Picklist__c" field.  Don't initialize for KSD or SMH Opportunities
            if(trigger.isInsert && opp.Division__c != 'KSD' && opp.Division__c != 'SMH'){
                opp.Kadant_Receives_Probability_Picklist__c = String.valueOf(opp.Probability).replace('.00', '').replace('.0', '') + '%';
            }
            //Initialize the "Kadant_Receives_Probability_Picklist__c" field
            if(trigger.isUpdate && (mapOpportunitiesOld.get(opp.Id).StageName != opp.StageName)){
                if(opp.StageName == 'Closed-Lost - 0%')
                    opp.Kadant_Receives_Probability_Picklist__c = '0%';
                if(opp.StageName == 'Closed-Canceled - 0%')
                    opp.Kadant_Receives_Probability_Picklist__c = '0%';
                if(opp.StageName == 'Inactive')
                    opp.Kadant_Receives_Probability_Picklist__c = '0%';
                if(opp.StageName == 'Closed-Won - 100%')
                    opp.Kadant_Receives_Probability_Picklist__c = '100%';
            }
                           
            //Initialize "Close Date - Year" and "Close Date - Quarter" fields
            if(trigger.isInsert || (trigger.isUpdate && (opp.Close_Date_Year__c == null || (mapOpportunitiesOld.get(opp.Id).CloseDate != mapOpportunitiesOld.get(opp.Id).CloseDate))))
            {
                Period[] curt = [Select p.Number, p.FullyQualifiedLabel From Period p where type = 'Quarter' and p.StartDate <= :opp.CloseDate and p.EndDate >= :opp.CloseDate limit 1];
                if(curt.size() > 0)
                {
                    opp.Close_Date_Year__c = curt[0].FullyQualifiedLabel.right(4);
                    opp.Close_Date_Quarter__c = 'Q' + curt[0].Number.format();
                }
                else
                {
                    opp.Close_Date_Year__c = opp.CloseDate.year().format();
                    if(opp.CloseDate.month() >= 1 && opp.CloseDate.month() <= 3)
                        opp.Close_Date_Quarter__c = 'Q1';
                    if(opp.CloseDate.month() >= 4 && opp.CloseDate.month() <= 6)
                        opp.Close_Date_Quarter__c = 'Q2';
                    if(opp.CloseDate.month() >= 7 && opp.CloseDate.month() <= 9)
                        opp.Close_Date_Quarter__c = 'Q3';
                    if(opp.CloseDate.month() >= 10 && opp.CloseDate.month() <= 12)
                        opp.Close_Date_Quarter__c = 'Q4';
                }
                
            }
        }        
    }

    /*
        * MethodName  : buildOpportunityStageList
        * param       : old,new list of Opportunity.
        * Description : This method is called after update of Opportunity.
    */
    private static void buildOpportunityStageList(List<Opportunity> lstOpportunitiesNew, Map<Id,Opportunity> mapOpportunitiesNew, Map<Id,Opportunity> mapOpportunitiesOld, String strOperation)
    {
        //Following section is to update quote opportunities, which are associated with an order opportunity, to Closed/Won
        List<Opportunity> lstFilteredOpportunity1 = new List<Opportunity>();//List of Opportunities

        //Iterate over the Ids in the keySet of mapOpportunitiesOld.
        for(Opportunity objOpportunity : lstOpportunitiesNew)
        {
            if(objOpportunity.Order_Active_Quote_Inactive_Quote__c=='Order'){
                if(mapOpportunitiesOld.get(objOpportunity.Id).KWS_Quote_Number__c != objOpportunity.KWS_Quote_Number__c)//Check if Quote Number is updated.
                    lstFilteredOpportunity1.add(objOpportunity);
            }
        }
        if(!lstFilteredOpportunity1.isEmpty()){
            updateOpportunityStage(lstFilteredOpportunity1);
        }

    } 
    /* End */

    /*
        * MethodName  : updateOpportunityStage
        * param       : list of Opportunity.
        * Description : This method is called on after insert and after update of Opportunity.
    */
    private static void updateOpportunityStage(List<Opportunity> lstOpportunity)
    {
        final string strClosedWonStage = 'Closed-Won - 100%';

        List<Opportunity> lstOpportunityToUpdate = new List<Opportunity>();//List of Opportunity.
        Map <String, Id> mapQuoteNoToOppId = new Map <String, Id>();
        Map<Id, Id> mapOpps = new Map<Id, Id>();
                
        for(Opportunity objOpportunity : lstOpportunity)
        {
            if(objOpportunity.Order_Active_Quote_Inactive_Quote__c=='Order' && objOpportunity.KWS_Quote_Number__c != null)
                mapQuoteNoToOppId.put(objOpportunity.KWS_Quote_Number__c, objOpportunity.Id);
        }
        
        if(!mapQuoteNoToOppId.isEmpty())
        {
        
            for(Opportunity objQuote : [SELECT Id,
                                                 StageName,
                                                 Quote_Number__c,
                                                 Kadant_Receives_Probability_Picklist__c
                                                 FROM Opportunity
                                                 WHERE Quote_Number__c IN :mapQuoteNoToOppId.KeySet() 
                                                 AND Id NOT IN :mapQuoteNoToOppId.values()
                                                 ORDER BY Quote_Number__c])
            {
                if(objQuote.StageName != strClosedWonStage){
                    objQuote.StageName = strClosedWonStage;//Change the stage of opportunity to closed-won.
                    objQuote.Kadant_Receives_Probability_Picklist__c = '100%';
                    lstOpportunityToUpdate.add(objQuote);
                }
                for(Opportunity objOpp : [SELECT Id FROM Opportunity
                                                      WHERE KWS_Quote_Number__c = :objQuote.Quote_Number__c
                                                      AND Order_Active_Quote_Inactive_Quote__c = 'Order'])
                {
                    objOpp.Quote_Id__c = objQuote.Id;
                    if(mapOpps.containsKey(objOpp.Id)==false)
                    {
                        mapOpps.put(objOpp.Id, objOpp.Id);
                        lstOpportunityToUpdate.add(objOpp);
                    }
                }
            }
        
            //Update list of opportunity.
            if(!lstOpportunityToUpdate.isEmpty())
                update lstOpportunityToUpdate;
        }
    }
    /* End */

    /*
        * MethodName  : doDeletionStuff
        * param       : list of Opportunity.
        * Description : This method is called on before Delete of Opportunity.
    */
    private static void doDeletionStuff(List<Opportunity> lstOpportunity)
    {

        List<Mfg_Cost_Price__c> lstMCPsToDelete = new List<Mfg_Cost_Price__c>();

        for(Opportunity opp: lstOpportunity){

            for(Mfg_Cost_Price__c objMCP : [SELECT Id
                FROM Mfg_Cost_Price__c 
                WHERE Opportunity__c = :opp.Id])
            {
                 lstMCPsToDelete.add(objMCP);
            }

        }

        if(!lstMCPsToDelete.isEmpty())
            delete lstMCPsToDelete;
        
    }
    /* End */

    //Following method is to do "after" stuff
    private static void doAfterStuff(list<Opportunity> lstOpportunitiesNew, map<Id,Opportunity> mapOpportunitiesNew, map<Id,Opportunity> mapOpportunitiesOld, String strOperation){

        List<Mfg_Cost_Price__c> lstMCP = new List<Mfg_Cost_Price__c>();
        List<OpportunityLineItem> lstOppLine = new List<OpportunityLineItem>();
        List<Task> lstTaskIns = new List<Task>();
        List<Task> lstTaskUpd = new List<Task>();
        OpportunityLineItem objOLI;
        List<Quote> lstQuote = new List<Quote>();

        for(Opportunity objOpp : lstOpportunitiesNew)
        {
            if(trigger.isInsert || string.isblank(objOpp.Management_Info__c))
            {
                Mfg_Cost_Price__c objMCP = new Mfg_Cost_Price__c(RecordTypeId = Schema.SObjectType.Mfg_Cost_Price__c.getRecordTypeInfosByName().get('Opportunities').getRecordTypeId(), Opportunity__c = objOpp.id, OwnerId = objOpp.OwnerId);
                lstMCP.Add(objMCP);
            }
                
            if(trigger.isInsert)
            {
                //Create task for owner to follow-up on auto-generated opportunities 
                if(objOpp.Autogenerated__c == true && !String.valueof(objOpp.OwnerId).startsWith('005600000056iHr')) //Don't create task is owner is Salesforce Admin
                {
                    Task futask = new Task(
                        OwnerId = objOpp.OwnerId,
                        WhatId = objOpp.Id,
                        Status = 'Not Started',
                        Priority = 'Normal',
                        Subject = 'Opportunity Followup',
                        ActivityDate = date.today().addDays(7), 
                        Description = 'An opportunity was autogenerated by the system. Please see opportunity for details');
                    lstTaskIns.add(futask);
                }  
                    
            }
            else if(trigger.isUpdate)
            {
                if(mapOpportunitiesOld.get(objOpp.Id).AccountId != objOpp.AccountId)
                {
                    for(Quote objQuote : [SELECT Id, Account__c
                        FROM Quote 
                        WHERE OpportunityId = :objOpp.Id and Account__c != :objOpp.AccountId])
                    {
                        objQuote.Account__c = objOpp.AccountId;
                        lstQuote.add(objQuote);
                    }
                }
            }

            // Mark task(s) as completed when opportunity is marked as Lost or Canceled
            if(trigger.isUpdate && objOpp.StageName != mapOpportunitiesOld.get(objOpp.Id).StageName && (objOpp.StageName.ToUpperCase().Contains('LOST') || objOpp.StageName.ToUpperCase().Contains('CANCELED')))
            {
                for(Task objTask : [SELECT Id, Status FROM Task Where WhatId = :objOpp.Id And Subject = 'Opportunity Follow-up' And Status != 'Completed'])
                {
                    objTask.Status = 'Completed';
                    lstTaskUpd.add(objTask);
                }

            }
        }

        if(!lstMCP.isEmpty())
            insert lstMCP;
        if(!lstOppLine.isEmpty())
            insert lstOppLine;
        if(!lstTaskIns.isEmpty())
            insert lstTaskIns;
        if(!lstQuote.isEmpty())
            update lstQuote;
        if(!lstTaskUpd.isEmpty())
            update lstTaskUpd;
    }

}