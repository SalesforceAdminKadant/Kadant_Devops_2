@isTest(SeeAllData=true)
public class GetObjectNameTest {
 
 @isTest
 public static void testReturnObjectName(){
 
 //Return newly created lead record 
 List<Lead> LeadList = [Select Id from Lead LIMIT 1];
 
 List<Id> IdList = new List<Id> ();
 
 For (Lead l: LeadList){
 IdList.add(l.Id);
 }
     List<String> results = GetObjectName.returnObjectName(IdList);
 }
    
}