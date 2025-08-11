using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSharp__Task_Session_9
{
    public class SavingAccount : Bank
    {
        public decimal InterestRate { get; set; }

        public SavingAccount(string name, string id, string num, int bal, string add, decimal InterestRate)
            : base(name, id, num, bal, add) 
        {
            this.InterestRate = InterestRate;
        }

        public override decimal CalculateInterest()
        {
            return Balance * InterestRate / 100;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"InterestRate: {InterestRate}%");
            Console.WriteLine("------------------------------\n");
        }
    }
}
