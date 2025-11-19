public with sharing class CTPersonTriggerHandler {

    
    public static void beforeInsertHandler(List<Person__c> personRecords){
         // CTPersonTriggerHandler.beforeInsert(persons);
        for(Person__c persons: personRecords){

                if(persons.Health_Status__c!='Green'){
                persons.addError('Helath status should be green ');
                persons.Health_Status__c='Green';
                }
                persons.Token__c=CTPersonController.getToken(persons.Mobile__c);
         }

   }  
    public static void beforeUpdateHandler(List<Person__c> personRecords, Map<Id,Person__c> oldPersonRecords){
        for(Person__c persons: personRecords){
                   if(persons.Health_Status__c!=oldPersonRecords.get(persons.Id).Health_Status__c){
                
                   persons.Status_Update_Date__c= System.now().Date();

                    }

        }
    }
    public static void afterUpdateHandler(List<Person__c> personRecords, Map<Id,Person__c> oldPersonRecords){
       List<Location_Tracing__c> Location = new List<Location_Tracing__c>();
       Set<Id> statusChange=new Set<Id>();
       Set<Id> redStatusChange=new Set<Id>();
     
         for(Person__c persons: personRecords){
            
            
            
                  if(persons.Health_Status__c!=oldPersonRecords.get(persons.Id).Health_Status__c ){
                     statusChange.add(persons.Id);
                  }
                  if(persons.Health_Status__c=='Red' & oldPersonRecords.get(persons.Id).Health_Status__c!='Red' ){
                     redStatusChange.add(persons.Id);
                  }

            }
            Set<Id> yellowStatusChange=new Set<Id>();
            Set<Id> orangeStatusChange=new Set<Id>();
            Set<Id> alreadyProcessed=new Set<Id>();
            List<Person__c> personToUpdate=new List<Person__c>();
            alreadyProcessed.addAll(redStatusChange);
            orangeStatusChange.addAll(CTPersonController.getCohibitants(redStatusChange,alreadyProcessed));
            Set<Id>primaryContact=CTPersonController.getPrimaryContact(redStatusChange,alreadyProcessed);
            orangeStatusChange.addAll(primaryContact);
            yellowStatusChange.addAll(CTPersonController.getNeighbours(redStatusChange,alreadyProcessed));
                  
            yellowStatusChange.addAll(CTPersonController.getSecondaryContact(primaryContact,alreadyProcessed));    
            for(Id pId:orangeStatusChange){
                personToUpdate.add(new Person__c(Id=pId,Health_Status__c='Orange'));
            }
            for(Id pId:yellowStatusChange){
                personToUpdate.add(new Person__c(Id=pId,Health_Status__c='Orange'));
            }
            update personToUpdate;
            List<Location_Tracing__c> LocationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
            Set<Id> locationIds=new Set<Id>();
        
            if (LocationTraces!=null&& LocationTraces.size()> 0){
                
                for(Location_Tracing__c lt:LocationTraces){
                    locationIds.add(lt.Location__c);
                }
            }
            CTLocationController.updateRedScore(locationIds);



         }
        //  }); }
        
     
    public static List<Location_Tracing__c> getLocationByPersonId(String personIds){
    
         return [SELECT Id, Name, Person__c, Location__c, Location__r.Status__c,Location__r.Red_Score__c,Person__r.Health_Status__c,Visit_Date__c 
         FROM Location_Tracing__c 
         WHERE Person__c =:personIds 
         AND Visit_Date__c= LAST_N_DAYS: 10 
         ORDER BY Visit_Date__c DESC];
        
   
    } 

}    
    