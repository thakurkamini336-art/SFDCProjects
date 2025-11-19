public with sharing class ContactTriggerHandler {
    
    public static void afterInsertHandler(List<Contact> contactList){
       
       Set<Id> accountid=new Set<Id>();
             for(Contact contact:contactList){
                 
                    if(String.isNotBlank(contact.AccountId)) {
                    accountid.add(contact.AccountId);
                    }
                
                
                
               } 
               AccountToupdate.updateAccount(accountid);   
               
     }           
    public static void afterUpdateHandler(List<Contact> newConatctList, Map<Id,Contact> oldContactList){
       
        Set<Id> accountid=new Set<Id>();
        for(Contact contact:newConatctList){
                 
             if(String.isNotBlank(contact.AccountId) && contact.Active__c!=oldContactList.get(contact.Id).Active__c ) {
                     accountid.add(contact.AccountId);
            }
            if(contact.AccountId!=oldContactList.get(contact.Id).AccountId && String.isNotBlank(contact.AccountId)){
                        accountid.add(contact.AccountId);
                        accountid.add(oldContactList.get(contact.Id).AccountId);
            }
         }
         AccountToupdate.updateAccount(accountid);   
                
                
    }  
     public static void afterDeleteHandler(List<Contact> contactList){
       
            Set<Id> accountid=new Set<Id>();
            for(Contact contact:contactList){
                 
                    if(String.isNotBlank(contact.AccountId)) {
                    accountid.add(contact.AccountId);
                    }
            
               } 
               AccountToupdate.updateAccount(accountid);   
               
     }    
     public static void afterUnDeleteHandler(List<Contact> contactList){
       
       Set<Id> accountid=new Set<Id>();
             for(Contact contact:contactList){
                 
                    if(String.isNotBlank(contact.AccountId)) {
                    accountid.add(contact.AccountId);
                    }
                
                
                
               } 
               AccountToupdate.updateAccount(accountid);   
               
     }     
}