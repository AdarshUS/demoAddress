 <cfcomponent >
   <cffunction name="createContact" access="public" returntype="boolean">
      <cfargument name="title" type="string" required="true">
      <cfargument name="firstName" type="string" required="true"> 
      <cfargument name="lastName" type="string" required="true"> 
      <cfargument name="gender" type="string" required="true"> 
      <cfargument name="dateOfBirth" type="string" required="true">
      <cfargument name="photo" type="string" required="true">
      <cfargument name="Address" type="string" required="true">
      <cfargument name="street" type="string" required="true">
      <cfargument name="district" type="string" required="true">
      <cfargument name="state" type="string" required="true">
      <cfargument name="nationality" type="string" required="true">
      <cfargument name="pinCode" type="string" required="true">
      <cfargument name="email" type="string" required="true">
      <cfargument name="phone" type="string" required="true">
      <cfargument name="role" type="string" required="false">  
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
                  <cfqueryparam value="#arguments.photo#" cfsqltype="cf_sql_varchar">,
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
            SELECT c.contactId,
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
      <cfargument name="photo" type="string" required="true">
      <cfargument name="address" type="string" required="true">
      <cfargument name="street" type="string" required="true">
      <cfargument name="district" type="string" required="true">
      <cfargument name="state" type="string" required="true">
      <cfargument name="nationality" type="string" required="true">
      <cfargument name="pincode" type="string" required="true">
      <cfargument name="emailId" type="string" required="true">
      <cfargument name="phoneNumber" type="string" required="true">
      <cfargument name="hiddenPhoto" type="string" required="true">
      <cfargument name="role"  type="string" required="true">      
      <cfif len(arguments.photo)>            
         	<cfset local.uploadRelativePath = "./Images/Uploads/">				
            <cfset local.uploadedImagePath = application.contactObj.uploadImage(uploadRelativePath,"photo")>
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

   <cffunction  name="uploadImage" access="public" returntype="string">
      <cfargument name="pathForDownload" type="string"  required="true">
      <cfargument name="inputName" type="string" required="true">
      <cffile action="upload" destination="#expandPath(arguments.pathForDownload)#" nameconflict="makeUnique" filefield="#arguments.inputName#" result="newPath" >
      <cfset local.imagePath = arguments.pathForDownload & #newPath.ServerFile#>     
      <cfreturn local.imagePath>
   </cffunction>
</cfcomponent>