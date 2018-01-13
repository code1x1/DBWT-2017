using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Meilenstein3Paket5.Models;

namespace Meilenstein3Paket5.Controllers
{
    public class ProduktController : Controller
    {
        // GET: Produkt
        public ActionResult Index(int? kategorie, int? vegan, int? vegetarisch, int? limit)
        {
            List<Produkt> produkte = Produkt.getProdukteListe(kategorie, vegan, vegetarisch, limit);

            ViewBag.Kategorie = Kategorie.kategorieName(kategorie);

            ViewBag.KategorieListe = Kategorie.kategorieListe();

            return View(produkte);
        }

        // GET: Produkt
        public ActionResult Detail(int? id)
        {
            if(id == null)
            {
                return RedirectToAction("Index", "Home");
            }

            Preis p = Preis.getPreis(Convert.ToInt32(id));

            if(string.IsNullOrEmpty(Session["user"] as string) || Session["role"].ToString().Equals("Gast"))
            {
                ViewBag.PreisName = "Gast Preis";
                ViewBag.Preis = string.Format("{0:#.00}", Convert.ToDecimal(p.gastPreis));
            }
            else if(Session["role"].ToString().Equals("Student"))
            {
                ViewBag.PreisName = "Studenten Preis";
                ViewBag.Preis = string.Format("{0:#.00}", Convert.ToDecimal(p.studentPreis));
            }
            else
            {
                ViewBag.PreisName = "Mitarbeiter Preis";
                ViewBag.Preis = string.Format("{0:#.00}", Convert.ToDecimal(p.mitarbeiterPreis));
            }

            ViewBag.detailProdukt = Produkt.getProdukt(Convert.ToInt32(id));

            return View();
        }
    }
}