package com.diary.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConfig {

    private static String env(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String host = env("DB_HOST", "localhost");
        String port = env("DB_PORT", "8889");
        String name = env("DB_NAME", "diary_app_php");
        String user = env("DB_USER", "root");
        String password = env("DB_PASSWORD", "root");

        String url = String.format(
            "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Tokyo&characterEncoding=UTF-8",
            host, port, name
        );

        return DriverManager.getConnection(url, user, password);
    }
}
