package utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.jdbi.v3.core.Jdbi;


public class JdbiConnector {
    public static Jdbi jdbi;
    public static HikariDataSource dataSource;

    public static Jdbi getJdbi() {
        if (jdbi == null) {
            connect();
        }
        return jdbi;
    }
    public static void  connect(){
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://"+ Property.HOST+":"+Property.PORT+"/"+Property.DBNAME+ "?zeroDateTimeBehavior=convertToNull");
        config.setUsername(Property.USERNAME);
        config.setPassword(Property.PASSWORD);

        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);

        config.setConnectionTestQuery("SELECT 1");
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        dataSource = new HikariDataSource(config);
        jdbi = Jdbi.create(dataSource);
    }

}
