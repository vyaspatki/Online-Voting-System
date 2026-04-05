<%@ page import="java.sql.*" %>
<%--
  Centralized DB connection include for Railway/Render (Postgres).
  Usage:
    <%@ include file="includes/db.jsp" %>
    <%
      Connection con = (Connection) request.getAttribute("dbCon");
      // use `con` for queries
      if (con != null) con.close();
    %>

  This file reads DB credentials from environment variables (Railway) or
  application context params (set in WEB-INF/web.xml) or falls back to placeholders.
  It creates a Connection and stores it in request attribute `dbCon`.
--%>
<%
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
}

Connection dbCon = null;
try {
    Class.forName("org.postgresql.Driver");
    // add a short login timeout so the page doesn't hang indefinitely if the
    // database is unreachable. 5 seconds is usually enough for a LAN/vpn.
    DriverManager.setLoginTimeout(5);
    dbCon = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    request.setAttribute("dbCon", dbCon);
} catch (Exception e) {
    // save error message for diagnostics and log it
    request.setAttribute("dbError", e.getMessage());
    out.println("<!-- DB connection error: " + e.getMessage() + " -->");
    e.printStackTrace();
}

%>
