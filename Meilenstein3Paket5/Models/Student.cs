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
    public class Student :FE_Nutzer
    {

        [DisplayName("Matrikelnummer")]
        [Required(ErrorMessage = "Bitte geben Sie eine Matrikelnummer ein.")]
        [StringLength(7, ErrorMessage = "Matrikelnummer muss 7 Zeichen lang sein.", MinimumLength = 7)]
        public int matrikelnummer { get; set; }
        [DisplayName("Studiengang")]
        [Required(ErrorMessage = "Bitte geben Sie einen Studiengang ein.")]
        [StringLength(20, ErrorMessage = "Studiengang muss zwischen 3 und 20 Zeichen lang sein.", MinimumLength = 3)]
        public string studiengang { get; set; }

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
                `student`(NutzerFk,Matrikelnummer,Studiengang) 
                values(@NutzerFk,@mnummer,@studiengang)";
                cmd.Parameters.AddWithValue("NutzerFk", cmd.LastInsertedId);
                cmd.Parameters.AddWithValue("mnummer", this.matrikelnummer);
                cmd.Parameters.AddWithValue("studiengang", this.studiengang);
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