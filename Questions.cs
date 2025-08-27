using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.PortableExecutable;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    abstract class Questions
    {
        public string? header { get; set; }
        public string? body { get; set; }
        public int mark { get; set; }
        public int RightAnswer { get; set; }

        public Questions(string? header, string? body, int mark)
        {
            this.header = header;
            this.body = body;
            this.mark = mark;
        }

        public abstract void Display_Question();
        public abstract bool Check_Correct_Answer(string UserAnswer);
        public abstract string GetCorrectAnswer();
        public abstract int GetAnswersCount();


    }
}