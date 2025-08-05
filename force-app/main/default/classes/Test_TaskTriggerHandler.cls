@isTest
private class Test_TaskTriggerHandler {

    @isTest
    static void testHandleAfterUpdateCompletion() {
        // Insert Opportunity and let trigger create Task 1
        Opportunity opp = new Opportunity(
            Name = 'Task Trigger Test',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Process__c = 'Onboarding'
        );
        insert opp;

        // Fetch the task created by the OpportunityTrigger
        Opportunity_Task__c firstTask = [
            SELECT Id, Status__c 
            FROM Opportunity_Task__c 
            WHERE Opportunity__c = :opp.Id 
            LIMIT 1
        ];

        // Update status to Completed
        firstTask.Status__c = 'Completed';

        Test.startTest();
        update firstTask; // This should trigger creation of next task
        Test.stopTest();

        // Assert: There should be exactly 2 tasks now (first + next)
        List<Opportunity_Task__c> tasks = [
            SELECT Id FROM Opportunity_Task__c 
            WHERE Opportunity__c = :opp.Id
        ];
        System.assertEquals(2, tasks.size(), 'Exactly 2 tasks should exist after completion');
    }
}