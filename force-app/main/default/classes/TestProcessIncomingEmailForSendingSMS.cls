@isTest
public with sharing class TestProcessIncomingEmailForSendingSMS
{
    static testMethod void testMe() {

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new KadantMockHttpResponseGenerator());

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // setup the data for the email
        env.fromAddress = 'salesforce.texting@kadant.com';
        email.fromname = 'Salesforce Administrator';
        email.subject = '+12695551212';
        email.plainTextBody = 'This is a test';


        // call the email service class and test it with the data in the testMethod
        ProcessIncomingEmailForSendingSMSText emailProcess = new ProcessIncomingEmailForSendingSMSText();
        emailProcess.handleInboundEmail(email, env);

    }
}