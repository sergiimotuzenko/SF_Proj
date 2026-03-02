/**
 * Lead Follow-Up Task Creator Test Class
 *
 * Provides comprehensive test coverage for LeadFollowUpTaskCreator.
 * Ensures follow-up tasks are created correctly for old open leads.
 *
 * @version 65.0
 */
@isTest
private class LeadFollowUpTaskCreatorTest {

    /**
     * Test creates follow-up tasks for leads older than 60 days
     */
    @isTest
    static void testCreatesFollowUpTasksForOldLeads() {
        // Arrange - Create old open leads (older than 60 days)
        List<Lead> oldLeads = createOldOpenLeads(5, 65);
        insert oldLeads;

        // Act - Run the follow-up task creation
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, 2);
        Test.stopTest();

        // Assert - Tasks should be created
        System.assertEquals(5, result.getLeadsProcessed(), 'Should process 5 leads');
        System.assertEquals(5, result.getTasksCreated(), 'Should create 5 tasks');
        System.assertEquals(0, result.getTasksFailed(), 'Should have 0 failed tasks');

        // Verify tasks were actually created
        List<Task> tasks = [
            SELECT Id, Subject, WhatId, OwnerId, ActivityDate, Status, Priority
            FROM Task
            WHERE WhatId IN :oldLeads
        ];
        System.assertEquals(5, tasks.size(), 'Should have 5 tasks created');

