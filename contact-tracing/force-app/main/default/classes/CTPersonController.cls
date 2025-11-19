public with sharing class CTPersonController {
     public static String getToken(String mobileNo){
        
            Blob targetBlob = Blob.valueOf(mobileNo);
            Blob hash = Crypto.generateDigest('MD5', targetBlob);
            String result = EncodingUtil.base64Encode(hash);
            System.debug('Value: ' + result);
            return result;
    }
   // to get recent helath updates of all people
    public static List <Person__c> getRecentHealthChanges(){


        List<Person__c> allPersons = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c Order By Status_Update_Date__c DESC LIMIT 100 ];
        return allPersons;
    }
     // to search data of people with searchTerm
    public static List <Person__c> searchPeople(String searchTerm){
         searchTerm = searchTerm+'%';

        List<Person__c> searchTermMatchedPersons = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c  WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm Order By Status_Update_Date__c DESC NULLS LAST] ; 
        
        return searchTermMatchedPersons;
    }

      //to get data of a person by Id
    public static Person__c getPersonById(String personId){

        Person__c person=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c  WHERE Id=:personId];
        return person;
    }

    public static Set<Id> getCohibitants(Set<Id>personId,Set<Id>alreadyProcessed){
        List<String> healthStatus=new List<String>{'Green','Yellow'};
        Set<Id> cohibitantIds=new Set<Id>();
        List<People_Tracing__c> cohibitantRecords = [SELECT  Person_1__c, Person_2__c 
                                            FROM People_Tracing__c 
                                            WHERE (Person_1__c=:personId OR Person_2__c=:personId)
                                             AND  Contact_Type__c= 'Cohabitant' 
                                             AND (Person_1__r.Health_Status__c =:healthstatus 
                                              OR Person_2__r.Health_Status__c =:healthstatus )];
        for(People_Tracing__c records:cohibitantRecords )  {
            if(!alreadyProcessed.contains(records.Person_1__c)){
                cohibitantIds.add(records.Person_1__c);
                alreadyProcessed.add(records.Person_1__c);
            }
            if(!alreadyProcessed.contains(records.Person_2__c)){
                cohibitantIds.add(records.Person_2__c);
                alreadyProcessed.add(records.Person_2__c);
            }

        }                             
        return cohibitantIds;
     
    }
    public static Set<Id> getNeighbours(Set<Id>personId,Set<Id>alreadyProcessed){
        String healthStatus='Green';
        Set<Id> neighboursId=new Set<Id>();
        List<People_Tracing__c> neighbours = [SELECT  Person_1__c, Person_2__c 
                                            FROM People_Tracing__c 
                                            WHERE (Person_1__c=:personId OR Person_2__c=:personId)
                                            AND  Contact_Type__c= 'Neighbour' 
                                            AND (Person_1__r.Health_Status__c =:healthstatus 
                                            OR Person_2__r.Health_Status__c =:healthstatus )];
        for(People_Tracing__c nb:neighbours )  {
            if(!alreadyProcessed.contains(nb.Person_1__c)){
                neighboursId.add(nb.Person_1__c);
                alreadyProcessed.add(nb.Person_1__c);
            }
            if(!alreadyProcessed.contains(nb.Person_2__c)){
                neighboursId.add(nb.Person_2__c);
                alreadyProcessed.add(nb.Person_2__c);
            }

        }                             
        return neighboursId;
     
    }

    public static Set<Id> getPrimaryContact(Set<Id>personId,Set<Id>alreadyProcessed){
       List<String> healthStatus=new List<String>{'Green','Yellow'};
        Set<Id> pContactId=new Set<Id>();
        List<People_Tracing__c>primaryContact=[SELECT  Person_1__c, Person_2__c 
                                              FROM People_Tracing__c 
                                              WHERE (Person_1__c=:personId OR Person_2__c=:personId)
                                              AND  Contact_Type__c= 'Other' 
                                              AND (Person_1__r.Health_Status__c =:healthstatus 
                                              OR Person_2__r.Health_Status__c =:healthstatus )
                                              AND Contact_Date__c=LAST_N_DAYS:10];
        for(People_Tracing__c pc:primaryContact )  {
            if(!alreadyProcessed.contains(pc.Person_1__c)){
                pContactId.add(pc.Person_1__c);
                alreadyProcessed.add(pc.Person_1__c);
            }
            if(!alreadyProcessed.contains(pc.Person_2__c)){
                pContactId.add(pc.Person_2__c);
                alreadyProcessed.add(pc.Person_2__c);
            }
            }
            return pContactId;
        }                             
        
     
    
    public static Set<Id> getSecondaryContact(Set<Id>pContactId,Set<Id>alreadyProcessed){
       List<String> healthStatus=new List<String>{'Green','Yellow'};
        Set<Id> sContactId=new Set<Id>();
        List<People_Tracing__c>secondaryContact=[SELECT  Person_1__c, Person_2__c 
                                              FROM People_Tracing__c 
                                              WHERE (Person_1__c=:pContactId OR Person_2__c=:pContactId)
                                              AND  Contact_Type__c= 'Other' 
                                              AND (Person_1__r.Health_Status__c =:healthstatus 
                                              OR Person_2__r.Health_Status__c =:healthstatus )
                                              AND Contact_Date__c=LAST_N_DAYS:10];
        for(People_Tracing__c pc:secondaryContact)  {
            if(!alreadyProcessed.contains(pc.Person_1__c)){
                sContactId.add(pc.Person_1__c);
                alreadyProcessed.add(pc.Person_1__c);
            }
            if(!alreadyProcessed.contains(pc.Person_2__c)){
                sContactId.add(pc.Person_2__c);
                 alreadyProcessed.add(pc.Person_2__c);
            }

        }                             
        return sContactId;
     
    }



      //to get count of people in every health status
    public static Map<String,Integer> getHealthStatusCount(){
        Map<String,Integer> healthStatusCount = new Map<String,Integer>();
        for(AggregateResult ar:[SELECT Health_Status__c, Count(Id)  FROM Person__c GROUP BY Health_Status__c]){
            string health= String.valueOf(ar.get('Health_Status__c'));
            Integer count = Integer.valueOf(ar.get('expr0'));
            healthStatusCount.put(health,count);
        }
        return healthStatusCount;
       
    }
    public static void updateVisitorsHealthStatus(Set<Id>visitors){
        List<Person__c>updatePeople=new List<Person__c>();
        if(visitors!=null && visitors.size()>0){
        List<Person__c> persons=[SELECT Name,Id, Health_Status__c FROM Person__c  WHERE Id IN:visitors];
        
        for(Person__c person: persons){
            updatePeople.add(new Person__c(Id=person.Id,Health_Status__c='Yellow'));
        }
        }
        update updatePeople;
    }

   
}