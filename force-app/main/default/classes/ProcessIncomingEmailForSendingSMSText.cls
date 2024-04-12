global class ProcessIncomingEmailForSendingSMSText implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        KadantHelperClasses.sendPlainTextEmail('salesforce.admin@kadant.com','Incoming email address for SMS Texting', email.fromAddress);
        
        if(!Test.isRunningTest())
            KadantHelperClasses.sendSMSTextMessage(email.subject, email.plainTextBody);

        return result;

      }

  }