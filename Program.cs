namespace CSharp__Task_Session_9
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Bank account1 = new Bank();

            Bank account2 = new Bank("Sara Hassan","30005011234569","01234567890", 2500,"Alexandria, Egypt");

            Bank account3 = new Bank( "Youssef Tarek", "30101011234560","01099887766", "Giza, Egypt");

            account1.ShowAccountDetails();
            account2.ShowAccountDetails();
            account3.ShowAccountDetails();
        }
    }
}
