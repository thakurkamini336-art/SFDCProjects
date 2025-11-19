ScheduleUpdateTrainingStatusBatch sbts=new ScheduleUpdateTrainingStatusBatch();
String cronExp='0 0 1 * * ? ';
Id JobId=system.schedule('ScheduleUpdateTrainingStatus', cronExp, sbts);