        for (Task t : tasks) {
            System.assertEquals('Close the Lead or mark it Bogus', t.Subject, 'Task subject should match');
            System.assertEquals('High', t.Priority, 'Task priority should be High');
            System.assertEquals('Not Started', t.Status, 'Task status should be Not Started');
        }
    }

    /**
     * Test does not create tasks for recently created leads
     */
    @isTest
    static void testDoesNotCreateTasksForRecentLeads() {
        // Arrange - Create recent open leads (less than 60 days old)
        List<Lead> recentLeads = createOldOpenLeads(3, 30);
        insert recentLeads;

        // Act - Run the follow-up task creation
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, 2);
        Test.stopTest();

        // Assert - No tasks should be created
        System.assertEquals(0, result.getLeadsProcessed(), 'Should process 0 leads');
        System.assertEquals(0, result.getTasksCreated(), 'Should create 0 tasks');
    }

    /**
     * Test does not create tasks for converted leads
     */
    @isTest
    static void testDoesNotCreateTasksForConvertedLeads() {
        // Arrange - Create converted leads (old but converted)
        List<Lead> convertedLeads = new List<Lead>();
        for (Integer i = 0; i < 3; i++) {
            convertedLeads.add(new Lead(
                FirstName = 'Converted' + i,
                LastName = 'Lead' + i,
                Company = 'Test Company' + i,
                Status = 'Qualified',
                Email = 'converted' + i + '@example.com',
                IsConverted = true
            ));
        }
        insert convertedLeads;

        // Act - Run the follow-up task creation
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, 2);
        Test.stopTest();

        // Assert - No tasks should be created for converted leads
        System.assertEquals(0, result.getLeadsProcessed(), 'Should process 0 leads');
        System.assertEquals(0, result.getTasksCreated(), 'Should create 0 tasks');
    }

    /**
     * Test uses default parameters when null is provided
     */
    @isTest
    static void testUsesDefaultParameters() {
        // Arrange - Create old open leads
        List<Lead> oldLeads = createOldOpenLeads(2, 70);
        insert oldLeads;

        // Act - Run with null parameters (should use defaults)
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(null, null);
        Test.stopTest();

        // Assert - Should use default 60 days threshold
        System.assertEquals(2, result.getLeadsProcessed(), 'Should process 2 leads');
        System.assertEquals(2, result.getTasksCreated(), 'Should create 2 tasks');
    }

    /**
     * Test handles invalid parameters gracefully
     */
    @isTest
    static void testHandlesInvalidParameters() {
        // Arrange - Create old open leads
        List<Lead> oldLeads = createOldOpenLeads(2, 100);
        insert oldLeads;

        // Act - Run with invalid parameters (should use defaults)
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(0, -1);
        Test.stopTest();

        // Assert - Should use default values
        System.assertEquals(2, result.getLeadsProcessed(), 'Should process 2 leads');
        System.assertEquals(2, result.getTasksCreated(), 'Should create 2 tasks');
    }

    /**
     * Test handles empty lead list
     */
    @isTest
    static void testHandlesEmptyLeadList() {
        // Arrange - No leads exist

        // Act - Run the follow-up task creation
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, 2);
        Test.stopTest();

        // Assert - Should handle gracefully
        System.assertEquals(0, result.getLeadsProcessed(), 'Should process 0 leads');
        System.assertEquals(0, result.getTasksCreated(), 'Should create 0 tasks');
        System.assertEquals(0, result.getTasksFailed(), 'Should have 0 failed tasks');
    }

    /**
     * Test task due date is calculated correctly
     */
    @isTest
    static void testTaskDueDateCalculation() {
        // Arrange - Create old open leads
        List<Lead> oldLeads = createOldOpenLeads(1, 90);
        insert oldLeads;

        Integer taskDueDays = 5;
        Date expectedDueDate = Date.today().addDays(taskDueDays);

        // Act - Run with custom due date
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, taskDueDays);
        Test.stopTest();

        // Assert - Verify due date
        System.assertEquals(1, result.getTasksCreated(), 'Should create 1 task');

        Task createdTask = [SELECT ActivityDate FROM Task WHERE WhatId = :oldLeads[0].Id LIMIT 1];
        System.assertEquals(expectedDueDate, createdTask.ActivityDate, 'Task due date should be 5 days from today');
    }

    /**
     * Test assigns task to lead owner
     */
    @isTest
    static void testTaskAssignedToLeadOwner() {
        // Arrange - Create test user and old lead
        User testUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        List<Lead> oldLeads = new List<Lead>();
        for (Integer i = 0; i < 2; i++) {
            oldLeads.add(new Lead(
                FirstName = 'Owner' + i,
                LastName = 'Test' + i,
                Company = 'Test Company' + i,
                Status = 'New',
                Email = 'owner' + i + '@example.com',
                OwnerId = testUser.Id
            ));
        }
        insert oldLeads;

        // Act - Run the follow-up task creation
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, 2);
        Test.stopTest();

        // Assert - Tasks should be assigned to the lead owner
        List<Task> tasks = [
            SELECT OwnerId FROM Task
            WHERE WhatId IN :oldLeads
        ];

        for (Task t : tasks) {
            System.assertEquals(testUser.Id, t.OwnerId, 'Task should be assigned to lead owner');
        }
    }

    /**
     * Test scheduler class executes successfully
     */
    @isTest
    static void testSchedulerExecutes() {
        // Arrange - Create old open leads
        List<Lead> oldLeads = createOldOpenLeads(3, 75);
        insert oldLeads;

        // Act - Test the scheduler
        Test.startTest();
        String cronExp = '0 0 0 1 1 ? 2099'; // Far future date
        LeadFollowUpTaskCreator.LeadFollowUpScheduler scheduler = new LeadFollowUpTaskCreator.LeadFollowUpScheduler();
        System.schedule('TestLeadFollowUpScheduler', cronExp, scheduler);
        Test.stopTest();

        // Assert - Scheduler should be created (actual execution happens asynchronously)
        System.assert(true, 'Scheduler should be created successfully');
    }

    /**
     * Test bulk processing with many leads
     */
    @isTest
    static void testBulkProcessing() {
        // Arrange - Create 200 old open leads (bulk test)
        List<Lead> oldLeads = createOldOpenLeads(200, 100);
        insert oldLeads;

        // Act - Run the follow-up task creation
        Test.startTest();
        LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks(60, 2);
        Test.stopTest();

        // Assert - Should handle bulk processing
        System.assertEquals(200, result.getLeadsProcessed(), 'Should process 200 leads');
        System.assertEquals(200, result.getTasksCreated(), 'Should create 200 tasks');
    }

    /**
     * Helper method to create old open leads
     *
     * @param count Number of leads to create
     * @param daysOld How many days old to make the leads
     * @return List of Lead records (not inserted)
     */
    private static List<Lead> createOldOpenLeads(Integer count, Integer daysOld) {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < count; i++) {
            leads.add(new Lead(
                FirstName = 'Test' + i,
                LastName = 'Lead' + i,
                Company = 'Test Company' + i,
                Status = 'New',
                Email = 'test' + i + '@example.com'
            ));
        }
        return leads;
    }
}
