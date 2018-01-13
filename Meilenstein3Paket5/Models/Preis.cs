using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace Meilenstein3Paket5.Models
{
    public class Preis
    {
        public double gastPreis { get; set; }
        public double studentPreis { get; set; }
        public double mitarbeiterPreis { get; set; }
        public int fkId { get; set; }

        public static Preis getPreis(int produktId)
        {
            string sqlQuery = @"select p.ID, pr.Gastbetrag, pr.Studentenbetrag, pr.Mitarbeiterbetrag
                        from produkt as p
	                    join preis as pr on p.PreisFK = pr.ID
                        where p.ID= @ProduktID";
            MySqlConnection con = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            con.Open(); // danach ist möglich, mit dem DB Server zu interagieren
            MySqlCommand cmd = con.CreateCommand();
            cmd.CommandText = sqlQuery;
            cmd.Parameters.AddWithValue("ProduktID", produktId);
            // jetzt an die DB schicken!
            MySqlDataReader r = cmd.ExecuteReader();

            r.Read();
            Preis p = new Preis();
            p.gastPreis = Convert.ToDouble(r["Gastbetrag"]);
            p.studentPreis = Convert.ToDouble(r["Studentenbetrag"]);
            p.mitarbeiterPreis = Convert.ToDouble(r["Mitarbeiterbetrag"]);

            con.Close();

            return p;
        }


    }
}