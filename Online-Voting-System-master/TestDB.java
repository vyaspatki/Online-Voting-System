import java.sql.*;
public class TestDB {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection c = DriverManager.getConnection("jdbc:postgresql://db.dequxcboanuyqfhqrjka.supabase.co:5432/postgres?sslmode=require","postgres","6gtH8Ki@@tZr74y");
            System.out.println("Connected successfully");
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
