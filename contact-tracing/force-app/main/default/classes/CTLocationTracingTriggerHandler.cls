public with sharing class CTLocationTracingTriggerHandler {
    
    
    public static void beforeInsertHandler(List<Location_Tracing__c> newRecords){
        List<Location_Tracing__c> duplicates= CTLocationTracingController.checkDuplicates(newRecords);
        for(Location_Tracing__c trace:duplicates){
            trace.addError('Duplicates found for'+trace.Person__c +'and'+trace.Location__c);
        }
            
        }
           
}