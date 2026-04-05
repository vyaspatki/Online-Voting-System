<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Candidate List</title>
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

h1, h2 {
	text-align: center;
}

table {
	border-collapse: collapse;
	width: 80%;
	margin-top: 20px;
}

th, td {
	text-align: center;
	padding: 8px;
	border: 1px solid #ddd;
}

th {
	background-color: #48D1CC;
	color: black;
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
th {
	font-size: 20px;
}

td {
	font-size: 15px;
}

h1 {
	font-size: 25px;
}
</style>
</head>
<body>
	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>
	<%@ include file="includes/create_tables.jsp" %>

	<table align="center">
		<caption>
			<h1>Candidate List</h1>
		</caption>

		<tr>
			<th>Sr No.</th>
			<th>Registration Number</th>
			<th>Name</th>
			<th>Candidate ID</th>
			<th>Description</th>
		</tr>
		<%
		int cnt = 0;
		Connection con;
		PreparedStatement ps;
		ResultSet rs;

		try {
			con = (Connection) request.getAttribute("dbCon");
			
			if (con != null) {
				ps = con.prepareStatement("SELECT id as cid, registration_number, name, description FROM candidate");
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
				<td><%=rs.getInt("cid")%></td>
				<td><%=rs.getString("description")%></td>
			</tr>
			<%
				}
				rs.close();
				ps.close();
			} else {
				out.println("<tr><td colspan='5'>Database connection failed</td></tr>");
			}

		} // try
		catch (Exception e) {
		System.out.println(e);
		out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
		} // catch
		%>


	</table>
	<br />
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
