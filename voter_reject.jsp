<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Voter List</title>
<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, sans-serif;
	font-size: 14px;
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
	display: block;
	color: #f2f2f2;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
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
	background-color: #008080;
	color: white;
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
</style>
</head>
<body>

	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>
	<table>
		<caption>
			<h2>Voter List</h2>
		</caption>
		<tr>
			<th>Sr No.</th>
			<th>Reg No</th>
			<th>Name</th>
			<th>Email</th>
			<th>Mobile</th>
			<th>Class</th>
			<th>Division</th>
			<th>Birth Date</th>
		</tr>
		<%
		int cnt = 0;
		Connection con;
		PreparedStatement ps;
		Statement st;
		ResultSet rs;

		try {
			con = (Connection) request.getAttribute("dbCon");
			
			if (con != null) {
				ps = con.prepareStatement("SELECT * FROM voter");
				rs = ps.executeQuery();

				while (rs.next()) {
			%>
			<tr>
				<%
				cnt++;
				%>
				<td><%=cnt%></td>
				<td><%=rs.getString("registration_number")%></td>
				<td><%=rs.getString("name")%></td>
				<td><%=rs.getString("email")%></td>
				<td><%=rs.getString("phone")%></td>
				<td><%=rs.getString("class")%></td>
				<td><%=rs.getString("division")%></td>
				<td><%=rs.getString("birthdate")%></td>
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
	<br />


</body>
</html>
