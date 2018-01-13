using MySql.Data.MySqlClient;
using PasswordSecurity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace Meilenstein3Paket5.Models
{
    public class BE_Nutzer : FE_Nutzer
    {
        public int BEid { get; set; }

      
        internal Boolean isAuthorized()
        {
            string sqlQuery = @"select ID from `be-nutzer` where nutzerFK=@nutzerFK";
            MySqlConnection con = new MySqlConnection(ConfigurationManager.ConnectionStrings["webapp"].ConnectionString);
            con.Open(); // danach ist möglich, mit dem DB Server zu interagieren
            MySqlCommand cmd = con.CreateCommand();
            cmd.CommandText = sqlQuery;
            cmd.Parameters.AddWithValue("nutzerFK", ID);
            // jetzt an die DB schicken!
            MySqlDataReader r = cmd.ExecuteReader();
            
            if (r.Read())
            {

                con.Close();
                return r["ID"] != null ? true : false;
            }
            return false;
        }

    }
}