// Calc.java - compile: javac Calc.java && java Calc
import java.io.*;
import java.util.*;

public class Calc {
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)), true);
        out.println("Enter: a op b  (op = + - * /, q to quit)");
        while (true) {
            out.print("> ");
            out.flush();
            String line = in.readLine();
            if (line == null) break;
            line = line.trim();
            if (line.isEmpty()) continue;
            if (line.equalsIgnoreCase("q")) break;

            String[] parts = line.split("\\s+");
            if (parts.length != 3) { out.println("Error: invalid input format."); continue; }

            double a, b;
            try { a = Double.parseDouble(parts[0]); }
            catch (NumberFormatException e) { out.println("Error: invalid number."); continue; }
            try { b = Double.parseDouble(parts[2]); }
            catch (NumberFormatException e) { out.println("Error: invalid number."); continue; }

            double r;
            switch (parts[1]) {
                case "+": r = a + b; break;
                case "-": r = a - b; break;
                case "*": r = a * b; break;
                case "/":
                    if (b == 0.0) { out.println("Error: division by zero."); continue; }
                    r = a / b; break;
                default:
                    out.println("Error: unknown operator '" + parts[1] + "'."); continue;
            }
            out.println("= " + r);
        }
    }
}