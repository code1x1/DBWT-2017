using MySql.Data.MySqlClient;
using PasswordSecurity;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Linq;
using System.Web;

namespace Meilenstein3Paket5.Models
{
    public class Mitarbeiter : FE_Nutzer
    {
        [DisplayName("Mitarbeiternummer")]
        [Required(ErrorMessage = "Bitte geben Sie eine Mitarbeiternummer an.")]
        [StringLength(11, ErrorMessage = "Mitarbeiternummer muss 5-11 Zeichen lang sein.", MinimumLength = 5)]
        public int manummer { get; set; }
        [DisplayName("Telefon")]
        [StringLength(40, ErrorMessage = "Telefon muss 1-40 Zeichen lang sein.", MinimumLength = 1)]
        public string telefon { get; set; }
        [DisplayName("Büro")]
        [StringLength(10, ErrorMessage = "Büro muss 1-10 Zeichen lang sein.", MinimumLength = 1)]
        public string buro { get; set; }

        private Dictionary<String, String> passwordHash()
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


            try
            {
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
                cmd.ExecuteNonQuery();

                cmd.CommandText = @"insert into 
                `fh-angehöriger`(FeNutzerFhAngeFk) 
                values(@FeNutzerFhAngeFk)";
                cmd.Parameters.AddWithValue("FeNutzerFhAngeFk", cmd.LastInsertedId);
                cmd.ExecuteNonQuery();

                cmd.CommandText = @"insert into 
                `mitarbeiter`(NutzerFk,MA-Nummer,Telefon-Nummer,Büro) 
                values(@NutzerFk,@mnummer,@telefon,@buro)";
                cmd.Parameters.AddWithValue("NutzerFk", cmd.LastInsertedId);
                cmd.Parameters.AddWithValue("mnummer", this.manummer);
                cmd.Parameters.AddWithValue("telefon", this.telefon);
                cmd.Parameters.AddWithValue("buro", this.buro);
                cmd.ExecuteNonQuery();

                trans.Commit();

            }
            catch (MySqlException ex)
            {
                try
                {
                    trans.Rollback();

                }
                catch (MySqlException ex1)
                {
                    Console.WriteLine("Error: {0}", ex1.ToString());
                }

                Console.WriteLine("Error: {0}", ex.ToString());

            }
            finally
            {
                if (con != null)
                {
                    con.Close();
                }
            }


        }

    }
}