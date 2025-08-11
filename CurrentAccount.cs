using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSharp__Task_Session_9
{
    public class CurrentAccount : Bank
    {
        public decimal OverdraftLimit { get; set; }

        public CurrentAccount(string name, string id, string num, int bal, string add, decimal OverdraftLimit)
            : base(name, id, num, bal, add) 
        {
            this.OverdraftLimit = OverdraftLimit;
        }

        public override decimal CalculateInterest()
        {
            return 0;
        }

        public override void ShowAccountDetails()
        {
            base.ShowAccountDetails();
            Console.WriteLine($"Overdraft Limit: {OverdraftLimit} $");
            Console.WriteLine("------------------------------\n");
        }
    }
}
