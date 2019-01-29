/*
Name            : BOT_PlanProductTrigger
Created By      : Sreenivasulu A
Created Date    : 14-AUG-2018
Overview        : This trigger is written by BusinessOne Technologies Inc. 
                  1. It is used to truncate the name of the plan product if the characters are more than 80.
                  2. It populate the related SFDC Account ID into BOT_Account__c filed by comparing BOT_Entity_ID__c.

Modified by     : Sreenivasulu A
Modified date   : 09-OCT-2018
Reason          : Added update functionility. To update the BOT_Account__c field and BOT_Medical_Admin__c field when the record is created or updated.
*/
trigger BOT_PlanProductTrigger on BOT_Plan_Product__c (before insert, before update) 
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
        Set<Decimal> setEntityIds = new Set<Decimal>();                     //To store Account BOT Entity Ids
        Set<Decimal> setMedicalAdminIds = new Set<Decimal>();               //To store Account BOT Medical Admin Ids
        List<BOT_Plan_Product__c> lstPlanProductWithEntityId = new List<BOT_Plan_Product__c>();     //To store a list of plan product records with BOT Entity ID
        List<BOT_Plan_Product__c> lstPlanProductWithMedicalAdminId = new List<BOT_Plan_Product__c>();   //To store a list of plan product records with BOT Medical Admin ID
        //Creating set of BOT Entity Ids
        for(BOT_Plan_Product__c objPlanProduct : Trigger.new)
        {
            if(objPlanProduct.BOT_Entity_ID__c != null)
            {
                lstPlanProductWithEntityId.add(objPlanProduct);
                setEntityIds.add(objPlanProduct.BOT_Entity_ID__c);                
            }
            if(objPlanProduct.BOT_Medical_Admin_ID__c != null)
            {
                lstPlanProductWithMedicalAdminId.add(objPlanProduct);
                setMedicalAdminIds.add(objPlanProduct.BOT_Medical_Admin_ID__c);
            }
        }
        if(setEntityIds != Null)
        {
            BOT_PlanProductTriggerHandler.manageNameAndPopulateAccountId(lstPlanProductWithEntityId,setEntityIds);    
        }
        if(setMedicalAdminIds != Null)
        {
            BOT_PlanProductTriggerHandler.updateMedicalAdminIds(lstPlanProductWithMedicalAdminId,setMedicalAdminIds);    
        }
    }
    
    else if(Trigger.isBefore && Trigger.isUpdate)
    {
        //Set<Decimal> setEntityIds = new Set<Decimal>();                       //To store Account BOT Entity Ids
        Set<Decimal> setMedicalAdminIds = new Set<Decimal>();               //To store Account BOT Medical Admin Ids
        //List<BOT_Plan_Product__c> lstPlanProductWithUpdatedEntityId = new List<BOT_Plan_Product__c>();        //To store a list of plan product records where Entity ID is updated
        List<BOT_Plan_Product__c> lstPlanProductWithUpdatedMedicalAdminId = new List<BOT_Plan_Product__c>();    //To store a list of plan product records where Medical Admin ID is updated
        Integer planProductCount;                                           //To store total number of plan products getting updated
        Integer temp;                                                       //Temporary variable used to iterate the for loop
        
        planProductCount = Trigger.new.size();
        for(temp = 0; temp < planProductCount; temp++)
        {
            //To check where Entity Id is updated
            /*if(Trigger.old[temp].BOT_Entity_ID__c != Trigger.new[temp].BOT_Entity_ID__c)
            {
                if(Trigger.new[temp].BOT_Entity_ID__c != null)
                {
                    //Creating set of BOT Entity Ids
                    setEntityIds.add(Trigger.new[temp].BOT_Entity_ID__c);
                    //Creating a list of plan product records where Entity ID is updated
                    lstPlanProductWithUpdatedEntityId.add(Trigger.new[temp]);
                }
            }*/
            
            if(Trigger.new[temp].BOT_Medical_Admin_ID__c != null)
            {
                //To check where Medical Admin Id is updated
                if(Trigger.old[temp].BOT_Medical_Admin_ID__c != Trigger.new[temp].BOT_Medical_Admin_ID__c)
                {
                    //Creating a set of BOT Medical Admin Ids
                    setMedicalAdminIds.add(Trigger.new[temp].BOT_Medical_Admin_ID__c);
                    //Creating a list of plan product records where Medical Admin ID is updated
                    lstPlanProductWithUpdatedMedicalAdminId.add(Trigger.new[temp]);
                }
            }
        }
        if(setMedicalAdminIds != Null)
        {
            BOT_PlanProductTriggerHandler.updateMedicalAdminIds(lstPlanProductWithUpdatedMedicalAdminId,setMedicalAdminIds);   
        }
    }
}