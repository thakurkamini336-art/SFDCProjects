public with sharing class TrainingTriggerHandler {
    
    public static void updateTrainingStatusOnInsert(List<Training__c> trecord){
        Map<Id,String> contactInfo=new Map<Id,String>();
        for(Training__c tr:trecord){
            contactInfo.put(tr.Contact__c,String.valueOf(tr.Status__c));
        }
        System.debug('contactInfo'+contactInfo);
        List<Contact> contactRecords=[SELECT Id,Training_Status__c FROM Contact WHERE Id IN:contactInfo.keySet()];
        for(Contact cr:contactRecords){
            if(contactInfo.containsKey(cr.Id)){
             cr.Training_Status__c=contactInfo.get(cr.Id);
            }
            
        }
        System.debug('contactRecords'+contactRecords);
        if(!contactRecords.isEmpty()){
            try{
                update contactRecords;
            }catch(DmlException e){
                System.debug('Exception'+e.getMessage());
            }
        
        }  
    }    
    
    public static void updateTrainingStatusOnUpdate(List<Training__c> trecord, Map<Id,Training__c> oldtrecord){
            Map<Id,String> contactToUpdate=new Map<Id,String>();
            for(Training__c training:trecord){
            if(training.Status__c !='' && training.Status__c!=oldtrecord.get(training.Id).Status__c){
                contactToUpdate.put(training.Contact__c,String.valueOf(training.Status__c));
              }
           }
            List<Contact> contactRecords=[SELECT Id,Training_Status__c FROM Contact WHERE Id IN:contactToUpdate.keySet()];
            for(Contact cr:contactRecords){
            cr.Training_Status__c=contactToUpdate.get(cr.Id);
             }
        try{
            update contactRecords;
        }catch(DmlException e){
            System.debug('Exception'+e.getMessage());
        }
    }
}
    
