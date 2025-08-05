@isTest
private class Test_OpportunityTriggerHandler {

    @isTest
    static void testHandleAfterInsert() {
        Opportunity opp = new Opportunity(
            Name = 'Opp Insert Test',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Process__c = 'Onboarding'
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        List<Opportunity_Task__c> tasks = [
            SELECT Id FROM Opportunity_Task__c 
            WHERE Opportunity__c = :opp.Id
        ];
        System.assertEquals(1, tasks.size(), 'Expected exactly 1 task created by trigger');
    }

    @isTest
    static void testPreventProcessChangeIfTasksExist() {
        // Arrange
        Opportunity opp = new Opportunity(
            Name = 'Opp Update Test',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Process__c = 'Onboarding'
        );
        insert opp;

        // Let trigger create task → so there will be one task already

        // Try changing process
        opp.Process__c = 'Installation';

        String expectedMsg = 'You cannot change the Process once tasks are created';
        String actualMsg = '';

        Test.startTest();
        try {
            update opp;
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            actualMsg = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(False, actualMsg.contains('You cannot change the Process'), 'Expected process change to be blocked');
    }
}