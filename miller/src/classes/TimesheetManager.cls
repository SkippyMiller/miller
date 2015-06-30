public with sharing class TimesheetManager {
  public class TimesheetException extends Exception {}
  public static void handleTimesheetChange(List<Timesheet__c> oldTimesheets,
    List<Timesheet__c> newTimesheets) {
    Set<ID> contactIds = new Set<ID>();
    for (Timesheet__c timesheet : newTimesheets) {
      contactIds.add(timesheet.Contact__c);
    }
    List<Assignment__c> assignments = [ select Id, Start_Date__c,
      End_Date__c, Contact__c from Assignment__c
      where Contact__c in :contactIds ];
    if (assignments.size() == 0) {
      throw new TimesheetException('No assignments');
    }
    Boolean hasAssignment;
    for (Timesheet__c timesheet : newTimesheets) {
      hasAssignment = false;
      for (Assignment__c assignment : assignments) {
        if (assignment.Contact__c == timesheet.Contact__c &&
          timesheet.Week_Ending__c - 6 >= assignment.Start_Date__c &&
          timesheet.Week_Ending__c <= assignment.End_Date__c) {
            hasAssignment = true;
            break;
        }
      }
      if (!hasAssignment) {
        timesheet.addError('No assignment for contact ' + 
          timesheet.Contact__c + ', week ending ' + 
          timesheet.Week_Ending__c);
      }
    }
  }
}