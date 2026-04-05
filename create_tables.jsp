<%
// Auto-create missing tables if they don't exist
try {
    Connection con = (Connection) request.getAttribute("dbCon");
    if (con != null) {
        Statement stmt = con.createStatement();
        
        // Create election table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS election (" +
                "id SERIAL PRIMARY KEY," +
                "name VARCHAR(255)," +
                "date VARCHAR(20)," +
                "eid VARCHAR(100)" +
            ")");
        } catch (Exception e) {
            // Table may already exist
        }
        
        // Create result table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS result (" +
                "id SERIAL PRIMARY KEY," +
                "vote VARCHAR(255)," +
                "cid INT" +
            ")");
        } catch (Exception e) {
            // Table may already exist
        }
        
        // Create winner table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS winner (" +
                "id SERIAL PRIMARY KEY," +
                "cid INT," +
                "name VARCHAR(255)," +
                "votes INT" +
            ")");
        } catch (Exception e) {
            // Table may already exist
        }
        
        // Create contact/feedback table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS contact (" +
                "id SERIAL PRIMARY KEY," +
                "name VARCHAR(255)," +
                "email VARCHAR(255)," +
                "message TEXT" +
            ")");
        } catch (Exception e) {
            // Table may already exist
        }
        
        stmt.close();
    }
} catch (Exception e) {
    // Silent fail - tables may already exist
}
%>
