/* 
 * Author: Youp Schaefers and Marcel Oudmaijer
 * Date: 14/03/2022
 * 
 * Description: This class contains functions for the "Kadant Partner Portal" .
 */

public without sharing class KPP_Function_Library {

    /*######################## PART RELATED FUNCTIONS #################### */

    @AuraEnabled
    public static List<List<String>> searchProducts(String productDiv, String searchFilter)
    {    
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Product2> sDataSet = new List<Product2>(); 
        
        if(searchFilter ==null) {searchFilter = ' ';}
 
        sSQL = 'select id, name, description, product_classification__r.product_line__c, product_division__c from product2 where IsActive=true and product_division__c=\'' + productDiv +  '\''
            	+ searchFilter
            	+ ' order by name limit 50';
 		sDataSet = Database.query(sSQL);
        
        for (Product2 sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                					String.valueOf(sobj.get('id')),
                        			String.valueOf(sobj.get('name')),
                        			String.valueOf(sobj.get('description')),
            						String.valueOf(sobj.getSobject('product_classification__r').get('product_line__c'))
            });            
        }
    
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static List<List<String>> getProduct(String sDocumentID, String sAccountID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Product2> sDataSet = new List<Product2>(); 
        
        String strJointFields = ' Joint_M_Size__c, Joint_M_Size_UOM__c,Joint_M_Type__c, Joint_M_Thread_Direction__c, ' +
                                ' Joint_P_Size__c, Joint_P_Size_UOM__c,Joint_P_Type__c, Joint_P_Thread_Direction__c, ' +
                                ' Joint_S_Size__c, Joint_S_Size_UOM__c,Joint_S_Type__c, Joint_S_Thread_Direction__c, ' +
                                ' Joint_Nipple_Size__c, Joint_Nipple_Size_UOM__c, Joint_Nipple_Type__c, Joint_Nipple_Thread_Direction__c, ' +
                                ' Joint_Seal_Material__c, Joint_Media__c,' +
                                ' Joint_Temperature__c, Joint_Temperature_UOM__c, ' +
                                ' Joint_Pressure__c, Joint_Pressure_UOM__c, ';
       
        String strBladeFields = ' BLD_Application__c, BLD_Bevel_Angle__c, BLD_CTL_Machine_Index__c, BLD_Holder_Type__c, ' +
                                ' BLD_KUK_Reference_Code__c, BLD_Length__c, BLD_Machine_No__c, BLD_Material__c, ' +
                                ' BLD_Thickness__c, BLD_Width__c, ';
        
       	sSQL = 'select id, name, description, productcode, list_price__c, Drawing_Number__c, product_classification__r.product_line__c, Unit_of_Measure__c, '
            	+ strJointFields
            	+ strBladeFields
            	+'IsActive from product2 where IsActive=true and id=\'' + sDocumentID + '\'';
       	sDataSet = Database.query(sSQL);
        
        for (Product2 sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                					String.valueOf(sobj.get('id')),
                        			String.valueOf(sobj.get('name')),
                        			String.valueOf(sobj.get('description')),
            						String.valueOf(sobj.get('productcode')),
                                    String.valueOf(sobj.get('Drawing_Number__c')),
                                    String.valueOf(sobj.get('Unit_of_Measure__c')),
                                    String.valueOf(sobj.getSobject('product_classification__r').get('product_line__c')),
                                   	String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null',''),
                            		String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null',''),
                            		String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null',''),
                            		String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null',''),
                            		String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' ').replace('null',''),
                            		String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Material__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null',''),
                            		String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_Nipple_Size__c')))+sobj.get('Joint_Nipple_Size_UOM__c')+' '+sobj.get('Joint_Nipple_Type__c')+' '+sobj.get('Joint_Nipple_Thread_Direction__c')).replace('null',''),
                            		String.valueOf(sobj.get('Drawing_Number__c')+' ').replace('null',''),
                            		String.valueOf(sobj.get('Unit_of_Measure__c')+' ').replace('null',''),
                                    String.valueOf(sobj.get('Joint_Media__c')+' ').replace('null',''),
                                    String.valueOf(sobj.get('list_price__c')+' ').replace('null','')  

                                        });            
        }
    
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static String getDrawingFileID(String PartID, String UserID){

        	String sContentID = '';
        	String sContactID = '';
            String sDrawingID = '';
            String sDrawingType = '';
            String sDrawingFileID = '';  
            List<ContentDocumentLink> dwgfile = new List<ContentDocumentLink>(); 
           
            //product2[] dwg = [SELECT id, drawing__r.id, drawing__r.name, drawing__r.status__c, drawing__r.title__c, drawing__r.type__c, drawing__r.drawing_type__c, drawing__r.current_rev_lvl__c  FROM product2 where id=:PartID];
            product2[] dwg = [SELECT drawing__r.id, Drawing__r.Type__c FROM product2 where id=:PartID];
            
            if(!dwg.isEmpty()){
                for (product2 sobj:dwg) {
                    sDrawingID = String.valueOf(sobj.drawing__r.id);
                    sDrawingType = String.valueOf(sobj.drawing__r.Type__c);
                    //system.debug(sDrawingType);

                    if(sDrawingID !='' && sDrawingType == 'Assembly'){
                        if(sDrawingID !='null'){
                            String sSOQL = 'SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Id FROM ContentDocumentLink WHERE LinkedEntityId=\'' + sDrawingID + '\' LIMIT 1';
                            dwgfile = Database.query(sSOQL);
                    
                            for (ContentDocumentLink sobj2:dwgfile) {
                                sDrawingFileID = String.valueOf(sobj2.ContentDocument.LatestPublishedVersionId);
                                sContentID = String.valueOf(sobj2.ContentDocument.Id);

                                	
                                	user[] usr = [SELECT contactid from user where id=:UserID];
                                	for (user sobjUser:usr) {
                    					sContactID = String.valueOf(sobjUser.Contactid);
                                    }
                                
                                	
                                    if(sContactID !='null'){
                                		ContentDocumentLink[] cdl = [SELECT id from ContentDocumentLink where LinkedEntityId=:sContactID and ContentDocumentId=:sContentID];              
                                        if(cdl.isEmpty()){
                                    		ContentDocumentLink cDocLink = new ContentDocumentLink();
											cDocLink.ContentDocumentId = sContentID;//Add ContentDocumentId
        									cDocLink.LinkedEntityId = sContactID; //Youp portal contact Timber
											cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
											cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        									insert cDocLink;
                                        }
                                    }
									
                            }
                        }
                    }
                    
                }
            }

         if(sDrawingType == null){sDrawingFileID='NoDrawing';}
        if(sDrawingType == ''){sDrawingFileID='NoDrawing';}
        if(sDrawingType == 'None'){sDrawingFileID='NoDrawing';}
        if(sDrawingType == 'SAD'){sDrawingFileID='NoDrawing';}
        if(sDrawingType == 'Detail'){sDrawingFileID='Detail';}
        
        
        
    	//Return sContentID + '@' + sDrawingType; 
        Return sContentID + '@' + sDrawingFileID;
    }
 
    
    /*######################## CUSTOMER RELATED FUNCTIONS #################### */
    
    @AuraEnabled
    public static List<List<String>> searchCustomers(String productDiv, String searchFilter, String recordType)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Account> sDataSet = new List<Account>(); 
        
        if(searchFilter ==null) {searchFilter = ' ';}
 
        sSQL = 'select id, name, shippingcity, shippingcountry from account where Active__c=true'
            	+ searchFilter
            	+ 'and recordtypeid = \'' + recordType +  '\' order by name limit 50';
       	sDataSet = Database.query(sSQL);
        
        for (Account sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                					String.valueOf(sobj.get('id')),
                        			String.valueOf(sobj.get('name')),
                        			String.valueOf(sobj.get('shippingcity')),
            						String.valueOf(sobj.get('shippingcountry'))
            });            
        }
    
        Return sSearchResults;
    }
    
    
    @AuraEnabled
    public static List<List<String>> getCustomer(String DocumentID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Account> sDataSet = new List<Account>(); 
        
       	sSQL = 'select name, shippingcity, shippingcountry from account where id=\'' + DocumentID + '\'';
       	sDataSet = Database.query(sSQL);
        
        for (Account sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                					String.valueOf(sobj.get('id')),
                        			String.valueOf(sobj.get('name')),
                        			String.valueOf(sobj.get('shippingcity')),
            						String.valueOf(sobj.get('shippingcountry'))
            });            
        }
    
        Return sSearchResults;
    }

    
    
    
    /*######################## ASSET RELATED FUNCTIONS #################### */
    
    @AuraEnabled
    public static List<List<String>> getAssets(String sAccountID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Asset> sDataSet = new List<Asset>(); 
        
       	sSQL = 'select id, name, short_description__c from asset where accountid=\'' + sAccountID + '\' order by name';
       	sDataSet = Database.query(sSQL);
        
        for (Asset sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('id')),
                					String.valueOf(sobj.get('name')),
              						String.valueOf(sobj.get('short_description__c'))
            });            
        }
    
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static List<List<String>> getAsset(String sDocumentID, String sAccountID)  {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Asset> sDataSet = new List<Asset>(); 
        
       	sSQL = 'select name, account.name, account.id, short_description__c from asset where id=\'' + sDocumentID + '\' order by name';
       	sDataSet = Database.query(sSQL);
        
        for (Asset sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('name')),
                                    String.valueOf(sobj.getSobject('account').get('name')),
                                    String.valueOf(sobj.getSobject('account').get('id')),
              						String.valueOf(sobj.get('short_description__c')+ ' ').replace('null','')
            });            
        }
      
        Return sSearchResults;
    }

    

    /*######################## CONTACT RELATED FUNCTIONS #################### */
   
    @AuraEnabled
    public static List<List<String>> getContacts(String sAccountID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Contact> sDataSet = new List<Contact>(); 
        
       	sSQL = 'select id, name, title, phone, email from contact where accountid=\'' + sAccountID + '\' order by name';
       	sDataSet = Database.query(sSQL);
        
        for (Contact sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('id')),
                					String.valueOf(sobj.get('name')),
              						(String.valueOf(sobj.get('title'))+' ').replace('null',''),
                                    (String.valueOf(sobj.get('phone'))+' ').replace('null','').replace(' ','').replace('+','00').replace('.','').replace('-',''),
                                    String.valueOf(sobj.get('email'))
            });            
        }
    
        Return sSearchResults;
    }    
    
    
    /*######################## WORKORDER RELATED FUNCTIONS #################### */
  
    @AuraEnabled
    public static List<List<String>> getWorkorders(String sDocumentID)
    {     
      	//List<List<String>> sWorkorders = new List<List<String>>();
        List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        String sWO = '(';
        List<Workorder> sDataSet = new List<Workorder>(); 
        List<ServiceAppointment> sDataSet2 = new List<ServiceAppointment>(); 
        List<AssignedResource> sDataSet3 = new List<AssignedResource>();
        List<ContentDocumentLink> sDataSet4 = new List<ContentDocumentLink>();
        String sAssRes='';
        String sReport='';
        Integer nCount=0;
        
        sSQL = 'select id, workordernumber, status, subject, priority, description, worktype.name from workorder where caseid=\'' + sDocumentID + '\' order by CreatedDate desc';
       	sDataSet = Database.query(sSQL);
	
        
        
        for (Workorder sobj : sDataSet){  
              sWO = sWO + '\',\'' + String.valueOf(sobj.get('Id'));
        }
                            
        sWO = (sWO + '\')').replace('(\',','(');   
        
        
        //system.debug(sWO);

        sSQL = 'SELECT id, AppointmentNumber, Status, schedstarttime, schedendtime, parentrecord.name, parentrecordid FROM ServiceAppointment where parentrecordid IN' + sWO + ' order by schedstarttime';
       	sDataSet2 = Database.query(sSQL);                                 
                                 
        for (Workorder sobj : sDataSet){  
        	
           	String sWorkType = ' ';
            nCount = 0;
            
            if( sobj.getSobject('worktype') != null){ sWorkType = String.valueOf(sobj.getSobject('worktype').get('name'));}
            
            sSearchResults.add(new List<String>{
                    'W',
                	String.valueOf(sobj.get('Id')),
                    String.valueOf(sobj.get('workordernumber')),
                    String.valueOf(sobj.get('status')),
                    String.valueOf(sobj.get('subject')+'').replace('null',''),
                    String.valueOf(sobj.get('priority'))+'',
                    String.valueOf(sobj.get('description')+'').replace('null',''),                    
                    sWorkType,
                    ' '
                    });
            
            		
        			for (ServiceAppointment sobj2 : sDataSet2){  
            
                		if (sobj2.get('parentrecordid') == sobj.get('Id')){

                            nCount = nCount+1;
                            
                            sAssRes='';                            
                            sSQL = 'SELECT AssignedResourceNumber, ServiceAppointmentId, Work_Order__c, Service_Resource_Name__c, ServiceResourceId FROM AssignedResource where serviceappointmentid=\'' + String.valueOf(sobj2.get('Id')) + '\' LIMIT 1';
       						sDataSet3 = Database.query(sSQL); 
                            for (AssignedResource sobj3 : sDataSet3){ sAssRes=String.valueOf(sobj3.get('Service_Resource_Name__c'));   }   
                            
                            sReport='';
                            sSQL = 'SELECT contentdocumentid FROM ContentDocumentLink WHERE linkedentityid =\'' + String.valueOf(sobj2.get('Id')) + '\' LIMIT 1';
       						sDataSet4 = Database.query(sSQL);
                            for (ContentDocumentLink sobj4 : sDataSet4){ sReport=String.valueOf(sobj4.get('contentdocumentid'));   } 

            				sSearchResults.add(new List<String>{
                            		'S',
                					String.valueOf(sobj2.get('Id')),
                                    String.valueOf(sobj2.get('AppointmentNumber')),
                        			String.valueOf(sobj2.get('Status')),
                                    String.valueOf(sobj2.get('schedstarttime')),
                                    String.valueOf(sobj2.get('schedendtime')),
                                    sAssRes,
                                    sReport,
                                    String.valueOf(nCount)
            				});
                		}
             		}
					
        }
            
  
        Return sSearchResults;
    } 
    

    /*######################## CHAT RELATED FUNCTIONS #################### */
    
    @AuraEnabled
    public static List<List<String>> getHomeChat(String sUser)
    {     
      	String sAgentID='x';
       
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }
        
      	List<List<String>> sFeedComments = new List<List<String>>();
        List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = ''; 
        List<FeedComment> sDataSet = new List<FeedComment>(); 
        
        if(sAgentID !='x'){
        	//=========== get list of customers connected to this agent ====
        
	        Map<String,String> AccountMap = new Map<String,String>();
        
    	    List<account_division__c> sDataSet01 = new List<account_division__c>(); 
        	sSQL = 'SELECT account__c, account__r.name  from account_division__c where agent__c =\'' + sAgentID + '\' order by account__c';
       		sDataSet01 = Database.query(sSQL);	
        
        	String sDOCS = '(';
        	for (account_division__c sobj01 : sDataSet01){  
            	sDOCS = sDOCS + '\',\'' + String.valueOf(sobj01.get('account__c'));
            	AccountMap.put(String.valueOf(sobj01.get('account__c')), String.valueOf(sobj01.getSobject('account__r').get('name')) );
        	}
                            
        	sDOCS = (sDOCS + '\')').replace('(\',','(');
        
	        //=========== get chats ====
        
        	sSQL = 'SELECT Id, FeedItemId, ParentId, CreatedBy.name, CreatedDate,CommentBody, RelatedRecordId FROM FeedComment where commenttype=\'TextComment\' and isDeleted=false and ParentId IN' + sDOCS + ' order by FeedItemId,CreatedDate desc';
       		sDataSet = Database.query(sSQL);
        
        
        	List<FeedItem> sDataSet2 = new List<FeedItem>(); 
        
       		sSQL = 'SELECT Id, ParentId, CreatedBy.name, CreatedDate, CommentCount, Body, LinkUrl, IsRichText, RelatedRecordId FROM FeedItem where type=\'TextPost\' and IsDeleted = false and ParentId IN' + sDOCS + ' order by LastModifiedDate desc';
       		sDataSet2 = Database.query(sSQL);
        
        	for (FeedItem sobj2 : sDataSet2){  
        
            sSearchResults.add(new List<String>{
                					'Topic',
                        			String.valueOf(sobj2.get('id')),
                                    String.valueOf(sobj2.get('ParentId')),
                                    String.valueOf(sobj2.get('id')),
                                    String.valueOf(sobj2.getSobject('CreatedBy').get('name')),
                                    String.valueOf(sobj2.get('CreatedDate')),
              						String.valueOf(sobj2.get('Body')+ ' ').replace('null','').replace('<p>','').replace('</p>',''),                                    
                                    String.valueOf(AccountMap.get( String.valueOf(sobj2.get('ParentId')))),
                                    'Cus'
            });  
            
           	for (FeedComment sobj : sDataSet){  
        
                if (sobj2.get('id') == sobj.get('FeedItemId')){
            			sSearchResults.add(new List<String>{
                            		'Comment',
                					String.valueOf(sobj.get('Id')),
                                    String.valueOf(sobj.get('ParentId')),
                        			String.valueOf(sobj.get('FeedItemId')),
                                    String.valueOf(sobj.getSobject('CreatedBy').get('name')),
                                    String.valueOf(sobj.get('CreatedDate')),
              						String.valueOf(sobj.get('CommentBody')+ ' ').replace('null','').replace('<p>','').replace('</p>',''),
                                    ' ',
                                    'Cus'
            			});            
                	}
        		}
            
        	}
        
        }
        
        
        Return sSearchResults;
    }
    
    
    
    @AuraEnabled
    public static List<List<String>> getChat(String sDocumentID)
    {     
      	List<List<String>> sFeedComments = new List<List<String>>();
        List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<FeedComment> sDataSet = new List<FeedComment>(); 
        
        sSQL = 'SELECT Id, FeedItemId, ParentId, CreatedBy.name, CreatedDate,CommentBody, RelatedRecordId FROM FeedComment where commenttype=\'TextComment\' and isDeleted=false and ParentId=\'' + sDocumentID + '\' order by FeedItemId,CreatedDate';
       	sDataSet = Database.query(sSQL);
        
        
        List<FeedItem> sDataSet2 = new List<FeedItem>(); 
        
       	sSQL = 'SELECT Id, ParentId, CreatedBy.name, CreatedDate, CommentCount, Body, LinkUrl, IsRichText, RelatedRecordId FROM FeedItem where type=\'TextPost\' and IsDeleted = false and ParentId=\'' + sDocumentID + '\' order by LastModifiedDate desc';
       	sDataSet2 = Database.query(sSQL);
        
        for (FeedItem sobj2 : sDataSet2){  
        
            sSearchResults.add(new List<String>{
                					'Topic',
                        			String.valueOf(sobj2.get('id')),
                                    String.valueOf(sobj2.get('ParentId')),
                                    String.valueOf(sobj2.get('id')),
                                    String.valueOf(sobj2.getSobject('CreatedBy').get('name')),
                                    String.valueOf(sobj2.get('CreatedDate')),
              						String.valueOf(sobj2.get('Body')+ ' ').replace('null','').replace('<p>','').replace('</p>','')
            });  
            
           	for (FeedComment sobj : sDataSet){  
        
                if (sobj2.get('id') == sobj.get('FeedItemId')){
            			sSearchResults.add(new List<String>{
                            		'Comment',
                					String.valueOf(sobj.get('Id')),
                                    String.valueOf(sobj.get('ParentId')),
                        			String.valueOf(sobj.get('FeedItemId')),
                                    String.valueOf(sobj.getSobject('CreatedBy').get('name')),
                                    String.valueOf(sobj.get('CreatedDate')),
              						String.valueOf(sobj.get('CommentBody')+ ' ').replace('null','').replace('<p>','').replace('</p>','')
            			});            
                }
        	}
            
        }
  
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static Id createChat(Id sDocumentID, String sBody)
    {     
    	FeedItem cDocLink = new FeedItem ();
		cDocLink.ParentId = sDocumentID;
        cDocLink.Body = sBody; 
		Insert cDocLink;
        
        Return sDocumentID;
    }
  
    @AuraEnabled
    public static Id createComment(Id sTopicID,  String sComment)
    {     
    	FeedComment cDocLink = new FeedComment();
		cDocLink.FeedItemId = sTopicID;
        cDocLink.CommentBody = sComment; 
		Insert cDocLink;
        
        Return sTopicID;
    }

    
        /*######################## OPPORTUNITY RELATED FUNCTIONS #################### */
 
    @AuraEnabled
    public static List<List<String>> getHomeOpps(String sUser)
    {     
      	String sAgentID='x';
        
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }
        
        List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        
        if(sAgentID !='x'){
        
        	List<Opportunity> sDataSet = new List<Opportunity>(); 
	        sSQL = 'SELECT id, opportunity_number__c, description, stagename, createddate, accountid, closedate, probability, Account.name, opportunity_Type__c, Amount FROM Opportunity where agent__c=\'' + sAgentID + '\' order by createddate desc LIMIT 6';

       		sDataSet = Database.query(sSQL);
        
        	for (Opportunity sobj : sDataSet){  

            	sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('id')),
                                    String.valueOf(sobj.get('opportunity_number__c')),
                					String.valueOf(sobj.get('description')+' ').replace('null',''),
              						String.valueOf(sobj.get('stagename')),
                                    String.valueOf(sobj.get('createddate')).left(10),
                                    String.valueOf(sobj.get('accountid')),
                                    String.valueOf(sobj.get('opportunity_Type__c')+' ').replace('null',''),
                                    String.valueOf(sobj.getSobject('account').get('name')),    
                                    String.valueOf(sobj.get('closedate')+' ').replace('null','').left(10),
                                    String.valueOf(sobj.get('Amount')),
                                    String.valueOf(sobj.get('probability'))
            	});            
        	}
    
        }
        Return sSearchResults;
    }

    
    @AuraEnabled
    public static List<List<String>> getOpp(String sDocumentID, String sAccountID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Opportunity> sDataSet = new List<Opportunity>(); 
        
       	sSQL = 'SELECT id, opportunity_number__c, description, stagename, createddate, accountid, closedate, probability, Account.name, opportunity_Type__c, Amount, name FROM Opportunity where id=\'' + sDocumentID + '\' LIMIT 1';

        sDataSet = Database.query(sSQL);
        
        for (Opportunity sobj : sDataSet){  
                
           	sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('id')),
                                    String.valueOf(sobj.get('opportunity_number__c')),
                					String.valueOf(sobj.get('description')+' ').replace('null',''),
              						String.valueOf(sobj.get('stagename')),
                                    String.valueOf(sobj.get('createddate')).left(10),
                                    String.valueOf(sobj.get('accountid')),
                                    String.valueOf(sobj.get('opportunity_Type__c')+' ').replace('null',''),
                                    String.valueOf(sobj.getSobject('account').get('name')),    
                                    String.valueOf(sobj.get('closedate')+' ').replace('null','').left(10),
                                    String.valueOf(sobj.get('Amount')),
                                    String.valueOf(sobj.get('probability')),
                                    String.valueOf(sobj.get('name'))
           	});  
            
        }
             
        Return sSearchResults;
    }
    

    /*######################## CASE RELATED FUNCTIONS #################### */
 
    @AuraEnabled
    public static List<List<String>> getHomeCases(String sUser)
    {     
      	String sAgentID='x';
      	String sAssetId='';
        String sAssetName='';

        
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }
        
        List<List<String>> sSearchResults = new List<List<String>>();
        
        if(sAgentID !='x'){
            
        	String sSQL = '';
        	List<Case> sDataSet = new List<Case>(); 
       		sSQL = 'select id, casenumber, subject, status, createddate, accountid, closeddate, assetid, account.name, type from case where agent__c=\'' + sAgentID + '\' order by createddate desc LIMIT 6';

	       	sDataSet = Database.query(sSQL);
        
        	for (Case sobj : sDataSet){  
            
            	sAssetId = String.valueOf(sobj.get('assetid'));
            	sAssetName=' ';
            
            	if(sAssetId != null){
            		Asset assetTable = [SELECT name FROM Asset WHERE Id = :sAssetId LIMIT 1];
        			if(assetTable.name != null){
	            		sAssetName = assetTable.name;
    	    		}
        	    }
        
            	sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('id')),
                                    String.valueOf(sobj.get('casenumber')),
                					String.valueOf(sobj.get('subject')),
              						String.valueOf(sobj.get('status')),
                                    String.valueOf(sobj.get('createddate')).left(10),
                                    String.valueOf(sobj.get('accountid')),
                                    String.valueOf(sobj.get('type')),
                                    String.valueOf(sobj.getSobject('account').get('name')),    
                                    String.valueOf(sobj.get('closeddate')+' ').replace('null','').left(10),
                                    sAssetName,
                                    String.valueOf(sobj.get('assetid'))
            	});            
        	}
    
        }
        Return sSearchResults;
    }
    
    
    @AuraEnabled
    public static List<List<String>> getCases(String sDocumentID, String sPage)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Case> sDataSet = new List<Case>(); 
        if(sPage=='ast'){
            sSQL = 'select id, casenumber, subject, status, createddate, accountid, closeddate, assetid, account.name, type from case where assetid=\'' + sDocumentID + '\' order by createddate desc';
        } else {
       		sSQL = 'select id, casenumber, subject, status, createddate, accountid, closeddate, assetid, account.name, type from case where accountid=\'' + sDocumentID + '\' order by createddate desc';
    	}
       	sDataSet = Database.query(sSQL);
        
        for (Case sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('id')),
                                    String.valueOf(sobj.get('casenumber')),
                					String.valueOf(sobj.get('subject')),
              						String.valueOf(sobj.get('status')),
                                    String.valueOf(sobj.get('createddate')).left(10),
                                    String.valueOf(sobj.get('accountid')),
                                    String.valueOf(sobj.get('type')),
                                    String.valueOf(sobj.get('closeddate')+' ').replace('null','').left(10),
                                    String.valueOf(sobj.get('assetid'))
            });            
        }
    
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static Id createCase(Id sAccountID, String sSubject, String sType, String sDescription, String sUser)
    {     
    	//system.debug(sAccountID +' ' + sSubject+' ' + sType+' ' +sDescription+' ' +sUser);
        String sAgentID='';
 
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }
        
        Case sfDoc = new Case();
		sfDoc.AccountId = sAccountID;
        sfDoc.Subject = sSubject; 
        sfDoc.Description = sDescription; 
        sfDoc.Type = sType;
        if(sAgentID<>''){sfDoc.Agent__c = sAgentID;}
		Insert sfDoc;
        
        Return sfDoc.Id;
    }
    
    
    @AuraEnabled
    public static Id saveCase(Id sCaseID, String sSubject, String sAssetID, String sDescription, String sUser)
    {    
        String sAgentID='';
        
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }
        
        
        try {
	        Case sfDoc = [SELECT Subject, AssetId, Description FROM Case WHERE Id = :sCaseID LIMIT 1];
     
            if(String.valueOf(sAssetID+'')!=''){
                sfDoc.AssetId = sAssetID;
            } else {
                sfDoc.AssetId = null;
            }
            sfDoc.Subject = sSubject;
            sfDoc.Description = sDescription;
            if(sAgentID<>''){sfDoc.Agent__c = sAgentID;}
			Update sfDoc;
        } 
        	catch(DmlException e)
        {
    		System.debug('An unexpected error has occurred: ' + e.getMessage());
		}

        Return sCaseID;
    }    
    
    
    @AuraEnabled
    public static List<List<String>> getCase(String sDocumentID, String sAccountID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Case> sDataSet = new List<Case>(); 
        String sAssetId = '';
        String sAssetName = '';
        
       	sSQL = 'select id, casenumber, status, createddate, accountid, closeddate, assetid, account.name, subject, type, description from case where id=\'' + sDocumentID + '\' LIMIT 1';

        sDataSet = Database.query(sSQL);
        
        for (Case sobj : sDataSet){  
        
            sAssetId = String.valueOf(sobj.get('assetid')+'');
            system.debug(sAssetId);
            if(sAssetId!='null'){
            	Asset sAsset = [SELECT name FROM Asset WHERE Id=:sAssetId LIMIT 1];
            	sAssetName = String.valueOf(sAsset.name);
            } else {
                sAssetId='';
            }
                
            sSearchResults.add(new List<String>{
                        String.valueOf(sobj.get('id')),
                        String.valueOf(sobj.get('casenumber')), 
                        String.valueOf(sobj.get('status')),
                        String.valueOf(sobj.get('createddate')),
                        String.valueOf(sobj.get('accountid')),
                        String.valueOf(sobj.getSobject('account').get('name')),
                        String.valueOf(sobj.getSobject('account').get('id')),
              			String.valueOf(sobj.get('subject')+ ' ').replace('null',' '),    
                        String.valueOf(sobj.get('type')),    
                        String.valueOf(sobj.get('closeddate')+ ' '),
                        String.valueOf(sobj.get('description')+ ' '), 
                        sAssetId,
                        sAssetName
                        
            });            
        }
             
        Return sSearchResults;
    }


    /*######################## QUOTE RELATED FUNCTIONS #################### */
 
    @AuraEnabled
    public static List<List<String>> getQuoteHistory(String sAccountID) {
        
        List<List<String>> CustomerOrderList = new List<List<String>>();
        String sPrevOrderId = '';
       	String sSQL ='';
        
        	sSQL = 'SELECT Quote.id, Quote.expirationdate, product2.name, Quantity, UnitPrice, TotalPrice, Quote.GrandTotal, Quote.Status, Quote.QuoteNumber, ' +
                		' Line_no__c, quote.opportunity.name, quote.opportunity.agent__c, product2.description, Quote.account.name, Quote.name, Quote.account.ShippingCountry, ' +
                		' Quote.Sales_Office__r.name, product2.productcode, quote.account.id, quote.opportunity.id FROM quotelineitem WHERE quote.account.id =\'' + sAccountID +'\'' +
                		' ORDER BY quote.expirationdate DESC, quote.id, Line_no__c';
        	List<sObject>  ol = Database.query(sSQL);

        
        	for (sObject sobj:ol) {
                
                if(String.valueOf(sobj.getSobject('Quote').get('id')) <> sPrevOrderId){
                    	CustomerOrderList.add(new List<String>{
                    		String.valueOf(sobj.getSobject('Quote').get('id')),
                    		String.valueOf(sobj.getSobject('Quote').get('expirationdate')),
                    		String.valueOf(sobj.getSobject('Quote').get('Status')),
                    		String.valueOf(sobj.getSobject('Quote').get('QuoteNumber')),
                        	String.valueOf(sobj.getSobject('Quote').getSobject('account').get('name')),
                    		'H',
                            String.valueOf(sobj.getSobject('Quote').get('GrandTotal')),
                            String.valueOf(sobj.getSobject('Quote').getSobject('opportunity').get('name')),
                            String.valueOf(sobj.getSobject('Quote').getSobject('opportunity').get('agent__c')),
                            String.valueOf(sobj.getSobject('Quote').get('name')),
                            String.valueOf(sobj.getSobject('Quote').getSobject('Sales_Office__r').get('name')),
                            String.valueOf(sobj.getSobject('Quote').getSobject('account').get('ShippingCountry'))+' ' ,
                            String.valueOf(sobj.getSobject('Quote').getSobject('account').get('id')),
                            String.valueOf(sobj.getSobject('Quote').getSobject('opportunity').get('id'))
                		});
                    sPrevOrderId  = String.valueOf(sobj.getSobject('Quote').get('id'));
                }
                
                CustomerOrderList.add(new List<String>{
                    String.valueOf(sobj.getSobject('Quote').get('id')),
                    String.valueOf(sobj.getSobject('Quote').get('expirationdate')),
                    String.valueOf(sobj.getSobject('product2').get('name')),    
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    'L',
                    String.valueOf(sobj.get('TotalPrice')),
                    String.valueOf(sobj.get('Line_No__c')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.getSobject('product2').get('productcode'))+' ',
                    ' ',
                    ' ',
                    ' ',
                    ' '
                });                  
        
        	}

        return CustomerOrderList;

    }
    
    
    @AuraEnabled
    public static List<List<String>> getQuote(String sDocumentID, String sAccountID)  {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Quote> sDataSet = new List<Quote>(); 
        
       
       	sSQL = 'SELECT id, name, expirationdate, GrandTotal, Status, QuoteNumber, opportunity.name, opportunity.agent__c, account.id, Sales_Office__r.name, ' + 
               'account.name, account.ShippingStreet, account.ShippingCity, account.ShippingState, account.ShippingPostalCode, account.ShippingCountry ' +
               'FROM quote WHERE id =\'' + sDocumentID +'\'';
       	sDataSet = Database.query(sSQL);
        
        for (Quote sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('name')),
                                    String.valueOf(sobj.getSobject('account').get('name')),
                                    String.valueOf(sobj.getSobject('account').get('id')),
              						String.valueOf(sobj.get('QuoteNumber')+ ' ').replace('null',''),
                                    String.valueOf(sobj.get('expirationdate')),
                    				String.valueOf(sobj.get('Status')),                                       
                                    String.valueOf(sobj.getSobject('opportunity').get('name')),
                                    String.valueOf(sobj.getSobject('opportunity').get('agent__c')),    
                            		String.valueOf(sobj.getSobject('Sales_Office__r').get('name')),
                                    String.valueOf(sobj.getSobject('account').get('ShippingStreet'))+' ',
                                    String.valueOf(sobj.getSobject('account').get('ShippingCity'))+' ',
                                    String.valueOf(sobj.getSobject('account').get('ShippingPostalCode'))+' ',
                            		String.valueOf(sobj.getSobject('account').get('ShippingCountry'))+' '
            });            
        }
      
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static List<List<String>> getQuoteLines(String sDocumentID)  {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<quotelineitem> sDataSet = new List<quotelineitem>(); 
        
       	sSQL = 'SELECT product2.name, Quantity, UnitPrice, TotalPrice, Line_no__c,  product2.description, product2.productcode FROM quotelineitem WHERE Quote.id =\'' + sDocumentID + '\' order by Line_no__c';
       	sDataSet = Database.query(sSQL);
        
        for (quotelineitem sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                    String.valueOf(sobj.getSobject('product2').get('name')),    
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('TotalPrice')),
                    String.valueOf(sobj.get('Line_No__c')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.getSobject('product2').get('productcode'))
            });            
        }
      
        Return sSearchResults;
    }

    
    
    /*######################## ORDER RELATED FUNCTIONS #################### */
    
    @AuraEnabled
    public static List<List<String>> getHomeOrders(String sUser) {
                     
        List<List<String>> CustomerOrderList = new List<List<String>>();
        String sPrevOrderId = '';
       	String sSQL ='';

        String sAgentID='';
        
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }
                
        	sSQL = 'SELECT Order.id, Order.effectivedate, product2.name, Quantity, UnitPrice, TotalPrice, Order.TotalAmount, Order.Status, ' +
                			' Order.OrderNumber, Line_no__c, Order.Tracking_Number__c, Order.Tracking__c, product2.description, Order.account.name, ' +
                			' order.name, Order.account.ShippingCountry, Order.Sales_Office__r.name, product2.productcode, Order.Account.Id ' + 
                			' FROM orderitem WHERE order.agent__c =\'' + sAgentID +'\'' +
                			' ORDER BY order.effectivedate DESC, Order.id, Line_no__c';
        	List<sObject>  ol = Database.query(sSQL);

        
        	for (sObject sobj:ol) {
                
                if(String.valueOf(sobj.getSobject('Order').get('id')) <> sPrevOrderId){
                    	CustomerOrderList.add(new List<String>{
                    		String.valueOf(sobj.getSobject('Order').get('id')),
                    		String.valueOf(sobj.getSobject('Order').get('effectivedate')),
                    		String.valueOf(sobj.getSobject('Order').get('Status')),
                    		String.valueOf(sobj.getSobject('Order').get('OrderNumber')),
                        	String.valueOf(sobj.getSobject('Order').getSobject('account').get('name')),
                    		'H',
                            String.valueOf(sobj.getSobject('Order').get('TotalAmount')),
                            String.valueOf(sobj.getSobject('Order').get('Tracking_Number__c'))+' ',
                            String.valueOf(sobj.getSobject('Order').get('Tracking__c'))+' ',
                            String.valueOf(sobj.getSobject('Order').get('name')),
                            String.valueOf(sobj.getSobject('Order').getSobject('Sales_Office__r').get('name')),
                            String.valueOf(sobj.getSobject('Order').getSobject('account').get('ShippingCountry'))+' ',
                            String.valueOf(sobj.getSobject('Order').getSobject('account').get('Id')) 
                		});
                    sPrevOrderId  = String.valueOf(sobj.getSobject('Order').get('id'));
                }
                
                CustomerOrderList.add(new List<String>{
                    String.valueOf(sobj.getSobject('Order').get('id')),
                    String.valueOf(sobj.getSobject('Order').get('effectivedate')),
                    String.valueOf(sobj.getSobject('product2').get('name')),    
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    'L',
                    String.valueOf(sobj.get('TotalPrice')),
                    String.valueOf(sobj.get('Line_No__c')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.getSobject('product2').get('productcode'))+' ',
                    ' ',
                    ' ',
                    ' '
                });                  
        
        	}

        return CustomerOrderList;

    }
    
    
    
    @AuraEnabled
    public static List<List<String>> getOrderHistory(String sAccountID) {
        
        List<List<String>> CustomerOrderList = new List<List<String>>();
        String sPrevOrderId = '';
       	String sSQL ='';
                
        	sSQL = 'SELECT Order.id, Order.effectivedate, product2.Id ,product2.name, Quantity, UnitPrice, TotalPrice, Order.TotalAmount, Order.Status, ' +
                			' Order.OrderNumber, Line_no__c, Order.Tracking_Number__c, Order.Tracking__c, product2.description, Order.account.name, ' +
                			' order.name, Order.account.ShippingCountry, Order.Sales_Office__r.name, product2.productcode, Order.Account.Id ' + 
                			' FROM orderitem WHERE order.account.id =\'' + sAccountID +'\'' +
                			' ORDER BY order.effectivedate DESC, Order.id, Line_no__c';
        	List<sObject>  ol = Database.query(sSQL);

        	for (sObject sobj:ol) {
                
                if(String.valueOf(sobj.getSobject('Order').get('id')) <> sPrevOrderId){
                    		CustomerOrderList.add(new List<String>{
                    		String.valueOf(sobj.getSobject('Order').get('id')),
                    		String.valueOf(sobj.getSobject('Order').get('effectivedate')).left(10),
                    		String.valueOf(sobj.getSobject('Order').get('Status')),
                    		String.valueOf(sobj.getSobject('Order').get('OrderNumber')),
                        	String.valueOf(sobj.getSobject('Order').getSobject('account').get('name')),
                    		'H',
                            String.valueOf(sobj.getSobject('Order').get('TotalAmount')),
                            String.valueOf(sobj.getSobject('Order').get('Tracking_Number__c'))+' ',
                            String.valueOf(sobj.getSobject('Order').get('Tracking__c'))+' ',
                            String.valueOf(sobj.getSobject('Order').get('name')),
                            String.valueOf(sobj.getSobject('Order').getSobject('Sales_Office__r').get('name')),
                            String.valueOf(sobj.getSobject('Order').getSobject('account').get('ShippingCountry'))+' ',
                            String.valueOf(sobj.getSobject('Order').getSobject('account').get('Id'))
                             
                		});
                    sPrevOrderId  = String.valueOf(sobj.getSobject('Order').get('id'));
                }
                
                CustomerOrderList.add(new List<String>{
                    String.valueOf(sobj.getSobject('Order').get('id')),
                    String.valueOf(sobj.getSobject('Order').get('effectivedate')),
                    String.valueOf(sobj.getSobject('product2').get('name')),    
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    'L',
                    String.valueOf(sobj.get('TotalPrice')),
                    String.valueOf(sobj.get('Line_No__c')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.getSobject('product2').get('productcode'))+' ',
                    ' ',
                    ' ',
                    ' ',
                    String.valueOf(sobj.getSobject('product2').get('id'))
                });                  
        
        	}

        return CustomerOrderList;

    }
    
    
    @AuraEnabled
    public static List<List<String>> getOrder(String sDocumentID, String sAccountID)  {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Order> sDataSet = new List<Order>(); 
        
       	sSQL = 'SELECT id, name, effectivedate,TotalAmount, Status,OrderNumber, Tracking_Number__c,Tracking__c, account.id, Sales_Office__r.name, ' + 
               'account.name, account.ShippingStreet, account.ShippingCity, account.ShippingState, account.ShippingPostalCode, account.ShippingCountry ' +
               'FROM order WHERE id =\'' + sDocumentID +'\'';
       	sDataSet = Database.query(sSQL);
        
        for (Order sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.get('name')),
                                    String.valueOf(sobj.getSobject('account').get('name')),
                                    String.valueOf(sobj.getSobject('account').get('id')),
              						String.valueOf(sobj.get('OrderNumber')+ ' ').replace('null',''),
                                    String.valueOf(sobj.get('effectivedate')),
                    				String.valueOf(sobj.get('Status')),
                                    String.valueOf(sobj.get('Tracking_Number__c'))+' ',
                            		String.valueOf(sobj.get('Tracking__c'))+' ',
                            		String.valueOf(sobj.getSobject('Sales_Office__r').get('name')),
                                    String.valueOf(sobj.getSobject('account').get('ShippingStreet'))+' ',
                                    String.valueOf(sobj.getSobject('account').get('ShippingCity'))+' ',
                                    String.valueOf(sobj.getSobject('account').get('ShippingPostalCode'))+' ',
                            		String.valueOf(sobj.getSobject('account').get('ShippingCountry'))+' '
            });            
        }
      
        Return sSearchResults;
    }
    
    @AuraEnabled
    public static List<List<String>> getOrderLines(String sDocumentID)  {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Orderitem> sDataSet = new List<Orderitem>(); 
        
       	sSQL = 'SELECT product2.name, product2.id, Quantity, UnitPrice, TotalPrice, Line_no__c,  product2.description, product2.productcode FROM Orderitem WHERE Order.id =\'' + sDocumentID + '\' order by Line_no__c';
       	sDataSet = Database.query(sSQL);
        
        for (Orderitem sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                    String.valueOf(sobj.getSobject('product2').get('name')),    
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('TotalPrice')),
                    String.valueOf(sobj.get('Line_No__c')),
                    String.valueOf(sobj.getSobject('product2').get('description')),
                    String.valueOf(sobj.getSobject('product2').get('productcode')),
                    String.valueOf(sobj.getSobject('product2').get('id'))    
            });            
        }
      
        Return sSearchResults;
    }
    
    
    @AuraEnabled
    public static Id CopyOrder(String sDocumentID, Id sAccountID, String sUser) { 
        
        String sAgentID='';
        String sOrderRecordType='';
        String sOppRecordType='';
        String sQuoteRecordType='';
        
        User userTable = [SELECT AccountId FROM User WHERE Id = :sUser LIMIT 1];
        if(userTable.AccountId != null){
            sAgentID = userTable.AccountId;
        }

        //----------- map record types

        Map<String,String> RTopp = new Map<String,String>();
		RTopp.put('KCD Orders', 'KCD Aftermarket');
		RTopp.put('KJ Orders','KJ Opportunity');
		RTopp.put('KJC Orders','KJC Opportunities');
		RTopp.put('KL OrdersF','KL Fiberline Aftermarket');
		RTopp.put('KL OrdersP','PSG-E Aftermarket');
		RTopp.put('KMX Orders','KMX Opportunities');
		RTopp.put('KSA Orders','KSA Aftermarket');
		RTopp.put('KSD Orders','KSD Opportunities');
		RTopp.put('NML Orders','NML Opportunities');
		RTopp.put('PSG-E Orders','PSG-E Aftermarket');
		RTopp.put('SMH Orders','SMH Opportunities');
		RTopp.put('VK Orders','VK Aftermarket');

        Map<String,String> RTquote = new Map<String,String>();
        RTquote.put('KCD Orders', 'KCD Quotes');
		RTquote.put('KJ Orders', 'KJ Quotes');
		RTquote.put('KJC Orders', 'KJC Quotes');
		RTquote.put('KL OrdersF', 'KL FiberLine Quotes');
		RTquote.put('KL OrdersP', 'KL Process Solutions Quotes');
		RTquote.put('KMX Orders', 'KMX Quotes');
		RTquote.put('KSA Orders', 'KSA Quotes');
		RTquote.put('KSD Orders', 'KSD Quotes');
		RTquote.put('NML Orders', 'NML Quotes');
		RTquote.put('PSG-E Orders', 'PSG-E Quotes');
		RTquote.put('SMH Orders', 'SMH Quotes');
		RTquote.put('VK Orders', 'VK Quotes');

        
        //--------- Select source order header --------------
        
        Order ord1 = [SELECT name, Status, OrderNumber, Sales_Office__r.id, Sales_Office__r.name, division__C, division, recordtype.name  FROM Order WHERE Id = :sDocumentID LIMIT 1];
        
        sOrderRecordType = String.valueOf(ord1.recordtype.name);
        if(String.valueOf(ord1.Sales_Office__r.name)=='Kadant Lamort Process Solutions') {sOrderRecordType = sOrderRecordType + 'P';}
        if(String.valueOf(ord1.Sales_Office__r.name)=='Kadant Lamort Fiberline') {sOrderRecordType = sOrderRecordType + 'F';}
        

        //----------- Create opportunity --------------
        
        sOppRecordType  = String.valueOf(RTopp.get(sOrderRecordType));
        RecordType rt1 = [select id from recordtype where name=:sOppRecordType LIMIT 1];

                
        
        Opportunity opp1 = new Opportunity(
               	name = 'New opp from reorder', 
                accountid = sAccountID, 
                CloseDate=Date.today(),
            	StageName='RFQ',
            	Agent__c = sAgentID,
            	Type='KJ Opportunity',
            	sales_office__c='VKFIN',
            	recordtypeid= rt1.id
        );        
        insert opp1;
        
        
        
        //-------------- Create quote ------------------
        
        Opportunity opp2 = [SELECT Id FROM Opportunity WHERE Id = :opp1.Id LIMIT 1];
        
        sQuoteRecordType  = String.valueOf(RTquote.get(sOrderRecordType));
        RecordType rt2 = [select id, name from recordtype where name=:sQuoteRecordType LIMIT 1];
        
        Quote quote1 = new Quote(
        	Name = 'Quote copy from ' + ord1.OrderNumber,
            OpportunityId = opp1.Id,
            expirationdate = Date.today(),
            //salesoffice__c
            //Agent__c
            recordtypeid= rt2.id
        );
        insert quote1;     
   
        
        //------------- Copy order lines to quote line ---------------
        
        Quote quote2 = [SELECT Id FROM Quote WHERE Id = :Quote1.Id LIMIT 1];       
        
        List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Orderitem> sDataSet = new List<Orderitem>();
        List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();

       	sSQL = 'SELECT product2id, Quantity, UnitPrice, TotalPrice, Line_no__c,  pricebookentryid, description, discount_pct__C FROM Orderitem WHERE Order.id =\'' + sDocumentID + '\' order by Line_no__c';
       	sDataSet = Database.query(sSQL);
        
        for (Orderitem sobj : sDataSet){  
           /*
            lstQLI.add(new QuoteLineItem(
                	QuoteId=String.valueOf(Quote1.Id), 
                    Line_No__c = Double.valueOf(sobj.get('Line_No__c')),                       
                    PriceBookEntryID = String.valueOf(sobj.get('pricebookentryid')),
                    Quantity = Double.valueOf(sobj.get('Quantity')),
                    UnitPrice = Double.valueOf(sobj.get('UnitPrice')), 
                    Discount = Double.valueOf(sobj.get('discount_pct__C')),
                    Comments__c = String.valueOf(sobj.get('description')),
                    Product2Id = String.valueOf(sobj.get('product2id'))
            ));
			*/
        }
        
        
        if(!lstQLI.isEmpty()){
        //    insert lstQLI;
        }

	

        return quote1.Id;

    } 
 
    
    /*######################## FILES RELATED FUNCTIONS #################### */
    
    @AuraEnabled
    public static Id UploadFile(Id cusId, String fileName, String base64Data, String contentType) { 

        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

            
            ContentVersion contentVersion_1 = new ContentVersion(
                Title=fileName, 
                PathOnClient =fileName,
                VersionData = EncodingUtil.base64Decode(base64Data), 
                origin = 'H'
            );
        
        insert ContentVersion_1;
            
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
            
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = cusId;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'I';   
        insert contentlink;     
        
        
        
        //V = Viewer permission. The user can explicitly view but not edit the shared file.
		//C = Collaborator permission. The user can explicitly view and edit the shared file.
  
        return contentVersion_1.Id;
    }
    
    
    @AuraEnabled
    public static List<List<String>> ShowFiles(Id docId) { 

        List<List<String>> sFileList = new List<List<String>>();
        String sSQL='';
        Id sDocumentID;
        
        List<ContentDocumentLink> sDataSet = new List<ContentDocumentLink>(); 
       	sSQL = 'SELECT contentdocumentid FROM ContentDocumentLink WHERE linkedentityid =\'' + docId + '\' ';
       	sDataSet = Database.query(sSQL);
        
        for (ContentDocumentLink sobj : sDataSet){  
        
            sDocumentID = String.valueOf(sobj.get('contentdocumentid'));
            
            ContentVersion sFile = [SELECT title, id, contentbodyid, filetype, description, owner.name, ContentDocumentId FROM ContentVersion WHERE islatest=true and ContentDocumentId=:sDocumentID LIMIT 1];
            
            sFileList.add(new List<String>{
            	String.valueOf(sFile.title),
                String.valueOf(sFile.id),
                String.valueOf(sFile.contentbodyid),                
                String.valueOf(sFile.filetype),
                String.valueOf(sFile.ContentDocumentId),
                String.valueOf(sFile.description),
                String.valueOf(sFile.owner.name)
            });            
        }
        
    	/*
    	select id, contentdocumentid from contentdocumentlink where linkedentityid='0016000001BOdFbAAL'
		select title, description, owner.name, id, contentbodyid from contentversion where islatest=true and ContentDocumentId='06959000001SJGIAA4'
		https://kadant--sand.sandbox.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+substr(contentversion.id,15)+'&operationContext=CHATTER&contentId='+substr(contentversion.contentbodyid,15)
		https://kadant--sand.sandbox.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId=06859000001S0RP&operationContext=CHATTER&contentId=05T59000006A3ml
    	*/
        
        return sFileList;
    }   
    
    /*
    @AuraEnabled
    public static Id AddFilePermission(Id ContentId) { 
    
    	ContentDocumentLink cDocLink = new ContentDocumentLink();
		cDocLink.ContentDocumentId = ContentId;//Add ContentDocumentId
        cDocLink.LinkedEntityId = '0035900000I7e4dAAB'; //Youp portal contact Timber
		cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
		cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        insert cDocLink;
        
        Return ContentId;
    }
    
    
    @AuraEnabled
    public static Id DeleteFilePermission(Id ContentId) { 
      
        ContentDocumentLink cDocLink = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :ContentId and LinkedEntityId = '0035900000I7e4dAAB' LIMIT 1];
		Delete cDocLink;
        
        Return ContentId;
    }
    */
    
    
    /*#################### ADVANCED SEARCH SCREEN RELATED FUNCTIONS ################ */
    
    @AuraEnabled
    public static List<List<String>> searchForParts(String strRecordID, String strObjectName, String searchText, String searchFilter, Map<String,String> SelectedPartMap){
   
       String searchQuery = '';
       String strPartSelected = null;
       String strPreviouslyOrdered = 'N';
       String PreviousPart ='';
       List<Product2> searchResults = new List<Product2>();                   
       List<OrderItem> searchResults3 = new List<OrderItem>(); 
       List<List<String>> searchResultsString = new List<List<String>>();
       Map<String,String> PrevOrderedMap = new Map<String,String>();
       
       
       String sSQL = 'SELECT CurrencyIsoCode, AccountID, pricebook2id FROM ' + strObjectName + ' WHERE Id =\'' + strRecordID +'\'';
       sObject[] MainRec = Database.query(sSQL);
        
       String strJointFields = ' Joint_M_Size__c, Joint_M_Size_UOM__c,Joint_M_Type__c, Joint_M_Thread_Direction__c, ' +
                                ' Joint_P_Size__c, Joint_P_Size_UOM__c,Joint_P_Type__c, Joint_P_Thread_Direction__c, ' +
                                ' Joint_S_Size__c, Joint_S_Size_UOM__c,Joint_S_Type__c, Joint_S_Thread_Direction__c, ' +
                                ' Joint_Nipple_Size__c, Joint_Nipple_Size_UOM__c, Joint_Nipple_Type__c, Joint_Nipple_Thread_Direction__c, ' +
                                ' Joint_Seal_Material__c, ' +
                                ' Joint_Temperature__c, Joint_Temperature_UOM__c, ' +
                                ' Joint_Pressure__c, Joint_Pressure_UOM__c, ';
       
       String strBladeFields = ' BLD_Application__c, BLD_Bevel_Angle__c, BLD_CTL_Machine_Index__c, BLD_Holder_Type__c, ' +
                                ' BLD_KUK_Reference_Code__c, BLD_Length__c, BLD_Machine_No__c, BLD_Material__c, ' +
                                ' BLD_Thickness__c, BLD_Width__c, ';
        
       if(searchFilter.left(7) !='HISTORY'){
            //######### if the search bar is empty, default with database query ############
            if(searchText ==''){
                searchQuery = 'SELECT Id, Name, Description, ProductCode, Drawing_Number__c, Part_Of_Kit__c, Part_Of_Kit_Remarks__c, Unit_of_Measure__c, '+
                    strJointFields +
                    strBladeFields +
                    ' IsActive FROM Product2 WHERE IsActive=true ' + searchFilter +                
                    ' AND Id IN(SELECT Product2Id FROM PricebookEntry WHERE pricebook2id=\'' + MainRec[0].get('pricebook2id') + '\' and currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\')' +
                    ' ORDER BY name LIMIT 150';
                searchResults = Database.query(searchQuery);
            }


            //######### if the search bar is has a value, use the salesforce find function ############
            if(searchText !=''){
                searchQuery = 'FIND \'' + searchText + '\' IN ALL FIELDS RETURNING ' +
                    ' Product2(Id, Name, Description, ProductCode, Drawing_Number__c, Part_Of_Kit__c, Part_Of_Kit_Remarks__c, Unit_of_Measure__c, ' +
                    strJointFields +
                    strBladeFields +
                    ' IsActive WHERE IsActive=true ' + searchFilter +
                    ' AND Id IN(SELECT Product2Id FROM PricebookEntry WHERE pricebook2id=\'' + MainRec[0].get('pricebook2id') + '\' and currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\')' +
                    ' ORDER BY name LIMIT 150)';
                List<List<sObject>> searchResults2 = search.query(searchQuery);
               
                for (List<SObject> sobjs : searchResults2) {
                    for (SObject sobj : sobjs) { searchResults.add((Product2) sobj); }
                }
            }


            //######### collect selling history to highlight previously ordered parts #############
            
            searchQuery = 'SELECT product2.Id FROM orderitem WHERE product2.IsActive=true ' +  
                    ' AND order.accountid=\'' + MainRec[0].get('AccountID') + '\' ' +
                    ' ORDER BY product2.Name, order.effectivedate DESC';
            // add include
            searchResults3 = Database.query(searchQuery);
            
            PreviousPart ='';
            for (OrderItem sobj3 : searchResults3){                 
                                                
                if(PreviousPart != String.valueOf(sobj3.getSobject('Product2').get('Id')) ){
                        PrevOrderedMap.put(String.valueOf(sobj3.getSobject('Product2').get('Id')), String.valueOf(sobj3.getSobject('Product2').get('Id')));
                }
                
                PreviousPart = String.valueOf(sobj3.getSobject('Product2').get('Id'));
            }

            //######### prepare array for return value ############
            for (Product2 sobj : searchResults){
                    if(SelectedPartMap.containsKey(sobj.Id)) {strPartSelected = 'PartSelected';} else {strPartSelected = null;}
                    if(PrevOrderedMap.containsKey(sobj.Id)) {strPreviouslyOrdered = 'Y';} else {strPreviouslyOrdered = 'N';}
                
                    searchResultsString.add(new List<String>{
                            sobj.Id,
                            String.valueOf(sobj.get('Name')),
                            String.valueOf(sobj.get('Description'))+' ',
                            String.valueOf(sobj.get('ProductCode')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_M_Size__c')))+sobj.get('Joint_M_Size_UOM__c')+' '+sobj.get('Joint_M_Type__c')+' '+sobj.get('Joint_M_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_P_Size__c')))+sobj.get('Joint_P_Size_UOM__c')+' '+sobj.get('Joint_P_Type__c')+' '+sobj.get('Joint_P_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_S_Size__c')))+sobj.get('Joint_S_Size_UOM__c')+' '+sobj.get('Joint_S_Type__c')+' '+sobj.get('Joint_S_Thread_Direction__c')).replace('null',''),
                            String.valueOf(sobj.get('Joint_Seal_Material__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Temperature__c')))+sobj.get('Joint_Temperature_UOM__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.get('Joint_Pressure__c')))+sobj.get('Joint_Pressure_UOM__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Application__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Holder_Type__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Length__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Material__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Thickness__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('BLD_Width__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.get('Joint_Nipple_Size__c')))+sobj.get('Joint_Nipple_Size_UOM__c')+' '+sobj.get('Joint_Nipple_Type__c')+' '+sobj.get('Joint_Nipple_Thread_Direction__c')).replace('null',''),
                            String.valueOf(sobj.get('Drawing_Number__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('Part_Of_Kit__c')+' ').replace('null',''), 
                            String.valueOf(sobj.get('Part_Of_Kit_Remarks__c')+' ').replace('null',''),   
                            String.valueOf(sobj.get('Unit_of_Measure__c')+' ').replace('null',''),
                            strPreviouslyOrdered,  
                            strPartSelected
                            
                    });
                    //---the strPerviouslyOrdered,strPartSelected booleans are !item[21] and !item[22] in resultset of the component
            }
       } else {
           //######### collect customer selling history ###########
           //
           //
           String searchTextSQL = searchFilter.replace('HISTORY','');
           
           String strJointFldExplicit = ' product2.Joint_M_Size__c, product2.Joint_M_Size_UOM__c, product2.Joint_M_Type__c, product2.Joint_M_Thread_Direction__c, ' +
                                ' product2.Joint_P_Size__c, product2.Joint_P_Size_UOM__c, product2.Joint_P_Type__c, product2.Joint_P_Thread_Direction__c, ' +
                                ' product2.Joint_S_Size__c, product2.Joint_S_Size_UOM__c, product2.Joint_S_Type__c, product2.Joint_S_Thread_Direction__c, ' +
                                ' product2.Joint_Nipple_Size__c, product2.Joint_Nipple_Size_UOM__c, product2.Joint_Nipple_Type__c, product2.Joint_Nipple_Thread_Direction__c, ' +
                                ' product2.Joint_Seal_Material__c, product2.Joint_Temperature__c, product2.Joint_Temperature_UOM__c, ' +
                                ' product2.Joint_Pressure__c, product2.Joint_Pressure_UOM__c, ';
       
            String strBladeFldExplicit = ' product2.BLD_Application__c, product2.BLD_Bevel_Angle__c, product2.BLD_CTL_Machine_Index__c, ' +
                                ' product2.BLD_Holder_Type__c, product2.BLD_KUK_Reference_Code__c, product2.BLD_Length__c, ' + 
                                ' product2.BLD_Machine_No__c, product2.BLD_Material__c, product2.BLD_Thickness__c, product2.BLD_Width__c, ';
           
           If(searchText !=''){
               //for multiple words we can split the field by spaces into an array and add AND filters sequential...
               //version 1 just support one word
               searchTextSQL = searchTextSQL + ' AND (product2.Name like \'%'+searchText+'%\' OR product2.Description like \'%'+searchText+'%\')';
           }
           
            searchQuery = 'SELECT product2.Id, product2.Name, product2.Description, product2.ProductCode, product2.Drawing_Number__c, order.name, order.effectivedate, UnitPrice, Customer_Item_Number__c, Unit_of_Measure__c, '+
                    strJointFldExplicit +
                    strBladeFldExplicit +
                    ' order.currencyisocode, product2.IsActive FROM orderitem WHERE product2.IsActive=true ' +  
                    ' AND order.sale_type__c!=\'ICI\'' +
                    ' AND order.accountid=\'' + MainRec[0].get('AccountID') + '\' ' +
                    searchTextSQL + 
                    ' ORDER BY product2.Name, order.effectivedate DESC';
            
           searchResults3 = Database.query(searchQuery);
           
            PreviousPart ='';
            for (OrderItem sobj : searchResults3){                  
                
                    if(SelectedPartMap.containsKey( String.valueOf(sobj.getSobject('Product2').get('Id')) )) {strPartSelected = 'PartSelected';} else {strPartSelected = null;}
                                    
                    if(PreviousPart != String.valueOf(sobj.getSobject('Product2').get('Id')) )
                    {
                        searchResultsString.add(new List<String>{
                            String.valueOf(sobj.getSobject('Product2').get('Id')),
                            String.valueOf(sobj.getSobject('Product2').get('Name'))+' ',
                            String.valueOf(sobj.getSobject('Product2').get('Description'))+' ',
                            String.valueOf(sobj.getSobject('Product2').get('ProductCode')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('order').get('name')),
                            String.valueOf(sobj.getSobject('order').get('effectivedate')).left(10),
                            String.valueOf( String.valueOf(Decimal.valueOf(Double.valueOf(sobj.get('UnitPrice'))).setScale(2))+' '+sobj.getSobject('order').get('currencyisocode')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_M_Size__c')))+sobj.getSobject('Product2').get('Joint_M_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_M_Type__c')+' '+sobj.getSobject('Product2').get('Joint_M_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_P_Size__c')))+sobj.getSobject('Product2').get('Joint_P_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_P_Type__c')+' '+sobj.getSobject('Product2').get('Joint_P_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_S_Size__c')))+sobj.getSobject('Product2').get('Joint_S_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_S_Type__c')+' '+sobj.getSobject('Product2').get('Joint_S_Thread_Direction__c')).replace('null',''),
                            String.valueOf(String.valueOf(Double.valueOf(sobj.getSobject('Product2').get('Joint_Nipple_Size__c')))+sobj.getSobject('Product2').get('Joint_Nipple_Size_UOM__c')+' '+sobj.getSobject('Product2').get('Joint_Nipple_Type__c')+' '+sobj.getSobject('Product2').get('Joint_Nipple_Thread_Direction__c')).replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('Joint_Seal_Material__c')+' ').replace('null',''),
                            String.valueOf(String.valueOf(Integer.valueOf(sobj.getSobject('Product2').get('Joint_Temperature__c')))+sobj.getSobject('Product2').get('Joint_Temperature_UOM__c')+' '   ).replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Bevel_Angle__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Length__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Material__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Thickness__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('BLD_Width__c')+' ').replace('null',''),
                            String.valueOf(sobj.getSobject('Product2').get('Drawing_Number__c')+' ').replace('null',''),
                            String.valueOf(sobj.get('Customer_Item_Number__c')+' ').replace('null',''),
                            String.valueOf(' '),    
                            String.valueOf(sobj.get('Unit_of_Measure__c')+' ').replace('null','') ,
                            strPreviouslyOrdered,
                            strPartSelected
                               
                        });
                        //---the strPerviouslyOrdered,strPartSelected booleans are !item[21] and !item[22] in resultset of the component
                    }
                
                    PreviousPart = String.valueOf(sobj.getSobject('Product2').get('Id'));
                }
       }
        return searchResultsString;
    }
   
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        //system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
        fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
    public static List<List<String>> showBomParts(String PartID){
        
            String searchQuery = '';
            String strPartSelected = null;
        	
                
            List<List<String>> searchResultsString = new List<List<String>>();     
            List<Bill_of_Material__c> searchResults3 = new List<Bill_of_Material__c>(); 
        
            searchQuery = 'SELECT Child_Product__c, Sequence__c, Qty_Per__c, Child_Part_ID__c, Child_Part_Description__c, Drw_Ref_No__c '+
                    ' FROM Bill_of_Material__c WHERE parent_product__c=\'' + PartID + '\' ORDER BY Sequence__c';

            searchResults3 = Database.query(searchQuery);
           
            for (Bill_of_Material__c sobj : searchResults3){                    
                
                    //if(SelectedPartMap.containsKey( String.valueOf(sobj.get('Child_Product__c')) )) {strPartSelected = 'PartSelected';} else {strPartSelected = null;}
                	String DrwRef = '';
                	if(String.valueOf(sobj.get('Drw_Ref_No__c'))!='null') {DrwRef = String.valueOf(sobj.get('Drw_Ref_No__c'));}
                 
                    searchResultsString.add(new List<String>{
                            String.valueOf(sobj.get('Child_Product__c')),
                            String.valueOf(sobj.get('Sequence__c'))+' ',
                            String.valueOf(sobj.get('Qty_Per__c'))+' ',
                            String.valueOf(sobj.get('Child_Part_ID__c'))+' ',
                            String.valueOf(sobj.get('Child_Part_Description__c'))+' ',
                            DrwRef,
                            strPartSelected
                    });

            }

            return searchResultsString;
    }
    
    @AuraEnabled
    public static List<List<String>> GetBladeDetails(String sRecordTypeId){
        
            String searchQuery = '';
            String strPartSelected = null;
        
            List<List<String>> searchResultsString = new List<List<String>>();     
            List<Blade_Details__c> searchResults = new List<Blade_Details__c>(); 
            
            
            searchQuery = 'SELECT Blade_Name__r.id, Blade_Name__r.name, id, width__c, thickness__c,'
                    + ' ICP_Per_Unit__c, Price_Per_Unit__c, CurrencyIsoCode, unit_of_measure__c,' 
                    + 'Blade_Name__r.Finishing_Surcharge_Full__c,  Blade_Name__r.Finishing_Surcharge_Plain__c,'
                    + 'Blade_Name__r.Packaging_Surcharge__c, Blade_Name__r.Material_Group__c, Blade_Name__r.GBPtoEUR__c, Blade_Name__r.GBPtoSEK__c, Blade_Name__r.GBPtoUSD__c,bevel_angle__c'
                    + ' FROM Blade_details__c '
                    + ' WHERE Blade_Name__r.RecordTypeId=\'' + sRecordTypeId + '\' and Blade_Name__r.standard__c=True '
                    + ' and Blade_Name__r.active__c=True and ICP_Per_Unit__c > 0 ORDER BY Blade_Name__r.name, width__c, thickness__c';
            
            searchResults = Database.query(searchQuery);
           
            for (Blade_Details__c sobj : searchResults){                    
                                                  
                    searchResultsString.add(new List<String>{
                            String.valueOf(sobj.getSobject('Blade_Name__r').get('id')),
                            String.valueOf(sobj.getSobject('Blade_Name__r').get('name')),
                            String.valueOf(sobj.get('id')),
                            String.valueOf(Double.valueOf(sobj.get('width__c'))),
                            String.valueOf(Double.valueOf(sobj.get('thickness__c'))),
                            String.valueOf(Double.valueOf(sobj.get('ICP_Per_Unit__c'))),
                            String.valueOf(Double.valueOf(sobj.get('Price_Per_Unit__c'))),
                            String.valueOf(sobj.get('CurrencyIsoCode')),
                            String.valueOf(sobj.get('unit_of_measure__c')),
                            String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('Finishing_Surcharge_Full__c'))).replace('null','0'),
                            String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('Finishing_Surcharge_Plain__c'))).replace('null','0'), 
                            String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('Packaging_Surcharge__c'))).replace('null','0'),
                            String.valueOf(sobj.getSobject('Blade_Name__r').get('Material_Group__c')),
                            String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('GBPtoEUR__c'))).replace('null','1'),
                            String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('GBPtoSEK__c'))).replace('null','1'),
                            String.valueOf(Double.valueOf(sobj.getSobject('Blade_name__r').get('GBPtoUSD__c'))).replace('null','1'),
                            String.valueOf(sobj.get('bevel_angle__c')).replace('null',' ')
                    });

            }

            /*
              ,

                            String.valueOf(Double.valueOf(sobj.get('Price_Per_Unit__c'))).replace('null','0'),

             */
        
            system.debug(searchResultsString);
            return searchResultsString;
    }
    
    
    @AuraEnabled
    public static List<List<String>> getQuoteDetailsPage2(String sDocumentID)
    {     
      	List<List<String>> sSearchResults = new List<List<String>>();
        String sSQL = '';
        List<Quote> sDataSet = new List<Quote>(); 
        
       	sSQL = 'select RecordType.Name, RecordTypeId, Pricebook2Id, CurrencyIsoCode, Lead_Time__c, Lead_Time_UOM__c, Sales_Office__c, Sales_Office_Picklist__c, ShippingCountry, Account.Country_ID__c from quote where id=\'' + sDocumentID + '\'';
       	sDataSet = Database.query(sSQL);
        
        for (Quote sobj : sDataSet){  
        
            sSearchResults.add(new List<String>{
                        			String.valueOf(sobj.getSobject('RecordType').get('name')),
                					String.valueOf(sobj.get('RecordTypeId')),
              						String.valueOf(sobj.get('Pricebook2Id')),
                                    String.valueOf(sobj.get('CurrencyIsoCode')),
                                    String.valueOf(sobj.get('Lead_Time__c')),
                                    String.valueOf(sobj.get('Lead_Time_UOM__c')),
                                    String.valueOf(sobj.get('Sales_Office__c')),
                                    String.valueOf(sobj.get('Sales_Office_Picklist__c')),
                                    String.valueOf(sobj.get('ShippingCountry')),
                                    String.valueOf(sobj.getSobject('Account').get('Country_ID__c'))
            });            
        }
    
        Return sSearchResults;
    }    
    
        @AuraEnabled
    public static List<List<String>> GetCustomerPricing(String strRecordID, String strObjectName, Map<String,String> SelectedPartMap){

        List<List<String>> CustomerPricingList = new List<List<String>>();
        String sSectionHasData = '0';

        String selectedParts = '@';
        for (String prod2ID:SelectedPartMap.keySet()) {
            
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        selectedParts = selectedParts.Replace('@,','');
        
        system.debug('SELECTED PARTS ---->' + selectedParts );
        
        String sSQL = 'SELECT accountId, account.ParentTextID__c, CurrencyIsoCode, account.Name, account.ParentTextName__c FROM ' 
                + strObjectName + ' WHERE Id =\'' + strRecordID +'\' LIMIT 1';
        List<sObject>  q = Database.query(sSQL);
        //system.debug(q);

        String sCustomerID = String.valueOf(q[0].get('accountId'));
        String sParentID = String.valueOf( q[0].getSobject('Account').get('ParentTextID__c') );
     
        String selectedAccountId = '\'' + sCustomerID + '\'';
        String selectedParentId ='';
        if(sParentID !='NA'){ selectedParentId = ',\'' + sParentID + '\''; }
        String selectedAccounts = selectedAccountId + selectedParentId;
           
        sSQL = 'select product__c, customer_item__c, price__c, price_agreement_header__r.Account__c  FROM Price_Agreement_detail__c WHERE ' 
                + ' CurrencyIsoCode=\'' + q[0].Get('CurrencyIsoCode') + '\'' 
                + ' AND Product__c in(' + selectedParts + ')' 
                + ' AND price_agreement_header__r.Account__c in(' + selectedAccounts + ') ' 
                + ' ORDER BY product__c';
        List<Price_Agreement_detail__c> pbe = Database.query(sSQL);
        
        for (Price_Agreement_detail__c sobj : pbe){
            
            if(String.valueOf(sobj.price_agreement_header__r.Account__c) == sCustomerID){                      
                CustomerPricingList.add(new List<String>{
                    String.valueOf(sobj.get('product__c')),
                    'Account agreement: ',
                    String.valueOf(q[0].getSobject('Account').get('Name')),
                    String.valueOf(sobj.get('customer_item__c'))+' ',
                    'dummy',
                    String.valueOf(sobj.get('price__c')),
                    String.valueOf(q[0].get('CurrencyIsoCode'))
                });
                if(String.valueOf(sobj.get('price__c'))!=''){sSectionHasData = '1';}
            } else{
                CustomerPricingList.add(new List<String>{
                    String.valueOf(sobj.get('product__c')),
                    'Parent agreement: ',
                    String.valueOf(q[0].getSobject('Account').get('ParentTextName__c'))+' ',
                    String.valueOf(sobj.get('customer_item__c'))+' ',
                    'dummy',
                    String.valueOf(sobj.get('price__c')),
                    String.valueOf(q[0].get('CurrencyIsoCode'))
                });
                if(String.valueOf(sobj.get('price__c'))!=''){sSectionHasData = '1';}
            }
        }
        
        for (String prod2ID:SelectedPartMap.keySet()) {
            
            String prod2IDsource = prod2ID;
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            
            QuoteLineItem[] ql = [SELECT Quote.Quote_number__c, Quote.Quote_Date__c, Quantity, UnitPrice, currencyisocode, internal_remarks__c, id FROM quotelineitem WHERE Quote.Opportunity.AccountId=:sCustomerID AND Product2Id=:prod2ID ORDER BY Quote.Quote_Date__c DESC LIMIT 5];
            for (QuoteLineItem sobj:ql) {
                CustomerPricingList.add(new List<String>{
                    String.valueOf(prod2IDsource),
                    'Quote history: ',
                    String.valueOf(sobj.Quote.Quote_number__c)+' ',
                    String.valueOf(sobj.Quote.Quote_Date__c),
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('currencyisocode')),
                    String.valueOf(sobj.get('internal_remarks__c')+ ' ').replace('null',''),
                    String.valueOf(sobj.get('id'))
                });
                if(String.valueOf(sobj.get('UnitPrice'))!=''){sSectionHasData = '1';}
            }
            
            OrderItem[] ol = [SELECT Order.Name, Order.effectivedate, Quantity, UnitPrice, currencyisocode FROM orderitem WHERE order.AccountId=:sCustomerID AND Product2Id=:prod2ID and order.Sale_Type__c in('D','ICO') ORDER BY order.effectivedate DESC LIMIT 5];
            for (OrderItem sobj:ol) {
                CustomerPricingList.add(new List<String>{
                    String.valueOf(prod2IDsource),
                    'Order history: ',
                    String.valueOf(sobj.Order.Name)+' ',
                    String.valueOf(sobj.Order.effectivedate),
                    String.valueOf(sobj.get('Quantity')),
                    String.valueOf(sobj.get('UnitPrice')),
                    String.valueOf(sobj.get('currencyisocode'))
                });
                if(String.valueOf(sobj.get('UnitPrice'))!=''){sSectionHasData = '1';}
            }

        
            CustomerPricingList.add(new List<String>{
                String.valueOf(prod2IDsource),
                'Has content: ',
                'dummy',
                'dummy',
                'dummy',
                sSectionHasData,
                'dummy'
            });
            
            sSectionHasData = '0';
        }
                
        Return CustomerPricingList;
    }

    
    @AuraEnabled
    public static List<List<String>> GetProductPricing(String strRecordID, String strObjectName, Map<String,String> SelectedPartMap, Map<String,String> SelectedPartMapQty){

        //map of selected parts sorted by product ID
        Map<String,List<String>> DocLinesListMap = new Map<String,List<String>>();
        
        //maps containing divisional selling price by product ID 
        Map<String,String> DivisionPriceMap = new Map<String,String>();
        Map<String,String> DivisionPriceListMap = new Map<String,String>();
        
        //map of selected parts sorted by order of selection
        List<List<String>> DocLinesList = new List<List<String>>();
        
        String sSQL = 'SELECT Pricebook2ID, CurrencyIsoCode, Account_Standard_Discount__c, accountid FROM ' + strObjectName + ' WHERE Id =\'' + strRecordID +'\' LIMIT 1';
        sObject[] MainRec = Database.query(sSQL); 

        String DefaultDiscount = '0';        
        if(MainRec[0].get('Account_Standard_Discount__c')!=null){
            DefaultDiscount = String.valueOf(MainRec[0].get('Account_Standard_Discount__c')).replace('null','0');
        }
         
        String selectedParts = '@';
        for (String prod2ID:SelectedPartMap.keySet()) {
            //remove -dup1, -dup2 etc. from the product2 ID. Max 50 duplicate parts
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            selectedParts = selectedParts + ',\''+ prod2ID + '\'';
        }
        selectedParts = selectedParts.Replace('@,','');
 
        
        //############## Get price from divisional price list 
        
        sSQL = 'SELECT Division_Price_List__r.name, Product__c, Product__r.name, Price__c, CurrencyIsoCode '+
            	' FROM Division_Price_List_Item__c where product__c in(' + selectedParts + ')'+
            	' AND currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\' and IsDeleted=false ' +
            	' and Division_Price_List__r.active__c=true and Division_Price_List__c in ' +
            	' (select Division_Price_List__c from account_division_price_list__c where account_division__r.account__c=\'' + MainRec[0].get('accountid') + '\')';
        List<Division_Price_List_Item__c> ppli = Database.query(sSQL);

        for (Division_Price_List_Item__c sobj2 : ppli){
            DivisionPriceMap.put(String.valueOf(sobj2.get('Product__c')), String.valueOf(sobj2.get('Price__c')) );
            DivisionPriceListMap.put(String.valueOf(sobj2.get('Product__c')), String.valueOf(sobj2.getSobject('Division_Price_List__r').get('name')) );
        }
        
        
       	//############ Get prices from standard price list
       	
        sSQL = 'SELECT Product2Id, Product2.Name, Product2.Description, unitprice, icp_price__c, Product2.No_Approval_Required__c, Product2.PSG_E_Dummy__c, Product2.Price_Reference_Document_ID__c, Product2.Product_Line__c FROM PricebookEntry WHERE isactive=true  AND Product2Id in(' +
                selectedParts + ')'+
                ' AND currencyisocode=\'' + MainRec[0].get('CurrencyIsoCode') + '\'' +
                ' AND Pricebook2ID=\''+ MainRec[0].get('Pricebook2ID') + '\'' +
                ' ORDER BY Product2.name';
        List<PricebookEntry> pbe = Database.query(sSQL);
      
        String ApplyDiscount = '0';
        String UnitPrice = '0';
        String IcpPrice = '0';
        String DivPriceList = 'None';
        for (PricebookEntry sobj : pbe){
            
            if(sobj.Product2.No_Approval_Required__c==True){ ApplyDiscount='0'; } else { ApplyDiscount = DefaultDiscount;}
            if(DivisionPriceMap.containsKey( String.valueOf(sobj.get('Product2Id')) )) {
                UnitPrice = String.valueOf(DivisionPriceMap.get( String.valueOf(sobj.get('Product2Id')) ));
                DivPriceList = String.valueOf(DivisionPriceListMap.get( String.valueOf(sobj.get('Product2Id')) ));
            } 
            else {
                UnitPrice = String.valueOf(sobj.get('unitprice'));
                IcpPrice = String.valueOf(sobj.get('icp_price__c'));
            	DivPriceList = 'None';
                system.debug(IcpPrice);
                
            }
 
            DocLinesListMap.put(String.valueOf(sobj.get('Product2Id')),new List<String>{
                String.valueOf(sobj.get('Product2Id')),
                String.valueOf(sobj.Product2.Name)+' ',
                String.valueOf(sobj.Product2.Description)+' ',
                UnitPrice,
                String.valueOf(MainRec[0].get('CurrencyIsoCode')),                
                String.valueOf(SelectedPartMapQty.get(String.valueOf(sobj.get('Product2Id')))),
                ApplyDiscount,
                DivPriceList,
                String.valueOf(sobj.Product2.PSG_E_Dummy__c),
                String.valueOf(sobj.Product2.Price_Reference_Document_ID__c),
                IcpPrice,
                String.valueOf(sobj.Product2.Product_Line__c)    
            });      
        
        }
        
        system.debug('DOCLINELISTMAP-->'+DocLinesListMap);
        
        //re-sort DocLinesListMap in order of selection
        for (String prod2ID:SelectedPartMap.keySet()) {
            
            String prod2IDsource = prod2ID;
            system.debug('prod2IDsource-->'+prod2IDsource);
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }
            //DocLinesList.add(DocLinesListMap.get(String.valueOf(prod2IDclean)));
            
            system.debug('prod2ID-->'+prod2ID);
            system.debug('Map entry-->'+DocLinesListMap.get(String.valueOf(prod2ID)));
                    
            DocLinesList.add(new List<String>{
                    String.valueOf(prod2IDsource),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[1]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[2]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[3]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[4]),               
                    String.valueOf(SelectedPartMapQty.get(String.valueOf(prod2IDsource))),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[6]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[7]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[8]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[10]),
                    String.valueOf(DocLinesListMap.get(String.valueOf(prod2ID))[11])    
              });
            
        }
        
        system.debug('DOCLINELIST-->'+DocLinesList);
        
        Return DocLinesList;
    }

    
    
    @AuraEnabled
    public static boolean AddQuoteLines(String strQuoteRecordID, String strQuotePB, String strQuoteCurr, String strQuoteRecType, Map<String,String> SelectedPartMap, String lineQTY, String lineUP, String lineDC, String lineSPEC, String lineLT, String lineNDO, String lineSCO){
   
        Decimal nLine_no = 0;
        Decimal nQuantity = 1;
        Decimal nUnitPrice = 0;
        String tmpKey ='';
        String tmpVal ='';
        List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();
		system.debug(lineQTY);
        system.debug(lineNDO); 
        system.debug(lineSCO);
            
        //######### line quantities
        Map<string, Decimal> lineQTYlist = new Map<string, Decimal>();
        List<Object> lineQTYobjects = (List<Object>)System.JSON.deserializeUntyped(lineQTY);
        for (Object lineQTYobject : lineQTYobjects) {
            system.debug(String.valueof(lineQTYobject));
            lineQTYlist.put(String.valueof(lineQTYobject).split(',')[0].replace('key=qty','').replace('{',''), Decimal.valueOf(String.valueof(lineQTYobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        
        //######### line prices
        Map<string, Decimal> lineUPlist = new Map<string, Decimal>();
        List<Object> lineUPobjects = (List<Object>)System.JSON.deserializeUntyped(lineUP);
        for (Object lineUPobject : lineUPobjects) {
            system.debug(String.valueof(lineUPobject));
            lineUPlist.put(String.valueof(lineUPobject).split(',')[0].replace('key=up','').replace('{',''), Decimal.valueOf(String.valueof(lineUPobject).split(',')[1].replace(' value=','').replace('}','')));
        }
      
        
        //######### line disc
        Map<string, Decimal> lineDClist = new Map<string, Decimal>();
        List<Object> lineDCobjects = (List<Object>)System.JSON.deserializeUntyped(lineDC);
        for (Object lineDCobject : lineDCobjects) {
            system.debug(String.valueof(lineDCobject));
            lineDClist.put(String.valueof(lineDCobject).split(',')[0].replace('key=disc','').replace('{',''), Decimal.valueOf(String.valueof(lineDCobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        //######### line leadtimes
        Map<string, Decimal> lineLTlist = new Map<string, Decimal>();
        List<Object> lineLTobjects = (List<Object>)System.JSON.deserializeUntyped(lineLT);
        for (Object lineLTobject : lineLTobjects) {
            system.debug(String.valueof(lineLTobject));
            lineLTlist.put(String.valueof(lineLTobject).split(',')[0].replace('key=lt','').replace('{',''), Decimal.valueOf(String.valueof(lineLTobject).split(',')[1].replace(' value=','').replace('}','')));
        }
        
        //######### line Natureza de Operacao (KSA)
        Map<string, String> lineNDOlist = new Map<string, String>();
        List<Object> lineNDOobjects = (List<Object>)System.JSON.deserializeUntyped(lineNDO);
        for (Object lineNDOobject : lineNDOobjects) {
            system.debug(String.valueof(lineNDOobject));
            lineNDOlist.put(String.valueof(lineNDOobject).split(',')[0].replace('key=ndo','').replace('{',''), String.valueOf(String.valueof(lineNDOobject).split(',')[1].replace(' value=','').replace('}','')));
        } 
        system.debug(lineNDOlist);
        //######### line Service Code (KSA)
        Map<string, String> lineSCOlist = new Map<string, String>();
        List<Object> lineSCOobjects = (List<Object>)System.JSON.deserializeUntyped(lineSCO);
        for (Object lineSCOobject : lineSCOobjects) {
            system.debug(String.valueof(lineSCOobject));
            lineSCOlist.put(String.valueof(lineSCOobject).split(',')[0].replace('key=sco','').replace('{',''), String.valueOf(String.valueof(lineSCOobject).split(',')[1].replace(' value=','').replace('}','')));
        }   
        //######### get quote line specs
        String Specs='';
        String lineSpecs='';
        Map<String, Object> lineSPECobject = (Map<String, Object>) JSON.deserializeUntyped(lineSPEC.replace('[','').replace(']',''));
        
        String prodid = String.valueof(lineSPECobject.get('prodid'));
        //system.debug(prodid);
        
        Specs = 'Material: ' + String.valueof(lineSPECobject.get('material')) +'\n';
        Specs = Specs + 'Width: ' + String.valueof(lineSPECobject.get('width')) +' MM \n';
        Specs = Specs + 'Length: ' + String.valueof(lineSPECobject.get('length')) +' MM\n';
        Specs = Specs + 'Thickness: ' + String.valueof(lineSPECobject.get('thickness')) +' MM\n';
        Specs = Specs + 'Bevel angle: ' + String.valueof(lineSPECobject.get('bevel'));
        Specs = Specs + 'Finishing: ' + String.valueof(lineSPECobject.get('fin'));
        
        system.debug(Specs);
        
        //######### get quote header and line details
        QuoteLineItem[] ql = [ SELECT Line_No__c FROM QuoteLineItem WHERE QuoteId=:strQuoteRecordID AND Line_No__c > 0 ORDER BY Line_No__c DESC LIMIT 1 ];
        if(!ql.isEmpty()){ 
            nLine_no = ql[0].Line_No__c;
        }
        
        //######### insert quote lines       
        
        for (String prod2ID:SelectedPartMap.keySet()) {
            
            String prod2IDsource = prod2ID;
            //system.debug('prod2IDsource-->'+prod2IDsource);
            
            //remove -dup1, -dup2 etc. from the product2 ID
            for (Integer i = 0; i < 50; i++) {
                    prod2ID = prod2ID.replace('-dup'+String.valueOf(i),'');
            }

            lineSpecs='';
            if(String.valueof(prod2IDsource)==prodid){lineSpecs=Specs;} 
            //system.debug(String.valueof(prod2ID));
           
            nLine_no = nLine_no+1;
            PricebookEntry[] pb = [ SELECT Id FROM PricebookEntry WHERE Pricebook2Id=:strQuotePB AND Product2Id=:prod2ID AND CurrencyIsoCode=:strQuoteCurr LIMIT 1];
			system.debug(lineSCOlist.get(prod2IDsource));
            if(!pb.isEmpty()){
                if(strQuoteRecType == 'KSA Quotes'){
                    if(lineSCOlist.get(prod2IDsource)!='None'){
                			lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2IDsource),
                            UnitPrice = lineUPlist.get(prod2IDsource), 
                            Discount = lineDClist.get(prod2IDsource),
                            Lead_Time__c = lineLTlist.get(prod2IDsource),
                            Nature_of_Transaction__c = lineNDOlist.get(prod2IDsource),                 
                            Service_Code__c = lineSCOlist.get(prod2IDsource),                  
                            Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );
               		}
                    else{
                      lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2IDsource),
                            UnitPrice = lineUPlist.get(prod2IDsource), 
                            Discount = lineDClist.get(prod2IDsource),
                            Lead_Time__c = lineLTlist.get(prod2IDsource),
                            Nature_of_Transaction__c = lineNDOlist.get(prod2IDsource),                 
 							Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );  
                    }
                }
                else{
                lstQLI.add(new QuoteLineItem(QuoteId=strQuoteRecordID, 
                            Line_No__c = nLine_no,                       
                            PriceBookEntryID = pb[0].Id,
                            Quantity = lineQTYlist.get(prod2IDsource),
                            UnitPrice = lineUPlist.get(prod2IDsource), 
                            Discount = lineDClist.get(prod2IDsource),
                            Lead_Time__c = lineLTlist.get(prod2IDsource),
                            Comments__c = lineSpecs,
                            Product2Id = prod2ID)
                          );   
                }
            }
        }
        
        if(!lstQLI.isEmpty()){
            insert lstQLI;
        }

        return true;
    }    
    
    
    
    /*######################## NEARBY MAP RELATED FUNCTIONS #################### */
  
    @AuraEnabled 
    public static List<Account> getCenter(Id accountId){
        
        //String sSQL='';
         
        //sSQL = 'select id, shippinglatitude, shippinglongitude from account where id=\'' + accountId + '\'';
       	//List<Account> centerlist = Database.query(sSQL);
        
        List<Account> centerlist = [select id, shippinglatitude, shippinglongitude from account where id = :accountId];

        system.debug(centerlist);
        return centerlist;
    }
    
    	@AuraEnabled
    public static List<Account> getNearbyCustomers(Id accountId, Integer maxDistance, Boolean metric, Boolean prioRatings, Boolean prioRanks, Boolean includeLeads, Boolean myLocations) {
		 system.debug(accountId);
         system.debug(maxDistance);
         system.debug(metric);
         system.debug('leads?' + includeLeads);
         system.debug('mine?' + myLocations);
         decimal centerlat = 0;
         decimal centerlong = 0;
         string acctrecordtype = '';
         string acctrating = '';
         string acctranking = '';
         string searchfilter = '';
         string searchstring = '';
         Id currentUser = UserInfo.getUserId();
        // Id theId = accountId;
        //Schema.sObjectType objType = recordId.getSObjectType();
        string theobject = 'Account'; 
         
         
         List<sObject> locations = new List<sObject>();
         

             List<Account> acctlist = [select id, shippinglatitude, shippinglongitude, recordtype.name, rating, strategex_rank__c, Website from account where id= :accountId limit 1];
            
             for(Account a: acctlist){ 
            centerlat = a.shippinglatitude;
            centerlong = a.shippinglongitude;
            acctrecordtype = a.recordtype.name;
            acctrating = a.rating;
            acctranking = a.Strategex_Rank__c;
            } 


         system.debug(acctrecordtype);
         //if(acctrecordtype == 'Kadant Europe Accounts'){
         List<String> rankingCategories = new List<String>{'A','B','BB','BLV','BMV','BHV','ND','','TS','W','RF'};
         List<String> ratingCategories = new List<String>{'Farming/Nurturing','Growth/New Business','Low Priority/Call instead of Visit',''};
         List<String> allowedStatuses = new List<String>{'Undetermined','Qualified-Hot'};
         if(prioRatings ==true){
             ratingCategories.clear(); 
             ratingCategories.add('Farming/Nurturing');
             ratingCategories.add('Growth/New Business');
            }
         if(prioRanks ==true){
            rankingCategories.clear(); 
            rankingCategories.add('A');
            rankingCategories.add('TS');
            rankingCategories.add('W');
            rankingCategories.add('RF');
             }
         system.debug(ratingCategories);
         system.debug(rankingCategories);
            // searchfilter = 'and rating in (' +ratingCategories+ ')';
        // }
         
         Location center = new Location();
         center.Latitude = centerlat;
         center.Longitude = centerlong;
         system.debug(center);
           
         if(metric==true && myLocations ==false){
         List<Account> accounts1 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km'), Website
            from Account where id != :accountId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') limit 200];
           system.debug(accounts1);
          	locations.addAll(accounts1);
         }
         if(metric==true && myLocations ==true){
         List<sObject> accounts2 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km'), Website
            from Account where id != :accountId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and id in (select account__c from account_division__c where account_owner__c = :currentUser and active__c = true) and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'km') limit 200];
           system.debug(accounts2);
          locations.addAll(accounts2);

         }
         if(metric==false && myLocations ==false){
         List<Account> accounts3 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi'), Website
            from Account where id != :accountId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') limit 200];
           system.debug(accounts3);
          	locations.addAll(accounts3);
         }
         if(metric==false && myLocations ==true){
         List<sObject> accounts4 = [select Id, Name, ShippingStreet,ShippingPostalCode, ShippingCity, Account_Owner_Name__c,
            ShippingLatitude, ShippingLongitude, Rating, Strategex_Rank__c, AccountNumber, DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi'), Website
            from Account where id != :accountId and Active__c = true and ShippingLatitude <> null and recordtype.name = :acctrecordtype
            and id in (select account__c from account_division__c where account_owner__c = :currentUser and active__c = true) and Rating in :ratingCategories and Strategex_Rank__c in :rankingCategories and DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') < :maxDistance
            order by DISTANCE(ShippingAddress, GEOLOCATION(:center.Latitude, :center.Longitude), 'mi') limit 200];
          system.debug(accounts4);
          locations.addAll(accounts4);

         }
         
           return locations;  
    }

    public class Location {

        @AuraEnabled public Decimal Latitude {get; set;}
        @AuraEnabled public Decimal Longitude {get; set;}
        public Location() {}
    }

}