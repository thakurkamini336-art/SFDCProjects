public with sharing class CTLocationTracingController {
   

    public static List<Location_Tracing__c> getVisitors(String locationId){
        List<Location_Tracing__c> locationTraces=[SELECT Id, Name, Person__c, Person__r.Health_Status__c,Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Id =:locationId ORDER BY Visit_Date__c DESC];
        
        return locationTraces;
    }
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id>personIds){
    
         return [SELECT Id, Name, Person__c, Location__c, Person__r.Health_Status__c,Visit_Date__c FROM Location_Tracing__c WHERE Person__c IN :personIds AND Visit_Date__c= LAST_N_DAYS: 10 ORDER BY Visit_Date__c DESC];
        
   
    }
     public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id>locationIds){
        List<Location_Tracing__c> locationTraces=new List<Location_Tracing__c>();
        
         locationTraces.add([SELECT Id, Name, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Location__c IN :locationIds and Person__r.Health_Status__c= 'green' and Visit_Date__c= LAST_N_DAYS: 10 ORDER BY Visit_Date__c DESC ]);
        

     if(locationTraces!=null && locationTraces.size()>0){
         return locationTraces;
     }
     return null;
    }

    public static List <Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        Set<Id> locationIds= new Set<Id>();
        Set<Id> personIds= new Set<Id>();
        for(Location_Tracing__c traces: newLocationTraces){
              locationIds.add(traces.Location__c);
              personIds.add(traces.Person__c);
                       
        }
            
        Map<Id,Set<Id>> mapOfExistingRecords= new Map<Id,Set<Id>>();
        
       List<Location_Tracing__c> existingRecord= [SELECT Id, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Person__c IN:personIds AND Location__c IN:locationIds];
     
       if(existingRecord!=null && existingRecord.size()>0){
        for(Location_Tracing__c trace: existingRecord){
            if(!mapOfExistingRecords.containsKey(trace.Location__c)){
                mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
            }
            mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            //adding 
        }
      }
        List<Location_Tracing__c> duplicates= new List<Location_Tracing__c>();
        for(Location_Tracing__c trace: newLocationTraces){
            if(mapOfExistingRecords.containsKey(trace.Location__c) && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                duplicates.add(trace);
                
            }
        }
        return duplicates;
         
      } 
    
    //  List<Location_Tracing__c> duplicates=new List<Location_Tracing__c>();
    //  for(locationTraces trace:traces){
    //       for(Location_Tracing__c traceRecord:existingTracingRecords){
    //           if(trace.Location__c==traceRecord.Location__c && trace.Person__c==traceRecord.Person__c && trace.Visit_Date__c==traceRecord.Visit_Date__c){
    //               duplicates.add(trace);
    //            }
    //       }
     
    //   }


      //return duplicates;
    
    public static Set<Id> redLocationVisitors(Set<Id> redLoactions){
        List<String> healthStatus=new List<String>{'Red','Orange'};
        Set<Id> personId=new Set<Id>();
        List<Location_Tracing__c> persons=[SELECT Person__c 
                FROM Location_Tracing__c
                WHERE Location__c IN: redLoactions
                AND Visit_Date__c= LAST_N_DAYS:10
                AND Person__r.Health_Status__c NOT IN: healthStatus];
                
        for(Location_Tracing__c pId: persons){
            personId.add(pId.Person__c);
        }
        return personId;
    }
        

    
    
    
}