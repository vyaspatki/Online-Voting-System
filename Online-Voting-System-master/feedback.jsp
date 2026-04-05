<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Feedback</title>
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
	background-color: #FF0033;
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
	<%@ include file="includes/create_tables.jsp" %>
	
	<table>
		<caption>
			<h2>Feedback</h2>
		</caption>

		<tr>
			<th>Sr No.</th>
			<th>Name</th>
			<th>Email</th>
			<th>Description</th>
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
				ps = con.prepareStatement("select * from contact");

				rs = ps.executeQuery();

				while (rs.next()) {
			%>
			<tr>
				<%
				cnt++;
				%>
				<td><%=cnt%></td>
				<td><%=rs.getString(1)%></td>
				<td><%=rs.getString(2)%></td>
				<td><%=rs.getString(3)%></td>
			</tr>
			<%
			}
			rs.close();
			ps.close();
			} else {
				out.println("<tr><td colspan='4'>Database connection failed</td></tr>");
			}
		} // try
		catch (Exception e) {
			System.out.println(e);
			out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
		} // catch
		%>

	</table>
	<br />
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
