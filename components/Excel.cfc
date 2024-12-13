<cfcomponent >
   <cffunction name="getExcel"  access="remote" returntype="struct" returnformat="JSON">		
      <cfset local.contacts =application.contactObj.fetchContacts(session.userId)>
      <cfset local.fileName = "myContactSheet.xlsx">
      <cfset local.exceFilePath = expandPath("../Files/"&local.fileName)>
      <cfset local.excelPathUsernameStruct = structNew()>      
      <cfspreadsheet  action="write" query="local.contacts" overwrite="yes" filename="#local.exceFilePath#">
      <cfset local.excelPathUsernameStruct["fileForDownload"] = "./Files/"&local.fileName>
      <cfset local.currentTime= dateTimeFormat(now(),"dd-mm-yyyy-HH-nn-ss")>
      <cfset local.excelPathUsernameStruct["user"] = "#session.fullName##local.currentTime#">      
      <cfreturn local.excelPathUsernameStruct>
   </cffunction>
</cfcomponent>