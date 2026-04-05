<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<%
	// Handle form submissions
	String action = request.getParameter("action");
	String message = "";
	String messageType = "";

	if (action != null) {
		Connection con = null;
		PreparedStatement ps = null;

		try {
			con = (Connection) request.getAttribute("dbCon");

			if (con != null) {
				if ("add".equals(action)) {
					// Add new candidate
					String name = request.getParameter("name");
					String email = request.getParameter("email");
					String registrationNumber = request.getParameter("registration_number");
					String password = request.getParameter("password");
					String description = request.getParameter("description");
					String isVoter = request.getParameter("is_voter");
					String eid = request.getParameter("eid");

					ps = con.prepareStatement("INSERT INTO candidate (name, email, registration_number, password, description, is_voter, eid) VALUES (?, ?, ?, ?, ?, ?, ?)");
					ps.setString(1, name);
					ps.setString(2, email);
					ps.setString(3, registrationNumber);
					ps.setString(4, password);
					ps.setString(5, description);
					ps.setString(6, isVoter);
					ps.setString(7, eid);

					int result = ps.executeUpdate();
					if (result > 0) {
						message = "Candidate added successfully!";
						messageType = "success";
					} else {
						message = "Failed to add candidate.";
						messageType = "error";
					}
				} else if ("delete".equals(action)) {
					// Delete candidate
					int id = Integer.parseInt(request.getParameter("id"));

					ps = con.prepareStatement("DELETE FROM candidate WHERE id = ?");
					ps.setInt(1, id);

					int result = ps.executeUpdate();
					if (result > 0) {
						message = "Candidate deleted successfully!";
						messageType = "success";
					} else {
						message = "Failed to delete candidate.";
						messageType = "error";
					}
				}
			} else {
				message = "Database connection failed.";
				messageType = "error";
			}
		} catch (Exception e) {
			message = "Error: " + e.getMessage();
			messageType = "error";
		} finally {
			try {
				if (ps != null) ps.close();
			} catch (SQLException e) {
				// ignore
			}
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Candidates - Admin</title>
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
	color: white;
}

table {
	border-collapse: collapse;
	width: 90%;
	margin: 20px auto;
	background-color: white;
}

th, td {
	text-align: center;
	padding: 8px;
	border: 1px solid #ddd;
}

th {
	background-color: #FF0033;
	color: white;
	font-size: 18px;
}

td {
	font-size: 14px;
}

tr:nth-child(even) {
	background-color: #f9f9f9;
}

.btn {
	padding: 8px 16px;
	margin: 4px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	text-decoration: none;
	display: inline-block;
}

.btn-add {
	background-color: #4CAF50;
	color: white;
}

.btn-edit {
	background-color: #2196F3;
	color: white;
}

.btn-delete {
	background-color: #f44336;
	color: white;
}

.btn:hover {
	opacity: 0.8;
}

.form-container {
	background-color: white;
	padding: 20px;
	margin: 20px auto;
	width: 80%;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input, .form-group textarea, .form-group select {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
}

.form-group textarea {
	height: 80px;
	resize: vertical;
}

.form-actions {
	text-align: center;
	margin-top: 20px;
}

.message {
	padding: 10px;
	margin: 10px auto;
	width: 80%;
	border-radius: 4px;
	text-align: center;
	font-weight: bold;
}

.message.success {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.message.error {
	background-color: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}

@media screen and (max-width: 600px) {
	.navbar a {
		float: none;
		width: 100%;
	}
	table {
		width: 100%;
		font-size: 12px;
	}
}
</style>
</head>
<body>
	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>
	<%@ include file="includes/create_tables.jsp" %>

	<h1>Manage Candidates</h1>

	<% if (!message.isEmpty()) { %>
	<div class="message <%=messageType%>">
		<%=message%>
	</div>
	<% } %>

	<!-- Add New Candidate Form -->
	<div class="form-container">
		<h2>Add New Candidate</h2>
		<form action="manage_candidates.jsp" method="post">
			<input type="hidden" name="action" value="add">
			<div class="form-group">
				<label for="name">Name:</label>
				<input type="text" id="name" name="name" required>
			</div>
			<div class="form-group">
				<label for="email">Email:</label>
				<input type="email" id="email" name="email" required>
			</div>
			<div class="form-group">
				<label for="registration_number">Registration Number:</label>
				<input type="text" id="registration_number" name="registration_number" required>
			</div>
			<div class="form-group">
				<label for="password">Password:</label>
				<input type="password" id="password" name="password" required>
			</div>
			<div class="form-group">
				<label for="description">Description:</label>
				<textarea id="description" name="description"></textarea>
			</div>
			<div class="form-group">
				<label for="is_voter">Is Voter:</label>
				<select id="is_voter" name="is_voter">
					<option value="yes">Yes</option>
					<option value="no">No</option>
				</select>
			</div>
			<div class="form-group">
				<label for="eid">Election ID:</label>
				<input type="text" id="eid" name="eid">
			</div>
			<div class="form-actions">
				<button type="submit" class="btn btn-add">Add Candidate</button>
			</div>
		</form>
	</div>

	<!-- Candidates List Table -->
	<table>
		<caption>
			<h2>Current Candidates</h2>
		</caption>
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Email</th>
			<th>Reg Number</th>
			<th>Description</th>
			<th>Is Voter</th>
			<th>Election ID</th>
			<th>Actions</th>
		</tr>
		<%
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = (Connection) request.getAttribute("dbCon");

			if (con != null) {
				ps = con.prepareStatement("SELECT * FROM candidate ORDER BY id");
				rs = ps.executeQuery();

				while (rs.next()) {
		%>
		<tr>
			<td><%=rs.getInt("id")%></td>
			<td><%=rs.getString("name") != null ? rs.getString("name") : ""%></td>
			<td><%=rs.getString("email") != null ? rs.getString("email") : ""%></td>
			<td><%=rs.getString("registration_number") != null ? rs.getString("registration_number") : ""%></td>
			<td><%=rs.getString("description") != null ? rs.getString("description") : ""%></td>
			<td><%=rs.getString("is_voter") != null ? rs.getString("is_voter") : ""%></td>
			<td><%=rs.getString("eid") != null ? rs.getString("eid") : ""%></td>
			<td>
				<a href="edit_candidate.jsp?id=<%=rs.getInt("id")%>" class="btn btn-edit">Edit</a>
				<a href="manage_candidates.jsp?action=delete&id=<%=rs.getInt("id")%>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this candidate?')">Delete</a>
			</td>
		</tr>
		<%
				}
			} else {
				out.println("<tr><td colspan='8'>Database connection failed</td></tr>");
			}
		} catch (Exception e) {
			out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
		} finally {
			try {
				if (rs != null) rs.close();
				if (ps != null) ps.close();
			} catch (SQLException e) {
				// ignore
			}
		}
		%>
	</table>

	<%@ include file="includes/footer.jsp" %>
</body>
</html>