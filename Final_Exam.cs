using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    class Final_Exam : Base_Exam
    {
        public Final_Exam(int Time, int NumberOfQuestions) : base(Time, NumberOfQuestions)
        {

        }
        public override void Show_Exam_Info()
        {
            int totalMarks = 0;
            DateTime startTime = DateTime.Now;
            

            for (int i = 0; i < Questions.Length; i++)
            {
                var question = Questions[i];
                question.Display_Question();  

                Console.Write("Your Answer: ");
                string userAnswer = Console.ReadLine();

                while (string.IsNullOrWhiteSpace(userAnswer) || !int.TryParse(userAnswer, out int user_answer_after) || user_answer_after < 1 || user_answer_after > question.GetAnswersCount())
                {
                    Console.WriteLine("Invalid input, Please enter a valid choice number.");
                    Console.Write("Your Answer: ");
                    userAnswer = Console.ReadLine();
                }

                Console.Clear();  

                if (question.Check_Correct_Answer(userAnswer))
                {
                    totalMarks += question.mark;
                }
            }


            DateTime endTime = DateTime.Now;
            TimeSpan duration = endTime - startTime;

            Console.WriteLine("\n------------------------------------");
            Console.WriteLine($"Time Taken: {duration.Minutes} minutes and {duration.Seconds} seconds");
            Console.WriteLine($"Total Marks: {totalMarks}");
        }


    }

}

