/*
Name            : BOT_AccountTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 20-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class for BOT_AccountTriggerHandler.
*/
@isTest(seeAllData = false)
private class BOT_AccountTriggerHandlerTest 
{
    //Testing while creating a single Account record
    static testMethod void createAccountRecordWithParentId()
    {
        Account objParentAccount;		//To store a parent account record
        Account objAffiliateAccount;	//To store an affiliate account with parent Id
        
        //To create an Account record with parent ID
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createAccountsWithParentId(1,1,'MCO');
        
        //Querying the created test data
        objParentAccount = [SELECT Id FROM Account WHERE BOT_Parent_Entity_ID__c = Null];
        objAffiliateAccount = [SELECT Id, ParentId, Primary_Parent_vod__c, BOT_Is_BOT_Data__c, recordTypeId 
                               FROM Account WHERE BOT_Parent_Entity_ID__c != Null];
        
        //Test data validation
        System.assertEquals(objAffiliateAccount.ParentId, objParentAccount.Id);
        System.assertEquals(objAffiliateAccount.Primary_Parent_vod__c, objParentAccount.Id);
		System.assertEquals(objAffiliateAccount.BOT_Is_BOT_Data__c, true);
        System.assertEquals(objAffiliateAccount.recordTypeId, Schema.SObjectType.Account.getRecordTypeInfosByName().get('BOT Commercial').getRecordTypeId());
    }
    
    //Testing while creating a list of Account records
    static testMethod void createAccountRecordsWithParentId()
    {
        List<Account> lstParentAccount;		//To store a list of parent account records
        List<Account> lstAffiliateAccount;	//To store a list of affiliate account with parent Id
        Id accountRecordTypeId;				//To store record type Id
        Integer i,j,temp = 0;
        
        //To create a list of Account records with parent ID
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'Stand Alone Hix');
        clsTestDataFactory.createAccountsWithParentId(5,5,'Stand Alone Hix');
        
        //Querying the Record type Id
        accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BOT Commercial').getRecordTypeId();
        //Querying the created test data
        lstParentAccount = [SELECT Id FROM Account WHERE BOT_Parent_Entity_ID__c = Null];
        lstAffiliateAccount = [SELECT Id, ParentId, Primary_Parent_vod__c, recordTypeId FROM Account 
                               WHERE BOT_Parent_Entity_ID__c != Null AND BOT_Is_BOT_Data__c = true AND recordTypeId =: accountRecordTypeId
                               ORDER BY Primary_Parent_vod__c];
        
        //Test data validation
        System.assertEquals(lstParentAccount.size(), 5);
        System.assertEquals(lstAffiliateAccount.size(), 25);
        
        for(i = 0; i < 5; i++)
        {
            for(j = 0; j < 5; j++)
            {
            	System.assertEquals(lstAffiliateAccount[temp].ParentId, lstParentAccount[i].Id);
        		System.assertEquals(lstAffiliateAccount[temp].Primary_Parent_vod__c, lstParentAccount[i].Id);
                temp++;
            }
        }
    }
}