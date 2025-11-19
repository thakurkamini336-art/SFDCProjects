public with sharing class CTLocationStatusUpdateBatch implements Database.Batchable<SObject>{

    public Database.QueryLocator start(Database.BatchableContext bc){
        Date today= Date.today();
        Date fourteenDaysAgo=today-14;
        List<String> status=new List<String>{'Red','Orange','Yellow'};
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status_Update_Date__c =:fourteenDaysAgo AND Status__c IN:status');
    }

    public void execute(Database.BatchableContext bc, List<Location__c> scope){
        for(Location__c location : scope){
            location.Status__c = 'Green';
        }
        update scope;
    } 

    public void finish(Database.BatchableContext bc){
        System.debug('Batch is complete');
    }
    
}