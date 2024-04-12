@isTest(SeeAllData=True)
public class TestGuidedQuoteFollowUp {

    @isTest
    static void generalGuidedQuoteTest() {
        
        String testuser = '';
        List<String> testquoteids = new List<String>();
        String testquoteid = '';
            
        List<Quote> testquote = [select id, ownerid from quote where ownerid in(select id from user where guided_quote_user__c = true) and language__c !='English' and contact.email != null limit 1];
        for(Quote a: testquote){
            testuser = a.ownerid;
            testquoteids.add(a.id);
            testquoteid = a.id;
        }
        
        GuidedQuoteFollowUp.getQuotes(testuser);
        
        GuidedQuoteFollowUp.getQuotes2(testuser);
        
        GuidedQuoteFollowUp.emailSlctRec(testquoteids,testquoteids);

        GuidedQuoteFollowUp.removeSlctRec(testquoteids,testquoteids);
    }
 
}