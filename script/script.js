let validInput = true;
$("#logout").click(function() {
        if (confirm("Are you sure you want to Logout")) {
            $.ajax({
                url: 'components/logOut.cfc?method=logOutUser',
                type: 'POST',
                success: function(result) {
                  location.reload();
                },
                error: function() {
                    
                }
            });
        }
});
$('#excel,#excelData').click(function() {	
	 $.ajax({
    url: 'components/Excel.cfc?method=getExcel',
    type: 'POST',
    success: function(result) {
		let jsonObj = JSON.parse(result);          
		let a = document.createElement("a");
		a.download = jsonObj.user;      
		a.href = jsonObj.fileForDownload;
		a.click();						              
    },
    error: function() {        
    }
	});		           
});
$("#pdf").click(function() { 
		
	$.ajax({
    url: 'components/pdf.cfc?method=getPdf',
    type: 'POST',
    success: function(result) {						
		let jsonObj = JSON.parse(result);	
		let a = document.createElement("a");
		a.download = jsonObj.user;      
		a.href = jsonObj.fileForDownload;
		a.click();		          
    },
    error: function() {              
    }
	});		  
});

function validate()
{
	validInputUser = true;
	const fullName = document.getElementById("fullName").value;
	const email = document.getElementById("email").value;
	const userName = document.getElementById("username").value;
	const password = document.getElementById("password").value;
	const confirmPassword = document.getElementById("confirmPassword").value;

	let nameError = document.getElementById("nameError");
	let mailError = document.getElementById("mailError");
	let usernameError = document.getElementById("userError");
	let passwordError = document.getElementById("passwordError");
	let passwordMatchError = document.getElementById("passwordMatchError");

	nameError.textContent = "";
	mailError.textContent = "";
	usernameError.textContent = "";
	passwordError.textContent = "";
	passwordMatchError.textContent = "";

	if(fullName.trim() === "")
	{
		nameError.textContent = "Name cannot be Empty";
		validInputUser = false;
	}
	if(email.trim() === "")
	{
		mailError.textContent = "Email cannot be empty";
		validInputUser = false;
	}
	else if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
	{
		mailError.textContent = "Invalid mail";
		validInputUser = false;
	}			
	if(userName.trim() === "")
	{
		usernameError.textContent = "Username cannot be empty";
		validInputUser = false;
	}
	else if(!/^[a-z0-9_.]+$/.test(userName))
	{
		usernameError.textContent = "Invalid Username";
		validInputUser = false;
	}
	if(password.trim() === "")
	{
		passwordError.textContent = "Password cannot be empty";
		validInputUser = false;
	}
	else if( password.search(/[a-z]/) < 0)
	{
		passwordError.textContent = "Password should contain Atleast one lowercase";
		validInputUser = false;
	}
	else if( password.search(/[A-Z]/) < 0)
	{
		passwordError.textContent = "Password should contain Atleast one Uppercase";
		validInputUser = false;
	}
	else if(password.search(/[0-9]/) < 0)
	{
		passwordError.textContent = "Password should contain Atleast one Digit";
		validInputUser = false;
	}
	else if(password.length<6)
	{
		passwordError.textContent = "Password should contain Atleast Six characters";
		validInputUser = false;
	}
	if(password != confirmPassword)
	{
		passwordMatchError.textContent = "Password does'nt match";
		validInputUser = false;
	}
  
	return validInputUser;
}

document.getElementById("excelForm").addEventListener("submit", function (event) {
	event.preventDefault(); 

	let excelFileElement = document.getElementById("excelFile");
	let file = excelFileElement.files[0];

	if (!file) {
			document.getElementById("excelFileError").textContent = "select a file to Upload";
	}

	const excelData = new FormData();
	excelData.append("excelfile", file);

	$.ajax({
			url: 'components/contactDatabaseOperations.cfc?method=processExcel',
			type: 'POST',
			data: excelData, 
			contentType: false, 
			processData: false, 
			success: function (result) {
					let path = JSON.parse(result);
					let fileName = "Upload_Result";					
					console.log("File uploaded successfully:", result);
					document.getElementById("fileUploadFeedback").textContent = "File Uploaded Successfully";
					document.getElementById("downloadIcon").style.display = "block";
					$("#downloadIcon").click(function() { 
								let a = document.createElement("a");				
					a.download = fileName;      
					a.href = path;
					a.click();
					}); 									            
			},
			error: function (xhr, status, error) {
					console.error("Error during file upload:", status, error);
					alert("There was an error processing the file.");
			}
	});
});

