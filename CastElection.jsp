<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*"%>
<%@ include file="includes/db.jsp" %>
<%@ include file="includes/create_tables.jsp" %>
<%
String electionName = request.getParameter("name");
String date = request.getParameter("date");

try {
    Connection con = (Connection) request.getAttribute("dbCon");
    
    if (con == null) {
        out.println("<script>alert('Database connection failed.');</script>");
        out.println("<script>window.location.href = 'declare_election.jsp';</script>");
    } else {
        String eid = "ELEC_" + System.currentTimeMillis();
        
        String insertQuery = "INSERT INTO election(name, date, eid) VALUES(?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(insertQuery);
        ps.setString(1, electionName);
        ps.setString(2, date);
        ps.setString(3, eid);

        int res = ps.executeUpdate();
        ps.close();
        
        if (res > 0) {
            // If election creation is successful, display success message and redirect
            out.println("<script>alert('Election Created Successfully! ID: " + eid + "');</script>");
            out.println("<script>window.location.href = 'Admin_dashboard.jsp';</script>");
        } else {
            // If insertion failed
            out.println("<script>alert('Election creation failed.');</script>");
            out.println("<script>window.location.href = 'declare_election.jsp';</script>");
        }
    }

} catch (Exception ex) {
    // Display an error message and redirect
    out.println("<script>alert('Election creation failed. An error occurred: " + ex.getMessage() + "');</script>");
    out.println("<script>window.location.href = 'declare_election.jsp';</script>");
    ex.printStackTrace();
}
%>
