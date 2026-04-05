<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Diagnostic - Check Column Names</title>
<style>
  body { font-family: Arial; margin: 20px; }
  .success { color: green; background: #f0fff0; padding: 10px; margin: 10px 0; border: 1px solid green; }
  .error { color: red; background: #fff0f0; padding: 10px; margin: 10px 0; border: 1px solid red; }
  .info { color: blue; background: #f0f0ff; padding: 10px; margin: 10px 0; border: 1px solid blue; }
  pre { background: #f4f4f4; padding: 10px; overflow-x: auto; }
</style>
</head>
<body>
  <h1>Column Names Diagnostic</h1>

  <%@ include file="includes/db.jsp" %>
  
  <%
    Connection con = (Connection) request.getAttribute("dbCon");
    String dbError = (String) request.getAttribute("dbError");
    if (con != null) {
      out.println("<div class='success'>✓ Database connection successful!</div>");
    } else {
      out.println("<div class='error'>✗ Database connection FAILED!</div>");
      if (dbError != null) {
        out.println("<div class='error'>Error message: " + dbError + "</div>");
      }
    }
      
      try {
        // Get table metadata
        DatabaseMetaData dbmd = con.getMetaData();
        ResultSet rs = dbmd.getColumns(null, null, "admin", null);
        
        out.println("<div class='info'><h3>Columns in 'admin' table:</h3>");
        out.println("<pre>");
        
        boolean hasColumns = false;
        while (rs.next()) {
          hasColumns = true;
          String colName = rs.getString("COLUMN_NAME");
          String colType = rs.getString("TYPE_NAME");
          out.println("- " + colName + " (" + colType + ")");
        }
        
        if (!hasColumns) {
          out.println("ERROR: No columns found in admin table!");
        }
        
        out.println("</pre>");
        out.println("</div>");
        
        // Try to fetch one row and show all values
        Statement stmt = con.createStatement();
        ResultSet rows = stmt.executeQuery("SELECT * FROM admin LIMIT 1;");
        
        if (rows.next()) {
          out.println("<div class='success'>✓ Admin table has data:</div>");
          out.println("<pre>");
          ResultSetMetaData rsmd = rows.getMetaData();
          int colCount = rsmd.getColumnCount();
          for (int i = 1; i <= colCount; i++) {
            String colName = rsmd.getColumnName(i);
            Object value = rows.getObject(i);
            out.println(colName + " = " + value);
          }
          out.println("</pre>");
        } else {
          out.println("<div class='error'>✗ Admin table is empty</div>");
        }
        
        rs.close();
        stmt.close();
      } catch (Exception e) {
        out.println("<div class='error'>✗ Error: " + e.getMessage() + "</div>");
        e.printStackTrace(new java.io.PrintWriter(out));
      }
    } else {
      out.println("<div class='error'>✗ Database connection FAILED!</div>");
    }
  %>

</body>
</html>
