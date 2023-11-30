package Database;

import Init.Config;

import java.lang.reflect.Field;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class DB {
    public static void main(String[] args) {// -10, -19, -28
        for (int i = 0; i < 10 && i >= 0; i++) {
            i += 1000;
            System.out.println(i);
            i -= 1000;
        }
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
        /*try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String serverName = "192.168.110.2";
            String port = "1433";
            String databaseName = "korean";
            String username = "minh";
            String password = "Minh1234";
            String url = "jdbc:sqlserver://" + serverName + ":" + port + ";databaseName=" + databaseName + ";trustServerCertificate=true;";
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException(e);
        }*/
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

    public static boolean dropAllTables(){
        String sql = "USE korean; -- Replace YourDatabaseName with your actual database name\n" +
                "\n" +
                "DECLARE @tableName NVARCHAR(255)\n" +
                "DECLARE @constraintName NVARCHAR(255)\n" +
                "DECLARE @sql NVARCHAR(MAX)\n" +
                "\n" +
                "-- Disable foreign key constraints\n" +
                "EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'\n" +
                "\n" +
                "-- Drop foreign keys\n" +
                "DECLARE foreignKeyCursor CURSOR FOR\n" +
                "    SELECT \n" +
                "        fk.name AS ForeignKeyName,\n" +
                "        tp.name AS TableName\n" +
                "    FROM \n" +
                "        sys.foreign_keys AS fk\n" +
                "    INNER JOIN \n" +
                "        sys.tables AS tp ON fk.parent_object_id = tp.object_id\n" +
                "\n" +
                "OPEN foreignKeyCursor\n" +
                "FETCH NEXT FROM foreignKeyCursor INTO @constraintName, @tableName\n" +
                "\n" +
                "WHILE @@FETCH_STATUS = 0\n" +
                "BEGIN\n" +
                "    SET @sql = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT ' + @constraintName\n" +
                "    EXEC sp_executesql @sql\n" +
                "\n" +
                "    FETCH NEXT FROM foreignKeyCursor INTO @constraintName, @tableName\n" +
                "END\n" +
                "\n" +
                "CLOSE foreignKeyCursor\n" +
                "DEALLOCATE foreignKeyCursor\n" +
                "\n" +
                "-- Drop tables\n" +
                "DECLARE tableCursor CURSOR FOR\n" +
                "    SELECT \n" +
                "        name AS TableName\n" +
                "    FROM \n" +
                "        sys.tables\n" +
                "\n" +
                "OPEN tableCursor\n" +
                "FETCH NEXT FROM tableCursor INTO @tableName\n" +
                "\n" +
                "WHILE @@FETCH_STATUS = 0\n" +
                "BEGIN\n" +
                "    SET @sql = 'DROP TABLE ' + @tableName\n" +
                "    EXEC sp_executesql @sql\n" +
                "\n" +
                "    FETCH NEXT FROM tableCursor INTO @tableName\n" +
                "END\n" +
                "\n" +
                "CLOSE tableCursor\n" +
                "DEALLOCATE tableCursor\n";
//        String[] vars = new String[]{Config.config.getProperty("db_name")};
//        return executeUpdate(sql, vars);
        return executeUpdate(sql);
    }
}
