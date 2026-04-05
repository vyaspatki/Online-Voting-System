<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Voter Validation Request</title>
<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, sans-serif;
	font-size: 16px;
	line-height: 1.5;
	background-color: #E63946;
}

.navbar {
	background-color: #E63946;
	overflow: hidden;
	font-size: 20px
}

.navbar a {
	float: left;
	cursor: pointer;
	display: block;
	color: #f2f2f2;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
	display: block;
}

.navbar a:hover {
	background-color: #444;
	color: black;
}

th {
	font-size: 20px;
}

td {
	font-size: 15px;
}

h2 {
	font-size: 25px;
}

h1, h2 {
	text-align: center;
}

table {
	border-collapse: collapse;
	width: 100%;
	margin-top: 20px;
}

th, td {
	text-align: center;
	padding: 8px;
	border: 1px solid #ddd;
}

th {
	background-color: #DC143C;
	color: white;
}

label {
	display: block;
	font-weight: bold;
	color: #fff;
	text-transform: uppercase;
	font-size: 14px;
	text-align: left;
}

input[type=text], input[type=checkbox] {
	padding: 15px;
	border-radius: 5px;
	border: none;
	margin-bottom: 20px;
	width: 20%;
	box-sizing: border-box;
	background-color: #f2f2f2;
	color: #666;
	font-size: 15px;
	font-weight: bold;
	outline: none;
}

select{
	padding: 15px;
	border-radius: 5px;
	border: none;
	margin-bottom: 20px;
	width: 20%;
	box-sizing: border-box;
	background-color: #f2f2f2;
	color: #666;
	font-size: 14px;
	font-weight: bold;
	text-align: center;
	outline: none;
}

input[type=text]:focus {
	background-color: #fff;
	color: #fff;
}

input[type=checkbox] {
	display: inline-block;
	margin-left: 20px;
	color: #fff;
	font-size: 14px;
	font-weight: normal;
	text-align: left;
}

input[type=submit] {
	background-color: #E63946;
	color: #fff;
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
}

input[type=submit]:hover {
	background-color: #555;
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

@media screen and (max-width: 600px) {
	.navbar a {
		float: none;
		width: 100%;
	}
}

.rid {
	width: 20%;
	height: 40px;
}

select[type="submit"] {
	border: 1px solid #ddd;
	padding: 8px;
	font-size: 16px;
	margin: 10px 0;
	border-radius: 4px;
}

input[type="submit"] {
	width: 10%;
	height: 40px;
	background-color: #008B8B;
	color: white;
	cursor: pointer;
}

input[type="submit"]:hover {
	background-color: #66CDAA;
}
</style>
</head>
<body>
    <%@ include file="includes/nav.jsp" %>
    <%@ include file="includes/db.jsp" %>

	<table>
		<caption>
			<h2>Voter Validation</h2>
		</caption>
		<tr>
			<th>Reg No</th>
			<th>Name</th>
			<th>Email</th>
			<th>Phone</th>
			<th>Class</th>
			<th>Division</th>
			<th>Birth Date</th>
			<th>Status</th>
		</tr>
		<%
		Connection con;
		PreparedStatement ps;
		Statement st;
		ResultSet rs;
		DatabaseMetaData dbmd;
		ResultSetMetaData rsmd;

		try {
			// Use Supabase connection from includes/db.jsp
			con = (Connection) request.getAttribute("dbCon");
			
			if (con != null) {
				// Query voter table
				ps = con.prepareStatement("SELECT * FROM voter");
				rs = ps.executeQuery();

				while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getString("registration_number")%></td>
			<td><%=rs.getString("name")%></td>
			<td><%=rs.getString("email")%></td>
			<td><%=rs.getString("phone")%></td>
			<td><%=rs.getString("class")%></td>
			<td><%=rs.getString("division")%></td>
			<td><%=rs.getString("birthdate")%></td>
			<td>Not Approved</td>

		</tr>
		<%
				}
				rs.close();
				ps.close();
			} else {
				out.println("<tr><td colspan='8'>Database connection failed</td></tr>");
			}
		} // try
		catch (Exception e) {
		System.out.println(e);
		out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
		} // catch
		%>


	</table>

	<form action="voter_approve.jsp" method="post">
	<br>
		<label for="search">Register Number</label> <input type="text"
			id="rno" name="rno" required class="rid"> <select
			name="Status">
			<option value="Approve">Approve</option>
			<option value="Reject">Reject</option>
		</select> <input class="submit" type="submit" value="Submit">
	</form>

</body>
</html>

<!-- new booking -->
