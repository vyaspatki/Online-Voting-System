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
            // Reset sequence to avoid duplicate key errors
            stmt.execute("SELECT setval('election_id_seq', COALESCE((SELECT MAX(id) FROM election), 0) + 1, false)");
        } catch (Exception e) {
            // Table may already exist
        }
        
        // Create admin table so login can work
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS admin (" +
                "id SERIAL PRIMARY KEY," +
                "username VARCHAR(255)," +
                "password VARCHAR(255)" +
            ")");
            // add a default admin account if table is empty (username/password both 'admin')
            stmt.execute("INSERT INTO admin(username,password) SELECT 'admin','admin' WHERE NOT EXISTS (SELECT 1 FROM admin)");
            // Reset sequence to avoid duplicate key errors
            stmt.execute("SELECT setval('admin_id_seq', COALESCE((SELECT MAX(id) FROM admin), 0) + 1, false)");
        } catch (Exception e) {
            // ignore
        }
        
        // Create candidate table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS candidate (" +
                "id SERIAL PRIMARY KEY," +
                "name VARCHAR(255)," +
                "email VARCHAR(255)," +
                "password VARCHAR(255)," +
                "registration_number VARCHAR(100)," +
                "description TEXT," +
                "is_voter VARCHAR(10)," +
                "eid VARCHAR(100)" +
            ")");
            // Reset sequence to avoid duplicate key errors
            stmt.execute("SELECT setval('candidate_id_seq', COALESCE((SELECT MAX(id) FROM candidate), 0) + 1, false)");
        } catch (Exception e) {
            // Table may already exist
        }
        
        // Create voter table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS voter (" +
                "id SERIAL PRIMARY KEY," +
                "name VARCHAR(255)," +
                "registration_number VARCHAR(100)," +
                "password VARCHAR(255)," +
                "email VARCHAR(255)" +
            ")");
            // Reset sequence to avoid duplicate key errors
            stmt.execute("SELECT setval('voter_id_seq', COALESCE((SELECT MAX(id) FROM voter), 0) + 1, false)");
        } catch (Exception e) {
            // Table may already exist
        }
        
        // Create result table if not exists (ensure rid primary key exists)
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS result (cid INT, vid INT, eid VARCHAR(100))");
            // if old table lacks rid, add it now
            stmt.execute("ALTER TABLE result ADD COLUMN IF NOT EXISTS id SERIAL PRIMARY KEY");
        } catch (Exception e) {
            // Table may already exist or alteration may fail
        }
        
        // Create winner table if not exists
        try {
            stmt.execute("CREATE TABLE IF NOT EXISTS winner (" +
                "id SERIAL PRIMARY KEY," +
                "cid INT," +
                "name VARCHAR(255)," +
                "votes INT" +
            ")");
            // Reset sequence to avoid duplicate key errors
            stmt.execute("SELECT setval('winner_id_seq', COALESCE((SELECT MAX(id) FROM winner), 0) + 1, false)");
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
            // Reset sequence to avoid duplicate key errors
            stmt.execute("SELECT setval('contact_id_seq', COALESCE((SELECT MAX(id) FROM contact), 0) + 1, false)");
        } catch (Exception e) {
            // Table may already exist
        }
        
        stmt.close();
    }
} catch (Exception e) {
    // Silent fail - tables may already exist
}
%>

