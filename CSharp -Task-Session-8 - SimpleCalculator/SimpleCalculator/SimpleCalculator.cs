namespace SimpleCalculator
{
    internal class SimpleCalculator
{
        static double GetNum()
        {
            while (true)
            {
                string input = Console.ReadLine();
                if (double.TryParse(input, out double num))
                    return num;
                else
                    Console.WriteLine("Invalid number, please try again:");
            }
        }

        static void Main(string[] args)
        {
        Console.WriteLine("Hello!");
        
        Console.WriteLine("Input the first number:");
        double num1 = GetNum();

        Console.WriteLine("Input the second number:");
        double num2 = GetNum();

        Console.WriteLine("What do you want to do with those numbers?");
        Console.WriteLine("[A]dd");
        Console.WriteLine("[S]ubtract");
        Console.WriteLine("[M]ultiply");

        string choice = Console.ReadLine().Trim().ToLower();

        switch (choice)
        {
            case "a":
                Console.WriteLine($"{num1} + {num2} = {num1 + num2}");
                break;
            case "s":
                Console.WriteLine($"{num1} - {num2} = {num1 - num2}");
                break;
            case "m":
                Console.WriteLine($"{num1} * {num2} = {num1 * num2}");
                break;
            default:
                Console.WriteLine("Invalid option");
                break;
        }

        Console.WriteLine("Press any key to close");
        Console.ReadKey();
    }

    
    }
}
