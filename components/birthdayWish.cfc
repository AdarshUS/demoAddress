<cfcomponent >
   <cffunction name="makeBirthdayWish" access="public" returntype="void">     
   <Cfset local.sender  = "adarshus199@gmail.com">
      <cfquery  name="getcontactDob">
        SELECT firstName,emailId,dateOfBirth from Contact WHERE _createdBy = <cfqueryparam value = #session.userName# cfsqltype="CF_SQL_VARCHAR">             
      </cfquery>
      <cfloop query = getcontactDob>
         <cfif dateFormat(getcontactDob.dateOfBirth,"dd-mm") EQ dateFormat(now(),"dd-mm")>           
            <cfmail from="#local.sender#" subject="birthday" to="#getcontactDob.emailId#" >
               Happy Birthday Manh                           
            </cfmail>
         </cfif>               
      </cfloop>
   </cffunction>
</cfcomponent>