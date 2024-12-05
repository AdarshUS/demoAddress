<cfcomponent >  
   <cffunction name="sendEmail" access="remote" returntype="void">
   <cfargument name="user" type="string">
      <cfquery name = "getContactsDob">
          SELECT firstName,emailId,dateOfBirth from Contact WHERE _createdBy = <cfqueryparam value = #arguments.user# cfsqltype="CF_SQL_VARCHAR">
      </cfquery>
      <cfif dateFormat(getContactsDob.dateOfBirth,"dd-mm") EQ dateFormat(now(),"dd-mm")>     
         <cfset local.sender = "adarshus1999@gmail.com">
         <cfmail from="#local.sender#" subject="birthday" to="#getContactsDob.emailId#" >
            Happy Birthday #getContactsDob.firstName# 
         </cfmail>               
      </cfif>
   </cffunction>
</cfcomponent>