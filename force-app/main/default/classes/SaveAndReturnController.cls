public with sharing class SaveAndReturnController
{

    public ApexPages.StandardSetController stdCntrlr {get; set;}
    public SaveAndReturnController(ApexPages.StandardSetController controller) {
        stdCntrlr = controller;
    }
    
    public PageReference SaveAndReturn(){
        stdCntrlr.save();
        PageReference returnPage = stdCntrlr.cancel();
        returnPage.setRedirect(true);
        return returnPage;
    }
}