<cfcomponent >
   <cfset this.sessionManagement = true>
   <cfset this.name = "myAddressBook">
   <cfset this.ormEnabled = true>
   <cfset this.datasource = "cf_tutorial">  

<cffunction name="onApplicationStart" returnType="boolean">
   <cfset application.contactObj = new components.contactDatabaseOperations()>
   <cfset application.userObj = new components.userDatabaseOperations()>
   <cfset application.pdfObj = new components.pdf()>
   <cfset application.excelObj = new components.Excel()>
<cfreturn true>

</cffunction>
   <cffunction  name="onrequest" returntype="any">
    <cfargument name="requestpage">        
    <cfset local.arrayExclude = ["/index.cfm","/signUp.cfm","/loginSuccess.cfm","/scheduleBirthday.cfm","/schedule.cfm"]>
    <cfif arrayContains(local.arrayExclude,arguments.requestpage)>
      <cfinclude  template="#arguments.requestpage#">
    <cfelseif structKeyExists(session, "userId")>
      <cfinclude  template="#arguments.requestpage#">
    <cfelse>
      <cfinclude  template="./index.cfm">
    </cfif>
  </cffunction>
</cfcomponent>