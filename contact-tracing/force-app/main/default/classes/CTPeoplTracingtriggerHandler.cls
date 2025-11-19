public with sharing class CTPeoplTracingtriggerHandler {
     
     public static void beforeInsertHandler(List<People_Tracing__c> traces){
       List<People_Tracing__c> duplicates= CTPeopleTracingController.checkDuplicates(traces);
       for(People_Tracing__c duplicate:duplicates){
        duplicate.addError('duplicates found for'+duplicate.Person_1__c +'and'+duplicate.Person_2__c);
       }
     }
}