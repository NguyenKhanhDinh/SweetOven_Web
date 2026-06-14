package utils;

public class Property {
    public final static String HOST = System.getenv("MYSQLHOST");
    public final static String PORT = System.getenv("MYSQLPORT");
    public final static String DBNAME = System.getenv("MYSQLDATABASE");
    public final static String USERNAME = System.getenv("MYSQLUSER");
    public final static String PASSWORD = System.getenv("MYSQLPASSWORD");
}
