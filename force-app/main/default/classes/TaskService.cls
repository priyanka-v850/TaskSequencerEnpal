public class TaskService {
    
    public static void createFirstTask(Map<Id, Opportunity> oppIdToRecord) {
        List<Opportunity_Task__c> tasksToInsert = new List<Opportunity_Task__c>();
        
        for (Id oppId : oppIdToRecord.keySet()) {
            Opportunity opp = oppIdToRecord.get(oppId);
            
            // Get Track Name from Task_Process__mdt
            Task_Process__mdt processConfig = [
                SELECT Track_Name__c 
                FROM Task_Process__mdt 
                WHERE Process_Value__c = :opp.Process__c 
                LIMIT 1
            ];
            
            // Get first task (sequence = 1) from Task_Definition__mdt
            Task_Definition__mdt firstDef = [
                SELECT Task_Name__c, Sequence__c, Description__c 
                FROM Task_Definition__mdt 
                WHERE Track_Name__c = :processConfig.Track_Name__c 
                AND Sequence__c = 1
                LIMIT 1
            ];
            
            if (firstDef != null) {
                Opportunity_Task__c task = new Opportunity_Task__c();
                task.Opportunity__c = oppId;
                task.Task_Name__c = firstDef.Task_Name__c;
                task.Status__c = 'Not Started';
                task.Sequence__c = firstDef.Sequence__c;
                task.Track_Name__c = processConfig.Track_Name__c;
                tasksToInsert.add(task);
            }
            
        }
        
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
    
    public static void createNextTask(List<Opportunity_Task__c> completedTasks) {
        List<Opportunity_Task__c> tasksToInsert = new List<Opportunity_Task__c>();
        
        for (Opportunity_Task__c completedTask : completedTasks) {
            Integer nextSeq = Integer.valueOf(completedTask.Sequence__c.intValue() + 1);
            
            // Fetch only one next task metadata
            Task_Definition__mdt def = [
                SELECT Task_Name__c, Sequence__c 
                FROM Task_Definition__mdt 
                WHERE Track_Name__c = :completedTask.Track_Name__c 
                AND Sequence__c = :nextSeq
                LIMIT 1
            ];
            
            if (def != null) {
                Opportunity_Task__c newTask = new Opportunity_Task__c();
                newTask.Opportunity__c = completedTask.Opportunity__c;
                newTask.Task_Name__c = def.Task_Name__c;
                newTask.Status__c = 'Not Started';
                newTask.Sequence__c = def.Sequence__c;
                newTask.Track_Name__c = completedTask.Track_Name__c;
                tasksToInsert.add(newTask);
            }
        }
        
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}