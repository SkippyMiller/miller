/*
    Custom Controller Code 
    
    Javascript remoting to get the Account Records with their Call Reports for a given Date Range

*/


public with sharing class CallReportMapCon {
    
    @RemoteAction
    public static List<Account> returnAccountsforDateRange(String startDate, String endDate){
        
        List<Account> crAccounts = new List<Account>();
        
        Datetime startdt = Datetime.valueOf(startDate + ' 00:00:00'); // Convert from Dates to DateTimes
        Datetime enddt   = Datetime.valueof(endDate + ' 23:59:00'); // Dates to DateTimes
        
        crAccounts = [Select Id, Name, BillingStreet, BillingCity,BillingCountry,BillingState,BillingPostalCode,(Select Id, Name, Status__c, Date_Completed__c from Call_Reports__r where CreatedDate > :startdt AND CreatedDate < :enddt) from Account order by Id];
        
        return crAccounts;
    }


}