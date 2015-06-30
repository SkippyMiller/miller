@isTest
private class TestTimesheetManager {
  private static ID contactId, projectId;
  
  static {
    Contact contact = new Contact(FirstName = 'Nobody', LastName = 'Special');
    insert contact;
    contactId = contact.Id;
    Project__c project = new Project__c(Name = 'Proj1');
    insert project;
    projectId = project.Id;
  }

  @isTest static void positiveTest() {
    Date weekEnding = Date.valueOf('2009-04-11');
    insert new Assignment__c(Project__c = projectId,
      Start_Date__c =  weekEnding - 6, End_Date__c = weekEnding,
      Contact__c = contactId);
    insert new Timesheet__c(Project__c = projectId,
      Week_Ending__c = weekEnding, Contact__c = contactId);
  }

  @isTest static void testNoAssignments() {
    Timesheet__c timesheet = new Timesheet__c(Project__c = projectId,
      Week_Ending__c = Date.valueOf('2009-04-11'),
      Contact__c = contactId);
    try {
      insert timesheet;
    } catch (DmlException e) {
      System.assert(e.getMessage().indexOf('No assignments') > 0);
      return;
    }
    System.assert(false);
  }

  @isTest static void testNoValidAssignments() {
    Date weekEnding = Date.valueOf('2009-04-04');
    insert new Assignment__c(Project__c = projectId,
      Start_Date__c = weekEnding - 6, End_Date__c = weekEnding,
      Contact__c = contactId);
    try {
      insert new Timesheet__c(Project__c = projectId,
      Week_Ending__c = Date.today(), Contact__c = contactId);
    } catch (DmlException e) {
      System.assert(e.getMessage().indexOf('No assignment for contact') > 0);
      return;
    }
    System.assert(false);
  }

  @isTest static void testBatch() {
    Date weekEnding = Date.valueOf('2009-04-11');
    insert new Assignment__c(Project__c = projectId,
      Start_Date__c =  weekEnding - 6, End_Date__c = weekEnding,
      Contact__c = contactId);
    List<Timesheet__c> timesheets = new List<Timesheet__c>();
    for (Integer i=0; i<200; i++) {
      timesheets.add(new Timesheet__c(Project__c = projectId,
        Week_Ending__c = weekEnding, Contact__c = contactId));
    }
    insert timesheets;
  }
}