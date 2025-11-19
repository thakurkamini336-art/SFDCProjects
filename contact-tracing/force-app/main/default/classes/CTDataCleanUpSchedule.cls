public with sharing class CTDataCleanUpSchedule implements Schedulable{
    public static final String cronExp='0 0 2 * * ?';

    public void execute(SchedulableContext sc){
       CTPeopleTracingDataCleanUpBatch peopleTracingBatch = new CTPeopleTracingDataCleanUpBatch();

        Database.executeBatch(peopleTracingBatch, 100);

        CTLocationTracingDataCleanUpBatch batch = new CTLocationTracingDataCleanUpBatch();
        Database.executeBatch(batch,500);
    }
    
}