<cfcomponent >
	<cffunction name="insert"  access="public" returntype="boolean">
		<cfargument name="fullName" required="true" type="string">
		<cfargument name="emailId" required="true" type="string" >
		<cfargument name="userName" required="false" type="string" >
		<cfargument name="password" required="false"  type="string" >
		<cfargument name="profilePhoto" required="true" type="string" >
		<cfset local.password = hash("#arguments.password#" , "SHA-256" , "UTF-8")>
      <cftry>
			<cfquery name="verifyEmail">
			SELECT count(emailId) as count					
			FROM Users
			WHERE emailId = < cfqueryparam value = "#arguments.emailId#" cfsqltype = "varchar" >
				OR userName = < cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar" >
			</cfquery>
			<cfif verifyEmail.count GT 0>				
				<cfreturn false>
				<cfelse>
					<cfquery name="insertData">
				INSERT INTO Users (
						fullName
						,emailId
						,userName
						,password
						,profilePhoto
						)
				VALUES (
					'#arguments.fullName#'
					,'#arguments.emailId#'
					,'#arguments.userName#'
					,'#local.password#'
					,'#arguments.profilePhoto#'
					)					
			</cfquery>
			</cfif>			
			<cfcatch type="any">			
				<cfreturn false>			
			</cfcatch>
		</cftry>
			<cfreturn true>
	</cffunction>

	<cffunction name="verifyUser" access="public" returntype="query">
		<cfargument name="userName" type="string" required="true" >
		<cfargument name="password" type="string" required="true">
		<cfset local.password = hash("#arguments.password#" , "SHA-256" , "UTF-8")>
		<cfquery name="verifyUser">
			SELECT fullName
					,emailId
					,userName
					,password
					,profilePhoto
			FROM Users
			WHERE userName = < cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar" >
			AND password = < cfqueryparam value = "#local.password#" cfsqltype = "varchar" >				
		</cfquery>		
		<cfreturn verifyUser>		
	</cffunction>

	<cffunction name="verifyEmail" access="public" returntype="query">
		<cfargument name="email" type="string" required="true" >	
			<cfquery name = "verifyEmail">
				SELECT fullName,profilePhoto,userName		
				FROM Users
				WHERE emailId	 = < cfqueryparam value = "#arguments.email#" cfsqltype = "varchar" >
			</cfquery>			
		<cfreturn verifyEmail>
	</cffunction>
</cfcomponent>