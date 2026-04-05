<%
// logic extracted from register.jsp to isolate Java code and avoid JSP parsing issues
String regSuccess = "";
String regError = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String birthdate = request.getParameter("date");
    String rgno = request.getParameter("rgno");
    String password = request.getParameter("password");
    String division = request.getParameter("division");
    String classVal = request.getParameter("classVal");
    out.println("<!-- register POST received name="+name+" email="+email+" -->");

    if (name != null && !name.isEmpty() && email != null && !email.isEmpty()) {
        Connection con = (Connection) request.getAttribute("dbCon");
        if (con == null) {
            regError = "Database connection failed!<br>";
            String dbError = (String) request.getAttribute("dbError");
            if (dbError != null) {
                regError += "DB Error: " + dbError + "<br>";
            }
            regError += "Check Neon DB credentials and network access.";
            out.println("<div style='color:red'>DB connection is null. " + regError + "</div>");
        } else {
            try {
                String createTableSQL = "CREATE TABLE IF NOT EXISTS voter (" +
                        "id SERIAL PRIMARY KEY, " +
                        "name VARCHAR(255) NOT NULL, " +
                        "email VARCHAR(255), " +
                        "phone VARCHAR(20), " +
                        "birthdate VARCHAR(20), " +
                        "registration_number VARCHAR(20), " +
                        "password VARCHAR(255), " +
                        "division VARCHAR(50), " +
                        "class VARCHAR(50), " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";

                Statement createStmt = con.createStatement();
                createStmt.execute(createTableSQL);
                createStmt.close();

                String insertSQL = "INSERT INTO voter (name, email, phone, birthdate, registration_number, password, division, class) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(insertSQL);
                pst.setString(1, name);
                pst.setString(2, email);
                pst.setString(3, phone);
                pst.setString(4, birthdate);
                pst.setString(5, rgno);
                pst.setString(6, password);
                pst.setString(7, division);
                pst.setString(8, classVal);

                int count = pst.executeUpdate();
                out.println("<div style='color:blue'>Inserted rows: " + count + "</div>");
                pst.close();

                regSuccess = "Registration successful! You can now log in.";
                Statement chk = con.createStatement();
                ResultSet rs = chk.executeQuery("SELECT COUNT(*) FROM voter");
                if (rs.next()) {
                    out.println("<div style='color:blue'>Total voters: " + rs.getInt(1) + "</div>");
                }
                rs.close();
                chk.close();
            } catch (Exception e) {
                regError = "Registration error: " + e.getMessage() + "<br>";
                out.println("<div style='color:red'>Exception: " + e.getMessage() + "</div>");
                e.printStackTrace(System.out);
            }
        }
    }
}

// expose values to page
request.setAttribute("regSuccess", regSuccess);
request.setAttribute("regError", regError);
// --- Diagnostics: Confirm logic execution and show all form parameters ---
out.println("<div style='color:purple;font-weight:bold;'>[DIAG] register_logic.jsp executed.</div>");
out.println("<div style='color:purple;'>[DIAG] Request method: " + request.getMethod() + "</div>");
out.println("<div style='color:purple;'>[DIAG] Form params: name=" + request.getParameter("name") + ", email=" + request.getParameter("email") + ", phone=" + request.getParameter("phone") + ", birthdate=" + request.getParameter("date") + ", rgno=" + request.getParameter("rgno") + ", password=" + request.getParameter("password") + ", division=" + request.getParameter("division") + ", classVal=" + request.getParameter("classVal") + "</div>");

// Show a visible banner ONLY for POST requests
if ("POST".equalsIgnoreCase(request.getMethod())) {
    out.println("<div style='background:orange;color:black;font-weight:bold;padding:10px;text-align:center;'>[DIAG] POST logic reached in register_logic.jsp</div>");
}

// Diagnostics: Print DB connection status and last error at top of page
if (request.getAttribute("dbCon") == null) {
    out.println("<div style='color:red;font-weight:bold;'>[DIAG] DB connection is NULL. Check Neon DB credentials and network/firewall.</div>");
    String dbError = (String) request.getAttribute("dbError");
    if (dbError != null) {
        out.println("<div style='color:red;font-weight:bold;'>[DIAG] DB Error: " + dbError + "</div>");
    }
} else {
    out.println("<div style='color:green;font-weight:bold;'>[DIAG] DB connection established.</div>");
}
%>