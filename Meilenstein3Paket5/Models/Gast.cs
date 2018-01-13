using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Configuration;
using PasswordSecurity;

namespace Meilenstein3Paket5.Models
{
    public class Gast : FE_Nutzer
    {
        [DisplayName("Grund")]
        public String grund { get; set; }
        [ScaffoldColumn(false)]
        public DateTime ablauf { get; set; }

        private Dictionary<String,String> passwordHash()
        {
            string pwhash = PasswordStorage.CreateHash(this.password);
            string[] pwhashexplode = pwhash.Split(':');
            Dictionary<String, String> pwdictionary = new Dictionary<String, String>();
            pwdictionary.Add("type", pwhashexplode[0]);
            pwdictionary.Add("iteration", pwhashexplode[1]);
            pwdictionary.Add("length", pwhashexplode[2]);
            pwdictionary.Add("salt", pwhashexplode[3]);
            pwdictionary.Add("hash", pwhashexplode[4]);
            return pwdictionary;
        }

        internal void insertDB()
        {
            MySqlConnection con = null;
            MySqlTransaction trans = null;
            Dictionary<String, String> pwdictionary = passwordHash();


            try { 
            con = new MySqlConnection(
                ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);

            con.Open();
            trans = con.BeginTransaction();
            MySqlCommand cmd = con.CreateCommand();
            cmd.CommandText = @"insert into 
                    `fe-nutzer`(Loginname,Aktiv,Vorname,Nachname,Email,Algorithmus,Stretch,Salt,Hash) 
                    values(@login,@aktiv,@vorname,@nachname,@email,@algorithmus,@stretch,@salt,@hash)";
            cmd.Parameters.AddWithValue("login", this.loginname);
            cmd.Parameters.AddWithValue("aktiv", false);
            cmd.Parameters.AddWithValue("vorname", this.vorname);
            cmd.Parameters.AddWithValue("nachname", this.nachname);
            cmd.Parameters.AddWithValue("email", this.email);
            cmd.Parameters.AddWithValue("algorithmus", pwdictionary["type"]);
            cmd.Parameters.AddWithValue("stretch", pwdictionary["iteration"]);
            cmd.Parameters.AddWithValue("salt", pwdictionary["salt"]);
            cmd.Parameters.AddWithValue("hash", pwdictionary["hash"]);
            // jetzt an die DB schicken!
            cmd.ExecuteNonQuery();

            cmd.CommandText = @"insert into 
                gast(NutzerFk,Grund) 
                values(@nutzerfk,@grund)";
            cmd.Parameters.AddWithValue("nutzerfk", cmd.LastInsertedId);
            cmd.Parameters.AddWithValue("grund", this.grund);
           
            // jetzt an die DB schicken!
            cmd.ExecuteNonQuery();


            trans.Commit();

            } catch (MySqlException ex) 
            {
                try 
                {
                    trans.Rollback();                

                } catch (MySqlException ex1) 
                {
                    Console.WriteLine("Error: {0}",  ex1.ToString());                
                }

                Console.WriteLine("Error: {0}",  ex.ToString());

            } finally 
            {
               if (con != null)
               {
                        con.Close();
               }
            }


        }
    }
}