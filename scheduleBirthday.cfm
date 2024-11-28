<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title></title>
      <meta name="description" content="">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="">
   </head>
   <body>
      <cfset local.birthdayObj = new components.birthdayWish()>
      <cfset local.birthdayObj.makeBirthdayWish()>  
     <cfschedule
         action="delete"
         task="makeBirthdayWish"
         >    
       <!---  operation="HTTPRequest"
         startDate="28/11/2024"
         startTime="6:06 PM"
         url="http://www.myaddressbook.localhost.org/scheduleBirthday.cfm"
         interval="daily" --->
   </body>
</html>

