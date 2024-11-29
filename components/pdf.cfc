<cfcomponent >
   <cffunction name="getPdf" access="remote" returntype="string" returnformat="JSON">
      <!--- Fetch data from the database --->
      <cfquery name="getContacts">        
            SELECT contactId,title,firstName,lastName,gender,dateOfBirth,photo,Address,street,district,state,nationality,pinCode,emailId,phoneNumber FROM Contact WHERE _createdBy = <cfqueryparam value = #session.userName# cfsqltype="cf_sql_varchar">      
      </cfquery>
      <cfset local.fileName = "mypdf.pdf">
      <cfset local.pdfFilePath = "../Files/" & local.fileName>
      <cfset local.fileForDownload = "./Files/"&local.fileName>

<!--- Generate PDF --->
      <cfdocument format="PDF" 
                  filename="#local.pdfFilePath#" 
                  overwrite="yes">
         <h1>My Contacts</h1>
         <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                  <tr>
                     <th>title</th>
                     <th>firstName</th>
                     <th>lastName</th>
                     <th>gender</th>
                     <td>dateOfBirth</td>
                     <th>photo</th>
                     <th>Address</th>
                     <th>street</th>
                     <th>district</th>
                     <th>state</th>
                     <th>nationality</th>
                     <th>pinCode</th>
                     <th>emailId</th>
                     <th>phoneNumber</th>                     
                  </tr>
            </thead>
            <tbody>
                  <!--- Loop through query results --->
                  <cfoutput query="getContacts">
                     <tr>
                        <td>#title#</td>
                        <td>#firstName#</td>
                        <td>#lastName#</td>
                        <td>#gender#</td>
                        <td>#dateOfBirth#</td>
                        <td>#photo#</td>
                        <td>#Address#</td>
                        <td>#street#</td>
                        <td>#district#</td>
                        <td>#state#</td>
                        <td>#nationality#</td>
                        <td>#pinCode#</td>
                        <td>#emailId#</td>
                        <td>#phoneNumber#</td>
                     </tr>
                  </cfoutput>
            </tbody>
         </table>
      </cfdocument>
      <cfreturn local.fileForDownload>
   </cffunction>
</cfcomponent>