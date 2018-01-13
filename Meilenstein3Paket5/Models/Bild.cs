using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;

namespace Meilenstein3Paket5.Models
{
    public class Bild
    {
        public int ID;
        public string bindaten;
        public string alttext;
        public string title;
        public string unterschrift;

        internal static Bild getBild(int bID)
        {
            string sqlQuery = @"select b.ID, b.`Binärdaten`, b.AltText, b.Title, b.Unterschrift
                                from bild as b
	                            where b.ID= @bid";
            MySqlConnection con = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            con.Open(); // danach ist möglich, mit dem DB Server zu interagieren
            MySqlCommand cmd = con.CreateCommand();
            cmd.CommandText = sqlQuery;
            cmd.Parameters.AddWithValue("bid", bID);
            // jetzt an die DB schicken!
            MySqlDataReader r = cmd.ExecuteReader();

            r.Read();
            Bild b = new Bild();
            b.ID = Convert.ToInt32(r["ID"]);
            b.bindaten = r["Binärdaten"].ToString();
            b.alttext = r["AltText"].ToString();
            b.title = r["Title"].ToString();
            b.unterschrift = r["Unterschrift"].ToString();

            return b;
        }

        internal string blobToBase64()
        {

            string q = "SELECT `Binärdaten`, `AltText`, `Unterschrift` FROM Bild WHERE ID=@id";
            using (MySqlConnection con = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString))
            {
                con.Open();
                using (MySqlCommand cmd = con.CreateCommand())
                {
                    cmd.CommandText = q;
                    cmd.Parameters.AddWithValue("id", ID);
                    MySqlDataReader r = cmd.ExecuteReader(CommandBehavior.SingleResult);
                    if (r.Read())
                    {
                        // auch hier: wählen Sie den Methodennamen und drücken Sie F12 um den Methodentext zu sehen
                        string base64text = BlobToBase64(r["Binärdaten"]);
                        return base64text;
                    }
                    else
                    {
                        return "";
                    }
                }
            }
            
        }

        private string BlobToBase64(object b)
        {
            byte[] bytes = (byte[])b;
            if (bytes != null)
            {
                return Convert.ToBase64String(bytes);
            }
            return "";
        }
    }
}