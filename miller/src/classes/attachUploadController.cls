public class attachUploadController{
//public class AutoFlow5Controller extends JWTController{

    public string claimID{get;set;}      
    public String parentId {get;set;}
    public transient Attachment attach {get;set;}
    public String attachId {get;set;}
    public String currentUser {get;set;}
    public List<Attachment> attachments;    // list of existing attachments - populated on demand
    public static final Integer NUM_ATTACHMENTS_TO_ADD=5;// the number of new attachments to add to the list when the user clicks 'Add More'
    public List<Attachment> newAttachments {get; set;}  // list of new attachments to add   
    public string delAttId {get;set;}
    
    public void upload(){
        attach.ParentId = ApexPages.currentPage().getParameters().get('cid');
        insert attach;
    }
    
    @RemoteAction
    public static void removeAttach(string attachId){       
        attachId = attachId;        
        List<Attachment>a = [select id,ParentId from Attachment where id =: attachId];
        if (a.size() > 0){
            delete a;          
        }           
    }
   
    public attachUploadController(){
         attach = new Attachment();
        //claimID = ApexPages.currentPage().getParameters().get('cid');
          
        /*if( claimID != '' && claimID != null  ){
                subClaimType = [SELECT Claim_Sub_Type__c FROM Case Where Id =: claimID ].Claim_Sub_Type__c ; 
                caseclaimType = [SELECT Claim_Type__c FROM Case Where Id =: claimID].Claim_Type__c;  
                List<eFNOL_Claim_Contacts__c> eFNOLInsuredClaimContact = [Select Id, (Select Id, No_Damage__c from eFNOL_Property__r ) from eFNOL_Claim_Contacts__c where eFNOL_Claim__c =: claimID and eFNOL_Type_Of_Claim_Contact__c = 'Insured' Limit 1 ];     
            
            if(eFNOLInsuredClaimContact.size() > 0){
                if(eFNOLInsuredClaimContact[0].eFNOL_Property__r != null){
                        for(eFNOL_Property__c property    : eFNOLInsuredClaimContact[0].eFNOL_Property__r ){
                                if(property.No_Damage__c == true){
                                        noDamage = true ;
                                break;
                                }
                        }           
                }
            }
        }*/
            
    }
    //ie attachment methods
    
    // Add more attachments action method
    public void addMore(){
        // append NUM_ATTACHMENTS_TO_ADD to the new attachments list
        for (Integer idx=0; idx<NUM_ATTACHMENTS_TO_ADD; idx++){
            newAttachments.add(new Attachment());
        }       
    }
    //creates attachment list   
    public List<Attachment> getAttachments(){
        // retrieve the existing attachments
        currentUser = UserInfo.getUserId();
        parentId = ApexPages.currentPage().getParameters().get('cid');      
        if (null==attachments){// only execute the SOQL if the list hasn't been initialised
            attachments=[select Id, Description, ParentId, Name, CreatedDate from Attachment where ParentId=:parentId and CreatedDate = TODAY and OwnerId=:currentUser order by CreatedDate Desc];
        }       
        return attachments;
    }
    //refreshes only the attachment list  
    public pagereference refreshcmp(){
        // retrieve the existing attachments
        currentUser = UserInfo.getUserId();
        parentId = ApexPages.currentPage().getParameters().get('cid');      
        attachments=[select Id, Description, ParentId, Name, CreatedDate from Attachment where ParentId=:parentId and CreatedDate = TODAY and OwnerId=:currentUser order by CreatedDate Desc];              
        return null;   
    }
    public PageReference deleteFile(){
         system.debug('**delId**'+delAttId);
         Attachment thisAttachment = new Attachment(id=delAttId);
         delete thisAttachment;
         attachments = null;  
         getAttachments();
         return null;
    }
}