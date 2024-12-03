<cfcomponent >
   <cfset this.sessionManagement = true>
   <cfset this.name = "myAddressBook">
   <cfset this.ormEnabled = true>
   <cfset this.datasource = "cf_tutorial">

   <cffunction  name="onrequest" returntype="any">
    <cfargument name="requestpage">        
    <cfset local.arrayExclude = ["/index.cfm","/signUp.cfm","/loginSuccess.cfm","/scheduleBirthday.cfm","/schedule.cfm"]>
    <cfif arrayContains(local.arrayExclude,arguments.requestpage)>
      <cfinclude  template="#arguments.requestpage#">
    <cfelseif structKeyExists(session, "userName")>
      <cfinclude  template="#arguments.requestpage#">
    <cfelse>
      <cfinclude  template="./index.cfm">
    </cfif>
  </cffunction>
</cfcomponent>