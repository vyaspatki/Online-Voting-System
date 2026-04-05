<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date, java.text.*, java.sql.*"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cast Your Vote</title>
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
        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #fff;
        }
        h2 {
            color: #fff;
            margin-top: 30px;
        }
        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .candidate-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            border: 3px solid #069494;
            transition: all 0.3s;
        }
        .candidate-card:hover {
            background: #f0f0f0;
            transform: scale(1.05);
        }
        .candidate-card.selected {
            background: #069494;
            color: #fff;
            border-color: #fff;
        }
        .candidate-card input[type="radio"] {
            margin: 10px 0;
        }
        .candidate-name {
            font-size: 18px;
            font-weight: bold;
            margin: 10px 0;
        }
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        button {
            background: #069494;
            color: #fff;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin: 0 10px;
        }
        button:hover {
            background: #047070;
        }
        .info-box {
            background: #fff;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: center;
        }
        .error {
            background: #ff6b6b;
            color: #fff;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <%@ include file="includes/nav.jsp" %>
    <%@ include file="includes/db.jsp" %>
    <%@ include file="includes/create_tables.jsp" %>
    
    <div class="container">
        <h1>Cast Your Vote</h1>
        
        <%
            String voterId = session.getAttribute("voter_id") != null ? session.getAttribute("voter_id").toString() : null;
            
            if (voterId == null) {
                out.println("<div class='error'>Error: Please login first!</div>");
                out.println("<script>setTimeout(function() { window.location.href = 'Voter_Login.jsp'; }, 2000);</script>");
            } else {
                Connection con = (Connection) request.getAttribute("dbCon");
                
                if (con == null) {
                    out.println("<div class='error'>Database connection error</div>");
                } else {
                    try {
                        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                        String todayDate = df.format(new Date());
                        
                        String electionQuery = "SELECT eid, name FROM election WHERE date = ?";
                        PreparedStatement psElection = con.prepareStatement(electionQuery);
                        psElection.setString(1, todayDate);
                        ResultSet rsElection = psElection.executeQuery();
                        
                        if (!rsElection.next()) {
                            out.println("<div class='error'>No election scheduled for today</div>");
                            out.println("<script>setTimeout(function() { window.location.href = 'voter_dashboard.jsp'; }, 3000);</script>");
                        } else {
                            String electionId = rsElection.getString("eid");
                            String electionName = rsElection.getString("name");
                            
                            out.println("<div class='info-box'><strong>Election:</strong> " + electionName + "</div>");
                            
                            // Get all candidates (simplified - show all candidates)
                            String candidateQuery = "SELECT id, name FROM candidate ORDER BY id DESC LIMIT 10";
                            PreparedStatement psCandidate = con.prepareStatement(candidateQuery);
                            ResultSet rsCandidate = psCandidate.executeQuery();
                            
                            out.println("<h2>Select a Candidate:</h2>");
                            out.println("<form method='POST' action='submit_vote.jsp'>");
                            out.println("<input type='hidden' name='electionId' value='" + electionId + "'>");
                            out.println("<div class='candidates-grid'>");
                            
                            int candidateCount = 0;
                            while (rsCandidate.next()) {
                                candidateCount++;
                                // use numeric primary key instead of registration number
                                String candidateId = String.valueOf(rsCandidate.getInt("id"));
                                String candidateName = rsCandidate.getString("name");
                                
                                out.println("<div class='candidate-card'>");
                                out.println("<input type='radio' name='candidateId' value='" + candidateId + "' id='cand_" + candidateId + "' required>");
                                out.println("<label for='cand_" + candidateId + "'>");
                                out.println("<div class='candidate-name'>" + candidateName + "</div>");
                                out.println("</label>");
                                out.println("</div>");
                            }
                            
                            out.println("</div>");
                            
                            if (candidateCount == 0) {
                                out.println("<div class='error'>No candidates available for this election. Please check back later.</div>");
                            } else {
                                out.println("<div class='info-box'>Total Candidates: " + candidateCount + "</div>");
                                out.println("<div class='button-group'>");
                                out.println("<button type='submit'>Submit Vote</button>");
                                out.println("<button type='reset'>Clear Selection</button>");
                                out.println("</div>");
                            }
                            
                            out.println("</form>");
                            
                            rsCandidate.close();
                            psCandidate.close();
                        }
                        
                        rsElection.close();
                        psElection.close();
                        
                    } catch (Exception e) {
                        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    }
                }
            }
        %>
    </div>
    
    <script>
        document.querySelectorAll('.candidate-card').forEach(card => {
            card.addEventListener('click', function() {
                document.querySelectorAll('.candidate-card').forEach(c => c.classList.remove('selected'));
                this.classList.add('selected');
                this.querySelector('input[type="radio"]').checked = true;
            });
        });
    </script>
</body>
</html>
