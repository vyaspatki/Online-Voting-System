<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.time.LocalDate"%>
<!DOCTYPE html>
<html>
<head>
<title>Voter Registration Form</title>
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #E63946;
}

form {
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0px 0px 10px #ccc;
	max-width: 400px;
	margin: 0 auto;
	text-align: center;
}

h2 {
	margin-top: 0;
	color: #333;
	font-weight: bold;
	text-transform: uppercase;
	font-size: 24px;
	margin-bottom: 30px;
}

label {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
	color: #333;
	text-transform: uppercase;
	font-size: 14px;
	text-align: left;
}

input[type=text], input[type=email], input[type=date], input[type=tel], input[type=password]
	{
	padding: 15px;
	border-radius: 5px;
	border: none;
	margin-bottom: 20px;
	width: 100%;
	box-sizing: border-box;
	background-color: #f2f2f2;
	color: #666;
	font-size: 14px;
	font-weight: bold;
	text-align: left;
	outline: none;
}
select{
	padding: 15px;
	border-radius: 5px;
	border: none;
	margin-bottom: 20px;
	width: 50%;
	box-sizing: border-box;
	background-color: #f2f2f2;
	color: #666;
	font-size: 14px;
	font-weight: bold;
	text-align: center;
	outline: none;
}


input[type=text]:focus, input[type=email]:focus, input[type=tel]:focus,input[type=date]:focus,
	input[type=password]:focus {
	background-color: #fff;
	color: #333;
}

input[type=submit] {
	background-color:  #DC143C;
	color: #fff;
	    <!-- Minimal test form for POST submission diagnostics -->
	    <form action="register.jsp" method="post" style="margin:20px 0;padding:20px;border:2px dashed orange;">
	        <h3 style="color:orange;">Minimal Test Form</h3>
	        <label for="test_name">Name:</label>
	        <input type="text" id="test_name" name="name" placeholder="Test Name" required><br>
	        <label for="test_email">Email:</label>
	        <input type="email" id="test_email" name="email" placeholder="Test Email" required><br>
	        <input type="submit" value="Test Submit" style="background:orange;color:black;font-weight:bold;">
	    </form>
	padding: 15px 30px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 20px;
	width: 80%;
	box-sizing: border-box;
	text-transform: uppercase;
	font-size: 16px;
	font-weight: bold;
	transition: all 0.3s ease;
}

input[type=submit]:hover {
	background-color:  rgb(7, 105, 97);
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}

p {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
	color: #333;
	text-transform: uppercase;
	font-size: 14px;
	text-align: center;
}

.btn {
	background-color: #fff;
	color: #333;
	padding: 15px 30px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 20px;
	width: 100%;
	box-sizing: border-box;
	text-transform: uppercase;
	font-size: 16px;
	font-weight: bold;
	transition: all 0.3s ease;
	border: 2px solid #333;
}

.btn:hover {
	background-color: #E63946;
	color: #fff;
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}

button:hover {
	background-color: #555;
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}

.back-button {
	background-color: #008CBA;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	float: left;
}

.back-button:hover {
	background-color: #006d8a;
}
</style>
</head>
<body>
	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>
	<!-- register.jsp loaded -->
	
<%@ include file="includes/register_logic.jsp" %>
<%-- register_logic.jsp declares regSuccess/regError and handles POST if needed --%>
    <%-- variables are already available here after inclusion --%>
	
	<% if (!regSuccess.isEmpty()) { %>
	  <div style="color:green;text-align:center;padding:10px;margin:10px;border:1px solid green;">
	    <%= regSuccess %>
	    <p><a href="Voter_Login.jsp">Click here to login</a></p>
	  </div>
	<% } %>
	
	<% if (!regError.isEmpty()) { %>
	  <div style="color:red;text-align:center;padding:10px;margin:10px;border:1px solid red;">
	    <%= regError %>
	  </div>
	<% } %>
	
	<button class="back-button"
		onclick="window.location.href='Voter_Login.jsp'">Back</button>
	<form action="register.jsp" method="post">

		<h2>Voter Registration Form</h2>

		<label for="fullname">Full Name:</label> <input type="text"
			id="fullname" name="name" placeholder="Enter your name" required>

		<label for="email">Email:</label> <input type="email" id="email"
			name="email" placeholder="Enter your email" required> 
			
		<label
			for="mobile">Mobile Number:</label> <input type="tel" id="mobile"
			name="phone" pattern="[0-9]{10}" minlength="10" maxlength="10"
			placeholder="Enter your Number" required> 
			
		<label for="bdate">Birth Date:</label>
		<input type="date" id="birthdate" name="date" placeholder=" Your Birth Date"
			required> 
		
		<label for="class">Class:</label>
		 <select  id="classVal" name="classVal" required>
				<option value="">--Select Class--</option>
				<option value="MBA">MBA</option>
				<option value="MCA">MCA</option>
		</select>
			
		<label
			for="mobile">Registration Number:</label> <input type="text" id="regno"
			name="rgno"  minlength="10" maxlength="10"
			placeholder="Enter your Registration Number" required>
		
		<label for="class">Division:</label>
		 <select  id="classVal" name="division" required>
					<option value="">--Select Division--</option>
					<option value="A">A</option>
					<option value="B">B</option>
					<option value="C">C</option>
		</select>
		
			<label for="password">Password:</label> <input type="password"
		    id="password" name="password"
			pattern="^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[A-Z]).{8,}$"
			title="Password must contain at least 1 digit, 1 special character, 1 uppercase letter, and be at least 8 characters long."
			placeholder="Enter your password" required>
			
			<input type="submit" id="submitBtn" value="Submit">

		<p>
			Already have an account? <a href="Voter_Login.jsp"><br><br>Login here</a>
		</p>
	</form>
<script>
  function calculateAge() {
    var birthday = new Date(document.getElementById("birthdate").value);
    var ageDifMs = Date.now() - birthday.getTime();
    var ageDate = new Date(ageDifMs);
    var age = Math.abs(ageDate.getUTCFullYear() - 1970);

    if (age < 18) {
      alert("You must be at least 18 years old to register as a voter.");
      return false;
    }
    return true;
  }
</script>

	<%@ include file="includes/footer.jsp" %>
</body>
	<div style="background:yellow;color:black;font-weight:bold;padding:10px;text-align:center;">[DIAG] register.jsp loaded and running. If you see this, page is rendering.</div>
</html>
