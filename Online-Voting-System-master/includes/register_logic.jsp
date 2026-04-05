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
            out.println("<!-- dbCon was null -->");
            regError = "Database connection failed!";
        }

        if (con != null) {
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
                out.println("<!-- insert updated rows="+count+" -->");
                pst.close();

                regSuccess = "Registration successful! You can now log in.";
                Statement chk = con.createStatement();
                ResultSet rs = chk.executeQuery("SELECT COUNT(*) FROM voter");
                if (rs.next()) {
                    out.println("<!-- total voters="+rs.getInt(1)+" -->");
                }
                rs.close();
                chk.close();
            } catch (Exception e) {
                regError = "Registration error: " + e.getMessage();
                out.println("<!-- exception: " + e.getMessage() + " -->");
                e.printStackTrace(System.out);
            }
        }
    }
}

// expose values to page
request.setAttribute("regSuccess", regSuccess);
request.setAttribute("regError", regError);
%>