using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    class Subject
    {
        public string? name { get; set; }
        public int id { get; set; }
        public Base_Exam? Base_Exam { get; set; }

        public Subject(string? name, int id)
        {
            this.name = name;
            this.id = id;
        }

        public void CreateExam(Base_Exam exam)
        {
            Base_Exam = exam;

        }
    }
}
