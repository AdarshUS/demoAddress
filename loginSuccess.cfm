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
    <cfset name = userInfo.name>
    <cfset email  = userInfo.email>
    <cfset image = userInfo.picture>
    <cfset userName = Replace(name, " ", "", "all")& createUUID()>     
    <cfset isInserted = application.userObj.insert(name,email,username,'',image)>  
    <cfif isInserted> 
        <cfset session.fullName = name>
        <cfset session.profilePhoto = image>
        <cfset session.userName = userName>
        <cflocation url="./homePage.cfm" >
    <cfelse>   
        <cfset local.userData  = userObj.verifyEmail(email)>
        <cfset session.userName = userData.userName>
        <cfset session.profilePhoto = userData.profilePhoto>
        <cfset session.fullName = userData.fullName>
        <cfschedule
          action="update"
          task="birthdaymail"
          operation="HTTPRequest"
          url="http://www.myaddressbook.localhost.org/scheduleBirthday.cfm"
          startDate="#DateFormat(Now(),'YYYY-MM-dd')#"
           starttime="2:40 PM"
          interval ="daily"
          repeat = "0"
          overwrite="true">  
        <cflocation url="./homePage.cfm" >
    </cfif>
<cfelse>
    <cfoutput>Authorization failed</cfoutput>
</cfif>