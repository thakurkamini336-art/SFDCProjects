trigger UpdateContactTrainingStatus on Training__c (after insert,after update) {

   
   
    switch on Trigger.operationType {
        when AFTER_INSERT {

            
                TrainingTriggerHandler.updateTrainingStatusOnInsert(Trigger.new);
        
            
        }
        when AFTER_UPDATE {
            
        TrainingTriggerHandler.updateTrainingStatusOnUpdate(Trigger.new, Trigger.oldMap);
    }
    }

}