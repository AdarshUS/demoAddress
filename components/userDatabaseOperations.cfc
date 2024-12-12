<cfcomponent >
	<cffunction name="insertUser"  access="public" returntype="boolean">
		<cfargument name="fullName" required="true" type="string">
		<cfargument name="emailId" required="true" type="string" >
		<cfargument name="userName" required="false" type="string" >
		<cfargument name="password" required="false"  type="string" >
		<cfargument name="profilePhoto" required="true" type="string" >
		<cfset local.password = hash("#arguments.password#" , "SHA-256" , "UTF-8")>
      <cftry>
			<cfquery name="local.verifyEmailUsername">
			SELECT count(emailId) as count					
			FROM Users
			WHERE emailId = <cfqueryparam value = "#arguments.emailId#" cfsqltype = "cf_sql_varchar">
			OR userName = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
			</cfquery>
			<cfif local.verifyEmailUsername.count GT 0>				
				<cfreturn false>
				<cfelse>
					<cfquery name="local.insertData">
						INSERT INTO Users (
								fullName,
								emailId,
								userName,
								password,
								profilePhoto
								)
						VALUES (
							<cfqueryparam value = '#arguments.fullName#' cfsqltype="cf_sql_varchar">,
							<cfqueryparam value = '#arguments.emailId#' cfsqltype="cf_sql_varchar">,
							<cfqueryparam value = '#arguments.userName#' cfsqltype="cf_sql_varchar">,
							<cfqueryparam value = '#arguments.userName#' cfsqltype="cf_sql_varchar">,
							<cfqueryparam value = '#local.password#' cfsqltype="cf_sql_varchar">,
							<cfqueryparam value = '#arguments.profilePhoto#' cfsqltype="cf_sql_varchar">					
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
		<cfquery name="local.verifyUser">
			SELECT fullName,
					 emailId,
					 userName,
					 password,
					 profilePhoto,
					 userId
			FROM Users
			WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
			AND password = <cfqueryparam value = "#local.password#" cfsqltype = "cf_sql_varchar" >				
		</cfquery>		
		<cfreturn local.verifyUser>
	</cffunction>

	<cffunction name="verifyEmail" access="public" returntype="query">
		<cfargument name="email" type="string" required="true" >	
			<cfquery name = "local.verifyEmail">
				SELECT fullName,
				profilePhoto,
				userName,
				userId	
				FROM Users
				WHERE emailId	 = <cfqueryparam value = "#arguments.email#" cfsqltype = "cf_sql_varchar">
			</cfquery>			
		<cfreturn local.verifyEmail>
	</cffunction>
</cfcomponent>