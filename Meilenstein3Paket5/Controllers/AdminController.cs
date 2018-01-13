using Meilenstein3Paket5.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Meilenstein3Paket5.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        public ActionResult Index()
        {
            List<FE_Nutzer> liste = FE_Nutzer.listFeNutzer();
            //if(!string.IsNullOrEmpty( Session["admin"] as string) && Session["admin"].ToString().Equals("true"))
            {
                return View(liste);
            }
            return RedirectToAction("Login", "Admin");
        }

        // Get
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(string username, string password)
        {
            BE_Nutzer bE_Nutzer = (BE_Nutzer)new BE_Nutzer().Login(username, password);
            

            if(bE_Nutzer != null && bE_Nutzer.isAuthorized())
            {
                Session["admin"] = "true";
                return RedirectToAction("Index","Admin");
            }

            return View();
        }

    }
}