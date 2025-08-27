using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    abstract class Base_Exam
    {
        public int time { get; set; }
        public int numOFquestions { get; set; }
        public Questions []? Questions { get; set; }

        public Base_Exam(int time , int numOFquestions) 
        {
            this.time = time;
            this.numOFquestions = numOFquestions;
            Questions = new Questions[numOFquestions];
        }

        public abstract void Show_Exam_Info();

    }
}
