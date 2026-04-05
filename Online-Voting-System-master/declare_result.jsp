<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Declare Result</title>
<style>
/* reuse some styles from other pages for consistency */
* { box-sizing: border-box; }
body { margin: 0; font-family: Arial, sans-serif; font-size: 16px; line-height: 1.5; background-color: #E63946; }
.navbar { background-color: #E63946; overflow: hidden; font-size: 20px }
.navbar a { float: left; display: block; color: #f2f2f2; text-align: center; padding: 14px 16px; text-decoration: none; }
.navbar a:hover { background-color: #444; color: black; }
h1 { text-align: center; margin-top: 50px; }
form { background-color: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 0px 10px #ccc; max-width: 400px; margin: 20px auto; text-align: center; }
label { display: block; margin-bottom: 10px; font-weight: bold; color: #fff; text-transform: uppercase; font-size: 14px; text-align: left; }
input[type=text], input[type=submit] { padding: 15px; border-radius: 5px; border: none; margin-bottom: 20px; width: 100%; box-sizing: border-box; background-color: #f2f2f2; color: #666; font-size: 14px; font-weight: bold; outline: none; }
input[type=submit] { background-color: #008080; color: #fff; cursor: pointer; text-transform: uppercase; font-size: 16px; font-weight: bold; transition: all 0.3s ease; }
input[type=submit]:hover { background-color: #555; transform: translateY(-2px); box-shadow: 0px 5px 10px #888; }
</style>
</head>
<body>
    <div class="navbar">
        <a href="Admin_dashboard.jsp">Home</a>
    </div>
    <%@ include file="includes/nav.jsp" %>
    <%@ include file="includes/db.jsp" %>
    <%@ include file="includes/create_tables.jsp" %>

    <%
    // post-processing logic: when form is submitted run declaration
    String resultMsg = null;
    String resultColor = "green";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection con = (Connection) request.getAttribute("dbCon");
        if (con != null) {
            try {
                int cid = Integer.parseInt(request.getParameter("cid"));
                String election = request.getParameter("election");
                if (election == null) election = "";

                // count votes for this candidate (optional election filter)
                PreparedStatement ps = con.prepareStatement(
                        "SELECT COUNT(*) FROM result WHERE cid = ?" +
                        (election.isEmpty() ? "" : " AND eid = ?")
                );
                ps.setInt(1, cid);
                if (!election.isEmpty()) ps.setString(2, election);
                ResultSet rs = ps.executeQuery();
                int votes = 0;
                if (rs.next()) {
                    votes = rs.getInt(1);
                }
                rs.close();
                ps.close();

                // look up candidate name
                String name = null;
                ps = con.prepareStatement("SELECT name FROM candidate WHERE id = ?");
                ps.setInt(1, cid);
                rs = ps.executeQuery();
                if (rs.next()) {
                    name = rs.getString("name");
                }
                rs.close();
                ps.close();

                if (name == null) {
                    resultMsg = "No candidate found for ID " + cid;
                    resultColor = "red";
                } else {
                    // remove any existing winner record for same candidate/election
                    ps = con.prepareStatement("DELETE FROM winner WHERE cid = ?" +
                            (election.isEmpty() ? "" : " AND eid = ?"));
                    ps.setInt(1, cid);
                    if (!election.isEmpty()) ps.setString(2, election);
                    ps.executeUpdate();
                    ps.close();

                    // insert winner row
                    ps = con.prepareStatement("INSERT INTO winner (cid, name, votes, eid) VALUES (?, ?, ?, ?)");
                    ps.setInt(1, cid);
                    ps.setString(2, name);
                    ps.setInt(3, votes);
                    ps.setString(4, election);
                    ps.executeUpdate();
                    ps.close();

                    resultMsg = "Result declared for candidate " + name + " (ID: " + cid + ") with " + votes + " votes." +
                                (election.isEmpty() ? "" : " Election: " + election);
                }
            } catch (Exception e) {
                e.printStackTrace();
                resultMsg = "Error: " + e.getMessage();
                resultColor = "red";
            }
        } else {
            resultMsg = "Database connection unavailable.";
            resultColor = "red";
        }
    }
    %>

    <h1>Declare Result</h1>
    <% if (resultMsg != null && !resultMsg.isEmpty()) { %>
        <div style="color:<%=resultColor%>;text-align:center;"><%=resultMsg%></div>
    <% } %>

    <% if (resultMsg != null && !resultMsg.isEmpty()) { %>
    <script>
        alert('<%=resultMsg.replace("'", "\\'")%>');
    </script>
    <% } %>

    <!-- display vote counts and leader -->
    <%
        try {
            Connection con2 = (Connection) request.getAttribute("dbCon");
            if (con2 != null) {
                PreparedStatement ps2 = con2.prepareStatement(
                        "SELECT r.cid, c.name, COUNT(*) AS votes " +
                        "FROM result r LEFT JOIN candidate c ON r.cid = c.id " +
                        "GROUP BY r.cid, c.name ORDER BY votes DESC");
                ResultSet rs2 = ps2.executeQuery();
                boolean first = true;
                out.println("<table style='margin:10px auto;border:1px solid #fff;color:#fff;'><tr><th>Candidate</th><th>Votes</th><th>ID</th></tr>");
                while (rs2.next()) {
                    String nm = rs2.getString("name") != null ? rs2.getString("name") : "(unknown)";
                    int v = rs2.getInt("votes");
                    int cid2 = rs2.getInt("cid");
                    if (first) {
                        out.println("</table>");
                        out.println("<div style='text-align:center;color:#fff;margin:5px;'>Currently leading: " + nm + " (" + v + " votes, ID " + cid2 + ")</div>");
                        out.println("<table style='margin:10px auto;border:1px solid #fff;color:#fff;'><tr><th>Candidate</th><th>Votes</th><th>ID</th></tr>");
                        first = false;
                    }
                    out.println("<tr><td>" + nm + "</td><td>" + v + "</td><td>" + cid2 + "</td></tr>");
                }
                out.println("</table>");
                rs2.close();
                ps2.close();
            }
        } catch (Exception e) {
            // ignore errors
        }
    %>

    <form method="post" action="declare_result.jsp">
        <label for="cid">Candidate ID:</label>
        <input type="text" id="cid" name="cid" placeholder="Enter Candidate ID" required>

        <label for="election">Election Name (optional):</label>
        <input type="text" id="election" name="election" placeholder="Enter Election Name">

        <input type="submit" value="Declare Result">
    </form>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>