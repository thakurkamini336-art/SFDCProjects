public with sharing class CTLocationDataCleanUpschedule implements Schedulable{
    public static final String CRON_EXP = '0 0 2 * * ?';
    public void execute(SchedulableContext sc){
        CTLocationTracingDataCleanUpBatch batch = new CTLocationTracingDataCleanUpBatch();
        Database.executeBatch(batch,500);
    }

    
}