trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        OpportunityTriggerHandler.handleAfter(Trigger.new, Trigger.oldMap, Trigger.isInsert);
    }
}