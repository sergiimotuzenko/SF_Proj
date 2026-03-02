/**
 * Lead Follow-Up Task Creator
 *
 * Finds open leads that are older than 60 days and creates follow-up tasks
 * for the lead owners to either close the lead or mark it as Bogus.
 *
 * @version 65.0
 */
public with sharing class LeadFollowUpTaskCreator {

    /**
     * Default number of days to consider a lead as old
     */
    private static final Integer DEFAULT_DAYS_THRESHOLD = 60;

    /**
     * Default number of days until task is due
     */
    private static final Integer DEFAULT_TASK_DUE_DAYS = 2;

    /**
     * Task subject for follow-up
     */
    private static final String TASK_SUBJECT = 'Close the Lead or mark it Bogus';

    /**
     * Finds open leads older than 60 days and creates follow-up tasks for their owners.
     * Uses user mode for security enforcement (FLS and sharing rules).
     *
     * @return LeadFollowUpResult containing counts of processed leads and created tasks
     */
    public static LeadFollowUpResult createFollowUpTasks() {
        return createFollowUpTasks(DEFAULT_DAYS_THRESHOLD, DEFAULT_TASK_DUE_DAYS);
    }

    /**
     * Finds open leads older than specified days and creates follow-up tasks for their owners.
     * Uses user mode for security enforcement (FLS and sharing rules).
     *
     * @param daysThreshold Number of days to consider a lead as old (0 or negative means all open leads)
     * @param taskDueDays Number of days until the task is due
     * @return LeadFollowUpResult containing counts of processed leads and created tasks
     */
    public static LeadFollowUpResult createFollowUpTasks(Integer daysThreshold, Integer taskDueDays) {
        LeadFollowUpResult result = new LeadFollowUpResult();

        // Validate input parameters
        if (daysThreshold == null || daysThreshold < 0) {
            daysThreshold = DEFAULT_DAYS_THRESHOLD;
        }
        if (taskDueDays == null || taskDueDays < 1) {
            taskDueDays = DEFAULT_TASK_DUE_DAYS;
        }

        // Calculate the cutoff date
        // When daysThreshold is 0, we want all leads created today or earlier
        // Use Date comparison for CreatedDate (DAY_ONLY function)
        Date cutoffDate;
        if (daysThreshold == 0) {
            // Include all leads created today or earlier
            cutoffDate = Date.today();
        } else {
            cutoffDate = Date.today().addDays(-daysThreshold);
        }

        // Query open leads older than the threshold
        // Using WITH USER_MODE to enforce field-level security and sharing rules
        // DAY_ONLY(CreatedDate) converts DateTime to Date for comparison
        List<Lead> oldOpenLeads = [
            SELECT Id, OwnerId, Name, Company, Status, CreatedDate
            FROM Lead
            WHERE IsConverted = false
            AND DAY_ONLY(CreatedDate) <= :cutoffDate
            WITH USER_MODE
        ];

        result.setLeadsProcessed(oldOpenLeads.size());

        if (oldOpenLeads.isEmpty()) {
            return result;
        }

        // Create follow-up tasks for each lead owner
        List<Task> tasksToCreate = new List<Task>();
        Date taskDueDate = Date.today().addDays(taskDueDays);

        for (Lead lead : oldOpenLeads) {
            Task followUpTask = new Task(
                Subject = TASK_SUBJECT,
                WhatId = lead.Id,
                OwnerId = lead.OwnerId,
                ActivityDate = taskDueDate,
                Status = 'Not Started',
                Priority = 'High',
                Description = 'This lead has been open for ' + daysThreshold + ' days. Please review and either close the lead or mark it as Bogus.'
            );
            tasksToCreate.add(followUpTask);
        }

        // Insert tasks with partial success allowed
        if (!tasksToCreate.isEmpty()) {
            Database.SaveResult[] saveResults = Database.insert(tasksToCreate, false);

            Integer successCount = 0;
            Integer failureCount = 0;

            for (Database.SaveResult sr : saveResults) {
                if (sr.isSuccess()) {
                    successCount++;
                } else {
                    failureCount++;
                    // Log errors for debugging
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('Error creating task: ' + err.getMessage());
                    }
                }
            }

            result.setTasksCreated(successCount);
            result.setTasksFailed(failureCount);
        }

        return result;
    }

    /**
     * Schedulable implementation to run the follow-up task creation on a schedule.
     */
    public class LeadFollowUpScheduler implements System.Schedulable {

        /**
         * Execute method called by the scheduler
         *
         * @param sc SchedulableContext
         */
        public void execute(SchedulableContext sc) {
            LeadFollowUpResult result = LeadFollowUpTaskCreator.createFollowUpTasks();
            System.debug('Lead Follow-Up Task Creation completed. Leads processed: ' +
                result.getLeadsProcessed() + ', Tasks created: ' + result.getTasksCreated() +
                ', Tasks failed: ' + result.getTasksFailed());
        }
    }
}
