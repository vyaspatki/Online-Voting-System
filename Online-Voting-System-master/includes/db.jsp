<%@ page import="java.sql.*" %>
<%--
  Centralized DB connection include for Supabase (Postgres).
  Usage:
    <%@ include file="includes/db.jsp" %>
    <%
      Connection con = (Connection) request.getAttribute("dbCon");
      // use `con` for queries
      if (con != null) con.close();
    %>

  This file reads `DB_URL`, `DB_USER`, `DB_PASS` from application context params
  (set in WEB-INF/web.xml) or falls back to placeholders. It creates a Connection
  and stores it in request attribute `dbCon`.
--%>
<%
String dbUrl = application.getInitParameter("DB_URL");
String dbUser = application.getInitParameter("DB_USER");
String dbPass = application.getInitParameter("DB_PASS");
if (dbUrl == null) {
    dbUrl = "jdbc:postgresql://HOST:5432/DBNAME?sslmode=require"; // placeholder
    dbUser = "DB_USER";
    dbPass = "DB_PASS";
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
