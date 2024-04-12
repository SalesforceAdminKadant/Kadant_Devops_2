@isTest
public with sharing class TestPartsOnHandCallOut {

    // Method to test getstockinfo() method
    @isTest
    public static void testgetstockinfo() {
        Test.startTest();
        String testProduct2Id = '01t0z0000065pWuAAI';
        String testObject = 'QuoteLineItem';
        // Setting up the mock response
        Test.setMock(HTTPCalloutMock.class, new PartsOnHandCallOutMock());
        // Performing the API callout
        List<List<String>> PartDetails = PartsOnHandCallOut.getstockinfo(testProduct2Id,testObject);
        Test.stopTest();
    }
}