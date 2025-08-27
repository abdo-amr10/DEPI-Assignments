using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    class Practical_Exam : Base_Exam
    {
        public Practical_Exam(int Time, int NumberOfQuestions) : base(Time, NumberOfQuestions)
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

                string userAnswer;
                int user_answer_id;

                while (true)
                {
                    Console.Write("Your Answer: ");
                    userAnswer = Console.ReadLine();

                    bool valid = int.TryParse(userAnswer, out user_answer_id);

                    if ((!string.IsNullOrEmpty(userAnswer)) && valid && user_answer_id >= 1 && user_answer_id <= question.GetAnswersCount()) break;
                    Console.WriteLine("Invalid input, Please enter a valid answer.");
                }

                bool answer_is_correct = question.Check_Correct_Answer(userAnswer);
                if (answer_is_correct)
                {
                    totalMarks += question.mark;
                }

                Console.Clear();
         
            }

            DateTime endTime = DateTime.Now;
            TimeSpan duration = endTime - startTime;

            Console.WriteLine("\n------------------------------------");
            Console.WriteLine($"Time Taken: {duration.Minutes} minutes and {duration.Seconds} seconds");
        }


    }
}

