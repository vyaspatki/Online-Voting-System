<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Result</title>

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
	width: 50%;
	margin-top: 20px;
}

th, td {
	text-align: center;
	padding: 8px;
	border: 1px solid #ddd;
}

td {
	background-color: #FFFFE0;
	color: black;
}

th {
	background-color: crimson;
	color: white;
}

tr:nth-child(even) {
	background-color: crimson;
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

	<table border="2" align="center">
		<caption>
			<h2 align="center">Winner</h2>
		</caption>
		<tr>
			<th>Name</th>
			<th>Votes</th>
			<th>Election name</th>
		</tr>

		<%
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs2 = null;
		try {
			con = (Connection) request.getAttribute("dbCon");
			if (con != null) {
				ps = con.prepareStatement("select * from winner");
				rs2 = ps.executeQuery();

				// check if eid column exists
				java.sql.ResultSetMetaData md2 = rs2.getMetaData();
				boolean hasEid = false;
				for (int i = 1; i <= md2.getColumnCount(); i++) {
				    if ("eid".equalsIgnoreCase(md2.getColumnName(i))) {
				        hasEid = true;
				        break;
				    }
				}
				while (rs2.next()) {
				%>
				<tr>
					<td><%=rs2.getString("name")%></td>
					<td><%=rs2.getInt("votes")%></td>
					<td><%=hasEid ? rs2.getString("eid") : "-"%></td>
				</tr>
				<%
				}
				rs2.close();
				ps.close();
			}
		} catch (Exception e) {
			out.println("Error: " + e.getMessage());
		}
		%>
	</table>
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
