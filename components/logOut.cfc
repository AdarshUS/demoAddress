<cfcomponent >
  <cffunction name="logOutUser"  access="remote">
    <cfset StructClear(Session)>     
  </cffunction>
</cfcomponent>