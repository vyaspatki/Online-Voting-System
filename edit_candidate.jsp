<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<%
	// Get candidate ID from URL parameter
	String idParam = request.getParameter("id");
	int candidateId = 0;
	if (idParam != null) {
		try {
			candidateId = Integer.parseInt(idParam);
		} catch (NumberFormatException e) {
			response.sendRedirect("manage_candidates.jsp");
			return;
		}
	} else {
		response.sendRedirect("manage_candidates.jsp");
		return;
	}

	// Handle form submission for updates
	String action = request.getParameter("action");
	String message = "";
	String messageType = "";

	if ("update".equals(action)) {
		Connection con = null;
		PreparedStatement ps = null;

		try {
			con = (Connection) request.getAttribute("dbCon");

			if (con != null) {
				String name = request.getParameter("name");
				String email = request.getParameter("email");
				String registrationNumber = request.getParameter("registration_number");
				String password = request.getParameter("password");
				String description = request.getParameter("description");
				String isVoter = request.getParameter("is_voter");
				String eid = request.getParameter("eid");

				ps = con.prepareStatement("UPDATE candidate SET name=?, email=?, registration_number=?, password=?, description=?, is_voter=?, eid=? WHERE id=?");
				ps.setString(1, name);
				ps.setString(2, email);
				ps.setString(3, registrationNumber);
				ps.setString(4, password);
				ps.setString(5, description);
				ps.setString(6, isVoter);
				ps.setString(7, eid);
				ps.setInt(8, candidateId);

				int result = ps.executeUpdate();
				if (result > 0) {
					message = "Candidate updated successfully!";
					messageType = "success";
				} else {
					message = "Failed to update candidate.";
					messageType = "error";
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

	// Fetch candidate data
	String name = "", email = "", registrationNumber = "", password = "", description = "", isVoter = "", eid = "";
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	try {
		con = (Connection) request.getAttribute("dbCon");

		if (con != null) {
			ps = con.prepareStatement("SELECT * FROM candidate WHERE id = ?");
			ps.setInt(1, candidateId);
			rs = ps.executeQuery();

			if (rs.next()) {
				name = rs.getString("name") != null ? rs.getString("name") : "";
				email = rs.getString("email") != null ? rs.getString("email") : "";
				registrationNumber = rs.getString("registration_number") != null ? rs.getString("registration_number") : "";
				password = rs.getString("password") != null ? rs.getString("password") : "";
				description = rs.getString("description") != null ? rs.getString("description") : "";
				isVoter = rs.getString("is_voter") != null ? rs.getString("is_voter") : "";
				eid = rs.getString("eid") != null ? rs.getString("eid") : "";
			} else {
				response.sendRedirect("manage_candidates.jsp");
				return;
			}
		}
	} catch (Exception e) {
		message = "Error loading candidate: " + e.getMessage();
		messageType = "error";
	} finally {
		try {
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		} catch (SQLException e) {
			// ignore
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Candidate - Admin</title>
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

.form-container {
	background-color: white;
	padding: 20px;
	margin: 20px auto;
	width: 80%;
	max-width: 600px;
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

.btn {
	padding: 10px 20px;
	margin: 0 10px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	text-decoration: none;
	display: inline-block;
}

.btn-update {
	background-color: #4CAF50;
	color: white;
}

.btn-cancel {
	background-color: #f44336;
	color: white;
}

.btn:hover {
	opacity: 0.8;
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
	.form-container {
		width: 95%;
	}
}
</style>
</head>
<body>
	<%@ include file="includes/nav.jsp" %>
	<%@ include file="includes/db.jsp" %>

	<h1>Edit Candidate</h1>

	<% if (!message.isEmpty()) { %>
	<div class="message <%=messageType%>">
		<%=message%>
	</div>
	<% } %>

	<div class="form-container">
		<h2>Edit Candidate Details</h2>
		<form action="edit_candidate.jsp?id=<%=candidateId%>" method="post">
			<input type="hidden" name="action" value="update">
			<div class="form-group">
				<label for="name">Name:</label>
				<input type="text" id="name" name="name" value="<%=name%>" required>
			</div>
			<div class="form-group">
				<label for="email">Email:</label>
				<input type="email" id="email" name="email" value="<%=email%>" required>
			</div>
			<div class="form-group">
				<label for="registration_number">Registration Number:</label>
				<input type="text" id="registration_number" name="registration_number" value="<%=registrationNumber%>" required>
			</div>
			<div class="form-group">
				<label for="password">Password:</label>
				<input type="password" id="password" name="password" value="<%=password%>" required>
			</div>
			<div class="form-group">
				<label for="description">Description:</label>
				<textarea id="description" name="description"><%=description%></textarea>
			</div>
			<div class="form-group">
				<label for="is_voter">Is Voter:</label>
				<select id="is_voter" name="is_voter">
					<option value="yes" <%= "yes".equals(isVoter) ? "selected" : "" %>>Yes</option>
					<option value="no" <%= "no".equals(isVoter) ? "selected" : "" %>>No</option>
				</select>
			</div>
			<div class="form-group">
				<label for="eid">Election ID:</label>
				<input type="text" id="eid" name="eid" value="<%=eid%>">
			</div>
			<div class="form-actions">
				<button type="submit" class="btn btn-update">Update Candidate</button>
				<a href="manage_candidates.jsp" class="btn btn-cancel">Cancel</a>
			</div>
		</form>
	</div>

	<%@ include file="includes/footer.jsp" %>
</body>
</html>