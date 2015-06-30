public class AccessTokenGenerator {
                private static String JWT_PRODUCTION_HOST = 'login.salesforce.com' ; 
                private static String JWT_SANDBOX_HOST = 'test.salesforce.com' ;
                private static AccessTokenGenerator accessTokenGenerator ;
                //private static Map<String, String> accessTokenMap = new Map<String,String>();
                private static List<String> accessTokenList = new List<String>();
                private static String jwtCertificate ;
                private static String jwtConsumerKey ;
                private static String jwtHostName ;
                


                /* Initialize AccessToken Map by Looking up 
                   CustomSettings with all users
                
                private static void initializeTokens() { 
                                jwtCertificate = eFNOL_Settings__c.getValues('JwtCertificate').Value__c; //read from eFNOL_Settings__c 'JwtCertificate'
                                jwtConsumerKey = eFNOL_Settings__c.getValues('JwtConsumerKey').Value__c; //read from eFNOL_Settings__c 'JwtConsumerKey'
                                jwtHostName = eFNOL_Settings__c.getValues('JwtLoginHostName').Value__c; //read from eFNOL_Settings__c 'JwtLoginHostName'
                                List<String> remoteAccessUsers = getUserList() ;
                                if(remoteAccessUsers.size() >0)
                                                setAccessTokensForConnectedAppUsers(remoteAccessUsers) ;
                } */ 

                /* 
                   Initializes list of users to be used for JWT by reading CustomSetting
              
                private static List<String> getUserList() {
                                System.debug('####################: start getUserList'); 
                                // Find all the connectedAppUsers in the custom setting
                                List<EFNOL_ConnectedAppUsers__c> searchConnectedUsersList = EFNOL_ConnectedAppUsers__c.getAll().values() ;
                                List<String> userNameList = new List<String>();
                                if(searchConnectedUsersList.size() > 0) {
                                                for (EFNOL_ConnectedAppUsers__c connectedAppUser : searchConnectedUsersList) {
                                                    //RAJESH
                                                    //userNameList.add(connectedAppUser.UserName__c) ; 
                                                    userNameList.add(connectedAppUser.Name) ;
                                                }
                                }
                                System.debug('####################: ' + userNameList);    
                                return userNameList;
                }  */
                
                /*
                                Get Access Tokens for each connected app user
                                Map<String,String> = Map<Access Token, UserName>
               
                private static void setAccessTokensForConnectedAppUsers(List<String> connectedAppUserList) {
                                if(connectedAppUserList.size() > 0) {
                                                Map<String, String> accessTokenMap = new Map<String,String>();
                                                setAccessTokensFromCache();
                                                if(accessTokenList.size() == 0) { 
                                                                 String accessToken ;
                                                                for(String userName : connectedAppUserList) {
                                                                               //RAJESH
                                                                               //accessToken = getAccessToken(userName) ;
                                                                               accessToken = getAccessToken(EFNOL_ConnectedAppUsers__c.getInstance(userName).UserName__c);
                                                                               System.debug('##############: Access Token: ' + accessToken + ' - UserName: ' + userName) ;
                                                                               if(accessToken != null) {
                                                                                               accessTokenMap.put(userName, accessToken) ;
                                                                                               accessTokenList.add(accessToken) ;
                                                                               }
                                                                }
                                                               //update access tokens in cache
                                                                updateAccessTokens(accessTokenMap) ;
                                                }
                                }
                } */
                                
                /* 
                   Returns access token by calling Jwt API
                
                private static String getAccessToken(String userName) {
                OAuthJwt.Configuration config = new OAuthJwt.Configuration();
        config.jwtUsername = userName;
        config.jwtSigningCertificateName = jwtCertificate;
        config.jwtHostname = jwtHostName ;
        config.jwtConnectedAppConsumerKey = jwtConsumerKey;
        
        return new OAuthJwt(config).requestAccessToken();                            
                }*/
                
                /*
                                Returns access token if token has not experied  
                
                private static void setAccessTokensFromCache() {
                                List<EFNOL_ConnectedAppUsers__c> searchUsers = EFNOL_ConnectedAppUsers__c.getAll().values() ;
                                if(searchUsers.size() >0) {
                                                String accessToken = searchUsers.get(0).Access_Token__c;
                                                DateTime tokenExpiration = searchUsers.get(0).Access_Token_Expiration__c; 
                                                if(accessToken == null || tokenExpiration == null) {
                                                                System.debug('Access Tokens have not been cached. Getting new tokens.');
                                                                return ;
                                                } else {
                                                //checkk if token will expire in the next five minutes
                                                                tokenExpiration = tokenExpiration.addMinutes(-5);
                                                                System.debug('Access Token Expiration: ' + tokenExpiration);
                                                                System.debug('Access Token Time Now: ' + DateTime.now());
                                                                if(tokenExpiration < DateTime.now()) {
                                                                                System.debug('Access Tokens expired. Getting new tokens.');
                                                                                return ; //get new access token
                                                                }
                                                }
                                } 
                                System.debug('Getting Access Tokens from Cache.');
                                for(EFNOL_ConnectedAppUsers__c searchUser : searchUsers ) {
                                                System.debug('##############: Access Token from Cache: ' + searchUser.Access_Token__c + ' - UserName: ' + searchUser.UserName__c) ;
                                                accessTokenList.add(searchUser.Access_Token__c) ;
                                }
                }*/
                
                /* 
                                Updates custom settings to cache access tokens
                
                private static void updateAccessTokens(Map<String,String> accessTokenMap) {
                                //Get timeout setting - better if we can get from user profile settings but in interest of time using custom setting
                                Integer sessionTimeoutValue = Integer.valueOf(eFNOL_Settings__c.getValues('JwtSessionTimeoutValueInHours').Value__c);
                                List<EFNOL_ConnectedAppUsers__c> searchUsers = new List<EFNOL_ConnectedAppUsers__c>();
                                EFNOL_ConnectedAppUsers__c searchUser ;
                                for(String userName : accessTokenMap.keySet()) {
                                                System.debug('Search UserName: ' + userName) ;
                                                searchUser = EFNOL_ConnectedAppUsers__c.getInstance(userName) ;
                                                System.debug('Search User from Cache: ' + searchUser) ;
                                                //RAJESH
                                                //searchUser.Access_Token__c = accessTokenMap.get(searchUser.UserName__c) ;
                                                searchUser.Access_Token__c = accessTokenMap.get(userName) ;
                                                searchUser.Access_Token_Expiration__c = DateTime.now().addHours(sessionTimeoutValue) ;
                                                searchUsers.add(searchUser) ;
                                }
                                /*for(EFNOL_ConnectedAppUsers__c searchUser : searchUsers ) {
                                                searchUser = EFNOL_ConnectedAppUsers__c.getInstance(searchUser.Name) ;
                                                searchUser.Access_Token__c = accessTokenMap.get(searchUser.UserName__c) ;
                                                searchUser.Access_Token_Expiration__c = DateTime.now().addHours(sessionTimeoutValue) ;
                                }
                                update searchUsers ;
                }*/
                
                /* 
                   Returns list of AccessTokens
                
                public static List<String> getAccessTokens() {
                                initializeTokens();
                                return accessTokenList;
                                return null;
                }
                
                public static Boolean isRemoteAccessConfigured() {
                                if(EFNOL_ConnectedAppUsers__c.getAll().values().size() > 0)
                                                return true;
                                else 
                                                return false;
                }    */           


}