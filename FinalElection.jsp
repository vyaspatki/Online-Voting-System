<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cast Your Vote</title>
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

h1 {
	text-align: center;
	margin-top: 50px;
}

table {
	border-collapse: collapse;
	width: 80%;
	margin: 20px auto;
}

th, td {
	text-align: center;
	padding: 12px;
	border: 1px solid #ddd;
}

th {
	background-color: #008080;
	color: white;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

.vote-form {
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0px 0px 10px #ccc;
	max-width: 400px;
	margin: 20px auto;
	text-align: center;
}

label {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
	color: #fff;
	text-transform: uppercase;
	font-size: 14px;
	text-align: left;
}

input[type=radio] {
	margin: 10px;
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
</style>
</head>
<body>
	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>
	<%@ include file="includes/create_tables.jsp" %>
	
	<h1>Cast Your Vote</h1>

	<table>
		<tr>
			<th>Candidate ID</th>
			<th>Registration Number</th>
			<th>Candidate Name</th>
			<th>Description</th>
			<th>Select</th>
		</tr>
		<%
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
				<td><%=rs.getInt("cid")%></td>
				<td><%=rs.getString("registration_number")%></td>
				<td><%=rs.getString("name")%></td>
				<td><%=rs.getString("description")%></td>
				<td>
					<form action="submit_vote.jsp" method="post">
						<input type="hidden" name="electionId" value="ELEC_DEFAULT">
						<input type="radio" name="candidateId" value="<%=rs.getInt("cid")%>" required>
						<input type="submit" value="Vote">
					</form>
				</td>
			</tr>
			<%
				}
				rs.close();
				ps.close();
			} else {
				out.println("<tr><td colspan='5'>Database connection failed</td></tr>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
		}
		%>
	</table>
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
