public with sharing class BatchUpdateTrainingStatus implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator([SELECT Id, Status__c FROM Training__c WHERE Status__c='In Progress' and Course_Date__c>Last_N_Days:7]);
    }
    
    public void execute(Database.BatchableContext bc,List<Training__c> scope){
        if(!scope.isempty()){
        for(Training__c tr:scope){
            tr.Status__c='Completed';
        }
        List<Database.SaveResult> sr=Database.insert(scope, false);
    }
        
        
    }

    public void finish(Database.BatchableContext bc){
        System.debug('all training status is updated');
    }
    
}