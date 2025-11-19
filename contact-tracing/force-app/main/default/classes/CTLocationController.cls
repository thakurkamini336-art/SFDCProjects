public with sharing class CTLocationController {
     public static List <Location__c> getRecentStatusChanges(){

        List<Location__c> allLocation = [SELECT Id, Name, Status__c, Status_Update_Date__c, Address__c, Pincode__c, Red_Score__c FROM Location__c ORDER BY Status_Update_Date__c LIMIT 100];
        return allLocation;
    }
    public static List <Location__c> searchLoactions(String searchTerm){
         searchTerm = searchTerm+'%';

        List<Location__c> matchedLocations = [SELECT Id, Name, Status__c, Status_Update_Date__c, Address__c, Pincode__c, Red_Score__c FROM Location__c WHERE Name Like:searchTerm OR Pincode__c Like:searchTerm OR Address__c Like:searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
        
        return matchedLocations;
    }

      //to get data of a person by Id
    public static Location__c getLocationById(String locationId){

         List<Location__c> location= [SELECT Id, Name, Status__c, Status_Update_Date__c, Address__c, Pincode__c, Red_Score__c FROM Location__c WHERE Id=:locationId];
        if(location!=null &&location.size()>0){
            return location[0];
        }else{
            return null;
        }
        
           

    }
    public static Map<String,Integer> getStatusCount(){
        Map<String,Integer> locationStatusCount = new Map<String,Integer>();
        for(AggregateResult ar:([SELECT Status__c, Count(Id) FROM Location__c GROUP BY Status__c])){
            string health= String.valueOf(ar.get('Status__c'));
            Integer count = Integer.valueOf(ar.get('expr0'));
            locationStatusCount.put(health,count);
        }
        return locationStatusCount;
       
    }
     public static void updateRedScore(Set<Id> locationIds){
        List<Location__c> locationToUpdate = new List<Location__c>();
        AggregateResult[] redPeoplePerLocation = [SELECT Location__c, COUNT(Id) total FROM Location_Tracing__c
                WHERE Person__r.Health_Status__c = 'Red'
                AND Visit_Date__c = LAST_N_DAYS :10
                AND Location__c IN : locationIds
                GROUP BY Location__c];

                for (AggregateResult ar : redPeoplePerLocation) {
                    String locationId = String.valueOf(ar.get('Location__c'));
                    Integer redScore = Integer.valueOf(ar.get('total'));
                    String status = getStatus(redScore);
                    locationToUpdate.add(new Location__c(Id=locationId, Red_Score__c=redScore, Status__c=status));
                }

                if(locationToUpdate != null && locationToUpdate.size() > 0){
                    update locationToUpdate;
                }
    }

    public static String getStatus(Integer redScore){
        if(redScore == 0){
            return 'Green';
        } else if(redScore <= 5){
            return 'Yellow';
        } else if(redScore <= 10){
            return 'Orange';
        } else{
            return 'Red';
        }
    }
     
}