function viewData(contactId)
{
	
	$.ajax({
   	 url: 'components/contactDatabaseOperations.cfc?method=fetchSingleContact',
   	 type: 'POST',
   	 data: {contactId:contactId.value},		
   	 success: function(result) {			
		 jsonObj = JSON.parse(result);
		 console.log(jsonObj);
		 document.getElementById("cntName").textContent = jsonObj.FIRSTNAME;
		 document.getElementById("cntGender").textContent = jsonObj.GENDER;
		 document.getElementById("cntDob").textContent = jsonObj.DATEOFBIRTH;
		 document.getElementById("cntAddress").textContent = jsonObj.ADDRESS+" "+jsonObj.STREET+" "+jsonObj.DISTRICT+" "+jsonObj.STATE+" "+jsonObj.NATIONALITY;
		 document.getElementById("cntPincode").textContent = jsonObj.PINCODE;
		 document.getElementById("cntMail").textContent = jsonObj.EMAILID;
		 document.getElementById("cntPhone").textContent = jsonObj.PHONENUMBER;
		 document.getElementById("profile").src = jsonObj.PHOTO;
		 document.getElementById("cntRole").textContent = jsonObj.ROLES;
   	 },
   	 error: function() {		
   	 }
      });
}

function deleteContact(contactId)
{	
	if (confirm("Are you sure you want to delete"))
	{
		$.ajax({		
   	 url: 'components/contactDatabaseOperations.cfc?method=deleteContact',
   	 type: 'POST',
   	 data: {contactId:contactId.value},
   	 success: function() {			
			document.getElementById(contactId.value).remove();
   	 },
   	 error: function() {		
   	 }
      });
	}	
}

function validateContact()
{	
	
	let title = document.getElementById("title").value;	
	let firstName = document.getElementById("firstName").value;
	let lastName = document.getElementById("lastName").value;
	let gender = document.getElementById("gender").value;
	let dateOfBirth = document.getElementById("dob").value;	
	let address = document.getElementById("address").value;
	let street = document.getElementById("street").value;
	let district = document.getElementById("district").value;
	let state = document.getElementById("state").value;
	let nationality = document.getElementById("nationality").value;
	let pincode = document.getElementById("pincode").value;
	let email = document.getElementById("email").value;
	let phone = document.getElementById("phone").value;
	let role = document.getElementById("select").value;

	let titleError = document.getElementById("titleError");
	let firstNameError = document.getElementById("firstNameError");
	let lastNameError = document.getElementById("lastNameError");
	let genderError = document.getElementById("genderError");
	let dateOfBirthError = document.getElementById("dobError");
	let photoError = document.getElementById("photoError");
	let addressError = document.getElementById("addressError");
	let streetError = document.getElementById("streetError");
	let districtError = document.getElementById("districtError");
	let stateError = document.getElementById("stateError");
	let nationalityError = document.getElementById("nationalityError");
	let pincodeError = document.getElementById("pincodeError");	
	let phoneError = document.getElementById("phoneError");
	let roleError = document.getElementById("RoleError"); 

	titleError.innerHTML = "";
	firstNameError.innerHTML = "";
	lastNameError.innerHTML = "";
	genderError.innerHTML = "";
	dateOfBirthError.innerHTML = "";
	photoError.innerHTML = "";
	addressError.innerHTML = "";
	streetError.innerHTML = "";
	districtError.innerHTML = "";
	stateError.innerHTML = "";
	nationalityError.innerHTML = "";
	pincodeError.innerHTML = "";
	phoneError.innerHTML = "";
	roleError.innerHTML = "";
	
	var CurrentDate = new Date();
	GivenDate = new Date(dateOfBirth);

	if(title == "notSelect")
	{		
		titleError.innerHTML = "Select Any title"		
		validInput = false;
	}
	if(firstName.trim() === "")
	{
		firstNameError.innerHTML = "firstName required"
		validInput = false;
	}
	if(lastName.trim() === "")
	{
		lastNameError.innerHTML = "lastName required"
		validInput = false;
	}
	if(gender == "notSelect")
	{
		genderError.innerHTML = "gender required"
		validInput = false;
	}
	if(dateOfBirth.trim() === "")
	{
		dateOfBirthError.innerHTML = "dateOfBirth required"
		validInput = false;
	}
	else if(GivenDate > CurrentDate)
	{
		dateOfBirthError.innerHTML = "Invalid DateOfBirth"
		validInput = false;
	}

	if(address.trim() === "")
	{
		addressError.innerHTML = "address required"
		validInput = false;
	}
	if(street.trim() === "")
	{
		streetError.innerHTML = "street required"
		validInput = false;
	}
	if(district.trim() === "")
	{
		districtError.innerHTML = "district required"
		validInput = false;
	}
	if(state.trim() === "")
	{
		stateError.innerHTML = "state required"
		validInput = false;
	}
	if(nationality.trim() === "")
	{
		nationalityError.innerHTML = "nationality required"
		validInput = false;
	}
	if(pincode.trim() === "")
	{
		pincodeError.innerHTML = "pincode required"
		validInput = false;
	}
	
	if(phone.trim() === "")
	{
		phoneError.innerHTML = "phone required"
		validInput = false;
	}
	if(role.trim() === "")
	{
		roleError.innerHTML = "select any Role"
	}
	     
	return validInput;
}

