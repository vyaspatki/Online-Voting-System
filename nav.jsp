<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    .navbar-top {
        background-color: #17a2b8;
        padding: 12px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        width: 100%;
        min-height: 60px;
    }
    
    .navbar-top .brand {
        display: flex;
        align-items: center;
        font-size: 20px;
        font-weight: bold;
        color: white;
        text-decoration: none;
        white-space: nowrap;
        flex-shrink: 0;
    }
    
    .navbar-top .brand svg {
        height: 35px;
        width: 35px;
        margin-right: 10px;
        flex-shrink: 0;
    }
    
    .navbar-top .nav-links {
        display: flex;
        gap: 15px;
        list-style: none;
        margin: 0;
        padding: 0;
        flex-wrap: wrap;
        justify-content: flex-end;
    }
    
    .navbar-top .nav-links li {
        white-space: nowrap;
    }
    
    .navbar-top .nav-links a {
        color: white;
        text-decoration: none;
        padding: 8px 12px;
        font-size: 14px;
        transition: background-color 0.3s ease;
        border-radius: 3px;
        display: inline-block;
    }
    
    .navbar-top .nav-links a:hover {
        background-color: rgba(255,255,255,0.2);
        border-radius: 3px;
    }
    
    @media screen and (max-width: 768px) {
        .navbar-top {
            flex-direction: column;
            gap: 10px;
        }
        .navbar-top .nav-links {
            width: 100%;
            justify-content: center;
        }
    }
</style>

<div class="navbar-top">
    <a href="student_council.jsp" class="brand">
        <svg viewBox="0 0 40 40" fill="white">
            <rect width="40" height="40" rx="5" fill="#17a2b8"/>
            <path d="M20 8C24.4 8 28 11.6 28 16C28 20.4 24.4 24 20 24C15.6 24 12 20.4 12 16C12 11.6 15.6 8 20 8M20 26C23.3 26 26.8 27.5 29 30V32H11V30C13.2 27.5 16.7 26 20 26Z" fill="white"/>
        </svg>
        Online Voting System
    </a>
    <ul class="nav-links">
        <li><a href="student_council.jsp">Home</a></li>
        <li><a href="Voter_Login.jsp">Login</a></li>
        <li><a href="student_council.jsp#register">Register</a></li>
        <li><a href="view_elections.jsp">Elections</a></li>
        <li><a href="candidate_list.jsp">Candidates</a></li>
    </ul>
</div>
