package com.example.korean.Database;

import com.example.korean.Init.Config;

import java.lang.reflect.Field;
import java.math.BigInteger;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class DB {
    public static void main(String[] args) throws SQLException {
        System.out.println(insertGetLastId("insert into provinces(name) values(?)", new String[]{"eragdfgdrtgaegerge"}));
    }

    public static Connection getConnection() {
        /*try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String serverName = Config.config.getProperty("db_server");
            String port = Config.config.getProperty("db_port");
            String databaseName = Config.config.getProperty("db_name");
            String username = Config.config.getProperty("db_username");
            String password = Config.config.getProperty("db_password");
            String url = "jdbc:sqlserver://" + serverName + ":" + port + ";databaseName=" + databaseName + ";trustServerCertificate=true;";
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }*/
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String serverName = "minh.database.windows.net";
            String port = "1433";
            String databaseName = "korean";
            String username = "minh";
            String password = "Matkhaulagivaytroi1";
            String url = "jdbc:sqlserver://" + serverName + ":" + port + ";databaseName=" + databaseName + ";trustServerCertificate=true;";
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean executeUpdate(String sql) {// insert update delete
        Connection connection = getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            int row = preparedStatement.executeUpdate();
            connection.close();
            return row > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean executeUpdate(String sql, String[] fields) {// insert update delete
        Connection connection = getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            for (int i = 0; i < fields.length; i++) {
                preparedStatement.setString(i + 1, fields[i]);
            }
            int row = preparedStatement.executeUpdate();
            connection.close();
            return row > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int insertGetLastId(String sql, String[] fields){
        Connection connection = getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            for (int i = 0; i < fields.length; i++) {
                preparedStatement.setString(i + 1, fields[i]);
            }
            preparedStatement.executeUpdate();
            ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
            if (generatedKeys.next()){
                return (int) generatedKeys.getLong(1);
            } else {
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static ArrayList<MyObject> getData(String sql, String[] fields) {
        Connection connection = getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery();
            ArrayList<MyObject> result = new ArrayList<>();
            List<MyObject> re ;
            while (resultSet.next()) {
                MyObject myObject = new MyObject();
                for (int i = 0; i < fields.length; i++) {
                    Field field = MyObject.class.getDeclaredField(fields[i]);
                    field.setAccessible(true);
                    field.set(myObject, resultSet.getString(fields[i]));
                }
                result.add(myObject);
            }
            connection.close();
            return result;
        } catch (SQLException | NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }

    public static ArrayList<MyObject> getData(String sql, String[] vars, String[] fields) {
        Connection connection = getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            for (int i = 0; i < vars.length; i++) {
                preparedStatement.setString(i + 1, vars[i]);
            }
            ResultSet resultSet = preparedStatement.executeQuery();
            ArrayList<MyObject> result = new ArrayList<>();
            while (resultSet.next()) {
                MyObject myObject = new MyObject();
                for (int i = 0; i < fields.length; i++) {
                    Field field = MyObject.class.getDeclaredField(fields[i]);
                    field.setAccessible(true);
                    field.set(myObject, resultSet.getString(fields[i]));
                }
                result.add(myObject);
            }
            connection.close();
            return result;
        } catch (SQLException | NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }
}
