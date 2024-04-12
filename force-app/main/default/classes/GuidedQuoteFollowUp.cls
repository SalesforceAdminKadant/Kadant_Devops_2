public class GuidedQuoteFollowUp {
    
    @AuraEnabled 
    public List<Quote> qtList = new List<Quote>();
    
    @AuraEnabled 
    public List<Quote> qtList2 = new List<Quote>();
    
    @AuraEnabled 
    public List<Quote> updRec = new List<Quote>();
    
    @AuraEnabled 
    public List<Quote> updRec2 = new List<Quote>();
    
    @AuraEnabled 
    public static List<Quote> getQuotes(String ownerID)
    {
        GuidedQuoteFollowUp qtl = new GuidedQuoteFollowUp();
        Id currentUserId = ownerID;
        system.debug('owner' + ownerID );
        String searchOpenQuotesRecentlyMade = '';
        String allowedstatus = 'Presented';
        Date todaysDate = date.today();
        system.debug(todaysDate);
        List<String> allowedlanguages = new List<String>{'English', 'Italian', 'French','German','Spanish', 'Dutch'};
		
        searchOpenQuotesRecentlyMade = 'select id, name, accountid, account.name, language__c, currencyisocode, quote_number__c, quote_total__c, quote_date__c, expirationdate, unmanaged__c, contact.email, FirstFollowUpInitiated__c, SecondFollowUpInitiated__c from quote where ownerId = :currentUserId and SuggestedFirstFollowUpDate__c <= :todaysDate and unmanaged__c = true and FirstFollowUpInitiated__c=false and status = :allowedstatus and language__c in :allowedlanguages and contactid != null order by quote_date__c asc';
        system.debug(searchOpenQuotesRecentlyMade);
        
        qtl.qtList = Database.query(searchOpenQuotesRecentlyMade);
         
        return qtl.qtList;

    }
 	
    @AuraEnabled 
    public static List<Quote> getQuotes2(String ownerID)
    {
        GuidedQuoteFollowUp qtl = new GuidedQuoteFollowUp();
        Id currentUserId = ownerID;
        String searchOpenQuotesNearExpiry = '';
        String allowedstatus = 'Presented';
        Date todaysDate = date.today();
        List<String> allowedlanguages = new List<String>{'English', 'Italian', 'French','German','Spanish', 'Dutch'};
           
		searchOpenQuotesNearExpiry = 'select id, name, accountid, account.name, language__c, currencyisocode, quote_number__c, quote_total__c, quote_date__c, expirationdate, unmanaged__c, contact.email, FirstFollowUpInitiated__c, SecondFollowUpInitiated__c from quote where ownerId = :currentUserId and SuggestedSecondFollowUpDate__c <= :todaysDate and unmanaged__c = true and SecondFollowUpInitiated__c=false and status = :allowedstatus and language__c IN :allowedlanguages and contactid != null order by expirationdate asc';
 
        qtl.qtList2 = Database.query(searchOpenQuotesNearExpiry);

        return qtl.qtList2;

    }
    
    
    @AuraEnabled 
    public static List<Quote> emailSlctRec(List<String> slctRec, List<String> slctRec2)
    {
		List<SDOC__SDJob__c> jobList = new List<SDOC__SDJob__c> {};
        GuidedQuoteFollowUp qtl = new GuidedQuoteFollowUp();
        String Division = 'KAI';
        String LanguageCode = 'EN';
        String FollowupType = 'First';
        Date todaysDate = date.today();
        qtl.updRec = [SELECT Id, language__c, sales_office_picklist__c, FirstFollowUpInitiated__c, SecondFollowUpInitiated__c FROM Quote WHERE contact.email != null and Id IN: slctRec];
		qtl.updRec2 = [SELECT Id, language__c, sales_office_picklist__c, FirstFollowUpInitiated__c, SecondFollowUpInitiated__c FROM Quote WHERE contact.email != null and Id IN: slctRec2];
        
        system.debug('slctRec + 2');
        system.debug(slctRec);
        system.debug(slctRec2);
        system.debug('updRec + 2');
        system.debug(qtl.updRec);
        system.debug(qtl.updRec2);
        if(!qtl.updRec.isEmpty()){
        	for(Quote a : qtl.updRec){
                if(a.language__c != 'English')
            	{
                if(a.Language__c == 'French'){LanguageCode = 'FR';}
                if(a.Language__c == 'Spanish'){LanguageCode = 'ES';}
                if(a.Language__c == 'Dutch'){LanguageCode = 'NL';}
                if(a.Language__c == 'Italian'){LanguageCode = 'IT';}
                if(a.Language__c == 'German'){LanguageCode = 'DE';}
                if(a.Language__c == 'Swedish'){LanguageCode = 'SE';}
                if(a.Language__c == 'Finnish'){LanguageCode = 'FI';}
                if(a.Language__c == 'Polish'){LanguageCode = 'PL';}
                if(a.Language__c == 'Czech'){LanguageCode = 'CZ';}
                if(a.Language__c == 'Turkish'){LanguageCode = 'TR';}
                if(a.Language__c == 'Portuguese (Brazil)'){LanguageCode = 'PT-BR';}
            	} 
                String QuoteTemplate = 'PSG-E_Quote_' + LanguageCode;
           		String EmailTemplate = Division +'_Email_Template_GuidedQuote_First_'+ LanguageCode;
                a.FirstFollowUpInitiated__c = true;
            	a.ActualFirstFollowupDate__c = todaysDate;
                system.debug('Quote: ' + QuoteTemplate + ' Email: ' +EmailTemplate);
				SDOC__SDJob__c job = new SDOC__SDJob__c(
                	SDOC__Start__c=true,
                    SDOC__Oid__c=a.Id,
                    SDOC__ObjApiName__c='Quote',
                    SDOC__SendEmail__c='1',
                    SDOC__Doclist__c=(QuoteTemplate + ',' + EmailTemplate)
            		//SDOC__Doclist__c=(EmailTemplate)
            );
            system.debug('sdjob :' + job);
    		jobList.add(job);
        	}            
        }
       
        if(!qtl.updRec2.isEmpty()){   
        	for(Quote a : qtl.updRec2){
			  if(a.language__c != 'English')
            	{
                if(a.Language__c == 'French'){LanguageCode = 'FR';}
                if(a.Language__c == 'Spanish'){LanguageCode = 'ES';}
                if(a.Language__c == 'Dutch'){LanguageCode = 'NL';}
                if(a.Language__c == 'Italian'){LanguageCode = 'IT';}
                if(a.Language__c == 'German'){LanguageCode = 'DE';}
                if(a.Language__c == 'Swedish'){LanguageCode = 'SE';}
                if(a.Language__c == 'Finnish'){LanguageCode = 'FI';}
                if(a.Language__c == 'Polish'){LanguageCode = 'PL';}
                if(a.Language__c == 'Czech'){LanguageCode = 'CZ';}
                if(a.Language__c == 'Turkish'){LanguageCode = 'TR';}
                if(a.Language__c == 'Portuguese (Brazil)'){LanguageCode = 'PT-BR';}
            	} 
                
            String QuoteTemplate = 'PSG-E_Quote_' + LanguageCode;
            String EmailTemplate = Division +'_Email_Template_GuidedQuote_Second_'+ LanguageCode;
           	system.debug('Quote: ' + QuoteTemplate + ' Email: ' +EmailTemplate);
			
            a.SecondFollowUpInitiated__c = true;
            a.ActualSecondFollowupDate__c = todaysDate;
            SDOC__SDJob__c job = new SDOC__SDJob__c(
                	SDOC__Start__c=true,
                    SDOC__Oid__c=a.Id,
                    SDOC__ObjApiName__c='Quote',
                    SDOC__SendEmail__c='1',
                    SDOC__Doclist__c=(QuoteTemplate + ',' + EmailTemplate)
                    //SDOC__Doclist__c=(EmailTemplate)
            		);
            	system.debug('sdjob :' + job);
    		jobList.add(job);
            	system.debug('sdjoblist :');
            	system.debug(joblist);
        	}
        }    
            
        if(!qtl.updRec.isEmpty()){
            update qtl.updRec; 
        }
        if(!qtl.updRec2.isEmpty()){          
            update qtl.updRec2;
        }
        if(!joblist.isEmpty()){
            insert joblist;
        }
        qtl.qtList.clear();
                
        return qtl.qtList;
       
    }
    @AuraEnabled 
    public static List<Quote> removeSlctRec(List<String> slctRec, List<String> slctRec2)
    {
    GuidedQuoteFollowUp qtl = new GuidedQuoteFollowUp();    
        
        qtl.updRec = [SELECT Id, SecondFollowUpInitiated__c, FirstFollowUpInitiated__c FROM Quote  WHERE Id IN: slctRec];
		qtl.updRec2 = [SELECT Id, SecondFollowUpInitiated__c, FirstFollowUpInitiated__c FROM Quote WHERE Id IN: slctRec2];
        
        if(!qtl.updRec.isEmpty()){
        	for(Quote a: qtl.updRec){
    		a.FirstFollowUpInitiated__c = true;
            }
           	update qtl.updRec;
        }
        if(!qtl.updRec2.isEmpty()){
        	for(Quote a: qtl.updRec2){
    		a.SecondFollowUpInitiated__c = true;
            }
           	update qtl.updRec2;
        }
        system.debug('after loop' + qtl.updRec);
        
        qtl.qtList.clear();
                
        return qtl.qtList;
    }
      
}