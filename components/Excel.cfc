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

   <cffunction name="getExcelHeaders"  access="remote" returntype="struct" returnformat="JSON">		
      <cfset local.contacts =application.contactObj.fetchContacts(session.userId)>
      <cfset queryDeleteColumn(local.contacts, "photo")>
      <cfset local.allColumns = local.contacts.getColumnList()>
       <cfset local.excludedColumn = "photo">
      <!---  <cfset local.filteredColumns = arrayDeleteNoCase(local.allColumns,local.excludedColumn)> --->
      <cfset local.headersOnlyQuery = QueryNew(ArrayToList(local.allColumns))> 
      <cfset local.fileName = "myContactSheet.xlsx">
      <cfset local.exceFilePath = expandPath("../Files/"&local.fileName)>
      <cfset local.excelPathUsernameStruct = structNew()>      
      <cfspreadsheet  action="write" query="local.headersOnlyQuery" overwrite="yes" filename="#local.exceFilePath#">
      <cfset local.excelPathUsernameStruct["fileForDownload"] = "./Files/"&local.fileName>
      <cfset local.currentTime= dateTimeFormat(now(),"dd-mm-yyyy-HH-nn-ss")>
      <cfset local.excelPathUsernameStruct["user"] = "Plain_Template.xlsx">      
      <cfreturn local.excelPathUsernameStruct>
   </cffunction>
</cfcomponent>