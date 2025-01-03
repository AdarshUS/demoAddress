 <cfcomponent >
   <cffunction name="createContact" access="public" returntype="boolean">
      <cfargument name="title" type="string" required="true">
      <cfargument name="firstName" type="string" required="true"> 
      <cfargument name="lastName" type="string" required="true"> 
      <cfargument name="gender" type="string" required="true"> 
      <cfargument name="dateOfBirth" type="string" required="true">
      <cfargument name="photo" type="string" required="false" default="">
      <cfargument name="Address" type="string" required="true">
      <cfargument name="street" type="string" required="true">
      <cfargument name="district" type="string" required="true">
      <cfargument name="state" type="string" required="true">
      <cfargument name="nationality" type="string" required="true">
      <cfargument name="pinCode" type="string" required="true">
      <cfargument name="email" type="string" required="true">
      <cfargument name="phone" type="string" required="true">
      <cfargument name="role" type="string" required="true"> 
      <cfif NOT len(arguments.photo)>
         <cfset local.image = "./Images/DefaultImage/profile.png">        
      <cfelse>
          <cfset local.image = arguments.photo>          
      </cfif>       
      <cftry>
          <cfquery name="local.insertContact" result="local.record">
              INSERT INTO Contact (
                  title,
                  firstName,
                  lastName,
                  gender,
                  dateOfBirth,
                  photo,
                  Address,
                  street,
                  district,
                  STATE,
                  nationality,
                  pinCode,
                  emailId,
                  phoneNumber,
                  _createdBy,
                  _updatedBy,
                  active
              )
              VALUES (
                  <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.dateOfBirth#" cfsqltype="cf_sql_date">,
                  <cfqueryparam value="#local.image#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.Address#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.street#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.district#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.nationality#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.pinCode#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="1" cfsqltype="cf_sql_integer">
              )
          </cfquery>  
          <cfquery name="local.insertContactRole">
              <cfloop list="#arguments.role#" delimiters="," item="role">
                  INSERT INTO contact_roles (contact_id, role_id)
                  VALUES (
                      <cfqueryparam value="#local.record.generatedKey#" cfsqltype="cf_sql_integer">,
                      <cfqueryparam value="#role#" cfsqltype="cf_sql_varchar">
                  );
              </cfloop>
          </cfquery>  
          <cfcatch type="any">
              <cfoutput>
                  <p>#cfcatch.detail#</p>
              </cfoutput>
              <cfreturn false>
          </cfcatch>
      </cftry>  
      <cfreturn true>
  </cffunction>  

   <cffunction name="fetchContacts" access="public" returntype="query">
      <cfargument name="userId" type="string" required="true">
      <cftry>
         <cfquery name="local.getContacts">
            SELECT c.title,
	               c.firstName,
	               c.lastName,
	               c.gender,
	               c.dateOfBirth,
	               c.photo,
	               c.Address,
	               c.street,
	               c.district,
	               c.STATE,
	               c.nationality,
	               c.pinCode,
	               c.emailId,
	               c.phoneNumber,
	               STRING_AGG(r.ROLE, ', ') AS roles
            FROM Contact c
            INNER JOIN contact_roles cr ON c.contactId = cr.contact_id
            INNER JOIN ROLE r ON r.roleId = cr.role_id
            WHERE c._createdBy = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
            AND   c.active = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            GROUP BY c.contactId,
	                 c.title,
	                 c.firstName,
	                 c.lastName,
	                 c.gender,
	                 c.dateOfBirth,
	                 c.photo,
	                 c.Address,
	                 c.street,
	                 c.district,
	                 c.STATE,
	                 c.nationality,
	                 c.pinCode,
	                 c.emailId,
	                 c.phoneNumber               
         </cfquery>
      <cfcatch type="any">  
         <cfdump var="#cfcatch#" >                      
      </cfcatch>              
      </cftry>
      <cfreturn local.getContacts>
   </cffunction>
   
   <cffunction name="fetchSingleContact" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="contactId" type="string" required="true">
    <cfset var local = {}> 
    <cfset local.structContact = structNew()>   
    <cfquery name="local.fetchAcontact">
       SELECT 
            c.contactId, 
            c.title, 
            c.firstName, 
            c.lastName, 
            c.gender, 
            c.dateOfBirth, 
            c.photo, 
            c.address, 
            c.street, 
            c.district, 
            c.STATE, 
            c.nationality, 
            c.pinCode, 
            c.emailId, 
            c.phoneNumber, 
            r.ROLE AS role, 
            r.roleId
      FROM Contact c
      LEFT JOIN contact_roles cr ON c.contactId = cr.contact_id
      LEFT JOIN ROLE r ON cr.role_id = r.roleId
      WHERE c.contactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_varchar">
    </cfquery>    
    <cfset var colname = "">
    <cfloop list="#local.fetchAcontact.columnList#" index="colname">
        <cfset local.structContact[colname] = local.fetchAcontact[colname][1]>
    </cfloop>    
    <cfif NOT isNull(local.structContact.dateOfBirth)>
        <cfset local.structContact.dateOfBirth = dateFormat(local.structContact.dateOfBirth, "yyyy-MM-dd")>
    </cfif>    
    <cfset local.structContact.roles = []>
    <cfloop query="local.fetchAcontact">
        <cfset arrayAppend(local.structContact.roles, local.fetchAcontact.role)>
    </cfloop>    
    <cfset local.structContact.rolesId = []>
    <cfloop query="local.fetchAcontact">
        <cfset arrayAppend(local.structContact.rolesId, local.fetchAcontact.roleId)>
    </cfloop>    
    <cfreturn local.structContact>
