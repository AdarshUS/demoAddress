<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
	  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	  <link rel="stylesheet" href="./style/bootstrap.css">
	  <link rel="stylesheet" href="./style/home.css">
</head>
<body>
	<cfoutput>		
	 <header>
      <div class="headerItem1">
         <img src="./Images/Capture.PNG" alt="logo" height="63">
         <div class="headerItem1Text">
            ADDRESS BOOK
         </div>
      </div>
      <div class="headerItem2">
      	<button class="headerItem2_log1" id="logout">
      	    <i class="fa-solid fa-right-from-bracket"></i>
      	    <span>Logout</span>
      	</button>         
      </div>
   </header>	
	<main>
		<div class="exportOption">
			<a id="pdf" href="##"><img src="./Images/pdf.png" alt="pdf" width="36"></a>
			<a id="excel"><img src="./Images/excel.png" alt="excel" width="36"></a>
			<a onclick="printContact()"><img src="./Images/printer.png" alt="printer" width="36"></a>
		</div>
		<div class="contact_profileContainer">
			<div class="profileContainer">								
				<img src="#session.profilePhoto#" alt="profilepic" width="70" height="70">
				<div class="profileName">#session.fullName#</div>
				<button class="createCntBtn" data-bs-toggle="modal" data-bs-target="##exampleModal" type="button" onclick="createContact()">CREATE CONTACT</button>
				<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<form method="POST" enctype="multipart/form-data" id="form" onsubmit="return validateContact()">
							<div class="modal-body">
								<div class="mainContainer d-flex">
									<div class="formContainer w-80 d-flex flex-column">										
											<div class="createContactText" id="createContactText">CREATE CONTACT</div>
											<div class="personalCntText">Personal Contact</div>										
											<table class="personalCntTable">
												<tr>
													<th class="required">Title</th>
													<th class="required">First Name</th>
													<th class="required">Last Name</th>											
												</tr>
												<tr>
													<td>
														<select name="title" id="title">
															<option value="notSelect"></option>
															<option value="Mr">Mr</option>
															<option value="Miss">Miss</option>
															<option value="Mrs">Mrs</option>													
														</select>
														<div id="titleError" class="error"></div>
													</td>
													<td>
														<input type="text" name="firstName" id="firstName" placeholder="Your First Name">
														<div id="firstNameError" class="error"></div>
													</td>
													<td>
														<input type="text" name="lastName" id="lastName" placeholder="Your Last Name">
														<div id="lastNameError" class="error"></div>
													</td>											
												</tr>
												<tr>
													<th class="required" colspan="2">Gender</th>		
													<th class="required">Date of Birth</th>									
												</tr>
												<tr>
													<td colspan="2">
														<select name="gender" id="gender">
															<option value="notSelect"></option>
															<option value="male">Male</option>
															<option value="female">Female</option>
															<option value="other">Other</option>													
														</select>
														<div id="genderError" class="error"></div>
													</td>
													<td>
														<input type="date" name="dob" id="dob">
														<div id="dobError" class="error"></div>
													</td>											
												</tr>
											</table>
											<label for="photo">Upload Photo</label>
											<input type="file" name="photo" id="photo" class="inputPhoto">
											<div id="photoError" class="error"></div>
											<div class="cntDetailsText">Contact Details</div>
											<table class="personalCntTable">
												<tr>
													<th class="required">Address</th>
													<th class="required">Street</th>
												</tr>
												<tr>
													<td>
														<input type="text" name="address" id="address" placeholder="Your Address">
														<div id="addressError" class="error"></div>
													</td>
													<td>
														<input type="text" name="street" id="street" placeholder="Your Street">
														<div id="streetError" class="error"></div>
													</td>
												</tr>
												<tr>
													<th class="required">District</th>
													<th class="required">State</th>
												</tr>
												<tr>
													<td>
														<input type="text" name="district" id="district" placeholder="Your District">
														<div id="districtError" class="error"></div>
													</td>
													<td>
														<input type="text" name="state" id="state" placeholder="Your State">
														<div id="stateError" class="error"></div>
														<input type="hidden" id="distinguishButtons" name="distinguishButtons">
													</td>
												</tr>
												<tr>
													<th class="required">Nationality</th>
													<th class="required">Pincode</th>
												</tr>
												<tr>
													<td>
														<input type="text" name="nationality" id="nationality" placeholder="Your Nationality">
														<div id="nationalityError" class="error"></div>
													</td>
													<td>
														<input type="text" name="pincode" id="pincode" placeholder="Your Pincode">
														<div id="pincodeError" class="error"></div>
													</td>
												</tr>
												<tr>
													<th class="required">Email Id</th>
													<th class="required">Phone Number</th>
												</tr>
												<tr>
													<td>
														<input type="email" name="email" id="email" placeholder="Your Email">
														<div id="emailError" class="error"></div>
													</td>
													<td>
														<input type="text" name="phone" id="phone" placeholder="Your Phone Number">
														<div id="phoneError" class="error"></div>
													</td>
												</tr>
											</table>										
										</div>
									<div class="profileIconContainer d-flex justify-content-center align-items-start">
										<img src="./Images/profile.png" alt="profile" width="90" height="90">									
									</div>							
								</div>						
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
								<button type="submit" class="btn btn-primary" id="submit" name="submit">Create</button>
							</div>							
						</div>
						</form>
					</div>
				</div>
				<!--- view modal --->
				<div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">							
							<div class="modal-body">
								<div class="mainContainer d-flex">
									<div class="formContainer w-80 d-flex flex-column">										
										<div class="createContactText" >CONTACT DETAILS</div>
										<div>
											<div class="cnt_details">
											<span class="cnt_heading">Name</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntName"></span>	
											</div>																				
										</div>
										<div class="cnt_details">
											<span class="cnt_heading">Gender</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntGender"></span>
											</div>												
										</div>
										<div class="cnt_details">
											<span class="cnt_heading">Date Of Birth</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntDob"></span>	
											</div>											
										</div>
										<div class="cnt_details">
											<span class="cnt_heading">Address</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntAddress"></span>	
											</div>											
										</div>
										<div class="cnt_details">
											<span class="cnt_heading">Pincode</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntPincode"></span>	
											</div>										
										</div>
										<div class="cnt_details">
											<span class="cnt_heading">Email Id</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntMail"></span>	
											</div>										
										</div>
										<div class="cnt_details">
											<span class="cnt_heading">Phone</span>
											<div class="cnt_detailsItem2">
												<span>:</span>
												<span id="cntPhone"></span>	
											</div>											
										</div>																		
									</div>												
								</div>
									<div class="profileIconContainer d-flex justify-content-center align-items-start">
										<img src="" alt="profile" width="90" id="profile">									
									</div>
								</div>	
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>								
							</div>
						</div>
					</div>
				</div>
			</div>
			<cfif structKeyExists(form,"submit")>
				<cfif LEN(form.distinguishButtons) GT 1>
					<cfset Application.contactObj.editContact(form.distinguishButtons,form.title,form.firstName,form.lastName,form.gender,form.dob,form.photo,form.address,form.street,form.district,form.state,form.nationality,form.pincode,form.email,form.phone)>
				<cfelse>
					<cfset uploadRelativePath = "./Images/Uploads/">
					<cffile action="upload" destination="#expandPath(uploadRelativePath)#" nameconflict="makeUnique" filefield="photo" result="newPath" >
					<cfset imagePath = uploadRelativePath & #newPath.ServerFile#>				
					<cfset result = Application.contactObj.createContact(form.title,form.firstName,form.lastName,form.gender,form.dob,local.imagePath,form.address,form.street,form.district,form.state,form.nationality,form.pincode,form.email,form.phone)>					
					<cfif NOT result>
						<p>Contact Already Exists</p>						
					<cfelse>
						<cflocation  url="./homePage.cfm">
					</cfif>					
				</cfif>																			
			</cfif>
			<cfset AllContacts = Application.contactObj.fetchContacts(session.userName)>
			
			<div class="contactContainer">
				<table class="cntTable">															
					<tr>
						<th></th>
						<th>NAME</th>
						<th>EMAIL ID</th>
						<th>PHONE NUMBER</th>
						<th></th>
						<th></th>
						<th></th>
					</tr>
					<cfset ormReload()>
					<cfset contactsOrm = entityLoad("contactOrm",{_createdBy = #session.userName#})>								
					<cfloop Array="#contactsOrm#" item = item>										
					<tr>
						<td><img src="#item.getphoto()#" alt="profile" width="70" height="70" class="prof_pic"></td>
						<td>#item.getfirstName() & " "&item.getlastName()#</td>
						<td>#item.getemailId()#</td>
						<td>#item.getphoneNumber()#</td>
						<td><button class="editBtn" data-bs-toggle="modal" data-bs-target="##exampleModal" value="#item.getcontactId()#" onclick="editContact(this)">EDIT</button></td>
						<td><button class="deleteBtn" onclick="deleteContact(this)" value="#item.getcontactId()#">DELETE</button></td>
						<td><button class="viewBtn" data-bs-toggle="modal" data-bs-target="##exampleModal2" value="#item.getcontactId()#" onclick="viewData(this)">VIEW</button></td>
					</tr>
					</cfloop>
				</table>
			</div>
		</div>		
	</main>
	</cfoutput>	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>	
	<script src="./script/script.js"></script>
</body>
</html>