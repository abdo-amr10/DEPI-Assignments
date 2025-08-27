using System;

namespace OOP_Exam
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Subject subject = new Subject("C#", 10);

            Console.WriteLine("");

            Console.WriteLine("OOP C# Exam - Route Academy!  :( ");

            Console.WriteLine("");
            int exam_time;
            while (true)
            {
               
                Console.Write("Enter Exam Time in minutes: ");
                if (int.TryParse(Console.ReadLine(), out exam_time)) break;
                Console.WriteLine("Invalid input, Please enter a valid number");
            }

            int num_of_questions;
            while (true)
            {
                Console.Write("Enter Number of Questions: ");
                if (int.TryParse(Console.ReadLine(), out num_of_questions) && num_of_questions > 0) break;
                Console.WriteLine("Invalid input, Please enter a valid number");
            }

            int exam_type;
            while (true)
            {
                Console.Write("Enter Exam Type (1 for Final, 2 for Practical): ");
                if (int.TryParse(Console.ReadLine(), out exam_type) && (exam_type == 1 || exam_type == 2)) break;
                Console.WriteLine("Invalid input, Please enter 1 or 2");
            }


            Base_Exam exam;

            if (exam_type == 1)
            {
                exam = new Final_Exam(exam_time, num_of_questions);
            }
            else
            {
                exam = new Practical_Exam(exam_time, num_of_questions);
            }


            Questions[] questions = new Questions[num_of_questions];

            for (int i = 0; i < num_of_questions; i++)
            {
                Console.Clear();
                Console.WriteLine($"\nEnter details for Question {i + 1}:");

                string header, body;
                int mark;

                Console.Write("Enter Question Header: ");
                while (true)
                {
                    header = Console.ReadLine();
                    if (!string.IsNullOrWhiteSpace(header)) break;
                    Console.Write("Header can't be empty, Try again: ");
                }

                
                Console.Write("Enter Question Body: ");
                while (true)
                {
                    body = Console.ReadLine();
                    if (!string.IsNullOrWhiteSpace(body)) break;
                    Console.Write("Body can't be empty, Try again: ");
                }


                while (true)
                {
                    Console.Write("Enter Question Mark: ");
                    if (int.TryParse(Console.ReadLine(), out mark) && mark > 0) break;
                    Console.WriteLine("Invalid input, Please enter a positive number");
                }

                if (exam_type == 2)
                {
                    int numChoices;
                    while (true)
                    {
                        Console.Write("Enter Number of Choices: ");
                        if (int.TryParse(Console.ReadLine(), out numChoices) && numChoices > 1) break;
                        Console.WriteLine("Invalid input, Please enter a number greater than 1");
                    }

                    string[] choices = new string[numChoices];
                    for (int j = 0; j < numChoices; j++)
                    {
                        string choice;
                        Console.Write($"Enter Choice number {j + 1}: ");
                        while (true)
                        {
                            choice = Console.ReadLine();
                            if (!string.IsNullOrWhiteSpace(choice)) break;
                            Console.WriteLine("invalid choice, Please enter a valid choice ");
                        }

                        choices[j] = choice;
                    }

                    int correctAnswer;
                    while (true)
                    {
                        Console.Write("Enter the true choice number : ");
                        string userInput = Console.ReadLine();

                        if (string.IsNullOrWhiteSpace(userInput))
                        {
                            Console.WriteLine("Answer cannot be empty, Please enter a valid choice number");
                            continue;  
                        }

                        if (int.TryParse(userInput, out correctAnswer) && correctAnswer >= 1 && correctAnswer <= numChoices)
                        {
                            break;  
                        }
                        Console.WriteLine("Invalid input, Please enter a valid choice number");
                    }

                    questions[i] = new MCQ_Question(header, body, mark, choices, correctAnswer.ToString());
                }
                else
                {
                    int questionType;
                    while (true)
                    {
                        Console.Write("Enter Question Type (1 for MCQ, 2 for True or False): ");
                        if (int.TryParse(Console.ReadLine(), out questionType) && (questionType == 1 || questionType == 2)) break;
                        Console.WriteLine("Invalid input, Please enter 1 or 2");
                    }

                    if (questionType == 1)
                    {
                        int numChoices;
                        while (true)
                        {
                            Console.Write("Enter Number of Choices: ");
                            if (int.TryParse(Console.ReadLine(), out numChoices) && numChoices > 1) break;
                            Console.WriteLine("Invalid input, Please enter a number greater than 1");
                        }

                        string[] choices = new string[numChoices];
                        for (int j = 0; j < numChoices; j++)
                        {
                            string choice ;
                            Console.Write($"Enter Choice number {j + 1}: ");
                            while (true)
                            {
                                choice = Console.ReadLine();
                                if (!string.IsNullOrWhiteSpace(choice)) break;
                                Console.WriteLine("invalid choice, Please enter a valid choice ");
                            }

                            choices[j] = choice;
                        }

                        int correctAnswer;
                        while (true)
                        {
                            Console.Write("Enter the true choice number : ");
                            string userInput = Console.ReadLine();

                            if (string.IsNullOrWhiteSpace(userInput))
                            {
                                Console.WriteLine("Answer cannot be empty, Please enter a valid choice number");
                                continue;
                            }

                            if (int.TryParse(userInput, out correctAnswer) && correctAnswer >= 1 && correctAnswer <= numChoices)
                            {
                                break;
                            }
                            Console.WriteLine("Invalid input, Please enter a valid choice number");
                        }

                        questions[i] = new MCQ_Question(header, body, mark, choices, correctAnswer.ToString());
                    }
                    else
                    {
                        bool correctAnswer;
                        while (true)
                        {
                            Console.Write("Enter Correct Answer (1 for True, 2 for False): ");
                            string input = Console.ReadLine();
                            if (input == "1") { correctAnswer = true; break; }
                            if (input == "2") { correctAnswer = false; break; }
                            Console.WriteLine("Invalid input, Please enter 1 or 2");
                        }

                        questions[i] = new True_False_Question(header, body, mark, correctAnswer);
                    }
                }
            }

            exam.Questions = questions;
            subject.CreateExam(exam);
            Console.Clear();
            exam.Show_Exam_Info();

            Console.WriteLine("\nExam info :");
            foreach (var question in exam.Questions)
            {
                Console.WriteLine($"{question.header}: {question.body}");
                Console.WriteLine($"Correct Answer: {question.GetCorrectAnswer()}");
                Console.WriteLine($"Mark: {question.mark}");
                Console.WriteLine("------------------------------------");
            }
        }
    }
}
