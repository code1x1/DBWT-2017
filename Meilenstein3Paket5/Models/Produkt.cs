using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace Meilenstein3Paket5.Models
{
    public class Produkt
    {
        public int id { get; set; }
        public String Name { get; set; }
        public String Beschreibung { get; set; }
        public int BID { get; set; }

        public static Produkt getProdukt(int id)
        {
            string sqlQuery = @"select p.BildFK as BID, p.ID, p.Beschreibung, p.Name, pr.Gastbetrag, k.Bezeichnung as Kategorie,
                        b.`Binärdaten`, b.AltText, b.Title, b.Unterschrift from produkt as p
	                    join preis as pr on p.PreisFK = pr.ID
	                    join kategorie as k on p.KategorieFK = k.ID
	                    join bild as b on p.BildFK = b.ID
                        where p.ID= @ProduktID";
            MySqlConnection con = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            con.Open(); // danach ist möglich, mit dem DB Server zu interagieren
            MySqlCommand cmd = con.CreateCommand();
            cmd.CommandText = sqlQuery;
            cmd.Parameters.AddWithValue("ProduktID", id);
            // jetzt an die DB schicken!
            MySqlDataReader r = cmd.ExecuteReader();
            Produkt produkt = null;

            if (r.Read())
            {
                produkt = new Produkt();
                produkt.id = Convert.ToInt32(r["ID"]);
                produkt.Name = r["Name"].ToString();
                produkt.BID = Convert.ToInt32(r["BID"]);
                produkt.Beschreibung = @r["Beschreibung"].ToString();

            }
            con.Close();
            return produkt;
        }

        public static List<Produkt> getProdukteListe(int? k, int? vegan, int? veget, int? limit)
        {
            List<Produkt> produkte = new List<Produkt>();

            MySqlConnection produktecon = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            produktecon.Open();
            MySqlCommand produktecmd = produktecon.CreateCommand();
            produktecmd.CommandText = @"select p.BildFK as BID, p.ID, p.Name
                                from produkt as p
                                join preis as pr on p.PreisFK = pr.ID
	                            join kategorie as k on p.KategorieFK = k.ID
	                            join bild as b on p.BildFK = b.ID
                                where (p.KategorieFK = @kategorien OR @kategorien IS NULL)
                                and (p.Vegan = @vegan OR @vegan IS NULL)
                                and (p.Vegetarisch = @vegetarisch OR @vegetarisch IS NULL)
                                limit @limit";
            produktecmd.Parameters.AddWithValue("kategorien", k);
            produktecmd.Parameters.AddWithValue("vegan", vegan);
            produktecmd.Parameters.AddWithValue("vegetarisch", veget);
            produktecmd.Parameters.AddWithValue("limit", limit == null ? 8 : limit);

            MySqlDataReader produkteresult = produktecmd.ExecuteReader();

            while (produkteresult.Read())
            {
                Produkt p = new Produkt();
                p.id = Convert.ToInt32(produkteresult["ID"]);
                p.Name = produkteresult["Name"].ToString();
                p.BID = Convert.ToInt32(produkteresult["BID"]);
                produkte.Add(p);
            }
            produktecon.Close();
            return produkte;
        }


    }
}