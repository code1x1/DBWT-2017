using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace Meilenstein3Paket5.Models
{
    public class Kategorie
    {
        public int id { get; set; }
        public String name { get; set; }

        public static Dictionary<String,String> kategorieListe()
        {
            Dictionary<String, String> kategorieD = new Dictionary<string, string>();
            MySqlConnection con = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            con.Open(); // danach ist möglich, mit dem DB Server zu interagieren
            MySqlCommand cmd = con.CreateCommand();
            cmd.CommandText = @"select k.Bezeichnung as Kategorie, k.ID
	                    from kategorie as k";
            // jetzt an die DB schicken!
            MySqlDataReader kategorien = cmd.ExecuteReader();
            while (kategorien.Read())
            {
                kategorieD.Add(kategorien["ID"].ToString(), kategorien["Kategorie"].ToString());
            }
            return kategorieD;
        }

        public static String kategorieName(int? id)
        {
            if(id == null)
            {
                return "";
            }
            MySqlConnection kategoriecon = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            kategoriecon.Open();
            MySqlCommand kategoriecmd = kategoriecon.CreateCommand();
            kategoriecmd.CommandText = @"select k.Bezeichnung as Kategorie, k.ID
                            from kategorie as k
                            where k.ID = @kategorien";
            kategoriecmd.Parameters.AddWithValue("kategorien", id);
            MySqlDataReader kategorieresult = kategoriecmd.ExecuteReader();
            if (kategorieresult.HasRows)
            {
                kategorieresult.Read();
                return kategorieresult["Kategorie"].ToString();
            }
            return "";

        }

    }
}