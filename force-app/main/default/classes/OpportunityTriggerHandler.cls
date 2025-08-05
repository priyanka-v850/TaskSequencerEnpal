public class OpportunityTriggerHandler {

    public static void handleAfter(List<Opportunity> newList, Map<Id, Opportunity> oldMap, Boolean isInsert) {
        Map<Id, Opportunity> oppIdToRecord = new Map<Id, Opportunity>();

        for (Opportunity opp : newList) {
            Boolean shouldCreate = false;

            if (isInsert && String.isNotBlank(opp.Process__c)) {
                shouldCreate = true;
            }
            else if (!isInsert) {
                Opportunity oldOpp = oldMap.get(opp.Id);
                if (opp.Process__c != oldOpp.Process__c) {
                    // Check if tasks exist
                    Integer count = [SELECT COUNT() FROM Opportunity_Task__c WHERE Opportunity__c = :opp.Id];
                    if (count > 0) {
                        opp.addError('You cannot change Process after tasks have been created.');
                        continue;
                    }
                    shouldCreate = true;
                }
            }

            if (shouldCreate) {
                oppIdToRecord.put(opp.Id, opp);
            }
        }

        if (!oppIdToRecord.isEmpty()) {
            TaskService.createFirstTask(oppIdToRecord);
        }
    }
}