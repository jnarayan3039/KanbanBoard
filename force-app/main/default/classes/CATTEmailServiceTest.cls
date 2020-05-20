@isTest
private class CATTEmailServiceTest {
    
    // 4 tests needed for full coverage
    // 1) positive test (correct subject, body includes parsable link and request doesn't already exist)
    // 2) negative test (bad subject)
    // 3) negative test (good subject, bad link parse)
    // 4) negative test (good subject, good link, request already exists)
    
    static testMethod void positiveTest() {
        // Create a new email and envelope
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
        // setup email data
        email.subject = 'Notification: A new CATT request has been created';
        email.fromname = 'Sean Harp';
        env.fromAddress = 'sharp@salesforce.com';
        email.plainTextBody = 'The following request has been created:\nhttps://org62.my.salesforce.com/aCF0M000000GmzY\n\nRed Account: Irvine Company - On-going stability issues\n\nSubject: Custom code causing instability and CPU time outs';
        
        // Get a count of CATT requests before
        AggregateResult[] arList = [SELECT count(Id) from CATT_Request__c];
        Integer beforeSize = arList.size();
        
        // Call the email service class
        CATTEmailService service = new CATTEmailService();
        service.handleInboundEmail(email, env);
        
        // Get a count of CATT requests after
        arList = [SELECT count(Id) from CATT_Request__c];
        Integer afterSize = arList.size();        
        
        // Expect a new CATT request
        System.assertNotEquals(beforeSize, afterSize);
    }

    static testMethod void negativeSubjectTest() {
        // Create a new email and envelope
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
        // setup email data
        email.subject = 'Notification: A new Monkey request has been created';
        email.fromname = 'Sean Harp';
        env.fromAddress = 'sharp@salesforce.com';
        email.plainTextBody = 'The following request has been created:\nhttps://org62.my.salesforce.com/aCF0M000000GmzY\n\nRed Account: Irvine Company - On-going stability issues\n\nSubject: Custom code causing instability and CPU time outs';
        
        // Get a count of CATT requests before
        AggregateResult[] arList = [SELECT count(Id) from CATT_Request__c];
        Integer beforeSize = arList.size();
        
        // Call the email service class
        CATTEmailService service = new CATTEmailService();
        service.handleInboundEmail(email, env);
        
        // Get a count of CATT requests after
        arList = [SELECT count(Id) from CATT_Request__c];
        Integer afterSize = arList.size();        
        
        // Expect no new CATT request
        System.assertEquals(beforeSize, afterSize);
    }

    static testMethod void negativeURLMatchTest() {

        // Create a new email and envelope
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
        // setup email data
        email.subject = 'Notification: A new CATT request has been created';
        email.fromname = 'Sean Harp';
        env.fromAddress = 'sharp@salesforce.com';
        email.plainTextBody = 'The following request has been created:\nhttps://monkey.com/aCF0M000000GmzY\n\nRed Account: Irvine Company - On-going stability issues\n\nSubject: Custom code causing instability and CPU time outs';
        
        // Get a count of CATT requests before
        AggregateResult[] arList = [SELECT count(Id) from CATT_Request__c];
        Integer beforeSize = arList.size();
        
        // Call the email service class
        CATTEmailService service = new CATTEmailService();
        service.handleInboundEmail(email, env);
        
        // Get a count of CATT requests after
        arList = [SELECT count(Id) from CATT_Request__c];
        Integer afterSize = arList.size();        
        
        // Expect no new CATT request
        System.assertEquals(beforeSize, afterSize);
    }
    
    static testMethod void RecordAlreadyExists() {

        // Create a new email and envelope
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
        // setup email data
        email.subject = 'Notification: A new CATT request has been created';
        email.fromname = 'Sean Harp';
        env.fromAddress = 'sharp@salesforce.com';
        email.plainTextBody = 'The following request has been created:\nhttps://monkey.com/aCF0M000000GmzY\n\nRed Account: Irvine Company - On-going stability issues\n\nSubject: Custom code causing instability and CPU time outs';
        
        // Get a count of CATT requests before
        AggregateResult[] arList = [SELECT count(Id) from CATT_Request__c];
        Integer beforeSize = arList.size();
        
        // Ensure there's a duplicate
        CATT_Request__c req = new CATT_Request__c();
        req.Org62_Id__c = 'aCF0M000000GmzY';
        insert req;
            
        // Call the email service class
        CATTEmailService service = new CATTEmailService();
        service.handleInboundEmail(email, env);
        
        // Get a count of CATT requests after
        arList = [SELECT count(Id) from CATT_Request__c];
        Integer afterSize = arList.size();        
        
        // Expect no new CATT request
        System.assertEquals(beforeSize, afterSize);
    }
    
}