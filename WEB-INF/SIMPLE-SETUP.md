SIMPLE GUIDE: Connect Supabase to your JSP app (Step-by-Step)

==============================================================================
STEP 1: Create Supabase project and get connection details
==============================================================================

1. Go to https://app.supabase.com (sign up if needed)
2. Click "New Project"
3. Fill in:
   - Project Name: "online-voting" (or any name)
   - Database Password: pick a strong password (remember it!)
   - Region: pick one closest to you
   - Click "Create new project"
4. Wait 2-3 minutes for the project to be created
5. Once ready, click on your project
6. Go to Settings (bottom left gear icon)
7. Click "Database"
8. Look for "Connection String" section
9. You should see something like:
   - Host: abc123.supabase.co
   - Database: postgres
   - User: postgres
   - Password: (the one you created)
   - Port: 5432

COPY THESE VALUES - you'll need them in the next step.

==============================================================================
STEP 2: Put Supabase details in web.xml
==============================================================================

Edit this file:
  c:\Users\ADMIN\Downloads\Online-Voting-System-master\Online-Voting-System-master\WEB-INF\web.xml

Find the lines that say:
  <param-value>jdbc:postgresql://HOST:5432/DBNAME?sslmode=require</param-value>
  <param-value>DB_USER</param-value>
  <param-value>DB_PASSWORD</param-value>

REPLACE them with your Supabase values. Example:

BEFORE:
  <param-value>jdbc:postgresql://HOST:5432/DBNAME?sslmode=require</param-value>
  <param-value>DB_USER</param-value>
  <param-value>DB_PASSWORD</param-value>

AFTER (with real Supabase values):
  <param-value>jdbc:postgresql://abc123.supabase.co:5432/postgres?sslmode=require</param-value>
  <param-value>postgres</param-value>
  <param-value>YourStrongPassword123!</param-value>

That's it! Now your app knows where Supabase is and how to log in.

==============================================================================
STEP 3: Use the connection in your JSPs
==============================================================================

Example: Using Supabase in Login.jsp

At the TOP of Login.jsp (after the <%@ page ... %> lines), add:
  <%@ include file="includes/db.jsp" %>

Then use the database like this:
  <%
    // Include the DB connection
    Connection con = (Connection) request.getAttribute("dbCon");
    
    if (con != null) {
      String user = request.getParameter("user");
      String pass = request.getParameter("pass");
      
      try {
        // Query Supabase database (example table: admin)
        String query = "SELECT * FROM admin WHERE username = ? AND password = ?";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setString(1, user);
        pst.setString(2, pass);
        ResultSet rs = pst.executeQuery();
        
        if (rs.next()) {
          // Login successful
          session.setAttribute("admin", user);
          response.sendRedirect("Admin_dashboard.jsp");
        } else {
          // Login failed
          out.println("Invalid username or password");
        }
        
        rs.close();
        pst.close();
      } catch (Exception e) {
        out.println("Error: " + e.getMessage());
      } finally {
        if (con != null) con.close();
      }
    } else {
      out.println("Database connection failed!");
    }
  %>

==============================================================================
STEP 4: Download JDBC driver and put in WEB-INF/lib
==============================================================================

The JDBC driver is a file that lets Java talk to Postgres.

Download it:
1. Go to: https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.10/
2. Look for file: postgresql-42.7.10.jar
3. Click it to download (about 900KB)

Put it here:
  c:\Users\ADMIN\Downloads\Online-Voting-System-master\Online-Voting-System-master\WEB-INF\lib\

Just copy/paste the jar file into that folder.

==============================================================================
STEP 5: Test it
==============================================================================

1. Make sure Tomcat is running
2. Open http://localhost:8080/Online-Voting-System/
3. Click a login page
4. Try logging in
5. Check Tomcat logs (catalina.out) for errors

If you see errors like "connection refused" or "driver not found":
  - Check the JDBC jar is in WEB-INF/lib
  - Check your Supabase credentials in web.xml are correct
  - Check Supabase project is still running

==============================================================================
COMMON MISTAKES
==============================================================================

1. Wrong hostname
   - WRONG: jdbc:postgresql://localhost:5432/postgres
   - RIGHT: jdbc:postgresql://abc123.supabase.co:5432/postgres

2. Missing ?sslmode=require
   - Supabase requires this! Don't remove it.

3. JDBC jar not in WEB-INF/lib
   - You'll see: "org.postgresql.Driver not found"

4. Wrong username/password in web.xml
   - You'll see: "connection refused" or "authentication failed"

5. Firewall blocking Supabase
   - If you're behind a strict firewall, Supabase port 5432 might be blocked
   - Solution: ask your IT, or use Supabase's HTTP API instead

==============================================================================
THAT'S IT!
==============================================================================

Once you follow these 5 steps, all your JSPs can use `includes/db.jsp` to 
connect to Supabase and run queries.

For help:
- Supabase docs: https://supabase.com/docs
- PostgreSQL docs: https://www.postgresql.org/docs/
