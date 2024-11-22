<cfcomponent >
   <cffunction name="upload" access="public">
      <cfargument name="image" type="string" required="true" >
      <cffile action="upload" destination="C:\ColdFusion2021\cfusion\wwwroot\AddressBook\Images" nameconflict="makeUnique" filefield="image" result="newPath" >
      <cfreturn newPath>
   </cffunction>
</cfcomponent>