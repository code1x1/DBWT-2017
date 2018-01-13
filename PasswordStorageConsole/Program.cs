using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PasswordSecurity;

namespace PasswordStorageConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            
            Console.Write("Create/Verify (1/2) ");
            String auswahl = Console.ReadLine();
            if (auswahl.Contains("1"))
            {
                Console.Write("Geben Sie Ihr gewünschtes Passwort ein: ");
                String passwordPlain = Console.ReadLine();
                String passwordEncrypt = PasswordStorage.CreateHash(passwordPlain);
                Console.WriteLine("Ihr verschlüsseltes Passwort lautet: " + passwordEncrypt);
              
            }
            else if (auswahl.Contains("2"))
            {
                Console.Write("Hash: ");
                string goodhash = Console.ReadLine();
                Console.Write("Passwort: ");
                string password = Console.ReadLine();
                if(PasswordStorage.VerifyPassword(password, goodhash))
                {
                    Console.WriteLine("Passwort ist korrekt.");
                }

            }

            Console.WriteLine("Zum beenden eine Taste drücken.");
            Console.ReadKey();
        }
    }
}
