public class TaskTriggerHandler {

    public static void handleAfterUpdate(List<Opportunity_Task__c> newList, Map<Id, Opportunity_Task__c> oldMap) {
        List<Opportunity_Task__c> completedTasks = new List<Opportunity_Task__c>();

        for (Opportunity_Task__c newTask : newList) {
            Opportunity_Task__c oldTask = oldMap.get(newTask.Id);
            if (newTask.Status__c == 'Completed' && oldTask.Status__c != 'Completed') {
                completedTasks.add(newTask);
            }
        }

        if (!completedTasks.isEmpty()) {
            TaskService.createNextTask(completedTasks);
        }
    }
}