</cffunction>

<cffunction name="deleteContact" access="remote" returntype="void">
   <cfargument name="contactId" type="string" required="true">
   <cfquery name="local.deleteContact">
       UPDATE Contact
       SET
           active = 0
       WHERE
           contactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
   </cfquery>
</cffunction>

   <cffunction name="editContact" access="public">
      <cfargument name="contactId" type="string" required="true">
      <cfargument name="title" type="string" required="true">
      <cfargument name="firstName" type="string" required="true">
      <cfargument name="lastName" type="string" required="true">
      <cfargument name="gender" type="string" required="true">
      <cfargument name="dateOfBirth" type="string" required="true">
      <cfargument name="photo" type="string" required="false" default="">
      <cfargument name="address" type="string" required="true">
      <cfargument name="street" type="string" required="true">
      <cfargument name="district" type="string" required="true">
      <cfargument name="state" type="string" required="true">
      <cfargument name="nationality" type="string" required="true">
      <cfargument name="pincode" type="string" required="true">
      <cfargument name="emailId" type="string" required="true">
      <cfargument name="phoneNumber" type="string" required="true">
      <cfargument name="hiddenPhoto" type="string" required="false" default="./Images/DefaultImage/profile.png">
      <cfargument name="role"  type="string" required="true">            
            <cfif len(arguments.photo)>            
               <cfset local.uploadRelativePath = "./Images/Uploads/">				
               <cfset local.uploadedImagePath = application.contactObj.uploadFile(uploadRelativePath,"photo")>
               <cfset local.photo = local.uploadedImagePath>
            <cfelse>               
                  <cfset local.photo = arguments.hiddenPhoto>              
            </cfif>
            <cfset local.todayDate = dateFormat(now(),"dd-mm-yyy")> 
            <cfquery name="local.editContact">
              UPDATE Contact         
              SET 
                  title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
                  firstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">,
                  lastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar">,
                  gender = <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
                  dateOfBirth = <cfqueryparam value="#arguments.dateOfBirth#" cfsqltype="cf_sql_date">,
                  photo = <cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">,
                  address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
                  street = <cfqueryparam value="#arguments.street#" cfsqltype="cf_sql_varchar">,
                  district = <cfqueryparam value="#arguments.district#" cfsqltype="cf_sql_varchar">,
                  state = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
                  nationality = <cfqueryparam value="#arguments.nationality#" cfsqltype="cf_sql_varchar">,
                  pinCode = <cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_varchar">,
                  emailId = <cfqueryparam value="#arguments.emailId#" cfsqltype="cf_sql_varchar">,
                  phoneNumber = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">,
                  _updatedOn = <cfqueryparam value="#local.todayDate#" cfsqltype="cf_sql_date">
              WHERE contactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="local.deleteExistingRoles">
               DELETE
               FROM 
                  contact_roles
               WHERE 
                  contact_id = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "cf_sql_integer" >
            </cfquery>   
            <cfloop list="#arguments.role#" item="RoleItem">      
               <cfquery name="local.insertNewRoles"> 
                   INSERT INTO 
                     contact_roles(
                        contact_id,
                        role_id
                     ) 
                     VALUES(
                        <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#RoleItem#" cfsqltype="cf_sql_integer">
                     )
               </cfquery>
            </cfloop>            
   </cffunction>

   <cffunction name="fetchRoles" access="public" returntype="query">
      <cfquery  name="local.getRoles">
         SELECT 
            roleId,
            role
         FROM
            Role; 
      </cfquery>
      <cfreturn local.getRoles>
   </cffunction>

   <cffunction  name="uploadFile" access="remote" returntype="string">
      <cfargument name="path" type="string"  required="true">
      <cfargument name="inputName" type="string" required="true">
      <cffile action="upload" destination="#expandPath(arguments.path)#" nameconflict="makeUnique" filefield="#arguments.inputName#" result="newPath" >
      <cfset local.imagePath = arguments.path & #newPath.ServerFile#>     
      <cfreturn local.imagePath>
   </cffunction>

   <cffunction name="processExcel" access="remote" returnformat="JSON">
    <cfargument name="excelfile" required="true">
    <cfspreadsheet action="read" src="#arguments.excelfile#" query="local.excelQuery" headerrow="1" excludeHeaderRow="true">    
    <cfset local.excelResultQuery = queryNew("title,firstName,LastName,gender,dateOfBirth,Address,street,district,state,nationality,pincode,emailId,phoneNumber,roles,result","Varchar,Varchar,Varchar,Varchar,Date,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar,Varchar")>
    <cfset local.requiredFields = ["title", "firstName", "LastName", "gender", "dateOfBirth", "Address", "street", "district", "state", "nationality", "pincode", "emailId", "phoneNumber", "roles"]>
    <cfset local.titleList = ["Mr", "Miss", "Mrs"]>
    <cfset local.validGenders = ["Male", "Female", "Other"]>
    <cfset local.validEmailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.(?:[A-Z]{2}|com|org|net|edu|gov)$">
   
     <cfquery name="local.checkEmail">
        SELECT *
        FROM contact
        WHERE
            _createdBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_varchar">
            AND active = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
    </cfquery>   
    <cfset local.queryEmailStruct = structNew()>
    <cfloop query="#local.checkEmail#">
        <cfset local.queryEmailStruct[local.checkEmail.emailId] = local.checkEmail.contactId>
    </cfloop>
    <cfset QueryAddColumn(local.excelQuery, "result","Varchar",arrayNew(1))>
    <cfloop query="local.excelQuery">
        <cfset local.rowError = "">
        <cfloop array="#local.requiredFields#" item="column">
            <cfif len(trim(local.excelQuery[column][currentRow])) EQ 0>
                <cfset local.rowError = listAppend(local.rowError, column & " missing")>
            </cfif>
        </cfloop>
        <cfif NOT listFind(arrayToList(local.titleList), local.excelQuery.title)>
            <cfset local.rowError = listAppend(local.rowError, "Invalid title")>
        </cfif>
        <cfif NOT listFind(arrayToList(local.validGenders), local.excelQuery.gender)>
            <cfset local.rowError = listAppend(local.rowError, "Invalid gender")>
        </cfif>
        <cfif NOT reFindNoCase(local.validEmailRegex, local.excelQuery.emailId)>
            <cfset local.rowError = listAppend(local.rowError, "Invalid MailId")>
        </cfif>
        <cftry>
             <cfset parsedDate = ParseDateTime(local.excelQuery.dateOfBirth, "dd/mm/yyyy")>
        <cfcatch>
            <cfset local.rowError = listAppend(local.rowError, "Invalid Dob")>
        </cfcatch>
        </cftry>
        <cfif NOT len(trim(local.excelQuery.pincode)) EQ 6>
            <cfset local.rowError = listAppend(local.rowError, "Invalid pincode")>                  
        </cfif>
        <cfif NOT len(trim(local.excelQuery.phoneNumber)) EQ 10>
             <cfset local.rowError = listAppend(local.rowError, "Invalid phoneNumber")>
        </cfif>
        <cfset local.roleQry = application.contactObj.fetchRoles()>
        <cfset local.columnValues = valueList(local.roleQry.Role)>   
        <cfset local.roleIdList = "">
        <cfloop list="#local.excelQuery.Roles.toString()#" index="local.role" delimiters=",">
            <cfif NOT listFind(local.columnValues, local.role)>
                <cfset local.rowError = listAppend(local.rowError, "invalid role")>
                <cfbreak>
            </cfif>
            <cfloop query="local.roleQry">
                <cfif local.role EQ local.roleQry.role>
                    <cfset local.roleIdList = listAppend(local.roleIdList, local.roleQry.roleId)>
                </cfif>
            </cfloop>
        </cfloop>        
        <cfif len(trim(local.rowError)) EQ 0 >        
            <cfif structKeyExists(local.queryEmailStruct, local.excelQuery.emailId.toString())>           
                <cfset editContact(
                    contactId = local.queryEmailStruct[local.excelQuery.emailId],
                    title = local.excelQuery.title,
                    firstName = local.excelQuery.firstName,
                    lastName = local.excelQuery.lastName,
                    gender = local.excelQuery.gender,
                    dateOfBirth = local.excelQuery.dateOfBirth,
                    address = local.excelQuery.Address,
                    street = local.excelQuery.street,
                    district = local.excelQuery.district,
                    state = local.excelQuery.state,
                    nationality = local.excelQuery.nationality,
                    pinCode = local.excelQuery.pinCode,
                    emailId = local.excelQuery.emailId,
                    phoneNumber = local.excelQuery.phoneNumber,
                    role = local.roleIdList
                )>
                <cfset local.rowError = "updated">
            <cfelse>
                <cfset application.contactObj.createContact(
                    title = local.excelQuery.title,
                    firstName = local.excelQuery.firstName,
                    lastName = local.excelQuery.lastName,
                    gender = local.excelQuery.gender,
                    dateOfBirth = local.excelQuery.dateOfBirth,
                    Address = local.excelQuery.Address,
                    street = local.excelQuery.street,
                    district = local.excelQuery.district,
                    state = local.excelQuery.state,
                    nationality = local.excelQuery.nationality,
                    pinCode = local.excelQuery.pinCode,
                    email = local.excelQuery.emailId,
                    phone = local.excelQuery.phoneNumber,
                    role = local.roleIdList
                )>
                <cfset local.rowError = "created">
            </cfif>
        </cfif>
        <cfset local.excelQuery.result[currentRow] = local.rowError>       
    </cfloop>
    <cfset querySort(local.excelQuery, sortExcelQuery)>   
    <cfset local.fileName = "resultExcel.xlsx">
    <cfset local.exceFilePath = expandPath("../Files/" & local.fileName)>
    <cfspreadsheet action="write" query="local.excelQuery" overwrite="yes" filename="#local.exceFilePath#">
    <cfset local.fileForDownload = "./Files/" & local.fileName>    
    <cfreturn local.fileForDownload>
