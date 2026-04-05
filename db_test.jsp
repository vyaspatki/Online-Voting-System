<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Database Connection Test</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; }
.success { color: green; }
.error { color: red; }
.info { background: #f0f0f0; padding: 10px; margin: 10px 0; }
</style>
</head>
<body>
	<h1>Database Connection Diagnostic</h1>

	<h2>Environment Variables</h2>
	<div class="info">
		<strong>DB_HOST:</strong> <%= System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "NOT SET" %><br>
		<strong>DB_PORT:</strong> <%= System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "NOT SET" %><br>
		<strong>DB_NAME:</strong> <%= System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "NOT SET" %><br>
		<strong>DB_USER:</strong> <%= System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "NOT SET" %><br>
		<strong>DB_PASS:</strong> <%= System.getenv("DB_PASS") != null ? "SET (hidden)" : "NOT SET" %>
	</div>

	<h2>Application Parameters (web.xml)</h2>
	<div class="info">
		<strong>DB_URL:</strong> <%= application.getInitParameter("DB_URL") != null ? application.getInitParameter("DB_URL").replaceAll("password=[^&]*", "password=***") : "NOT SET" %><br>
		<strong>DB_USER:</strong> <%= application.getInitParameter("DB_USER") != null ? application.getInitParameter("DB_USER") : "NOT SET" %><br>
		<strong>DB_PASS:</strong> <%= application.getInitParameter("DB_PASS") != null ? "SET (hidden)" : "NOT SET" %>
	</div>

	<h2>Database Connection Test</h2>
	<%
	String status = "Testing...";
	String statusClass = "info";
	Connection testCon = null;

	try {
		// Include the database connection logic
		String dbUrl = null;
		String dbUser = null;
		String dbPass = null;

		// First try environment variables (Railway/Render)
		String envHost = System.getenv("DB_HOST");
		String envPort = System.getenv("DB_PORT");
		String envName = System.getenv("DB_NAME");
		String envUser = System.getenv("DB_USER");
		String envPass = System.getenv("DB_PASS");

		if (envHost != null && !envHost.isEmpty() && envUser != null && !envUser.isEmpty()) {
		    // Build URL from environment variables
		    String port = (envPort != null && !envPort.isEmpty()) ? envPort : "5432";
		    String dbName = (envName != null && !envName.isEmpty()) ? envName : "neondb";
		    dbUrl = "jdbc:postgresql://" + envHost + ":" + port + "/" + dbName + "?sslmode=require";
		    dbUser = envUser;
		    dbPass = envPass;
		    out.println("<p><strong>Using Environment Variables</strong></p>");
		} else {
		    // Fall back to application context params (web.xml)
		    dbUrl = application.getInitParameter("DB_URL");
		    dbUser = application.getInitParameter("DB_USER");
		    dbPass = application.getInitParameter("DB_PASS");
		    if (dbUrl == null) {
		        dbUrl = "jdbc:postgresql://HOST:5432/DBNAME?sslmode=require"; // placeholder
		        dbUser = "DB_USER";
		        dbPass = "DB_PASS";
		    }
		    out.println("<p><strong>Using Application Parameters</strong></p>");
		}

		out.println("<p><strong>Connection URL:</strong> " + (dbUrl != null ? dbUrl.replaceAll("password=[^&]*", "password=***") : "null") + "</p>");
		out.println("<p><strong>User:</strong> " + (dbUser != null ? dbUser : "null") + "</p>");

		Class.forName("org.postgresql.Driver");
		DriverManager.setLoginTimeout(5);
		testCon = DriverManager.getConnection(dbUrl, dbUser, dbPass);

		if (testCon != null) {
			status = "✅ SUCCESS: Database connected successfully!";
			statusClass = "success";

			// Test a simple query
			Statement stmt = testCon.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM candidate");
			if (rs.next()) {
				int candidateCount = rs.getInt("count");
				out.println("<p><strong>Candidate Count:</strong> " + candidateCount + "</p>");
			}
			rs.close();
			stmt.close();
		}

	} catch (Exception e) {
		status = "❌ ERROR: " + e.getMessage();
		statusClass = "error";
		e.printStackTrace();
	} finally {
		try {
			if (testCon != null) testCon.close();
		} catch (SQLException e) {
			// ignore
		}
	}
	%>

	<div class="<%=statusClass%>">
		<strong>Status:</strong> <%=status%>
	</div>

	<h2>PostgreSQL Driver Test</h2>
	<%
	try {
		Class.forName("org.postgresql.Driver");
		out.println("<p class='success'>✅ PostgreSQL Driver loaded successfully</p>");
	} catch (Exception e) {
		out.println("<p class='error'>❌ PostgreSQL Driver failed: " + e.getMessage() + "</p>");
	}
	%>

	<br><br>
	<a href="manage_candidates.jsp">← Back to Manage Candidates</a>
</body>
</html>