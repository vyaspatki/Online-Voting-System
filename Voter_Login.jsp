<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.lang.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Login to Voter Panel</title>
<style>
body {
	background-color: #E63946;
	font-family: Arial, sans-serif;
}

form {
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0px 0px 10px #ccc;
	max-width: 300px;
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

input[type=text], input[type=password], input[type=checkbox] {
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

input[type=text]:focus, input[type=password]:focus {
	background-color: #fff;
	color: #333;
}

input[type=checkbox]+label {
	display: inline-block;
	margin-left: 10px;
	color: #333;
	font-size: 14px;
	font-weight: normal;
	text-align: left;
}

input[type=submit] {
	background-color: #DC143C;
	color: #fff;
	padding: 15px 30px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 20px;
	width: 60%;
	box-sizing: border-box;
	text-transform: uppercase;
	font-size: 16px;
	font-weight: bold;
	transition: all 0.3s ease;
}

input[type=submit]:hover {
	background-color: #555;
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}

a {
	display: block;
	margin-top: 20px;
	color: #333;
	text-decoration: none;
	font-size: 14px;
	font-weight: normal;
	transition: all 0.3s ease;
}

a:hover {
	color: #555;
}

button {
	background-color: #008080;
	color: #fff;
	padding: 15px 30px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 20px;
	font-size: 16px;
	font-weight: bold;
	text-transform: uppercase;
	transition: all 0.3s ease;
}

button:hover {
	background-color: #555;
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}

.back-button {
	background-color: #555;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	float: left;
}

.back-button:hover {
	background-color: #008CBA;
}
</style>
</head>
<body>
	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>
	
	<%
	  // Handle voter login
	  if ("POST".equalsIgnoreCase(request.getMethod())) {
	    String regno = request.getParameter("regno");
	    String password = request.getParameter("password");
	    
	    if (regno != null && password != null && !regno.isEmpty() && !password.isEmpty()) {
	      Connection con = (Connection) request.getAttribute("dbCon");
	      
	      if (con != null) {
	        try {
	          // Query voter table (columns: registration_number, password)
	          String query = "SELECT * FROM voter WHERE registration_number = ? AND password = ?";
	          PreparedStatement pst = con.prepareStatement(query);
	          pst.setString(1, regno);
	          pst.setString(2, password);
	          ResultSet rs = pst.executeQuery();
	          
	          if (rs.next()) {
	            // Login successful
	            session.setAttribute("voter_id", rs.getInt("id"));
	            session.setAttribute("voter_name", rs.getString("name"));
	            response.sendRedirect("voter_dashboard.jsp");
	            return;
	          } else {
	            out.println("<div style='color:red;text-align:center;padding:10px;'>Invalid registration number or password</div>");
	          }
	          rs.close();
	          pst.close();
	        } catch (Exception e) {
	          out.println("<div style='color:red;text-align:center;padding:10px;'>Login Error: " + e.getMessage() + "</div>");
	        }
	      }
	    }
	  }
	%>
	
	<form action="Voter_Login.jsp" method="post">
		<h2>Login to Voter Panel</h2>
		<label for="username">Registration number</label> <input type="text"
			class="form-control" id="username" name="regno" placeholder="Enter Registration No" required> <label
			for="password">Password</label> <input type="password"
			class="form-control" id="password" name="password" placeholder="Enter Password" required> <input
			type="submit" value="Login">
		<p>
			Don't have Account? <a href="register.jsp">Register here</a>
		</p>


	</form>
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
