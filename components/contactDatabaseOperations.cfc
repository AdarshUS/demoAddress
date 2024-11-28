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
      <cftry>
         <cfquery name="insertContact" datasource="#application.datasource#">
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
                  ,< cfqueryparam value = "#session.userName#" cfsqltype = "varchar" >
                  ,< cfqueryparam value = "#session.userName#" cfsqltype = "varchar" >
                  )
         </cfquery>
      <cfcatch type="any">
      <cfoutput >
          <p>#cfcatch.detail#</p>  
      </cfoutput>
        
         <cfdump var="inside catch" abort>
         <cfreturn false>               
      </cfcatch>
    </cftry>
      <cfreturn true>
   </cffunction>

   <cffunction name="fetchContacts" access="public" returntype="query">
      <cftry>
         <cfquery name="getContacts" datasource="#application.datasource#">
           SELECT contactId
                  ,title
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
            FROM Contact
            WHERE _createdBy = < cfqueryparam value = "#session.userName#" >
         </cfquery>
      <cfcatch type="any">                        
      </cfcatch>              
      </cftry>
      <cfreturn getContacts>
   </cffunction>

   <cffunction name="fetchSingleContact" access="remote" returntype="struct" returnformat="JSON">
      <cfargument name="contactId" type="string" required="true">
      <cfset local.structContact = structNew()>
      <cfquery name="fetchAcontact" datasource="#application.datasource#">
         SELECT contactId
                ,title
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
         FROM Contact
         WHERE contactId = < cfqueryparam value = "#arguments.contactId#" >
      </cfquery>
      <cfset session.contactId = fetchAcontact.contactId>       
       <cfset var colname = "">            
       <cfloop list="#fetchAcontact.columnList#" index="colname">
          <cfset "structContact.#colname#" = fetchAcontact[colname][1]>
       </cfloop>
       <cfset local.structContact["dateOfBirth"] = dateFormat(fetchAcontact.dateOfBirth,"yyyy-mm-dd")>
      <cfreturn local.structContact>
   </cffunction>

   <cffunction name="deleteContact" access="remote" returntype="void">      
      <cfargument name="contactId" type="string" required="true">      
      <cfquery name="deleteContact" datasource="#application.datasource#">
         DELETE
         FROM Contact
         WHERE contactId = < cfqueryparam value = "#arguments.contactId#" cfsqltype = "varchar" >             
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

      <cfif len(arguments.photo)>
         	<cfset local.uploadRelativePath = "./Images/Uploads/">
				<cffile action="upload" destination="#expandPath(local.uploadRelativePath)#" nameconflict="makeUnique" filefield="photo" result="newPath" >
				<cfset local.imagePath = local.uploadRelativePath & #newPath.ServerFile#>	
            <cfset local.photo = arguments.photo>
      <cfelse>
         <cfquery name = "qryPhoto" datasource="#application.datasource#">
            SELECT photo
            FROM contact
            WHERE contactId = < cfqueryparam value = "#session.contactId#" cfsqltype = "cf_sql_varchar" >
         </cfquery>
         <cfset local.photo = qryPhoto.photo>
      </cfif>
      <cfset local.todayDate = dateFormat(now(),"dd-mm-yyy")>
      <cfquery name="editContact" datasource="#application.datasource#">
         UPDATE Contact
         SET title = < cfqueryparam value = '#arguments.title#' cfsqltype = "varchar" >
            ,firstName = < cfqueryparam value = '#arguments.firstName#' cfsqltype = "varchar" >
            ,lastName = < cfqueryparam value = "#arguments.lastName#" cfsqltype = "varchar" >
            ,gender = < cfqueryparam value = "#arguments.gender#" cfsqltype = "varchar" >
            ,dateOfBirth = < cfqueryparam value = "#arguments.dateOfBirth#" cfsqltype = "date" >
            ,photo = < cfqueryparam value = "#local.photo#" cfsqltype = "varchar" >
            ,Address = < cfqueryparam value = "#arguments.address#" cfsqltype = "varchar" >
            ,street = < cfqueryparam value = "#arguments.street#" cfsqltype = "varchar" >
            ,district = < cfqueryparam value = "#arguments.district#" cfsqltype = "varchar" >
            ,STATE = < cfqueryparam value = "#arguments.state#" cfsqltype = "varchar" >
            ,nationality = < cfqueryparam value = "#arguments.nationality#" cfsqltype = "varchar" >
            ,pinCode = < cfqueryparam value = "#arguments.pincode#" cfsqltype = "varchar" >
            ,emailId = < cfqueryparam value = "#arguments.emailId#" cfsqltype = "varchar" >
            ,phoneNumber = < cfqueryparam value = "#arguments.phoneNumber#" cfsqltype = "varchar" >
            ,_updatedOn = < cfqueryparam value = "#local.todayDate#" cfsqltype = "cf_sql_date" >
         WHERE contactId = < cfqueryparam value = "#arguments.contactId#" >
      </cfquery>      
   </cffunction>
</cfcomponent>