<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="includes/db.jsp" %>
<%
String name = request.getParameter("name");
String email = request.getParameter("email");
String msg = request.getParameter("msg");

try {
    Connection con = (Connection) request.getAttribute("dbCon");
    if (con == null) {
        out.println("<script>alert('Database connection failed. Please try again later.'); window.location.href='contact.jsp';</script>");
    } else {
        PreparedStatement ps = con.prepareStatement("INSERT INTO contact(name, email, message) VALUES(?, ?, ?)");
        ps.setString(1, name != null ? name : "");
        ps.setString(2, email != null ? email : "");
        ps.setString(3, msg != null ? msg : "");
        int r = ps.executeUpdate();
        ps.close();
        if (r > 0) {
            out.println("<script>alert('Thank you for contacting us.'); window.location.href='index.html';</script>");
        } else {
            out.println("<script>alert('Failed to send message.'); window.location.href='contact.jsp';</script>");
        }
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('An error occurred: " + e.getMessage() + "'); window.location.href='contact.jsp';</script>");
}
%>
