trigger validateTimesheet on Timesheet__c (before insert, before update) {
  TimesheetManager.handleTimesheetChange(Trigger.old, Trigger.new);
}