using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSharp__Task_Session_9
{
    public class Bank
    {
        private const string BankCode = "BNK001";
        private static int _addAccountNum = 100;
        private readonly DateTime Createdate;
        private int _accountNum;
        private string _fullName;
        private string _nationalID;
        private string _phoneNum;
        private string _address;
        private int _balance;

        public int AccountNumber
        {
            get { return _accountNum; }
        }

        public string FullName
        {
            get { return _fullName; }
            set
            {
                if (string.IsNullOrEmpty(value))
                    Console.WriteLine("Invalid input!");
                else _fullName = value;
            }
        }

        public string NationalID
        {
            get { return _nationalID; }
            set
            {
                if (value.Length == 14)
                    _nationalID = value;
                else
                    Console.WriteLine("Invalid input!");
            }
        }

        public string PhoneNumber
        {
            get { return _phoneNum; }
            set
            {
                if (value.StartsWith("01") && value.Length == 11)
                    _phoneNum = value;
                else
                    Console.WriteLine("Invalid input!");
            }
        }

        public int Balance
        {
            get { return _balance; }
            set
            {
                if (value >= 0)
                    _balance = value;
                else
                    Console.WriteLine("Invalid input!");
            }
        }

        public string Address
        {
            get { return _address; }
            set
            {
                _address = value; 
            }
        }


        public Bank()
        {
            Createdate = DateTime.Now;
            _accountNum = ++_addAccountNum;
            FullName = "Mo Ali";
            NationalID = "29810112345677";
            PhoneNumber = "01090358431";
            Balance = 20000;
            Address = "Manofia, Egypt";
        }

        public Bank(string name, string id, string num, int bal, string add)
        {
            Createdate = DateTime.Now;
            _accountNum = ++_addAccountNum;
            FullName = name;
            NationalID = id;
            PhoneNumber = num;
            Balance = bal;
            Address = add;
        }

        public Bank(string name, string id, string num, string add)
        {
            Createdate = DateTime.Now;
            _accountNum = ++_addAccountNum;
            FullName = name;
            NationalID = id;
            PhoneNumber = num;
            Balance = 0;
            Address = add;
        }


        public void ShowAccountDetails()
        {
            Console.WriteLine($"Bank Code   : {BankCode}");
            Console.WriteLine($"Created     : {Createdate}");
            Console.WriteLine($"Account No. : {AccountNumber}");
            Console.WriteLine($"Name        : {FullName}");
            Console.WriteLine($"National ID : {NationalID}");
            Console.WriteLine($"Phone       : {PhoneNumber}");
            Console.WriteLine($"Address     : {Address}");
            Console.WriteLine($"Balance     : {Balance} $");
            Console.WriteLine("------------------------------\n");
        }

        public bool IsValidNationalID(string id)
        {
            if (id.Length == 14)
                return true;
            else
                return false;
        }

        public bool IsValidPhoneNumber(string ph)
        {
            if (ph.StartsWith("01") && ph.Length == 11)
                return true;
            else
                return false;
        }
    }
}

