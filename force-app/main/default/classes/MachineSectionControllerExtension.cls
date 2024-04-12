public class MachineSectionControllerExtension {

    private Machine_Section__c objMain;
    public boolean IsReadMode{get; set;}
    
    public MachineSectionControllerExtension(ApexPages.StandardController stdController) {
        objMain= (Machine_Section__c)stdController.getRecord();
        
        /**************Change below SOQL to select all fields for the object**********/
        List<Machine_Section__c> lstObj=[select Id, Machine__c, Machine_Type__c, Notes__c, Original_Supplier__c, Sequence__c, Section_Type__c, Configuration__c From Machine_Section__c where Id=:objMain.id LIMIT 1];
        if(lstObj!=null && lstObj.size()>0){
            objMain=lstObj[0];
            System.Debug('1 - ' + objMain.Id);

        }
    }


    public PageReference redirectPage(){
        System.Debug('2 - ' + objMain.Id);
        System.Debug('3 - ' + objMain.Configuration__c);
        if(String.isBlank(objMain.Configuration__c) == false){
            IsReadMode=true;
            return null;
        }else{
            //PageReference p = new PageReference('/'+objMain.id+ '/e?nooveride=1');
            //System.Debug('Theme: ' + UserInfo.getUiThemeDisplayed());
            IsReadMode=false;
            if(UserInfo.getUiThemeDisplayed() == 'Theme4d')
            {
                PageReference p = new PageReference('/lightning/r/Machine_Section__c/' + objMain.id + '/edit');
                return p;
            }else{
                PageReference p = new PageReference('/' + objMain.id +  '/e?retURL=%2Fapex/Machine_Section_Creation?Id=' + objMain.id);
                return p;
            }
        }

    }
   
}