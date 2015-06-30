public abstract class JWTController {
/*
   //guest methods
    public String accessToken ;
    public String getAccessToken() {
        return accessToken;
    }

    public void generateAccessToken() {
        accessToken = JSON.serialize(AccessTokenGenerator.getAccessTokens()) ;
         if(accessToken == null)
            accessToken = '' ;
    }

    private void setNewAccessToken(){
        accessToken = JSON.serialize(AccessTokenGenerator.getAccessTokens()) ;
        if(accessToken == null)
            accessToken = '' ;  
        
    }

    public PageReference redirectRequestToHttps() {
        setNewAccessToken();
        PageReference pageRef = null;
        if(AccessTokenGenerator.isRemoteAccessConfigured()) {
            if(!URL.getCurrentRequestUrl().getProtocol().equals('https')) {
                System.debug('################: ApexPages.currentPage().getHeaders() ' + ApexPages.currentPage().getHeaders());
                System.debug('################: Site.getBaseSecureUrl()  ' + Site.getBaseSecureUrl() );
                pageRef = new PageReference(getSecureURL());
                pageRef.setRedirect(true) ;
            }
        }
       return pageRef;
    }
    
    public String getSecureURL() {
        String secureURL = null;
        String pageName = ApexPages.currentPage().getUrl().split('apex/')[1];
        if(pageName != null) {
            secureURL = Site.getBaseSecureUrl() + '/' + pageName;
        } else {
            URL pageUrl = new URL('https', ApexPages.currentPage().getHeaders().get('Host'), URL.getCurrentRequestUrl().getPath());
            secureURL = pageUrl.toExternalForm();
        }
        return secureURL;
    }*/

}