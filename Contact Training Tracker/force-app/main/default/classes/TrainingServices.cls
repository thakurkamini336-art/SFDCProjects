public with sharing class TrainingServices {
    @AuraEnabled(cacheable=true)
    
    public static List<Training__c> getTrainings(Id recordId){
        List<Training__c> trainings=[SELECT Id,Course_Name__c,Status__c FROM Training__c WHERE Contact__c=:recordId and Status__c !='Completed'];
        return trainings;
    }
    @AuraEnabled(cacheable=false)
    public static void markTrainingComplete(Id trainingId){
        Training__c training=[SELECT Id,Name,Status__c FROM Training__c WHERE Id=:trainingId LIMIT 1];
        training.Status__c='Completed';
        System.debug('training'+training);
        try{
            update training;
        }catch(DmlException e){
            System.debug('Exception'+e.getMessage());
        }
        
    }
}