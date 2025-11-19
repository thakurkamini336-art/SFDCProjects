trigger CTLocationTrigger on Location__c (before insert,before update,after update,after insert) {
      

  switch on Trigger.operationType{
    when BEFORE_INSERT{
        

      CTLocationTriggerHandler.beforeInsertHandler(Trigger.new);
      
    }
    when BEFORE_UPDATE{
      CTLocationTriggerHandler.beforeUpdateHandler(Trigger.new,Trigger.oldMap);
    }
    
    
        
    }
   }

