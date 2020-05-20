/**
 * @File Name          : CattUtility.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 5/20/2020, 3:31:28 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/20/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class CattUtility {
    public CattUtility() {

    }

    @AuraEnabled (cacheable=true)
    public static List<CATT_Request__c> getCattRequests(){
        return [select id, Name, Status__c, Subject__c, Account__r.name, Description__c from CATT_Request__c];
    }
}