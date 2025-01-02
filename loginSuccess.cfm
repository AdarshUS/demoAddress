 <cflogin>
    <cfoauth
       type="google"       
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
    <cfset name = userInfo.name>
    <cfset email  = userInfo.email>
    <cfset image = userInfo.picture>
    <cfset userName = Replace(name, " ", "", "all")& createUUID()>     
    <cfset isInserted = application.userObj.insertUser(
        fullName = name,
        emailId = email,
        userName = username,
        password = '', 
        profilePhoto = image)>  
    <cfif isInserted> 
        <cfset session.fullName = name>
        <cfset session.profilePhoto = image>
        <cfset session.userId = userName>
        <cflocation url="./homePage.cfm"  addtoken="no">
    <cfelse>   
        <cfset local.userData  = application.userObj.verifyEmail(email = email)>        
        <cfset session.userid = userData.userid>
        <cfset session.profilePhoto = userData.profilePhoto>
        <cfset session.fullName = userData.fullName>
        <cflocation url="./homePage.cfm"  addtoken="no"> 
    </cfif>
<cfelse>
    <cfoutput>Authorization failed</cfoutput>
</cfif>