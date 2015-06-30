trigger setAccountOwner on Opportunity (before Insert, before update){

    Set<ID> acctIDs = New Set<ID>();
    Map<ID,ID> AccOwner = New Map<ID,ID>();

    for(Opportunity opp : trigger.new){
        acctIDs.add(opp.accountID);
    }

    for(Account a : [Select OwnerID From Account Where ID IN :acctIDs])
        AccOwner.put(a.id,a.ownerID);


    for(Opportunity opp : trigger.new){
        if(AccOwner.containsKey(opp.AccountID))
            opp.OwnerID = AccOwner.get(opp.AccountID);
    }


}