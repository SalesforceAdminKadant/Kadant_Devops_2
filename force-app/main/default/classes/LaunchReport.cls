public class LaunchReport
{
@AuraEnabled
    public String ReportId = apexpages.currentpage().getparameters().get('ReportId');
    public String UITheme = apexpages.currentpage().getparameters().get('UITheme');
    public String ReportParms = apexpages.currentpage().getparameters().get('ReportParms');
    public String CurrentURL = ApexPages.currentPage().getHeaders().get('Host');
    public String ReportURL {get;set;}
    public Boolean boolLightning = false;
    
    public PageReference NavigateToURL(){
    
        Profile[] p = [SELECT Id FROM Profile WHERE Id = :userinfo.getProfileId() And PermissionsLightningExperienceUser = true LIMIT 1];
        if(p.size() > 0)
            boolLightning = true;
        else
        {
            PermissionSetAssignment[] psa = [Select Id FROM PermissionSetAssignment Where PermissionSet.Label = 'Lightning Experience' And AssigneeID = :userinfo.getUserId() LIMIT 1];
            if (psa.size() > 0)
                boolLightning = true;
        }

        if(ReportParms != Null)
        {
            ReportParms = ReportParms.Replace('^', '&');
        }
        
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d' ||
            UITheme == 'Theme4d' ||
            boolLightning == true)
        {
            ReportURL = '/lightning/r/Report/' + ReportId + '/view';
            if(ReportParms != Null)
            {
                ReportParms = ReportParms.Replace('***PARM***', 'f');
                ReportURL += '?' + ReportParms;
            }
        }else{
            ReportURL = '/' + ReportId;
            if(ReportParms != Null)
            {
                ReportParms = ReportParms.Replace('***PARM***', 'p');
                ReportURL += '?' + ReportParms;
            }
        }

        PageReference pageRef = new PageReference(ReportURL);
        pageRef.setRedirect(true);
        return pageRef;
    
    }

}