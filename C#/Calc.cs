// Calc.cs - compile: dotnet run / csc Calc.cs
using System;
using System.Globalization;

class Calc
{
    static void Main()
    {
        Console.WriteLine("Enter: a op b  (op = + - * /, q to quit)");
        while (true)
        {
            Console.Write("> ");
            string line = Console.ReadLine() ?? string.Empty;
            if (line == null) break;
            line = line.Trim();
            if (line.Length == 0) continue;
            if (line.Equals("q", StringComparison.OrdinalIgnoreCase)) break;

            string[] parts = line.Split(' ', StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length != 3)
            {
                Console.WriteLine("Error: invalid input format.");
                continue;
            }

            if (!double.TryParse(parts[0], NumberStyles.Float, CultureInfo.InvariantCulture, out double a) ||
                !double.TryParse(parts[2], NumberStyles.Float, CultureInfo.InvariantCulture, out double b))
            {
                Console.WriteLine("Error: invalid number.");
                continue;
            }

            double r;
            switch (parts[1])
            {
                case "+": r = a + b; break;
                case "-": r = a - b; break;
                case "*": r = a * b; break;
                case "/":
                    if (b == 0.0) { Console.WriteLine("Error: division by zero."); continue; }
                    r = a / b; break;
                default:
                    Console.WriteLine($"Error: unknown operator '{parts[1]}'.");
                    continue;
            }
            Console.WriteLine($"= {r.ToString("G10", CultureInfo.InvariantCulture)}");
        }
    }
}