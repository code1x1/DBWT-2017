using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Configuration;
using PasswordSecurity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace Meilenstein3Paket5.Models
{
    public class FE_Nutzer
    {
        [DisplayName("Username")]
        [Required(ErrorMessage = "Bitte geben Sie einen Username ein.")]
        [StringLength(30, ErrorMessage = "Username muss zwischen 7 und 30 Zeichen lang sein.", MinimumLength = 7)]
        public string loginname { get; set; }
        [DisplayName("Vorname")]
        public string vorname { get; set; }
        [DisplayName("Nachname")]
        public string nachname { get; set; }
        [DisplayName("Passwort")]
        [Required(ErrorMessage = "Bitte geben Sie ein Passwort ein.")]
        [StringLength(255, ErrorMessage = "Passwort muss zwischen 8 und 255 Zeichen lang sein.", MinimumLength = 8)]
        [DataType(DataType.Password)]
        public string password { get; set; }
        [DisplayName("Wiederholen")]
        [Required(ErrorMessage = "Bitte geben Sie ein Passwort ein.")]
        [StringLength(255, ErrorMessage = "Passwort muss zwischen 8 und 255 Zeichen lang sein.", MinimumLength = 8)]
        [DataType(DataType.Password)]
        [Compare("password", ErrorMessage ="Die Passworte stimmen nicht überein.")]
        public string confirmPassword { get; set; }
        [ScaffoldColumn(false)]
        public string role { get; set; }
        [DisplayName("Email")]
        [Required(ErrorMessage = "Bitte geben Sie ein Passwort ein.")]
        [StringLength(255, ErrorMessage = "Email muss zwischen 8 und 255 Zeichen lang sein.", MinimumLength = 8)]
        public string email { get; set; }
        [ScaffoldColumn(false)]
        public Boolean aktiv { get; set; }
        [ScaffoldColumn(false)]
        public DateTime anlagedatum { get; set; }
        [ScaffoldColumn(false)]
        public DateTime letzterlogin { get; set; }
        [ScaffoldColumn(false)]
        public int ID { get; set; }


        internal void updateLastLogin()
        {
            MySqlConnection con = null;
            MySqlTransaction trans = null;


            try
            {
                con = new MySqlConnection(
                    ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);

                con.Open();
                trans = con.BeginTransaction();
                MySqlCommand cmd = con.CreateCommand();
                cmd.CommandText = @"update `fe-nutzer` set LetzterLogin = @lastlogin 
                                    where Loginname = @login";
                cmd.Parameters.AddWithValue("login", this.loginname);
                cmd.Parameters.AddWithValue("lastlogin", DateTime.Now);
                // jetzt an die DB schicken!
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

        public static List<FE_Nutzer> listFeNutzer()
        {
            List<FE_Nutzer> FeNutzerliste = new List<FE_Nutzer>();

            MySqlConnection FeNutzercon = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            FeNutzercon.Open();
            MySqlCommand FeNutzercmd = FeNutzercon.CreateCommand();
            FeNutzercmd.CommandText = @"select * from `fe-nutzer`";

            MySqlDataReader FeNutzerresult = FeNutzercmd.ExecuteReader();

            while (FeNutzerresult.Read())
            {
                FE_Nutzer fE_Nutzer = new FE_Nutzer();
                fE_Nutzer.ID = Convert.ToInt32(FeNutzerresult["Nr"]);
                fE_Nutzer.aktiv = Convert.ToBoolean(FeNutzerresult["Aktiv"]);
                fE_Nutzer.anlagedatum = FeNutzerresult.GetDateTime("Anlagedatum");
                fE_Nutzer.letzterlogin = FeNutzerresult.GetDateTime("LetzterLogin");
                fE_Nutzer.loginname = Convert.ToString(FeNutzerresult["Loginname"]);
                fE_Nutzer.email = Convert.ToString(FeNutzerresult["Email"]);

                FeNutzerliste.Add(fE_Nutzer);
            }
            FeNutzercon.Close();
            return FeNutzerliste;
            
        }

        public FE_Nutzer Login(string user, string password)
        {
            MySqlConnection logincon = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            logincon.Open();
            MySqlCommand logincmd = new MySqlCommand("LoginProcedure", logincon);
            logincmd.CommandType = System.Data.CommandType.StoredProcedure;
            logincmd.Parameters.AddWithValue("@Lname", user);
            MySqlDataReader loginresult = logincmd.ExecuteReader();
            FE_Nutzer fE_Nutzer = new FE_Nutzer();

            if (loginresult.Read() && !string.IsNullOrEmpty(loginresult["loginname"] as string))
            {
                string dbhash = String.Format("{0}:{1}:{2}:{3}:{4}",
                                                loginresult["algorithmus"],
                                                loginresult["stretch"],
                                                Convert.ToString(18),
                                                loginresult["salt"],
                                                loginresult["hash"]);
                if (PasswordStorage.VerifyPassword(password, dbhash))
                {
                    fE_Nutzer.loginname = loginresult["loginname"].ToString();
                    fE_Nutzer.role = loginresult["role"].ToString();
                    fE_Nutzer.email = loginresult["email"].ToString();
                    fE_Nutzer.aktiv = Convert.ToBoolean(loginresult["activ"]);
                    fE_Nutzer.letzterlogin = Convert.ToDateTime(loginresult["LetzterLogin"]);
                    fE_Nutzer.ID = Convert.ToInt32(loginresult["ID"]);
                    logincon.Close();
                    return fE_Nutzer;
                }

            }
            logincon.Close();
            return null;
            
        }

    }
}