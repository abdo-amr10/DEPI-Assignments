using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.PortableExecutable;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    class MCQ_Question : Questions
    {
        public string[]? Answers { get; set; }
        public string? Correct_Answer { get; set; }

        public MCQ_Question(string? header, string? body, int mark, string[]? Answers, string? Correct_Answer) : base(header, body, mark)
        {
            this.Answers = Answers;
            this.Correct_Answer = Correct_Answer;
        }


        public override void Display_Question()
        {
            Console.WriteLine($"{header}: {body} (Mark: {mark})");

            if (Answers != null && Answers.Length > 0)
            {
                for (int i = 0; i < Answers.Length; i++)
                {
                    Console.WriteLine($"{i + 1}. {Answers[i]}");
                }
            }
            else
            {
                Console.WriteLine(" answers not found ");
            }
        }


        public override bool Check_Correct_Answer(string UserAnswer)
        {
            if (int.TryParse(UserAnswer, out int user_Answer) && int.TryParse(Correct_Answer, out int correctAnswer))
            {
                return user_Answer == correctAnswer;
            }
            return false;
        }
        

        public override string GetCorrectAnswer()
        {
            if (Answers != null && Correct_Answer != null)
            {
                if (int.TryParse(Correct_Answer, out int correct_answer_number))
                {
                    if (correct_answer_number >= 1 && correct_answer_number <= Answers.Length)
                    {
                        return Answers[correct_answer_number - 1]; 
                    }
                }
            }

            return "Invalid answer";
        }
        public override int GetAnswersCount()
        {
            return Answers != null ? Answers.Length : 0;
        }

    }
}
