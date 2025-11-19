trigger CTPeopleTracing on People_Tracing__c (before insert) {
    
    switch on Trigger.operationType{
        when BEFORE_INSERT{
        CTPeoplTracingtriggerHandler.beforeInsertHandler(Trigger.New);

         }
    }
}