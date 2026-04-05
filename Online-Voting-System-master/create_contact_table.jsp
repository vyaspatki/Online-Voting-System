<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="includes/db.jsp" %>
<%
try {
    Connection con = (Connection) request.getAttribute("dbCon");
    if (con == null) {
        out.println("<h3>Database connection failed. Check WEB-INF/web.xml and JDBC driver.</h3>");
    } else {
        Statement stmt = con.createStatement();
        // Create contact table with timestamp
        stmt.execute("CREATE TABLE IF NOT EXISTS contact (" +
                     "id SERIAL PRIMARY KEY, " +
                     "name VARCHAR(255), " +
                     "email VARCHAR(255), " +
                     "message TEXT, " +
                     "created_at TIMESTAMPTZ DEFAULT now()" +
                     ")");
        stmt.close();
        out.println("<script>alert('Contact table created or already exists.'); window.location.href='feedback.jsp';</script>");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<h3>Error creating contact table: " + e.getMessage() + "</h3>");
}
%>
