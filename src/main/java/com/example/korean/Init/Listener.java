package com.example.korean.Init;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Properties;

public class Listener implements ServletContextListener{
    public HashMap<String, Properties> languages = new HashMap<>();
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        Config.path = sce.getServletContext().getRealPath("");
        File folder = new File(sce.getServletContext().getRealPath("") + "WEB-INF/lang/");
        File[] files = null;
        if (folder.exists() && folder.isDirectory()) {
            files = folder.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.isFile()) {
                        try {
                            InputStream inputStream = new FileInputStream(sce.getServletContext().getRealPath("") + "WEB-INF/lang/" + file.getName());
                            InputStreamReader reader = new InputStreamReader(inputStream, StandardCharsets.UTF_16);
                            Properties properties = new Properties();
                            properties.load(reader);
                            this.languages.put(file.getName().split("\\.")[0], properties);
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
            }
        }
        Language.languages = this.languages;
        Properties properties = new Properties();
        try (FileInputStream fis = new FileInputStream(sce.getServletContext().getRealPath("") + "WEB-INF/config.properties")) {
            InputStreamReader reader = new InputStreamReader(fis, StandardCharsets.UTF_16);
            properties.load(reader);
            Config.config = properties;
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
