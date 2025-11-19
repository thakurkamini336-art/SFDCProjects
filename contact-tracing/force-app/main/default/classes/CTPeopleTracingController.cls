public with sharing class CTPeopleTracingController {
   
    public static List<People_Tracing__c> getTraces(String recordId){
        List<People_Tracing__c> pTraces = [SELECT Id, Name, Contact_Type__c, Contact_Date__c, Person_1__c, Person_2__c FROM People_Tracing__c WHERE Person_1__c=:recordId OR Person_2__c=:recordId ORDER BY Contact_Date__c];
        return pTraces;

    }   
    
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces){


        Set<Id> personIds = new Set<Id>();
        for(People_Tracing__c p: peopleTraces){
            personIds.add(p.Person_1__c);
            personIds.add(p.Person_2__c);
        }

        
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
        Map<Id,Set<Id>> mapOfExistingRecords= new Map<Id,Set<Id>>();
        List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c WHERE Person_1__c IN:personIds OR Person_2__c IN:personIds];
        for(People_Tracing__c p: existingRecords){
            if(!mapOfExistingRecords.containsKey(p.Person_1__c)){
                mapOfExistingRecords.put(p.Person_1__c, new Set<Id>());
                
            }

            mapOfExistingRecords.get(p.Person_1__c).add(p.Person_2__c);
            
            if(!mapOfExistingRecords.containsKey(p.Person_2__c)){
                mapOfExistingRecords.put(p.Person_2__c, new Set<Id>());
                
            }

            mapOfExistingRecords.get(p.Person_2__c).add(p.Person_1__c);
        }

        
        for(People_Tracing__c p: peopleTraces){
            if((mapOfExistingRecords.containsKey(p.Person_1__c) && mapOfExistingRecords.get(p.Person_1__c).contains(p.Person_2__c)) ||
             (mapOfExistingRecords.containsKey(p.Person_2__c) && mapOfExistingRecords.get(p.Person_2__c).contains(p.Person_1__c)) ){
                duplicates.add(p);    
            }
        }             
                
            return duplicates;
        
    }

         

} 