<cfcomponent >
	<cffunction name="insert"  access="public" returntype="boolean">
		<cfargument name="fullName" required="true" type="string">
		<cfargument name="emailId" required="true" type="string" >
		<cfargument name="userName" required="true" type="string" >
		<cfargument name="password" required="true"  type="string" >
		<cfargument name="profilePhoto" required="true" type="string" >
		<cfset local.password = hash("#arguments.password#" , "SHA-256" , "UTF-8")>
      <!--- <cftry>  --->	
			<cfquery name="insertData" datasource="#application.datasource#">
				INSERT INTO Users(fullName,emailId,userName,password,profilePhoto) VALUES('#arguments.fullName#','#arguments.emailId#','#arguments.userName#','#local.password#','#arguments.profilePhoto#')					
			</cfquery>
		<!--- <cfcatch type="any">
			<cfreturn false>			
		</cfcatch>
		</cftry> --->
			<cfreturn true>
	</cffunction>

	<cffunction name="verifyUser" access="public" returntype="query">
		<cfargument name="userName" type="string" required="true" >
		<cfargument name="password" type="string" required="true">
		<cfset local.password = hash("#arguments.password#" , "SHA-256" , "UTF-8")>
		<cfquery name="verifyUser" datasource="#application.datasource#">
			SELECT fullName,emailId,userName,password,profilePhoto from Users where userName = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar"> AND password = <cfqueryparam value="#local.password#" cfsqltype="varchar">					
		</cfquery>		
		<cfreturn verifyUser>		
	</cffunction>
</cfcomponent>