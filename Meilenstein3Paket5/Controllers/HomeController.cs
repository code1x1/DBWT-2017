using Meilenstein3Paket5.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;

namespace Meilenstein3Paket5.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            
            List<XElement> l = null;
            try
            {
                var doc = XDocument.Load(Server.MapPath("~/App_Data/Speiseplan.xml"));

                XElement root = doc.Root;

                var q = from z in root.Descendants("Menu")
                        select z;

                

                foreach (var v in q.Elements("Produkte").Elements("Produkt"))
                {
                    bool has = Produkt.getProdukt(Convert.ToInt32(v.Attribute("ProduktID").Value)) == null ? false: true;
                    if (!has)
                    {
                        v.Remove();
                    }
                }

                foreach (var v in q.Elements("Produkte").Elements("Produkt"))
                {
                    Produkt produkt = Produkt.getProdukt(Convert.ToInt32(v.Attribute("ProduktID").Value));
                    Bild bild = Bild.getBild(produkt.BID);
                    Preis preis = Preis.getPreis(produkt.id);
                    XElement x = null;
                    XElement xx = null;

                    if (v.Parent.Parent.Attribute("Highlight") != null)
                    {
                        x = new XElement("Bild", bild.blobToBase64());
                        v.Add(x);
                    }
                    
                    if (string.IsNullOrEmpty( Session["role"] as string) || Session["role"].ToString().Equals("Gast"))
                    {

                        x = new XElement("preisVon", "Gast");
                        xx = new XElement("anzeigePreis", preis.gastPreis.ToString("C"));
                        
                    }
                    else if (Session["role"].ToString().Contains("Mitarbeiter"))
                    {
                        x = new XElement("preisVon", "Mitarbeiter");
                        xx = new XElement("anzeigePreis", preis.mitarbeiterPreis.ToString("C"));
                    }
                    else if(Session["role"].ToString().Contains("Student"))
                    {
                        x = new XElement("preisVon", "Student");
                        xx = new XElement("anzeigePreis", preis.studentPreis.ToString("C"));
                    }
                    v.Add(x);
                    v.Add(xx);

                    x = new XElement("beschreibung", produkt.Beschreibung);
                    v.Add(x);
                    x = new XElement("titel", produkt.Name);
                    v.Add(x);

                }

                l = q.ToList();
                ViewBag.xml = l;
            }
            catch (Exception e)
            {
            }

            return View();
        }

        public ActionResult Impressum()
        {
            return View();
        }
    }
}