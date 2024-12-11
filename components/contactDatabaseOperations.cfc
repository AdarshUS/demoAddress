 <cfcomponent >
   <cffunction name="createContact" access="public" returntype="boolean" >
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
      <cfargument  name="role" type="string" required="false">
      <cftry>
         <cfquery name="insertContact">
            INSERT INTO Contact (
               title
               ,firstName
               ,lastName
               ,gender
               ,dateOfBirth
               ,photo
               ,Address
               ,street
               ,district
               ,STATE
               ,nationality
               ,pinCode
               ,emailId
               ,phoneNumber
               ,_createdBy
               ,_updatedBy
	            )
               VALUES (
                   < cfqueryparam value = "#arguments.title#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.firstName#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.lastName#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.gender#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.dateOfBirth#" cfsqltype = "date" >
                  ,< cfqueryparam value = "#arguments.photo#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.Address#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.street#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.district#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.state#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.nationality#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.pinCode#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.email#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#arguments.phone#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#session.userId#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#session.userId#" cfsqltype = "varchar" >
                  )
         </cfquery>       
        <cfquery name="insertContactRole">        
        <cfloop list="#arguments.role#" delimiters="," item="role">        
            INSERT INTO contact_roles(contact_id, role_id)
               VALUES (
            (SELECT contactId FROM Contact WHERE emailId = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">),
            <cfqueryparam value="#role#" cfsqltype="cf_sql_varchar">
            );
         </cfloop>
      </cfquery>      
      <cfcatch type="any">
      <cfoutput >
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
         <cfquery name="getContacts">
            SELECT 
                c.contactId,
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
                (
                    SELECT STRING_AGG(r.role, ', ') 
                    FROM contact_roles cr
                    INNER JOIN Role r ON cr.role_id = r.roleId
                    WHERE cr.contact_id = c.contactId
                ) AS roles
            FROM 
                Contact c
            WHERE 
                c._createdBy = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_varchar">
         </cfquery>
      <cfcatch type="any">                        
      </cfcatch>              
      </cftry>
      <cfreturn getContacts>
   </cffunction>

   
   <cffunction name="fetchSingleContact" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="contactId" type="string" required="true">
    <cfset var local = {}> <!--- Initialize local scope --->
    <cfset local.structContact = structNew()>

    <!--- Fetch contact details --->
    <cfquery name="local.fetchAcontact">
        SELECT 
            contactId, title, firstName, lastName, gender, 
            dateOfBirth, photo, address, street, district, 
            state, nationality, pinCode, emailId, phoneNumber
        FROM Contact
        WHERE contactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!--- Fetch roles for the contact --->
    <cfquery name="local.fetchARole" >
        SELECT contact_roles.contact_id, Role.role,Role.roleId
        FROM Role
        INNER JOIN contact_roles 
            ON Role.roleId = contact_roles.role_id
        WHERE contact_id = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!--- Map contact details to struct --->
    <cfset var colname = "">
    <cfloop list="#local.fetchAcontact.columnList#" index="colname">
        <cfset local.structContact[colname] = local.fetchAcontact[colname][1]>
    </cfloop>

    <!--- Format dateOfBirth --->
    <cfif NOT isNull(local.structContact.dateOfBirth)>
        <cfset local.structContact.dateOfBirth = dateFormat(local.structContact.dateOfBirth, "yyyy-MM-dd")>
    </cfif>

    <!--- Add roles to structContact --->
    <cfset local.structContact.roles = []>
    <cfloop query="local.fetchARole">
        <cfset arrayAppend(local.structContact.roles, local.fetchARole.role)>
    </cfloop>

    <cfset local.structContact.rolesId = []>
    <cfloop query="local.fetchARole">
        <cfset arrayAppend(local.structContact.rolesId, local.fetchARole.roleId)>
    </cfloop>

    <!--- Return the structured contact details --->
    <cfreturn local.structContact>
</cffunction>


   <cffunction name="deleteContact" access="remote" returntype="void">      
      <cfargument name="contactId" type="string" required="true">   
      <cfquery name="deleteRole">
         DELETE FROM contact_roles WHERE contact_id = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "varchar" > 
      </cfquery>   
      <cfquery name="deleteContact">
         DELETE
         FROM Contact
         WHERE contactId = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "varchar" >             
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
				<cffile action="upload" destination="#expandPath(local.uploadRelativePath)#" nameconflict="makeUnique" filefield="photo" result="newPath" >
				<cfset local.imagePath = local.uploadRelativePath & #newPath.ServerFile#>	
            <cfset local.photo = local.imagePath>
      <cfelse>       
         <cfset local.photo = arguments.hiddenPhoto>
      </cfif>
      <cfset local.todayDate = dateFormat(now(),"dd-mm-yyy")>      
     <cfquery name="editContact">
    UPDATE Contact         
    SET title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">
        , firstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">
        , lastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar">
        , gender = <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">
        , dateOfBirth = <cfqueryparam value="#arguments.dateOfBirth#" cfsqltype="cf_sql_date">
        , photo = <cfqueryparam value="#local.photo#" cfsqltype="cf_sql_varchar">
        , address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
        , street = <cfqueryparam value="#arguments.street#" cfsqltype="cf_sql_varchar">
        , district = <cfqueryparam value="#arguments.district#" cfsqltype="cf_sql_varchar">
        , state = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">
        , nationality = <cfqueryparam value="#arguments.nationality#" cfsqltype="cf_sql_varchar">
        , pinCode = <cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_varchar">
        , emailId = <cfqueryparam value="#arguments.emailId#" cfsqltype="cf_sql_varchar">
        , phoneNumber = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">
        , _updatedOn = <cfqueryparam value="#local.todayDate#" cfsqltype="cf_sql_date">
    WHERE contactId = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
   </cfquery>
   <cfquery>
      DELETE FROM contact_roles WHERE contact_id = <cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">
   </cfquery>   
      <cfloop list="#arguments.role#" item="RoleItem">      
           <cfquery> 
               INSERT INTO contact_roles(contact_id,role_id) VALUES(<cfqueryparam value="#arguments.contactId#" cfsqltype="cf_sql_integer">,<cfqueryparam value="#RoleItem#" cfsqltype="cf_sql_integer">)
           </cfquery>
     </cfloop>
   
   </cffunction>
   <cffunction name="fetchRoles" access="public" returntype="query">
      <cfquery  name="getRoles">
         SELECT roleId
         ,role
         FROM Role; 
      </cfquery>
      <cfreturn getRoles>
   </cffunction>
</cfcomponent>