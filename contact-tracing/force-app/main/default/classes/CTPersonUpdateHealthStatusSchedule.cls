public with sharing class CTPersonUpdateHealthStatusSchedule implements Schedulable{
    public static final String CRON_EXP = '0 0 2 * * ?';
    public void execute(SchedulableContext sc){
        CTPersonUpdateStatusBatch Batch = new CTPersonUpdateStatusBatch();
        Database.executeBatch(Batch,200);
        CTLocationStatusUpdateBatch Batch1 = new CTLocationStatusUpdateBatch();
        Database.executeBatch(Batch1,200);
    }
   
}