function editContact(contactId)
{
	validInput = true;
	$("#select").val("").trigger("chosen:updated");
	let titleError = document.getElementById("titleError");
	let firstNameError = document.getElementById("firstNameError");
	let lastNameError = document.getElementById("lastNameError");
	let genderError = document.getElementById("genderError");
	let dateOfBirthError = document.getElementById("dobError");
	let photoError = document.getElementById("photoError");
	let addressError = document.getElementById("addressError");
	let streetError = document.getElementById("streetError");
	let districtError = document.getElementById("districtError");
	let stateError = document.getElementById("stateError");
	let nationalityError = document.getElementById("nationalityError");
	let pincodeError = document.getElementById("pincodeError");
	let emailError = document.getElementById("emailError");
	let phoneError = document.getElementById("phoneError");
	let roleError = document.getElementById("RoleError");

	titleError.innerHTML = "";
	firstNameError.innerHTML = "";
	lastNameError.innerHTML = "";
	genderError.innerHTML = "";
	dateOfBirthError.innerHTML = "";
	photoError.innerHTML = "";
	addressError.innerHTML = "";
	streetError.innerHTML = "";
	districtError.innerHTML = "";
	stateError.innerHTML = "";
	nationalityError.innerHTML = "";
	pincodeError.innerHTML = "";
	emailError.innerHTML = "";
	phoneError.innerHTML = "";
	roleError.innerHTML = "";
  
	$.ajax({		
   	 url: 'components/contactDatabaseOperations.cfc?method=fetchSingleContact',
   	 type: 'POST',
   	 data: {contactId:contactId.value},
   	 success: function(returnValue) {
		 jsonObj = JSON.parse(returnValue);	
		 console.log(jsonObj);
		 var roleArray = jsonObj.ROLESID;
		 const multiSelect = document.getElementById("select");
		Array.from(multiSelect.options).forEach(option => {       
			if(roleArray.includes(parseInt(option.value)))
			 {				
            option.selected = true;
				$("#select").trigger("chosen:updated");	
			 }			
		});
		let validGender = jsonObj.GENDER.toLowerCase();		
         document.getElementById("title").value = jsonObj.TITLE;
			document.getElementById("firstName").value = jsonObj.FIRSTNAME;
			document.getElementById("lastName").value = jsonObj.LASTNAME;
			document.getElementById(validGender).selected = true;
			document.getElementById("dob").value = jsonObj.DATEOFBIRTH;			
			document.getElementById("address").value = jsonObj.ADDRESS;
			document.getElementById("street").value = jsonObj.STREET;
			document.getElementById("district").value = jsonObj.DISTRICT;
			document.getElementById("state").value = jsonObj.STATE;
			document.getElementById("nationality").value = jsonObj.NATIONALITY;
			document.getElementById("pincode").value = jsonObj.PINCODE;
			document.getElementById("email").value = jsonObj.EMAILID;
			document.getElementById("phone").value = jsonObj.PHONENUMBER;
			document.getElementById("imagePathEdit").value = jsonObj.PHOTO;
			document.getElementById("distinguishButtons").value = jsonObj.CONTACTID; 
			document.getElementById("createContactText").innerHTML = "EDIT CONTACT";
			document.getElementById("submit").innerHTML = "Save Changes";
   	 },
   	 error: function() {		
   	 }
      });
}

function createContact()
{
	validInput = true;
	$(".error").text("");	
	$("#select").val("").trigger("chosen:updated");
	document.getElementById("createContactText").innerHTML = "CREATE CONTACT";
	document.getElementById("form").reset();
}

function printContact()
{
	window.print();
}

function refreshSelector()
{
	 $("#select").val("").trigger("chosen:updated");
}

 $(document).ready(function(){
   $("#select").chosen();
})

function downloadHeaders()
{
	$.ajax({
    url: 'components/Excel.cfc?method=getExcelHeaders',
    type: 'POST',	
    success: function(result) {
		let jsonObj = JSON.parse(result);          
		let a = document.createElement("a");
		a.download = jsonObj.user;      
		a.href = jsonObj.fileForDownload;
		a.click();						              
    },
    error: function() {        
    }
	});		           
}

$("#uploadBtn").click(function() {
	$(".error").text("");
	$("#fileUploadFeedback").text("");
   document.getElementById("downloadIcon").style.display = "none";
	document.getElementById("excelForm").reset();
});

function emailValidator(email)
{
	let emailError = document.getElementById("emailError");
	if(email.value.trim() === "")
	{
		emailError.innerHTML = "email required"
		validInput = false;
	}
	else{
		let contactId = document.getElementById("distinguishButtons").value;
		$.ajax({
    	url: 'components/contactDatabaseOperations.cfc?method=checkExistingContacts',
    	type: 'POST',
		data: {emailId:email.value,contactId:contactId},
    	success: function(existString) {
			let exist = existString === "true"?true:false
			if(exist)
			{
				console.log(exist)
				emailError.innerHTML = "Email Already Exist"
				validInput = false;
			}
			else
			{
				validInput = true;
				emailError.innerHTML = ""
			}
			
    },
    error: function() {        
    }
	});		           
	}
	
}

