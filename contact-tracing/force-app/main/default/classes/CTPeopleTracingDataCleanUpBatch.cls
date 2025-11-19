public with sharing class CTPeopleTracingDataCleanUpBatch implements Database.Batchable<Sobject>{
    
  public Database.QueryLocator start(Database.BatchableContext context){
    String query= 'SELECT Id FROM People_Tracing__c WHERE Contact_Date__c < LAST_N_DAYS : 30';
    return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext context,List<People_Tracing__c> scope){
    delete scope;
     
   }
   public void finish(Database.BatchableContext context){
    System.debug('Batch is complete');
   }
}