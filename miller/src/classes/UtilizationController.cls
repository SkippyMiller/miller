public class UtilizationController {
  public Timesheet__c sheet1 { get; private set; }
  public Timesheet__c sheet2 { get; private set; }
  public Boolean shared { get; set; }
  public Decimal utilization { get; private set; }
  public Decimal totalHours { get; private set; }
  public Integer totalResources { get; private set; }
  public UtilizationController() {
    sheet1 = new Timesheet__c();
    sheet2 = new Timesheet__c();
  }
  public PageReference calculate() {
    Date startDate = sheet1.Week_Ending__c;
    Date endDate = sheet2.Week_Ending__c;
    // assumes all active resources are billable
    List<Contact> contacts = [ SELECT Id FROM Contact
      WHERE Active__c = TRUE AND Start_Date__c < :startDate ];
    List<Timesheet__c> timesheets = [ SELECT Week_Ending__c,
      Total_Hours__c FROM Timesheet__c
      WHERE Billable__c = true AND
        Week_Ending__c >= :startDate AND
        Week_Ending__c <= :endDate
      ORDER BY Week_Ending__c ];
    totalHours = 0;
    if (timesheets.size() == 0) {
      return null;
    }
    for (Timesheet__c timesheet : timesheets) {
      totalHours += timesheet.Total_Hours__c;
    }
    // adjust start and end dates to match timesheet week endings
    Timesheet__c firstTimesheet = timesheets.get(0);
    Timesheet__c lastTimesheet = timesheets.get(timesheets.size() - 1);
    if (startDate < firstTimesheet.Week_Ending__c) {
      startDate = firstTimesheet.Week_Ending__c.addDays(-6);
      sheet1.Week_Ending__c = startDate;
    }
    if (endDate > lastTimesheet.Week_Ending__c) {
      endDate = lastTimesheet.Week_Ending__c;
      sheet2.Week_Ending__c = endDate;
    }
    totalResources = contacts.size();
    Long availableHours = totalResources *
      calculateAvailableHours(startDate, endDate);
    utilization = 100 * totalHours.divide(availableHours, 2);
    if (shared) {
      shareUtilization();
    }
    return null;
  }
  public static Long calculateAvailableHours(
    Date startDate, Date endDate) {
    BusinessHours bh = [ SELECT id FROM BusinessHours
      WHERE IsDefault = true ];
    DateTime startTime = DateTime.newInstance(
      startDate.year(), startDate.month(), startDate.day(),
      0, 0, 0);
    DateTime endTime = DateTime.newInstance(
      endDate.year(), endDate.month(), endDate.day(),
      0, 0, 0);
    Decimal diff = Decimal.valueOf(
      BusinessHours.diff(bh.id, startTime, endTime));
    return diff.divide(3600000, 0).round();
  }
  private void shareUtilization() {
    BenchmarkWS.AnonymousBenchmark service =
      new BenchmarkWS.AnonymousBenchmark();
    BenchmarkWS.UtilizationEntry ue =
      new BenchmarkWS.UtilizationEntry();
    ue.naicsCode = '541511';
    ue.startDate = sheet1.Week_Ending__c;
    ue.endDate = sheet2.Week_Ending__c;
    ue.totalHours = totalHours;
    ue.totalResources = totalResources;
    ue.utilization = utilization;
    BenchmarkWS.SubmissionStatus[] results =
      service.submitUtilizationData(
        new BenchmarkWS.UtilizationEntry[] { ue });
    if (results != null) {
      for (BenchmarkWS.SubmissionStatus result : results) {
        if (!result.success) {
          ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.ERROR, result.errorMessage));
        } else {
          ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.INFO,
            'Shared anonymous benchmark data'));
        }
      }
    }
  }
}