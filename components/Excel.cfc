<cfcomponent >
   <cffunction name="getExcel"  access="remote">
      <cfquery name="getContacts" datasource="#application.datasource#">
            SELECT contactId,title,firstName,lastName,gender,dateOfBirth,photo,Address,street,district,state,nationality,pinCode,emailId,phoneNumber FROM Contact WHERE _createdBy = <cfqueryparam value = #session.userName# cfsqltype="cf_sql_varchar">
      </cfquery>      
      <cfset local.fileName = createUUID() & ".xlsx">
      <cfset local.exceFilePath = expandPath("../ExcelFiles/"&local.fileName)>
      <cfspreadsheet  action="write" query="getContacts" overwrite="no" filename="#local.exceFilePath#">
   </cffunction>
</cfcomponent>