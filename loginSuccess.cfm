<cfparam name="url.code" default="">
<cfif url.code neq "">
    <!-- Exchange Authorization Code for Access Token -->
    <cfhttp method="POST" url="https://oauth2.googleapis.com/token" result="response">
        <cfhttpparam type="formfield" name="code" value="#url.code#">
        <cfhttpparam type="formfield" name="client_id" value="636355117117-8idvgifnno7urc2tqu7aqq3vs6dvkkei.apps.googleusercontent.com">
        
        <cfhttpparam type="formfield" name="redirect_uri" value="https://www.myaddressbook.localhost.org/loginSuccess.cfm">
        <cfhttpparam type="formfield" name="grant_type" value="authorization_code">
    </cfhttp>

    <cfset accessToken = DeserializeJSON(response.fileContent).access_token>

    <!-- Retrieve User Info -->
    <cfhttp method="GET" url="https://www.googleapis.com/oauth2/v2/userinfo" result="userResponse">
        <cfhttpparam type="header" name="Authorization" value="Bearer #accessToken#">
    </cfhttp>

    <cfset userInfo = DeserializeJSON(userResponse.fileContent)>

    <!-- Output User Info -->
    <cfoutput>
        Welcome, #userInfo.name# <br>
        Email: #userInfo.email# <br>
        Google ID: #userInfo.id#
    </cfoutput>
<cfelse>
    <cfoutput>Error: Missing Authorization Code</cfoutput>
</cfif>