</cffunction>

<cffunction name="sortExcelQuery" access="private">
   <cfargument name="row1" >
   <cfargument name="row2" >
   <cfset local.rowPriority = {"updated":1,"created":2}>
   <cfif structKeyExists(local.rowPriority,arguments.row1.result)>
      <cfset local.value1 = local.rowPriority[arguments.row1.result]>
   <cfelse>
      <cfset local.value1 = 0>
   </cfif>
    <cfif structKeyExists(local.rowPriority,arguments.row2.result)>
      <cfset local.value2 = local.rowPriority[arguments.row2.result]>
   <cfelse>
      <cfset local.value2 = 0>
   </cfif>
   <cfreturn compare(local.value1,local.value2)>
</cffunction>

<cffunction name="checkExistingContacts" access="remote" returntype="boolean" returnformat="JSON">
    <cfargument name="emailId" >      
    <cfargument name="contactId" >    
    <cfquery name="local.existingContacts">
        SELECT 
            *
        FROM
            Contact
        WHERE 
            emailId = <cfqueryparam  value="#arguments.emailId#" cfsqltype="cf_sql_varchar">           
            AND _createdBy = <cfqueryparam  value="#session.userId#" cfsqltype="cf_sql_integer"> 
            AND active = <cfqueryparam  value="1" cfsqltype="cf_sql_integer">
            AND NOT contactId = <cfqueryparam  value="#arguments.contactId#" cfsqltype="cf_sql_varchar">
    </cfquery>    
    <cfif local.existingContacts.RecordCount>
        <cfreturn true>
    </cfif>
    <cfreturn false>
</cffunction>
   
</cfcomponent>