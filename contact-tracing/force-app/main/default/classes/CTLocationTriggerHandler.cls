public with sharing class CTLocationTriggerHandler {
    public static void beforeInsertHandler(List<Location__c> locations){
         
        for(Location__c location: locations){

                if(location.Status__c!='Green'){
                location.addError('Helath status should be green ');
                location.Status__c='Green';
                }
               
         }
    }
    
    public static void beforeUpdateHandler(List<Location__c> newLocations, Map<Id,Location__c> oldLocations){
        for(Location__c location: newLocations){
                   if(location.Status__c!=oldLocations.get(location.Id).Status__c){
                
                   location.Status_Update_Date__c= System.now().Date();

                    }

        }
    }
    public static void afterUpdateHandler(List<Location__c> newLocations, Map<Id,Location__c> oldLocations){
      // List<Location_Tracing__c> Location = new List<Location_Tracing__c>();
       //Set<Id> statusChange=new Set<Id>();
       Set<Id> redStatusChange=new Set<Id>();
     
         for(Location__c location: newLocations){

             if(location.Status__c=='Red' & oldLocations.get(location.Id).Status__c!='Red' ){
                     redStatusChange.add(location.Id);
            }
         }

         Set<Id>personToUpdate= CTLocationTracingController.redLocationVisitors(redStatusChange);
         CTPersonController.updateVisitorsHealthStatus(personToUpdate);
    }            
}