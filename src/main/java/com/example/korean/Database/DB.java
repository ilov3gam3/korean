package com.example.korean.Database;

import com.example.korean.Init.Config;

import java.lang.reflect.Field;
import java.math.BigInteger;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class DB {
    static String slurpStdin() {
        String input = "";
        Scanner scan = new Scanner(System.in);

        while (true) {
            input += scan.nextLine();
            if (scan.hasNextLine()) {
                input += "\n";
            } else {
                break;
            }
        }

        return input;
    }


    public static void main(String[] args) throws SQLException {
        String input = slurpStdin();
        BigInteger N = new BigInteger(input.split(" ")[0]);
        BigInteger A = new BigInteger(input.split(" ")[1]);
        BigInteger B = new BigInteger(input.split(" ")[2]);
        BigInteger count = new BigInteger("0");
        BigInteger count_blue = new BigInteger("0");
        for (float i = 0; i < Math.pow(10, 10); i++) {
            count = count.add(A);
            if (count.compareTo(N)>=0){
                count_blue = count_blue.add(A.subtract(count.subtract(N)));
                break;
            } else {
                count_blue = count_blue.add(A);
            }
            count = count.add(B);
            if (count.compareTo(N)>=0){
                break;
            }
        }
        System.out.println(count_blue);
    }

    public static Connection getConnection() {
        try {
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
