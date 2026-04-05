<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
<title>Diagnostic Test</title>
<style>
  body { font-family: Arial; margin: 20px; }
  .success { color: green; background: #f0fff0; padding: 10px; margin: 10px 0; border: 1px solid green; }
  .error { color: red; background: #fff0f0; padding: 10px; margin: 10px 0; border: 1px solid red; }
  .info { color: blue; background: #f0f0ff; padding: 10px; margin: 10px 0; border: 1px solid blue; }
</style>
</head>
<body>
  <h1>JSP Diagnostic Test</h1>

  <div class="success">
    ✓ JSPs are working! This page loaded successfully.
  </div>

  <h2>Checking Database Connection...</h2>
  
  <%@ include file="includes/db.jsp" %>
  
  <%
    Connection con = (Connection) request.getAttribute("dbCon");
    if (con != null) {
      out.println("<div class='success'>✓ Database connection successful!</div>");
      
      try {
        String query = "SELECT * FROM admin LIMIT 1;";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        
        if (rs.next()) {
          out.println("<div class='success'>✓ Admin table found! ID: " + rs.getInt("id") + ", Username: " + rs.getString("admin") + ", Pass: " + rs.getString("pass") + "</div>");
        } else {
          out.println("<div class='error'>✗ Admin table is empty</div>");
        }
        rs.close();
        stmt.close();
      } catch (Exception e) {
        out.println("<div class='error'>✗ Query error: " + e.getMessage() + "</div>");
      }
    } else {
      out.println("<div class='error'>✗ Database connection FAILED! Check WEB-INF/web.xml credentials</div>");
    }
  %>

  <h2>Next Steps</h2>
  <div class="info">
    <p>If all checks pass above, try logging in:</p>
    <p><a href="Login.jsp">Go to Login.jsp</a></p>
  </div>

</body>
</html>
