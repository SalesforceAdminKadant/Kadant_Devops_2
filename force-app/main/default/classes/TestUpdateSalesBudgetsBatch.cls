@isTest(SeeAllData=true)
public class TestUpdateSalesBudgetsBatch {

    static testMethod void TestUpdateSalesBudgetsProcess() {


        Test.startTest();

        UpdateSalesBudgetsBatch sbs = new UpdateSalesBudgetsBatch(null);
        database.executebatch(sbs, 5);

        Test.stopTest();
    }
    
}