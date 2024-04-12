public without sharing class VisitReportController {
    public String vrId { get; set; }
    public String Internal {get; set;}

    //Visit Report
    public String vrObjectivesHTML { get; set; }
    public String vrSatisfactionSpareParts { get; set; }
    public String vrSatisfactionCapital { get; set; }
    public String vrSatisfactionOverall { get; set; }
    public String vrSatisfactionFieldRep { get; set; }
    public String vrSatisfactionComments { get; set; }
    
    //Account
    public String vrAccountId { get; set; }
    public String vrAccountName { get; set; }
    public String vrAccountShipping1 { get; set; }
    public String vrAccountShipping2 { get; set; }
    public String vrAccountShipping3 { get; set; }
    
    //Event/Contact
    public String vrEventId { get; set; }
    public Date vrEventDate { get; set; }
    public String vrReportType { get; set; }
    public List<contact> vrContacts { get; set; }
    
    //Tasks
    public List<Tasks> vrTasks { get; set; }

    //Notes
    public List<IntNotes> vrNotes { get; set; }
    
    /*######### Code #########*/
    public VisitReportController(ApexPages.StandardController controller) {
        vrId = ApexPages.CurrentPage().getparameters().get('id');
        Internal = ApexPages.CurrentPage().getparameters().get('Internal');
        Visit_Report__c VisitReport = [SELECT Id, Account__c, Event_ID__c, Visit_Report_Objective__c, Customer_Satisfaction_Capital__c, Customer_Satisfaction_Field_Service__c, Customer_Satisfaction_Overall__c, Customer_Satisfaction_SpareParts__c, Customer_Satisfaction_Comments__c  FROM Visit_Report__c WHERE Id=:vrId];
        vrAccountId = VisitReport.Account__c;
        vrEventId = VisitReport.Event_ID__c;
        
        //Get Visit Report Data - Visit Report Objectives
        vrObjectivesHTML = '<ul class="taskList">';
        List<String> Objectives = new List<String>();
        Objectives = VisitReport.Visit_Report_Objective__c.split(';');
        for (String obj : Objectives)
        {
           vrObjectivesHTML = vrObjectivesHTML + '<li>' + obj + '</li>';
        }
        
        vrObjectivesHTML = vrObjectivesHTML + '</ul>';

		//Get Visit Report Data - Customer Satisfaction
        if (VisitReport.Customer_Satisfaction_SpareParts__c == true) {
            vrSatisfactionSpareParts = 'Yes';
                } else {
                    vrSatisfactionSpareParts = 'No';
                }
         if (VisitReport.Customer_Satisfaction_Capital__c == true) {
            vrSatisfactionCapital = 'Yes';
                } else {
                    vrSatisfactionCapital = 'No';
                }
         if (VisitReport.Customer_Satisfaction_Field_Service__c == true) {
            vrSatisfactionFieldRep = 'Yes';
                } else {
                    vrSatisfactionFieldRep = 'No';
                }
         if (VisitReport.Customer_Satisfaction_Overall__c == true) {
            vrSatisfactionOverall = 'Yes';
                } else {
                    vrSatisfactionOverall = 'No';
                }
        if (VisitReport.Customer_Satisfaction_Comments__c == null) {
            if (VisitReport.Customer_Satisfaction_Overall__c == false ||
                VisitReport.Customer_Satisfaction_Field_Service__c == false ||
                VisitReport.Customer_Satisfaction_Capital__c == false ||
                VisitReport.Customer_Satisfaction_SpareParts__c == false) {
                    vrSatisfactionComments = '<i><br></br>Comments/Explaination on Customer Satisfaction:</i>';
                }
             } else {
                    vrSatisfactionComments = '<i><br></br>Comments/Explaination on Customer Satisfaction:</i><br></br>' + VisitReport.Customer_Satisfaction_Comments__c;
             }
         
        //Get Account Data
        Account account = [SELECT Id, Name, ShippingAddress,ShippingStreet,ShippingPostalCode,ShippingCity,ShippingState,ShippingCountry, BillingAddress FROM Account WHERE Id=:vrAccountId];
        vrAccountName = account.Name;
        vrAccountShipping1 = account.ShippingStreet; 
        vrAccountShipping2 = account.ShippingPostalCode + ' ' + account.ShippingCity;
        vrAccountShipping3 = account.ShippingState + ' ' + account.ShippingCountry;
      	
        //Get Event data - Contacts
        vrContacts = GetContacts(vrId);

        
        
        //Get Event data - Dates
        if (!String.isEmpty(vrEventId)) {
        Event event = [SELECT StartDateTime,Event_Type__c FROM Event WHERE Id=:vrEventID];
        vrEventDate = date.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day());
        vrReportType = string.valueOf(event.Event_Type__c);
        }

        //Get Tasks Data
        vrTasks = GetTask(vrId);

        //Get Notes
        vrNotes = GetNotes(vrId);
    }

    @AuraEnabled
    public static List<IntNotes> GetNotes(String visitReportId){
        List<IntNotes> NewNotesList = new List<IntNotes>();
        String NoteContent = '';

        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:visitReportId];
        for (ContentDocumentLink CDL : CDLs) {
            List<ContentNote> CNs = [SELECT Id, Content, CreatedBy.Name FROM ContentNote WHERE Id =:CDL.ContentDocumentId];
            for (ContentNote CN : CNs) {
                NoteContent = CN.Content.toString();
                //vrNotesBody = CN.CreatedBy.Name + NoteContent;
                IntNotes newNote = new IntNotes(CN.CreatedBy.Name, NoteContent);
                NewNotesList.add(newNote);
            }
        }
        return NewNotesList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Tasks> GetTask(String visitReportId)
    {
        List<Tasks> newTasksList = new List<Tasks>();
        List<Task> aTask = new List<Task>();
        aTask = [SELECT Id, Subject, Description, OwnerId, Owner_Name__c, ActivityDate, Visit_Report__c, WhatId,WhatId__c FROM Task WHERE Visit_Report__c=:visitReportId];
        
        for (Task sTask : aTask) {
            String Owner_Name;
            if (string.isBlank(String.valueOf(sTask.Owner_Name__c)) || string.isEmpty(String.valueOf(sTask.Owner_Name__c))) {
                Group groupname = [SELECT Name FROM Group WHERE Id=:sTask.OwnerId];
                Owner_Name = groupname.Name;
            } else {
                Owner_Name = sTask.Owner_Name__c;
            }

            //Misusing the Related_to__c field.
            /*SObject sob;
            sob = Database.query(String.escapeSingleQuotes('select Name from ' + sTask.WhatId.getSObjectType()
            + ' where Id = :sTask.WhatId__c'
            ));
            if (!string.isBlank(String.valueOf(sob.get('Name'))) || !string.isEmpty(String.valueOf(sob.get('Name')))) {
                sTask.Related_to__c = String.valueOf(sob.get('Name'));
            }*/

            Tasks newTasks = new Tasks(sTask.Id, sTask.Subject, sTask.Description, sTask.OwnerId, Owner_Name, sTask.ActivityDate, sTask.Visit_Report__c, sTask.WhatId, sTask.WhatId__c);
            newTasksList.add(newTasks);
            
        }

        return newTasksList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> GetContacts(String visitReportId){
        List<String> ContactIds = new List<String>();
        List<Contact> aContacts = new List<Contact>();
        String eventId; 

        Visit_Report__c VisitReport = [SELECT Id, Account__c, Event_ID__c, Visit_Report_Objective__c, Customer_Satisfaction_Capital__c, Customer_Satisfaction_Field_Service__c, Customer_Satisfaction_Overall__c, Customer_Satisfaction_SpareParts__c, Customer_Satisfaction_Comments__c  FROM Visit_Report__c WHERE Id=:visitReportId];
        eventId = VisitReport.Event_ID__c;

        //Get Event data - Contacts
        EventRelation[] evRelation = [SELECT Id, RelationId FROM EventRelation WHERE EventId=:eventId AND AccountId = NULL]; 
                for (EventRelation er : evRelation)
        	{
          		ContactIds.add(er.RelationId); 
        	}
        
        aContacts = [SELECT Id, Name, Phone, Email, Title FROM Contact WHERE Id IN :ContactIds];
        

        return aContacts;

    }

    public class Tasks {
        @AuraEnabled
        public String Id { get; set; }
        @AuraEnabled
        public String Subject { get; set; }
        @AuraEnabled
        public String Description { get; set; }
        @AuraEnabled
        public String OwnerId { get; set; }
        @AuraEnabled
        public String Owner_Name { get; set; }
        @AuraEnabled
        public Date ActivityDate { get; set; }
        @AuraEnabled
        public String Visit_Report { get; set; }
        @AuraEnabled
        public String WhatId { get; set; }
        @AuraEnabled
        public String WhatIdName { get; set; }

        public Tasks(String Id, String Subject, String Description, String OwnerId, String Owner_Name, Date ActivityDate, String Visit_Report, String WhatId, String WhatIdName) {
            this.Id = Id;
            this.Subject = Subject;
            this.Description = Description;
            this.OwnerId = OwnerId;
            this.Owner_Name = Owner_Name;
            this.ActivityDate = ActivityDate;
            this.Visit_Report = Visit_Report;
            this.WhatId = WhatId;
            this.WhatIdName = WhatIdName;
        }
    }

    public class IntNotes {
        @AuraEnabled
        public String Creator { get; set; }
        @AuraEnabled
        public String Body { get; set; }
        
        public IntNotes(String Creator, String Body) {
            this.Creator = Creator;
            this.Body = Body;
        }
    }
}