package Database;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Scanner;

public class Run {
    public static void main(String[] args) {
        try {
            String command = "dir";
            ProcessBuilder processBuilder = new ProcessBuilder(command.split("\\s+"));
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
    }
    public static String convertonormal(String input){
String[] morsecodesarr={".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", " ..-", "...-", ".--", "-..-", " -.--", "--.."};
//".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", " ..-", "...-", ".--", "-..-", " -.--", "--.."
//".-", "-.-.", "-..."


//abc
//acb
        String[] alphabet={"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
                "t", "u", "v", "w", "x", "y", "z"};
        String[] splitarr= input.split(" ");//[".-", "-.-.", "-..."]
        int index=0;
        String sentence="";//ab
        /*
        i = 1
        j = 2
        morsecodesarr[i] = -...
        splitarr[j] = -...
        compare : 1
        index = i = 1
        alphabet[index] = b
        * */
        for (int i = 0; i < morsecodesarr.length; i++) {
            for (int j = 0; j < splitarr.length; j++) {
                if (splitarr[j].equals(morsecodesarr[i])) {
                    index=i;
                    sentence+=alphabet[index];
                }
            }
        }
        return sentence;
    }
}
