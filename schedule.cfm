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
      <cfschedule
         action="update"
         task="birthdaymail#session.userName#"
         operation="HTTPRequest"
         url="http://www.myaddressbook.localhost.org/components/birthdayWish.cfc?method=sendEmail&user=#session.userName#"
         startDate="#DateFormat(Now(),'YYYY-MM-dd')#"               
         interval ="daily"
         repeat = "0"
         overwrite="true">    
   </body>
</html>