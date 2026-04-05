<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Candidate Registration Form</title>
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

p {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
	color: #333;
	text-transform: uppercase;
	font-size: 14px;
	text-align: center;
}

input[type=text], input[type=email], input[type=date], input[type=tel],
	input[type=password] {
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

textarea {
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
	outline: none;
}

select{
	padding: 15px;
	border-radius: 5px;
	border: none;
	margin-bottom: 20px;
	width: 60%;
	box-sizing: border-box;
	background-color: #f2f2f2;
	color: #666;
	font-size: 14px;
	font-weight: bold;
	text-align: center;
	outline: none;
}
input[type=text]:focus, input[type=email]:focus, input[type=tel]:focus,
	input[type=date]:focus, input[type=password]:focus {
	background-color: #fff;
	color: #333;
}

input[type=submit] {
	background-color: #DC143C;
	color: #fff;
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
	background-color: rgb(7, 105, 97);
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
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
    
    <%
      String regSuccess = "";
      String regError = "";
      
      if ("POST".equalsIgnoreCase(request.getMethod())) {
        String voterOption = request.getParameter("voterOption");
        String name = request.getParameter("name");
        String regno = request.getParameter("regno");
        String password = request.getParameter("password");
        String description = request.getParameter("descrp");
        
        if (name != null && regno != null && password != null && !name.isEmpty() && !regno.isEmpty() && !password.isEmpty()) {
          Connection con = (Connection) request.getAttribute("dbCon");
          
          if (con != null) {
            try {
              // Create candidate table if it doesn't exist
              String createTableSQL = "CREATE TABLE IF NOT EXISTS candidate (" +
                "id SERIAL PRIMARY KEY, " +
                "name VARCHAR(255), " +
                "registration_number VARCHAR(20) UNIQUE, " +
                "password VARCHAR(255), " +
                "description TEXT, " +
                "is_voter VARCHAR(10), " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
              
              Statement createStmt = con.createStatement();
              createStmt.execute(createTableSQL);
              createStmt.close();
              
              // Insert candidate
              String insertSQL = "INSERT INTO candidate (name, registration_number, password, description, is_voter) " +
                                  "VALUES (?, ?, ?, ?, ?)";
              PreparedStatement pst = con.prepareStatement(insertSQL);
              pst.setString(1, name);
              pst.setString(2, regno);
              pst.setString(3, password);
              pst.setString(4, description);
              pst.setString(5, voterOption);
              
              pst.executeUpdate();
              pst.close();
              
              regSuccess = "Registration successful! Name: " + name;
            } catch (Exception e) {
              regError = "Registration error: " + e.getMessage();
            }
          } else {
            regError = "Database connection failed!";
          }
        }
      }
    %>
    
    <% if (!regSuccess.isEmpty()) { %>
      <div style="color:green;text-align:center;padding:10px;margin:10px;border:1px solid green;">
        <%= regSuccess %>
        <table style="width:80%;margin:20px auto;border-collapse:collapse;">
          <tr style="background-color:#069494;color:#fff;">
            <th style="padding:10px;border:1px solid #069494;">Field</th>
            <th style="padding:10px;border:1px solid #069494;">Value</th>
          </tr>
          <tr>
            <td style="padding:10px;border:1px solid #ddd;"><strong>Name</strong></td>
            <td style="padding:10px;border:1px solid #ddd;"><%= request.getParameter("name") %></td>
          </tr>
          <tr>
            <td style="padding:10px;border:1px solid #ddd;"><strong>Registration Number</strong></td>
            <td style="padding:10px;border:1px solid #ddd;"><%= request.getParameter("regno") %></td>
          </tr>
          <tr>
            <td style="padding:10px;border:1px solid #ddd;"><strong>Voter Status</strong></td>
            <td style="padding:10px;border:1px solid #ddd;"><%= request.getParameter("voterOption") %></td>
          </tr>
        </table>
        <p><a href="Candidate_Login.jsp">Click here to login</a></p>
      </div>
    <% } %>
    
    <% if (!regError.isEmpty()) { %>
      <div style="color:red;text-align:center;padding:10px;margin:10px;border:1px solid red;">
        <%= regError %>
      </div>
    <% } %>
    
	<button class="back-button"
		onclick="window.location.href='Candidate_Login.jsp'">Back</button>

	<form action="candidate.jsp" method="post"
		onsubmit="return calculateAge();">

		<h2>Candidate Registration Form</h2>

		<label for="voterOption">Are you a voter?</label> <select
			class="form-control" id="voterOption" name="voterOption"
			onchange="handleVoterOption()">
			<option value="yes">Yes</option>
			<option value="no">No</option>
		</select>
		
		<label for="name">Full Name:</label> <input type="text"
			id="name" name="name" placeholder="Enter your full name" required>
		
		<label for="mobile">Registration Number:</label> <input type="text"
			id="regno" name="regno" minlength="10" maxlength="10"
			placeholder="Enter your Registration Number" required> <label
			for="password">Password:</label> <input type="password" id="password"
			name="password"
			pattern="^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[A-Z]).{8,}$"
			title="Password must contain at least 1 digit, 1 special character, 1 uppercase letter, and be at least 8 characters long."
			placeholder="Enter your password" required> <label
			for="description">Description</label>
		<textarea rows="4" cols="50" id="desc" name="descrp"
			placeholder="Enter your Description" required></textarea>

		<input type="submit" id="submitBtn" value="Submit">

		<p>
			Already have an account? <a href="Candidate_Login.jsp"> <br>
			<br>Login here
			</a>
		</p>
	</form>
	<script type="text/javascript">
		function handleVoterOption() {
			var voterOption = document.getElementById("voterOption");
			if (voterOption.value == "no") {
				window.location.href = "register.jsp";
			}
		}
	</script>
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
