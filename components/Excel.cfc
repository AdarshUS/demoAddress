<cfcomponent >
   <cffunction name="getExcel"  access="remote" returntype="string" returnformat="JSON">      
		 <cfset local.contactObj = new contactDatabaseOperations()>
      <cfset local.contacts = local.contactObj.fetchContacts(session.userName)>
      <cfset local.fileName = "myContactSheet.xlsx">
      <cfset local.exceFilePath = expandPath("../Files/"&local.fileName)>
      <cfset local.fileForDownload = "./Files/"&local.fileName>
      <cfspreadsheet  action="write" query="local.contacts" overwrite="yes" filename="#local.exceFilePath#">
      <cfreturn local.fileForDownload>
   </cffunction>
</cfcomponent>