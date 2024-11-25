<cfcomponent >
   <cfset this.sessionManagement = true>
   <cfset this.name = "myAddressBook">

   <cffunction name="onApplicationStart"  returntype="boolean">
      <cfset application.datasource = "cf_tutorial">
      <cfreturn true>
   </cffunction>

   <cffunction  name="onrequest" returntype="any">
    <cfargument name="requestpage">        
    <cfset local.arrayExclude = ["/index.cfm","/signUp.cfm"]>
    <cfif arrayContains(local.arrayExclude,arguments.requestpage)>
      <cfinclude  template="#arguments.requestpage#">
    <cfelseif structKeyExists(session, "userName")>
      <cfinclude  template="#arguments.requestpage#">
    <cfelse>
      <cfinclude  template="./index.cfm">
    </cfif>
  </cffunction>
</cfcomponent>