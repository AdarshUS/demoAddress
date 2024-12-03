<cfcomponent >  
   <cffunction name="sendEmail" access="remote" returntype="void">
      <cfargument name="receiverMail" type="string" required="true" >
      <cfargument name="receiverName"  type="string" required="true">
      <cfset local.sender = "adarshus1999@gmail.com">
      <cfmail from="#local.sender#" subject="birthday" to="#arguments.receiverMail#" >
               Happy Birthday #arguments.receiverName# Live Long..
      </cfmail>
   </cffunction>
</cfcomponent>