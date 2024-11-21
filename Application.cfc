<cfcomponent >
   <cfset this.sessionManagement = true>
   <cfset this.name = "myAddressBook">

   <cffunction name="onApplicationStart"  returntype="boolean">
      <cfset application.datasource = "cf_tutorial">
      <cfreturn true>
   </cffunction>
</cfcomponent>