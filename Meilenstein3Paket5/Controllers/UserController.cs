using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Meilenstein3Paket5.Models;

namespace Meilenstein3Paket5.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        public ActionResult Index()
        {
            return RedirectToAction("Login", "User");
        }

        // GET: Login
        public ActionResult Login()
        {
            return View();
        }

        // Post
        [HttpPost]
        public ActionResult Login(string user, string pass, string redirect, string abmelden)
        {
            if(!string.IsNullOrEmpty(abmelden))
            {
                Session["user"] = null;
                Session["role"] = null;
                return View();
            }

            FE_Nutzer fE_Nutzer = new FE_Nutzer().Login(user, pass);
            if(fE_Nutzer.letzterlogin.ToString().Equals("0000-00-00 00:00:00"))
            {
                Session["lastlogin"] = null;
            }
            else
            {
                Session["lastlogin"] = fE_Nutzer.letzterlogin.ToString();
            }

            if (!fE_Nutzer.aktiv)
            {
                Session["loginError"] = "Dieser Benutzer wurde noch nicht Aktiviert.";
                Session["user"] = null;
                Session["role"] = null;
                return View();
            }
            else if (fE_Nutzer != null)
            {
                Session["loginError"] = "";
                Session["user"] = fE_Nutzer.loginname;
                Session["role"] = fE_Nutzer.role;
                fE_Nutzer.updateLastLogin();
                if (!string.IsNullOrEmpty(redirect))
                {
                    return Redirect(redirect);
                }
                return View();
            }
            else
            {
                Session["loginError"] = "Dass hat nicht geklappt! Bitte versuchen Sie es erneut.";
                Session["user"] = null;
                Session["role"] = null;
                return View();
            }
        }

        public ActionResult Register()
        {
            return RedirectToAction("RegisterFirstStep");
        }

        public ActionResult RegisterFirstStep()
        {
            return View();
        }

        public ActionResult RegisterGast()
        {
            return View();
        }

        [HttpPost]
        public ActionResult RegisterGast(string loginname, string vorname, string nachname, string password,
                                        string email, string grund)
        {
            Gast gast = new Gast();
            gast.loginname = loginname;
            gast.vorname = vorname;
            gast.nachname = nachname;
            gast.password = password;
            gast.email = email;
            gast.grund = grund;

            gast.insertDB();

            return View();
        }

        public ActionResult RegisterStudent()
        {
            return View();
        }

        [HttpPost]
        public ActionResult RegisterStudent(string loginname, string vorname, string nachname, string password,
                                string email, int matrikelnummer, string studiengang)
        {
            Student student = new Student();
            student.loginname = loginname;
            student.vorname = vorname;
            student.nachname = nachname;
            student.password = password;
            student.email = email;
            student.matrikelnummer = matrikelnummer;
            student.studiengang = studiengang;

            student.insertDB();

            return View();
        }

        public ActionResult RegisterMitarbeiter()
        {
            return View();
        }

        [HttpPost]
        public ActionResult RegisterMitarbeiter(string loginname, string vorname, string nachname, string password,
                        string email, int manummer, string telefon, string buro)
        {
            Mitarbeiter mitarbeiter = new Mitarbeiter();
            mitarbeiter.loginname = loginname;
            mitarbeiter.vorname = vorname;
            mitarbeiter.nachname = nachname;
            mitarbeiter.password = password;
            mitarbeiter.email = email;
            mitarbeiter.manummer = manummer;
            mitarbeiter.telefon = telefon;
            mitarbeiter.buro = buro;

            mitarbeiter.insertDB();

            return View();
        }

    }
}