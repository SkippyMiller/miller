/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCallReportMapCon {

    static testMethod void testCallReportMapConMethod() {
        
        
        // Load the Data
        List<Account> accs = new List<Account>();
        
        accs.add(new Account(Name='Test1',BillingStreet='Test Street',BillingCity='TestCity',BillingState='TestState',BillingPostalCode='1111'));
        accs.add(new Account(Name='Test2',BillingStreet='Test Street2',BillingCity='TestCity2',BillingState='TestState2',BillingPostalCode='11112'));
        accs.add(new Account(Name='Test3',BillingStreet='Test Street3',BillingCity='TestCity3',BillingState='TestState3',BillingPostalCode='11113'));
        
        
        insert accs;
        
        List<Call_Report__c> reports = new List<Call_Report__c>();
        reports.add(new Call_Report__c(Account__c=accs[0].id));
        reports.add(new Call_Report__c(Account__c=accs[1].id));
        reports.add(new Call_Report__c(Account__c=accs[2].id));
        reports.add(new Call_Report__c(Account__c=accs[0].id));
        reports.add(new Call_Report__c(Account__c=accs[2].id,Status__c='Completed'));
        reports.add(new Call_Report__c(Account__c=accs[1].id));
        reports.add(new Call_Report__c(Account__c=accs[1].id,Status__c='Completed'));
        reports.add(new Call_Report__c(Account__c=accs[2].id));
        reports.add(new Call_Report__c(Account__c=accs[0].id));
        reports.add(new Call_Report__c(Account__c=accs[1].id));
        
        insert reports;
        
        Test.startTest();
        
        
        List<Account> returnedAccts = CallReportMapCon.returnAccountsforDateRange('2013-03-01', '2013-12-31');
        
        System.assertEquals(3,returnedAccts.size());
        
        
        Test.stopTest();
        
        
        
    }
}