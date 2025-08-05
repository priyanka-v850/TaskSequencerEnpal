@isTest
private class Test_TaskService {

    @isTest
    static void testCreateFirstTask() {
        // Arrange: Insert Opportunity with process "Onboarding"
        // Let the trigger automatically create the first task
        Opportunity opp = new Opportunity(
            Name = 'Trigger Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Process__c = 'Onboarding'
        );

        Test.startTest();
        insert opp; // Trigger will call TaskService.createFirstTask()
        Test.stopTest();

        // Assert: Only one task should be created by trigger
        List<Opportunity_Task__c> tasks = [
            SELECT Id, Opportunity__c, Task_Name__c, Status__c, Sequence__c, Track_Name__c 
            FROM Opportunity_Task__c 
            WHERE Opportunity__c = :opp.Id
        ];

        System.assertEquals(1, tasks.size(), 'Only 1 task should be created by trigger');
        System.assertEquals('Not Started', tasks[0].Status__c);
        System.assertEquals(1, tasks[0].Sequence__c.intValue());
    }

    @isTest
    static void testCreateNextTask() {
        // Arrange: Insert Opportunity and let the trigger create the first task
        Opportunity opp = new Opportunity(
            Name = 'Next Task Trigger Opp',
            StageName = 'Qualification',
            CloseDate = Date.today(),
            Process__c = 'Onboarding'
        );
        insert opp;

        // Get the auto-created task by trigger
        Opportunity_Task__c firstTask = [
            SELECT Id, Sequence__c, Status__c, Track_Name__c, Opportunity__c 
            FROM Opportunity_Task__c 
            WHERE Opportunity__c = :opp.Id 
            ORDER BY Sequence__c ASC 
            LIMIT 1
        ];

        // Simulate user completing it
        firstTask.Status__c = 'Completed';

        Test.startTest();
        update firstTask; // Trigger for Opportunity_Task__c (if exists) or service will be called manually
        Test.stopTest();

        // Assert: Now 2 tasks should exist
        List<Opportunity_Task__c> tasks = [
            SELECT Id, Sequence__c 
            FROM Opportunity_Task__c 
            WHERE Opportunity__c = :opp.Id
        ];

        System.assertEquals(2, tasks.size(), 'Second task should be created when first is completed');
    }
}