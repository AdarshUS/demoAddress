<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Address Book</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="./style/style.css">
</head>
<body>
   <header>
      <div class="headerItem1">
         <img src="./Images/Capture.PNG" alt="logo" height="63">
         <div class="headerItem1Text">
            ADDRESS BOOK
         </div>
      </div>
      <div class="headerItem2">
         <a class="headerItem2_log1" href="./signUp.cfm">
             <i class="fa-solid fa-user"></i>
             <span>Sign Up</span>
         </a>
          <a class="headerItem2_log2" href="#">
             <i class="fa-solid fa-right-to-bracket"></i>
             <span>Login</span>
         </a>        
      </div>
   </header>
   <main>
      <div class="loginContainer">
         <div class="loginContainer_left">
            <div class="imageContainer">
               <img src="./Images/Capture.PNG" alt="logo">
            </div>
         </div>
         <div class="loginContainer_right">
            <form method="POST">
               <div class="loginContainer_right-heading">LOGIN</div>
               <div class="userName inputArea">
                  <input type="text" id="userName" name="userName" placeholder="Username">
               </div>
               <div class="password inputArea">
                  <input type="password" name="password" id="password" placeholder="Password">
               </div>
               <div class="bottomContainer">
                  <button class="loginBtn" id="submit" name="submit">LOGIN</button>
                  <div class="bottomContainerText">Or Sign In Using</div>
                  <div class="imageContainer">
                     <img src="./Images/facebookLogo.png" alt="fb">
                     <a href="./loginSuccess.cfm"><img src="./Images/googleLogo.png" alt="googleLogo" height="48"></a>
                  </div>
                  <div class="registerContainer">Don't have an account? <a href="./signUp.cfm">Register Here</a></div>
               </div>
            </form>            
            <cfif structKeyExists(form,"submit")>               
               <cfset result = Application.userObj.verifyUser(
                  userName = form.userName,
                  password = form.password)>              
               <cfif result.recordCount GT 0>
                  <cfset session.userId = result.userid>
                  <cfset session.profilePhoto = result.profilePhoto>
                  <cfset session.fullName = result.fullName>                  
                  <cflocation url="./homePage.cfm"  addtoken="false">                  
               <cfelse>
                  <p class="error">Incorrect UserName or Password</p>
               </cfif>
            </cfif>
         </div>            
      </div>
   </main>   
</body>
</html>