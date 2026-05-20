package utils;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import java.sql.SQLException;

public class JdbiConnector {
    public static Jdbi jdbi;
    public static Jdbi getJdbi() {
        if (jdbi == null) {
            connect();
        }
        return jdbi;
    }
    public static void  connect(){
        MysqlDataSource ds = new MysqlDataSource();
        //jdbc:mysql://localhost:3306/ltweb
        ds.setURL("jdbc:mysql://"+ Property.HOST+":"+Property.PORT+"/"+Property.DBNAME+ "?zeroDateTimeBehavior=convertToNull");
        ds.setUser(Property.USERNAME);
        ds.setPassword(Property.PASSWORD);
        try {
            ds.setAutoReconnect(true);
            ds.setUseCompression(true);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        jdbi = Jdbi.create(ds);
    }

}
