using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.PortableExecutable;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    class True_False_Question : Questions
    {
        public bool The_Correct_Answer { get; set; }

        public True_False_Question(string? header, string? body, int mark, bool The_Correct_Answer)
        : base(header, body, mark)
        {
            this.The_Correct_Answer = The_Correct_Answer;
        }

        public override void Display_Question()
        {
            Console.WriteLine($"{header}: {body} (Mark: {mark})");
            Console.WriteLine("1. True");
            Console.WriteLine("2. False");
        }
        public override bool Check_Correct_Answer(string UserAnswer)
        {
            if (int.TryParse(UserAnswer, out int user_Answer))
            {
                return (user_Answer == 1 && The_Correct_Answer) || (user_Answer == 2 && !The_Correct_Answer);
            }
            return false;
        }


        public override string GetCorrectAnswer()
        {
            return The_Correct_Answer ? "True" : "False"; 
        }


        public override int GetAnswersCount() // ملهاش لزمه بس علشان عملتها ف الكلاس التانى لازم تتحط هنا
        {
            return 2;
        }
    }
}
