Where to put the Postgres JDBC driver (postgresql-<ver>.jar)

Options

1) Per-app (recommended for this project)
   - Path: <project-root>/WEB-INF/lib/
   - For your workspace that is:
     c:\Users\ADMIN\Downloads\Online-Voting-System-master\Online-Voting-System-master\WEB-INF\lib
   - Drop the JDBC jar here (e.g. postgresql-42.7.10.jar). It becomes available only to this webapp.

2) Server-wide (all apps)
   - Path: TOMCAT_HOME/lib
   - Example on Windows if Tomcat is installed at C:\apache-tomcat-9:
     C:\apache-tomcat-9\lib
   - Drop the JDBC jar there if you want all webapps to share it.

Download the JDBC jar

- Maven Central (recommended): https://repo1.maven.org/maven2/org/postgresql/postgresql/
  Pick a stable version (e.g. 42.7.10) and download the `postgresql-<ver>.jar` file.

Copy example (PowerShell)

# Copy into this project's WEB-INF/lib
Copy-Item -Path "C:\path\to\downloads\postgresql-42.7.10.jar" -Destination "c:\Users\ADMIN\Downloads\Online-Voting-System-master\Online-Voting-System-master\WEB-INF\lib\"

# Or copy into Tomcat lib (requires Tomcat path)
Copy-Item -Path "C:\path\to\downloads\postgresql-42.7.10.jar" -Destination "C:\apache-tomcat-9\lib\"

After copying

- Restart Tomcat (if running) so it loads the new jar.
- Verify by starting your app and checking logs for successful DB driver loading.

Notes

- Per-app (`WEB-INF/lib`) is safer for development and avoids changing the server installation.
- If you later build a WAR via a build tool (Maven), ensure the driver is included in `WEB-INF/lib` or provided by the server.
- For Supabase use `jdbc:postgresql://<HOST>:5432/<DBNAME>?sslmode=require` and the `org.postgresql.Driver` class.
