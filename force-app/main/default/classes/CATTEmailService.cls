global class CATTEmailService implements Messaging.InboundEmailHandler {
    
    static String newCATTSubject = 'Notification: A new CATT request has been created';
	static String fwdCATTSubject = 'Fwd: Notification: A new CATT request has been created';
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                           Messaging.InboundEnvelope env)
    {
        
        // Create an InboundEmailResult object for returning the result of the 
        // Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        // Ignore any message that doesn't have subject "Notification: A new CATT request has been created"
        // returning success prevents an error reply going back to the original sender
        String subject = email.subject;
        if (subject != newCATTSubject && subject != fwdCATTSubject)
        {
            result.success = true;
            return result;
        }
        
        // Otherwise we'll parse out the new CATT request record Id
        // The following request has been created:
        // https://org62.my.salesforce.com/aCF0M000000GmzY
        // 
        // TODO: log exception if we have a good subject line but no parsed record id
        // 
        Pattern p = Pattern.compile('(?m).*https://org62\\.my\\.salesforce\\.com\\/(aCF[A-Za-z0-9]{12})');
        Matcher pm = p.matcher(email.plainTextBody);
        String CATTRequestId;
        while (pm.find())
        { 
            CATTRequestId = pm.group(1); 
            System.debug(CATTRequestId);
        }
        
        // If we didn't extract an ID, just exit (future logging?)
        // returning success prevents an error reply going back to the original sender        
        if (CATTRequestId == null)
        {
            System.debug('Unable to extract CATT object id from email');
            result.success = true;
            return result;
        }
        
        // Query to see if this CATT request already exists
        CATT_Request__c[] requests = [SELECT Id from CATT_Request__c where Id=:CATTRequestId];
        
        // Create this request if it doesn't exist
        if (requests.size() == 0)
        {            
            CATT_Request__c newRec = new CATT_Request__c();
            newRec.Org62_Id__c = CATTRequestId;
            insert newRec;
            
            
        }
        
        // Set the status to true and queue an instance of the sync job
        result.success = true;
        //ID jobId = System.enqueueJob(new AsyncCATTSyncJob_Queueable());
        
        return result;
    }
}