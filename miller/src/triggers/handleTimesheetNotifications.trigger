trigger handleTimesheetNotifications on Timesheet__c (after update) {
  for (Timesheet__c timesheet : trigger.new) {
    if (timesheet.Status__c !=
      trigger.oldMap.get(timesheet.Id).Status__c &&
      (timesheet.Status__c == 'Approved' ||
      timesheet.Status__c == 'Rejected')) {
      Contact resource =
        [ SELECT Email FROM Contact
          WHERE Id = :timesheet.Contact__c LIMIT 1 ];
      Project__c project =
        [ SELECT Name FROM Project__c
          WHERE Id = :timesheet.Project__c LIMIT 1 ];
      User user = [ SELECT Name FROM User
          WHERE Id = :timesheet.LastModifiedById LIMIT 1 ];
      Messaging.SingleEmailMessage mail = new
        Messaging.SingleEmailMessage();
      mail.toAddresses = new String[]
        { resource.Email };
      mail.setSubject('Timesheet for '
        + timesheet.Week_Ending__c + ' on '
        + project.Name);
      mail.setHtmlBody('Your timesheet was changed to '
        + timesheet.Status__c + ' status by '
        + user.Name);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[]
        { mail });
    }
  }
}