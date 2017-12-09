-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server Version:               10.2.9-MariaDB - mariadb.org binary distribution
-- Server Betriebssystem:        Win64
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Exportiere Datenbank Struktur für praktikum
CREATE DATABASE IF NOT EXISTS `praktikum` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `praktikum`;

-- Exportiere Struktur von Tabelle praktikum.bestellung
CREATE TABLE IF NOT EXISTS `bestellung` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NutzerFK` int(11) NOT NULL,
  `Zeitpunkt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `NutzerFK` (`NutzerFK`),
  CONSTRAINT `NutzerFK` FOREIGN KEY (`NutzerFK`) REFERENCES `fe-nutzer` (`Nr`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.bestellung: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `bestellung` DISABLE KEYS */;
INSERT INTO `bestellung` (`ID`, `NutzerFK`, `Zeitpunkt`) VALUES
	(1, 1, '2017-12-09 00:49:44');
/*!40000 ALTER TABLE `bestellung` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.bestellungenthaltprodukt
CREATE TABLE IF NOT EXISTS `bestellungenthaltprodukt` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Anzahl` int(11) NOT NULL DEFAULT 1,
  `ProduktFK` int(11) NOT NULL,
  `BestellungFK` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ProduktFK` (`ProduktFK`),
  KEY `BestellungFK` (`BestellungFK`),
  CONSTRAINT `BestellungFK` FOREIGN KEY (`BestellungFK`) REFERENCES `bestellung` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `ProduktFK` FOREIGN KEY (`ProduktFK`) REFERENCES `produkt` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.bestellungenthaltprodukt: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `bestellungenthaltprodukt` DISABLE KEYS */;
INSERT INTO `bestellungenthaltprodukt` (`ID`, `Anzahl`, `ProduktFK`, `BestellungFK`) VALUES
	(1, 10, 1, 1);
/*!40000 ALTER TABLE `bestellungenthaltprodukt` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.bild
CREATE TABLE IF NOT EXISTS `bild` (
  `ID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `Binärdaten` blob NOT NULL,
  `AltText` varchar(60) DEFAULT NULL,
  `Title` varchar(60) DEFAULT NULL,
  `Unterschrift` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.bild: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `bild` DISABLE KEYS */;
INSERT INTO `bild` (`ID`, `Binärdaten`, `AltText`, `Title`, `Unterschrift`) VALUES
	(1, _binary '', 'Alt Text', 'Titel', 'Unterschrift');
/*!40000 ALTER TABLE `bild` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.fe-nutzer
CREATE TABLE IF NOT EXISTS `fe-nutzer` (
  `Nr` int(11) NOT NULL AUTO_INCREMENT,
  `Loginname` varchar(30) NOT NULL,
  `Aktiv` tinyint(1) NOT NULL DEFAULT 0,
  `Anlagedatum` timestamp NOT NULL DEFAULT current_timestamp(),
  `Vorname` varchar(50) NOT NULL,
  `Nachname` varchar(50) NOT NULL,
  `Email` varchar(160) NOT NULL,
  `Algorithmus` enum('sha256','sha1') DEFAULT NULL,
  `Stretch` int(11) NOT NULL,
  `Salt` varchar(32) NOT NULL,
  `Hash` varchar(24) NOT NULL,
  `LetzterLogin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`Nr`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Loginnamen` (`Loginname`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.fe-nutzer: ~4 rows (ungefähr)
/*!40000 ALTER TABLE `fe-nutzer` DISABLE KEYS */;
INSERT INTO `fe-nutzer` (`Nr`, `Loginname`, `Aktiv`, `Anlagedatum`, `Vorname`, `Nachname`, `Email`, `Algorithmus`, `Stretch`, `Salt`, `Hash`, `LetzterLogin`) VALUES
	(1, 'db9382s', 1, '2017-12-09 00:49:44', 'Denis', 'Behrends', 'denis.behrends@alumni.fl-aachen.de', 'sha1', 64000, 'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK', 'o9JPz62sen0Zf/fgsORhMEd4', '0000-00-00 00:00:00'),
	(2, 'db9788s', 1, '2017-12-09 00:49:44', 'Denis', 'Behrends', 'denis.behrends2@alumni.fl-aachen.de', 'sha1', 64000, 'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK', 'o9JPz62sen0Zf/fgsORhMEd4', '0000-00-00 00:00:00'),
	(3, 'db9383s', 1, '2017-12-09 00:49:44', 'Denis', 'Behrends', 'denis.behrends3@alumni.fl-aachen.de', 'sha1', 64000, 'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK', 'o9JPz62sen0Zf/fgsORhMEd4', '0000-00-00 00:00:00'),
	(4, 'db9582s', 1, '2017-12-09 00:49:44', 'Denis', 'Behrends', 'denis.behrends4@alumni.fl-aachen.de', 'sha1', 64000, 'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK', 'o9JPz62sen0Zf/fgsORhMEd4', '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `fe-nutzer` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.fh-angehöriger
CREATE TABLE IF NOT EXISTS `fh-angehöriger` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `FeNutzerFhAngeFk` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FeNutzerFhAngeFk` (`FeNutzerFhAngeFk`),
  CONSTRAINT `FeNutzerFhAngeFk` FOREIGN KEY (`FeNutzerFhAngeFk`) REFERENCES `fe-nutzer` (`Nr`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.fh-angehöriger: ~3 rows (ungefähr)
/*!40000 ALTER TABLE `fh-angehöriger` DISABLE KEYS */;
INSERT INTO `fh-angehöriger` (`ID`, `FeNutzerFhAngeFk`) VALUES
	(1, 1),
	(2, 2),
	(3, 4);
/*!40000 ALTER TABLE `fh-angehöriger` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.gast
CREATE TABLE IF NOT EXISTS `gast` (
  `NutzerFk` int(11) NOT NULL,
  `Grund` varchar(30) DEFAULT NULL,
  `Ablauf` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `GastNutzerFK` (`NutzerFk`),
  CONSTRAINT `GastNutzerFK` FOREIGN KEY (`NutzerFk`) REFERENCES `fe-nutzer` (`Nr`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.gast: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `gast` DISABLE KEYS */;
INSERT INTO `gast` (`NutzerFk`, `Grund`, `Ablauf`) VALUES
	(3, 'Gaststudent', '2017-12-09 00:49:44');
/*!40000 ALTER TABLE `gast` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.kategorie
CREATE TABLE IF NOT EXISTS `kategorie` (
  `ID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `Bezeichnung` varchar(100) DEFAULT NULL,
  `Oberkategorie` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `OberKat` (`Oberkategorie`),
  CONSTRAINT `OberKat` FOREIGN KEY (`Oberkategorie`) REFERENCES `kategorie` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.kategorie: ~6 rows (ungefähr)
/*!40000 ALTER TABLE `kategorie` DISABLE KEYS */;
INSERT INTO `kategorie` (`ID`, `Bezeichnung`, `Oberkategorie`) VALUES
	(1, 'Gebäck', NULL),
	(2, 'Mittagsgerichte', NULL),
	(3, 'Wok', NULL),
	(4, 'Getränke', NULL),
	(5, 'Kalte Getränke', 4),
	(6, 'Heiße Getränke', 4);
/*!40000 ALTER TABLE `kategorie` ENABLE KEYS */;

-- Exportiere Struktur von Prozedur praktikum.LoginProcedure
DELIMITER //
CREATE DEFINER=`webapp`@`localhost` PROCEDURE `LoginProcedure`(
	IN `Lname` VARCHAR(30)



)
    READS SQL DATA
BEGIN
DECLARE  drole ENUM('Gast','Student','Mitarbeiter');
DECLARE	dloginname VARCHAR(30);
DECLARE	demail VARCHAR(160);
DECLARE	dalgorithmus ENUM('sha256', 'sha1');
DECLARE	dstretch INT;
DECLARE	dsalt VARCHAR(32);
DECLARE	dhash VARCHAR(24);


IF (select count(*) from student as st 
	join `fh-angehöriger` as fh on st.NutzerFk = fh.ID 
	join `fe-nutzer` as fe on fh.FeNutzerFhAngeFk = fe.Nr
	where fe.Loginname = Lname) = 1 THEN
	set drole = 'Student';
ELSEIF (select count(*) from mitarbeiter as ma 
	join `fh-angehöriger` as fh on ma.NutzerFk = fh.ID 
	join `fe-nutzer` as fe on fh.FeNutzerFhAngeFk = fe.Nr
	where fe.Loginname = Lname) = 1 THEN
	set drole = 'Mitarbeiter';
ELSE
	set drole = 'Gast';
END IF;


select fe.Loginname, fe.Email, fe.Algorithmus, fe.Stretch, fe.Salt, fe.`Hash`
into dloginname, demail, dalgorithmus, dstretch, dsalt, dhash
                        from `fe-nutzer` as fe
                        where Loginname = Lname limit 1;

select drole as role, dloginname as loginname, demail as email, 
dalgorithmus as algorithmus, dstretch as stretch, dsalt as salt, dhash as `hash`;

END//
DELIMITER ;

-- Exportiere Struktur von Tabelle praktikum.mitarbeiter
CREATE TABLE IF NOT EXISTS `mitarbeiter` (
  `NutzerFk` int(11) NOT NULL,
  `MA-Nummer` int(11) NOT NULL,
  `Telefon-Nummer` varchar(40) DEFAULT NULL,
  `Büro` varchar(10) DEFAULT NULL,
  KEY `MitarbeiterFHFK` (`NutzerFk`),
  CONSTRAINT `MitarbeiterFHFK` FOREIGN KEY (`NutzerFk`) REFERENCES `fh-angehöriger` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.mitarbeiter: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `mitarbeiter` DISABLE KEYS */;
INSERT INTO `mitarbeiter` (`NutzerFk`, `MA-Nummer`, `Telefon-Nummer`, `Büro`) VALUES
	(3, 234534, '0324152543-31', '333');
/*!40000 ALTER TABLE `mitarbeiter` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.preis
CREATE TABLE IF NOT EXISTS `preis` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Gastbetrag` float NOT NULL,
  `Studentenbetrag` float NOT NULL,
  `Mitarbeiterbetrag` float NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.preis: ~4 rows (ungefähr)
/*!40000 ALTER TABLE `preis` DISABLE KEYS */;
INSERT INTO `preis` (`ID`, `Gastbetrag`, `Studentenbetrag`, `Mitarbeiterbetrag`) VALUES
	(1, 1.9, 1.5, 1.1),
	(2, 1.8, 1.3, 1.2),
	(3, 1.85, 1.2, 0.9),
	(4, 1.65, 1.19, 0.65);
/*!40000 ALTER TABLE `preis` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.produkt
CREATE TABLE IF NOT EXISTS `produkt` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PreisFK` int(11) NOT NULL,
  `KategorieFK` mediumint(9) NOT NULL,
  `BildFK` mediumint(9) NOT NULL,
  `Name` varchar(90) NOT NULL,
  `Beschreibung` varchar(500) NOT NULL,
  `Vegan` tinyint(1) DEFAULT NULL,
  `Vegetarisch` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `PreisFK` (`PreisFK`),
  KEY `KategorieFK` (`KategorieFK`),
  KEY `BildFK` (`BildFK`),
  CONSTRAINT `BildFK` FOREIGN KEY (`BildFK`) REFERENCES `bild` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `KategorieFK` FOREIGN KEY (`KategorieFK`) REFERENCES `kategorie` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `PreisFK` FOREIGN KEY (`PreisFK`) REFERENCES `preis` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.produkt: ~3 rows (ungefähr)
/*!40000 ALTER TABLE `produkt` DISABLE KEYS */;
INSERT INTO `produkt` (`ID`, `PreisFK`, `KategorieFK`, `BildFK`, `Name`, `Beschreibung`, `Vegan`, `Vegetarisch`) VALUES
	(1, 3, 5, 1, 'Coca-Cola Zero', 'Sehr süßes Softgetränk mit Koffein', 1, 1),
	(2, 3, 5, 1, 'Fanta', 'Sehr süßes Softgetränk mit Orangengeschmack', 1, 1),
	(3, 3, 2, 1, 'Falafel', 'Teigtasche mit Falafel aus Kichererbsen und Sesam, dazu passt hervorragend der Krautsalat', 1, 1);
/*!40000 ALTER TABLE `produkt` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.produktenthaltzutat
CREATE TABLE IF NOT EXISTS `produktenthaltzutat` (
  `ProduktFK` int(11) NOT NULL,
  `ZutatFK` int(11) NOT NULL,
  KEY `ProduktFK` (`ProduktFK`,`ZutatFK`),
  KEY `ZutatFK` (`ZutatFK`),
  CONSTRAINT `produktenthaltzutat_ibfk_1` FOREIGN KEY (`ProduktFK`) REFERENCES `produkt` (`ID`),
  CONSTRAINT `produktenthaltzutat_ibfk_2` FOREIGN KEY (`ZutatFK`) REFERENCES `zutat` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.produktenthaltzutat: ~6 rows (ungefähr)
/*!40000 ALTER TABLE `produktenthaltzutat` DISABLE KEYS */;
INSERT INTO `produktenthaltzutat` (`ProduktFK`, `ZutatFK`) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(2, 1),
	(2, 2),
	(3, 4);
/*!40000 ALTER TABLE `produktenthaltzutat` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.student
CREATE TABLE IF NOT EXISTS `student` (
  `NutzerFk` int(11) NOT NULL,
  `Matrikelnummer` int(11) NOT NULL,
  `Studiengang` varchar(20) NOT NULL,
  UNIQUE KEY `Matrikelnummer` (`Matrikelnummer`),
  KEY `StudentFHFK` (`NutzerFk`),
  CONSTRAINT `StudentFHFK` FOREIGN KEY (`NutzerFk`) REFERENCES `fh-angehöriger` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`Matrikelnummer` < 9999999),
  CONSTRAINT `CONSTRAINT_2` CHECK (`Matrikelnummer` > 10000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.student: ~2 rows (ungefähr)
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` (`NutzerFk`, `Matrikelnummer`, `Studiengang`) VALUES
	(1, 3005136, 'Informatik'),
	(2, 3005156, 'Geschichte');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle praktikum.zutat
CREATE TABLE IF NOT EXISTS `zutat` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(120) NOT NULL,
  `Beschreibung` varchar(500) DEFAULT NULL,
  `Vegan` tinyint(1) DEFAULT NULL,
  `Vegetarisch` tinyint(1) DEFAULT NULL,
  `Bio` tinyint(1) DEFAULT NULL,
  `Glutenfrei` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Exportiere Daten aus Tabelle praktikum.zutat: ~4 rows (ungefähr)
/*!40000 ALTER TABLE `zutat` DISABLE KEYS */;
INSERT INTO `zutat` (`ID`, `Name`, `Beschreibung`, `Vegan`, `Vegetarisch`, `Bio`, `Glutenfrei`) VALUES
	(1, 'Zucker', NULL, NULL, NULL, NULL, NULL),
	(2, 'Wasser', NULL, NULL, NULL, NULL, NULL),
	(3, 'Koffein', NULL, NULL, NULL, NULL, NULL),
	(4, 'Kichererbsen', NULL, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `zutat` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
