<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">    
      <title></title>
      <meta name="description" content="">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="./style/bootstrap.css">
   </head>
   <body>
        
      <cfquery name = "getContactsDob">
          SELECT firstName,emailId,dateOfBirth from Contact WHERE _createdBy = <cfqueryparam value = #session.userName# cfsqltype="CF_SQL_VARCHAR">
      </cfquery>      
      <cfloop query="getContactsDob">
         <cfif dateFormat(getcontactsDob.dateOfBirth,"dd-mm") EQ dateFormat(now(),"dd-mm")>
            <cfschedule
               action="update"
               task="birthdaymail#getcontactsDob.firstName#"
               operation="HTTPRequest"
               url="http://www.myaddressbook.localhost.org/components/birthdayWish.cfc?method=sendEmail&receiverMail=#getcontactsDob.emailId#&receiverName=#getcontactsDob.firstName#"
               startDate="#DateFormat(Now(),'YYYY-MM-dd')#"               
               interval ="daily"
               repeat = "0"
               overwrite="true">
         </cfif>               
      </cfloop>
   </body>
</html>