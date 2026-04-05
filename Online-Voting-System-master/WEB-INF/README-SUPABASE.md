Connect this JSP app to Supabase (Postgres)

1. Create a Supabase project
   - Go to https://app.supabase.com, create a project and database.
   - In Project Settings -> Database -> Connection string find host, dbname, user and password.

2. Add Postgres JDBC driver
   - Download the JDBC jar (example: postgresql-42.7.10.jar) from Maven Central:
     https://repo1.maven.org/maven2/org/postgresql/postgresql/
   - Put the jar in this project's WEB-INF/lib or in your Tomcat lib:
     c:\Users\ADMIN\Downloads\Online-Voting-System-master\Online-Voting-System-master\WEB-INF\lib\

3. Configure DB credentials
   - Edit `WEB-INF/web.xml` and replace placeholders with your Supabase values:
     - `DB_URL` should be: `jdbc:postgresql://<HOST>:5432/<DBNAME>?sslmode=require`
     - `DB_USER` the DB user
     - `DB_PASS` the DB password
   - Alternatively set these context params in Tomcat `context.xml` or as environment variables and reference them (recommended for production).

4. Use `includes/db.jsp` in your JSPs
   - Add at top of a JSP (where you need DB access):
     <%@ include file="includes/db.jsp" %>
   - Then get connection:
     <%
       Connection con = (Connection) request.getAttribute("dbCon");
       // run queries
       if (con != null) con.close();
     %>

5. Test
   - Deploy the webapp to Tomcat and restart Tomcat so it picks up the JDBC jar and context params.
   - Open pages that use the DB and check Tomcat logs for connection messages.

Notes
- Use `?sslmode=require` in the JDBC URL because Supabase requires SSL.
- For production, avoid hard-coding passwords in `web.xml`; use Tomcat `context.xml` or environment variables.
- If you prefer connection pooling, configure a DataSource in Tomcat and use JNDI lookup in your JSPs/servlets instead of direct DriverManager connections.
