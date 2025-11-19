public with sharing class ScheduleUpdateTrainingStatusBatch implements Schedulable {


    public void execute(SchedulableContext sc){

       BatchUpdateTrainingStatus bts=new BatchUpdateTrainingStatus();
       Id JobId=Database.executeBatch(bts, 200);
       System.debug('jobId'+ jobId);

    }
    
}