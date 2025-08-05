trigger OpportunityTaskTrigger on Opportunity_Task__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        TaskTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}