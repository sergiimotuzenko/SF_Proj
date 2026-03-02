/**
 * Lead Follow-Up Result
 *
 * Wrapper class to hold the results of the follow-up task creation process.
 *
 * @version 65.0
 */
public with sharing class LeadFollowUpResult {

    /**
     * Number of leads processed
     */
    private Integer leadsProcessed;

    /**
     * Number of tasks successfully created
     */
    private Integer tasksCreated;

    /**
     * Number of tasks that failed to create
     */
    private Integer tasksFailed;

    /**
     * Default constructor
     */
    public LeadFollowUpResult() {
        this.leadsProcessed = 0;
        this.tasksCreated = 0;
        this.tasksFailed = 0;
    }

    /**
     * Gets the number of leads processed
     *
     * @return Integer count of leads processed
     */
    public Integer getLeadsProcessed() {
        return leadsProcessed;
    }

    /**
     * Sets the number of leads processed
     *
     * @param leadsProcessed Number of leads processed
     */
    public void setLeadsProcessed(Integer leadsProcessed) {
        this.leadsProcessed = leadsProcessed;
    }

    /**
     * Gets the number of tasks created
     *
     * @return Integer count of tasks created
     */
    public Integer getTasksCreated() {
        return tasksCreated;
    }

    /**
     * Sets the number of tasks created
     *
     * @param tasksCreated Number of tasks created
     */
    public void setTasksCreated(Integer tasksCreated) {
        this.tasksCreated = tasksCreated;
    }

    /**
     * Gets the number of tasks failed
     *
     * @return Integer count of tasks failed
     */
    public Integer getTasksFailed() {
        return tasksFailed;
    }

    /**
     * Sets the number of tasks failed
     *
     * @param tasksFailed Number of tasks failed
     */
    public void setTasksFailed(Integer tasksFailed) {
        this.tasksFailed = tasksFailed;
    }
}
