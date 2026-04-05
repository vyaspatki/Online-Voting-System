<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	background-color: #E63946;
	font-family: Arial, sans-serif;
	display: flex;
	min-height: 100vh;
}

.header-top {
	position: absolute;
	top: 20px;
	left: 20px;
	color: #fff;
	font-size: 24px;
	font-weight: bold;
}

.logout-btn {
	position: absolute;
	top: 20px;
	right: 20px;
	background-color: #333;
	color: #fff;
	padding: 10px 20px;
	text-decoration: none;
	border-radius: 5px;
	font-weight: bold;
	cursor: pointer;
}

.logout-btn:hover {
	background-color: #555;
}

.sidebar {
	width: 150px;
	background-color: #333;
	padding: 20px 0;
	display: flex;
	flex-direction: column;
	gap: 0;
	margin-top: 60px;
}

.sidebar a {
	color: #fff;
	padding: 15px 10px;
	margin: 5px 10px;
	background-color: #555;
	text-decoration: none;
	cursor: pointer;
	font-weight: bold;
	border-radius: 3px;
	transition: all 0.3s ease;
	display: block;
	text-align: center;
	font-size: 13px;
	text-transform: uppercase;
}

.sidebar a:hover {
	background-color: #777;
}

.main-content {
	flex: 1;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 100px 40px 40px 40px;
}

.admin-title {
	font-size: 48px;
	color: #fff;
	margin-bottom: 40px;
	text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.vote-box {
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 4px 8px rgba(0,0,0,0.2);
	width: 450px;
	height: 350px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.vote-box svg {
	width: 100%;
	height: 100%;
}
</style>
</head>
<body>
	<div class="header-top">ADMIN DASHBOARD</div>
	<a href="Login.jsp" class="logout-btn">LOGOUT</a>
	
	<div class="sidebar">
		<a href="voter_approve.jsp">VOTER</a>
		<a href="candidate_list.jsp">CANDIDATE</a>
		<a href="view_elections.jsp">ELECTION</a>
		<a href="report.jsp">RESULT</a>
		<a href="report.jsp">REPORT</a>
		<a href="feedback.jsp">FEEDBACK</a>
	</div>

	<div class="main-content">
		<h1 class="admin-title">Administration</h1>
		<div class="vote-box">
			<img src="01j3e5rhzm0cwzen76wxzsbdme.png" alt="Vote Box">
		</div>
	</div>
</body>
</html>
