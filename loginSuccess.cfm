 <cfset userObj = new components.userDatabaseOperations()>
 <cflogin>
    <cfoauth
       type="google"
       clientid=""
       secretkey=""
       result="res"                  
       scope="email profile">
    </cfoauth>
</cflogin>           
<cfif structKeyExists(res, "access_token")>
    <cfset accessToken = res.access_token>    
    <cfhttp method="GET" url="https://www.googleapis.com/oauth2/v2/userinfo" result="userResponse">
        <cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
    </cfhttp>
    <cfset userInfo = DeserializeJSON(userResponse.fileContent)>    
    <cfset local.name = userInfo.name>
    <cfset local.email  = userInfo.email>
    <cfset local.image = userInfo.picture>
    <cfset local.userName = Replace(local.name, " ", "", "all")& createUUID()>     
    <cfset isInserted = userObj.insert(local.name,local.email,local.username,'',local.image)>  
    <cfif isInserted> 
        <cfset session.fullName = local.name>
        <cfset session.profilePhoto = local.image>
        <cfset session.userName = local.userName>
        <cflocation url="./homePage.cfm" >
    <cfelse>   
        <cfset local.userData  = userObj.verifyEmail(local.email)>
        <cfset session.userName = local.userData.userName>
        <cfset session.profilePhoto = local.userData.profilePhoto>
        <cfset session.fullName = local.userData.fullName>
        <cflocation url="./homePage.cfm" >                          
    </cfif>
<cfelse>
    <cfoutput>Authorization failed</cfoutput>
</cfif>