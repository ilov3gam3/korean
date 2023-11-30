package Database;

import java.util.Scanner;

public class Run {
    public static void main(String[] args) {
        System.out.println(convertonormal(".- -.-. -..."));//acb
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
