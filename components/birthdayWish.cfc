<cfcomponent >  
   <cffunction name="sendEmail" access="remote" returntype="void">
      <cfargument name="userId" type="string">        
      <cfset local.userContacts = application.contactObj.fetchContacts(arguments.userId)>
      <cfif dateFormat(local.userContacts.dateOfBirth,"dd-mm") EQ dateFormat(now(),"dd-mm")>     
         <cfset local.sender = "adarshus1999@gmail.com">
         <cfmail from="#local.sender#" subject="birthday" to="#local.userContacts.emailId#" >
            Happy Birthday #local.userContacts.firstName# 
         </cfmail>
      </cfif>
   </cffunction>
</cfcomponent>