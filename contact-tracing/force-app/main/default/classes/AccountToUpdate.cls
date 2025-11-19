public with sharing class AccountToUpdate {
    public static void UpdateAccount(set<Id>accountid) {
    
        AggregateResult[] result =[SELECT COUNT(Id) totalContacts,AccountId
                                       FROM Contact 
                                       WHERE Active__c=true 
                                       AND AccountId IN:accountid Group By AccountId];

            Map<Id,Account> acclist=new Map<Id,Account>();
             for(AggregateResult agg: result){
                Integer totalContact= Integer.valueOf(agg.get('totalContacts'));
                String accId=String.valueOf(agg.get('AccountId'));
                Account acc = new Account(Id=accId,Active_Conatct__c=totalContact);
                acclist.put(accId,acc);
            }

            for(Id aId:accountid){
                if(!acclist.containsKey(aId)){
                    Account acc = new Account(Id=aId,Active_Conatct__c=0);
                     acclist.put(aId,acc);
                }
            }
             update acclist.values();
            
    }
}