using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OOP_Exam
{
    class Answers
    {
            public int id { get; set; }
            public string? text { get; set; }

            public Answers(int id, string? text)
            {
                this.id = id;
                this.text = text;
            }

            public override string ToString()
            {
                return $"{id}: {text}";
            }

    }

}

