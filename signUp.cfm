<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Address Book</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="./style/bootstrap.css">
  <link rel="stylesheet" href="./style/signUp.css">
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
         <a class="headerItem2_log1" href="#">
             <i class="fa-solid fa-user"></i>
             <span>Sign Up</span>
         </a>
          <a class="headerItem2_log2" href="index.cfm">
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
            <div class="loginContainer_right-heading">SIGN UP</div>
            <form onsubmit="return validate()" method="POST" enctype="multipart/form-data">
               <div class="inputArea">
                  <input type="text" id="fullName" name="fullName" placeholder="Full Name">
               </div>
               <span id="nameError" class="error"></span>
               <div class="inputArea">
                  <input type="email" name="email" id="email" placeholder="Email ID">
               </div>
               <span id="mailError" class="error"></span>
               <div class="inputArea">
                  <input type="text" name="username" id="username" placeholder="Username">
               </div>
               <span id="userError" class="error"></span>
               <div class="inputArea">
                  <input type="password" name="password" id="password" placeholder="Password">
               </div>
               <span id="passwordError" class="error"></span>
               <div class="inputArea">
                  <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password">
               </div>
               <span id="passwordMatchError" class="error"></span>
               <div class="inputArea">
                  <input type="file" name="profile" id="profile">
               </div>
               <div class="bottomContainer">
                  <button class="loginBtn" id="submitButton" name="submitButton">REGISTER</button>
               </div>
            </form>           
            <cfif structKeyExists(form,"submitButton")>               
               <cfset uploadRelativePath = "./Images/Uploads/">
				   <cffile action="upload" destination="#expandPath(uploadRelativePath)#" nameconflict="makeUnique" filefield="profile" result="newPath" >
				   <cfset imagePath = uploadRelativePath & #newPath.ServerFile#>				
               <cfset inserted = Application.userObj.insertUser(
                  fullName = form.fullName,
                  emailId = form.email,
                  userName = form.username,
                  password = form.password,
                  profilePhoto = imagePath)>
               <cfif inserted>
                  <p class="added_success">Data Submitted Successfully</p>
               <cfelse>
                  <p class="added_failed">UserName or Email Already Exists</p>
               </cfif>               
            </cfif>
         </div>         
      </div>
   </main>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
   <script src="./script/script.js"></script>
</body>
</html>