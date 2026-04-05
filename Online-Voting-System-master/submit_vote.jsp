<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vote Submitted</title>
    <style>
        body {
            background-color: #E63946;
            font-family: Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .message-box {
            background: #fff;
            padding: 40px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .success {
            color: #069494;
            font-size: 24px;
            margin: 0;
        }
        .error {
            color: #ff6b6b;
            font-size: 24px;
            margin: 0;
        }
        p {
            margin: 15px 0;
            color: #333;
        }
    </style>
</head>
<body>
    <%@ include file="includes/db.jsp" %>
    <%@ include file="includes/create_tables.jsp" %>
    
    <%
        String voterId = session.getAttribute("voter_id") != null ? session.getAttribute("voter_id").toString() : null;
        // get candidate id as integer string
        String candidateId = request.getParameter("candidateId");
        String electionId = request.getParameter("electionId");
        
        if (voterId == null || candidateId == null || electionId == null) {
            out.println("<div class='message-box'><h1 class='error'>Invalid Vote Data</h1><p>Please try again.</p></div>");
            out.println("<script>setTimeout(function() { window.location.href = 'voter_dashboard.jsp'; }, 3000);</script>");
        } else {
            Connection con = (Connection) request.getAttribute("dbCon");
            
                if (con == null) {
                    out.println("<div class='message-box'><h1 class='error'>Database Error</h1><p>Unable to submit your vote.</p></div>");
                } else {
                    try {
                        // Check if voter has already voted in this election
                        String checkVoteSQL = "SELECT rid FROM result WHERE vid = ? AND eid = ?";
                        PreparedStatement psCheck = con.prepareStatement(checkVoteSQL);
                        psCheck.setString(1, voterId);
                        psCheck.setString(2, electionId);
                        ResultSet rsCheck = psCheck.executeQuery();
                    
                        if (rsCheck.next()) {
                            out.println("<div class='message-box'><h1 class='error'>Vote Already Submitted</h1><p>You have already voted in this election.</p></div>");
                            out.println("<script>setTimeout(function() { window.location.href = 'voter_dashboard.jsp'; }, 3000);</script>");
                        } else {
                            // Insert the vote
                            String insertVoteSQL = "INSERT INTO result (cid, vid, eid) VALUES (?, ?, ?)";
                            PreparedStatement psInsert = con.prepareStatement(insertVoteSQL);
                            // store numeric candidate id
                            try {
                                psInsert.setInt(1, Integer.parseInt(candidateId));
                            } catch (NumberFormatException nfe) {
                                psInsert.setString(1, candidateId); // fallback
                            }
                            psInsert.setString(2, voterId);
                            psInsert.setString(3, electionId);
                        
                            int result = psInsert.executeUpdate();
                            psInsert.close();
                        
                            if (result > 0) {
                                out.println("<div class='message-box'><h1 class='success'>✓ Vote Submitted Successfully!</h1><p>Thank you for voting.</p><p>Redirecting to dashboard...</p></div>");
                                out.println("<script>setTimeout(function() { window.location.href = 'voter_dashboard.jsp'; }, 3000);</script>");
                            } else {
                                out.println("<div class='message-box'><h1 class='error'>Vote Submission Failed</h1><p>Please try again.</p></div>");
                                out.println("<script>setTimeout(function() { window.location.href = 'CastVote.jsp'; }, 3000);</script>");
                            }
                        }
                    
                        rsCheck.close();
                        psCheck.close();

                        // Working example: Query result by rid using setInt
                        if (request.getParameter("rid") != null && !request.getParameter("rid").isEmpty()) {
                            try {
                                int ridValue = Integer.parseInt(request.getParameter("rid"));
                                String queryByRid = "SELECT * FROM result WHERE rid = ?";
                                PreparedStatement psRid = con.prepareStatement(queryByRid);
                                psRid.setInt(1, ridValue);
                                ResultSet rsRid = psRid.executeQuery();
                                while (rsRid.next()) {
                                    // Example: print candidate id for this rid
                                    out.println("<div style='color:green;'>Result for rid=" + ridValue + ": cid=" + rsRid.getString("cid") + "</div>");
                                }
                                rsRid.close();
                                psRid.close();
                            } catch (Exception ex) {
                                out.println("<div style='color:red;'>Error querying by rid: " + ex.getMessage() + "</div>");
                            }
                        }

                        // Example: Query result by rid using setInt (for future use)
                        // int ridValue = 1; // Replace with actual rid value
                        // String queryByRid = "SELECT * FROM result WHERE rid = ?";
                        // PreparedStatement psRid = con.prepareStatement(queryByRid);
                        // psRid.setInt(1, ridValue);
                        // ResultSet rsRid = psRid.executeQuery();
                        // while (rsRid.next()) {
                        //     // process result
                        // }
                        // rsRid.close();
                        // psRid.close();
                    
                } catch (Exception e) {
                    out.println("<div class='message-box'><h1 class='error'>Error: " + e.getMessage() + "</h1><p>Please try again.</p></div>");
                    out.println("<script>setTimeout(function() { window.location.href = 'CastVote.jsp'; }, 3000);</script>");
                    e.printStackTrace();
                }
            }
        }
    %>
        <!-- Display Previous Chats from Neon DB -->
        <div class="message-box" style="margin-top:30px;">
            <h2>Previous Chats</h2>
            <table style="width:100%;border-collapse:collapse;">
                <tr style="background:#f1f1f1;"><th>Name</th><th>Email</th><th>Message</th><th>Time</th></tr>
                <%
                Connection con = (Connection) request.getAttribute("dbCon");
                if (con != null) {
                    try {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT name, email, message, created_at FROM contact ORDER BY created_at DESC LIMIT 10");
                        while (rs.next()) {
                            String name = rs.getString("name");
                            String email = rs.getString("email");
                            String message = rs.getString("message");
                            String time = rs.getString("created_at");
                %>
                <tr>
                    <td><%= name %></td>
                    <td><%= email %></td>
                    <td><%= message %></td>
                    <td><%= time %></td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4' style='color:red;'>Error loading chats: " + e.getMessage() + "</td></tr>");
                    }
                } else {
                    out.println("<tr><td colspan='4' style='color:red;'>No DB connection</td></tr>");
                }
                %>
            </table>
        </div>
</body>
</html>
