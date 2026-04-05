<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Remove Result</title>
<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, sans-serif;
	font-size: 16px;
	line-height: 1.5;
	background-color: #E63946;
}

.navbar {
	background-color: #E63946;
	overflow: hidden;
	font-size: 20px
}

.navbar a {
	float: left;
	display: block;
	color: #f2f2f2;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

.navbar a:hover {
	background-color: #444;
	color: black;
}

h1 {
	text-align: center;
	margin-top: 50px;
}

table {
	border-collapse: collapse;
	width: 80%;
	margin: 20px auto;
}

th, td {
	text-align: center;
	padding: 12px;
	border: 1px solid #ddd;
}

th {
	background-color: #DC143C;
	color: white;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

form {
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0px 0px 10px #ccc;
	max-width: 400px;
	margin: 20px auto;
	text-align: center;
}

label {
	display: block;
	margin-bottom: 10px;
	font-weight: bold;
	color: #fff;
	text-transform: uppercase;
	font-size: 14px;
	text-align: left;
}

input[type=text], input[type=submit] {
	padding: 15px;
	border-radius: 5px;
	border: none;
	margin-bottom: 20px;
	width: 100%;
	box-sizing: border-box;
	background-color: #f2f2f2;
	color: #666;
	font-size: 14px;
	font-weight: bold;
	outline: none;
}

input[type=submit] {
	background-color: #DC143C;
	color: #fff;
	cursor: pointer;
	text-transform: uppercase;
	font-size: 16px;
	font-weight: bold;
	transition: all 0.3s ease;
}

input[type=submit]:hover {
	background-color: #555;
	transform: translateY(-2px);
	box-shadow: 0px 5px 10px #888;
}
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
	// declaration handling (candidate ID form)
	String declareMsg = null;
	String declareColor = "green";
	Connection con2 = (Connection) request.getAttribute("dbCon");
	// determine whether winner/result tables have an eid column
	boolean winnerHasEid = false;
	boolean resultHasEid = false;
	if (con2 != null) {
	    try {
	        DatabaseMetaData md = con2.getMetaData();
	        ResultSet c1 = md.getColumns(null, null, "winner", "eid");
	        winnerHasEid = c1.next();
	        c1.close();
	        ResultSet c2 = md.getColumns(null, null, "result", "eid");
	        resultHasEid = c2.next();
	        c2.close();
	    } catch (Exception ex) {
	        // ignore metadata errors
	    }
	}
	if (request.getParameter("cid") != null && !request.getParameter("cid").isEmpty()) {
	    try {
	        int cidVal = Integer.parseInt(request.getParameter("cid"));
	        String election = request.getParameter("election");
	        if (election == null) election = "";
	
	        // count votes for candidate (optional election filter)
	        String countSql = "SELECT COUNT(*) FROM result WHERE cid::int = ?";
	        if (resultHasEid && !election.isEmpty()) {
	            countSql += " AND eid = ?";
	        }
	        PreparedStatement pdecl = con2.prepareStatement(countSql);
	        pdecl.setInt(1, cidVal);
	        if (!election.isEmpty()) pdecl.setString(2, election);
	        ResultSet rsdecl = pdecl.executeQuery();
	        int votes = 0;
	        if (rsdecl.next()) votes = rsdecl.getInt(1);
	        rsdecl.close();
	        pdecl.close();
	
	        // look up candidate name
	        String name = null;
	        pdecl = con2.prepareStatement("SELECT name FROM candidate WHERE id = ?");
	        pdecl.setInt(1, cidVal);
	        rsdecl = pdecl.executeQuery();
	        if (rsdecl.next()) name = rsdecl.getString("name");
	        rsdecl.close();
	        pdecl.close();
	
	        if (name == null) {
	            declareMsg = "No candidate found for ID " + cidVal;
	            declareColor = "red";
	        } else {
                    // remove old winner record
                    String deleteSql = "DELETE FROM winner WHERE cid = ?";
                    if (winnerHasEid && !election.isEmpty()) {
                        deleteSql += " AND eid = ?";
                    }
                    pdecl = con2.prepareStatement(deleteSql);
                    pdecl.setInt(1, cidVal);
                    if (winnerHasEid && !election.isEmpty()) {
                        pdecl.setString(2, election);
                    }
                    pdecl.executeUpdate();
                    pdecl.close();
                    // insert new winner
                    if (winnerHasEid) {
                        pdecl = con2.prepareStatement("INSERT INTO winner (cid, name, votes, eid) VALUES (?, ?, ?, ?)");
                        pdecl.setInt(1, cidVal);
                        pdecl.setString(2, name);
                        pdecl.setInt(3, votes);
                        pdecl.setString(4, election);
                    } else {
                        pdecl = con2.prepareStatement("INSERT INTO winner (cid, name, votes) VALUES (?, ?, ?)");
                        pdecl.setInt(1, cidVal);
                        pdecl.setString(2, name);
                        pdecl.setInt(3, votes);
                    }
                    pdecl.executeUpdate();
                    pdecl.close();
	            declareMsg = "Result declared for candidate " + name + " (ID: " + cidVal + ") with " + votes + " votes." +
	                        (election.isEmpty() ? "" : " Election: " + election);
	        }
	    } catch (Exception ex) {
	        ex.printStackTrace();
	        declareMsg = "Error: " + ex.getMessage();
	        declareColor = "red";
	    }
	}
	%>

	<h1>Remove Result</h1>
	<% if (declareMsg != null) { %>
		<div style="color:<%=declareColor%>;text-align:center;"><%=declareMsg%></div>
	<% } %>

	<!-- declaration form -->
	<form method="post" action="remove_result.jsp">
		<label for="cid">Candidate ID:</label>
		<input type="text" id="cid" name="cid" placeholder="Enter Candidate ID" required>
		<label for="election">Election Name (optional):</label>
		<input type="text" id="election" name="election" placeholder="Enter Election Name">
		<input type="submit" value="Declare Result">
	</form>

	<%
	// show votes table and leader
	try {
	    if (con2 != null) {
	        PreparedStatement ps2 = con2.prepareStatement(
	                "SELECT r.cid, c.name, COUNT(*) AS votes " +
	                "FROM result r LEFT JOIN candidate c ON (r.cid::int = c.id) " +
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
	    // ignore
	}
	%>

	<table>
		<tr>
			<th>Winner Name</th>
			<th>Votes</th>
			<th>Election Name</th>
		</tr>
		<%
		Connection con;
		PreparedStatement ps;
		ResultSet rs;
		
		try {
			con = (Connection) request.getAttribute("dbCon");
			
			if (con != null) {
				ps = con.prepareStatement("select * from winner");
				rs = ps.executeQuery();

				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("name")%></td>
				<td><%=rs.getString("votes")%></td>
				<td><%=rs.getString("eid")%></td>
			</tr>
			<%
				}
				rs.close();
				ps.close();
			} else {
				out.println("<tr><td colspan='3'>Database connection failed</td></tr>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
		}
		%>
	</table>

	<form action="RemoveResult" method="post">
		<label for="election">Enter Election Name to Remove:</label>
		<input type="text" id="election" name="election" placeholder="Enter Election Name" required>
		
		<input type="submit" value="Remove Result">
	</form>
	<%@ include file="includes/footer.jsp" %>
</body>
</html>
