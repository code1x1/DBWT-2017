-- SQL stub, nutzen Sie dieses Snippet als Ausgangspunkt und erweitern und ändern Sie es so, 
-- dass es die Aufgaben aus Paket 2 löst

-- 
-- 
-- DROP statements
-- zuvor angelegte Tabellen löschen, niemals die ganze Datenbank löschen, nur Tabellen
-- mit DROP werden sowohl die Schemadefinitionen der Tabelle als auch die in ihr gespeicherten Daten


-- DROP STATEMENTS sollten in rücklaufender Reinfolge wie CREATE STATEMENTS druchgeführt werden
DROP TABLE IF EXISTS `BestellungEnthaltProdukt`;
DROP TABLE IF EXISTS `Bestellung`;
DROP TABLE IF EXISTS `ProduktEnthaltZutat`;
DROP TABLE IF EXISTS `Produkt`;
DROP TABLE IF EXISTS `Kategorie`;
DROP TABLE IF EXISTS `Bild`;
DROP TABLE IF EXISTS `Preis`;
DROP TABLE IF EXISTS `Zutat`;
DROP TABLE IF EXISTS `Gast`;
DROP TABLE IF EXISTS `Mitarbeiter`;
DROP TABLE IF EXISTS `Student`;
DROP TABLE IF EXISTS `FH-Angehöriger`;
DROP TABLE IF EXISTS `FE-Nutzer`;

-- 
-- 
-- CREATE statements
-- Schemaelemente definieren


CREATE TABLE `FE-Nutzer`(
	Nr INT AUTO_INCREMENT not null, -- Nr wird PK für eindeutige Identifikation
	Loginname VARCHAR(30) not null, -- Loginname soll entsprechend der Benutzer Kennung verwendet werden
	Aktiv BOOL not null default 0, -- Aktiv eit bool flag ob Account benutzt werden darf
	Anlagedatum TIMESTAMP default CURRENT_TIMESTAMP not null, -- Anlagedatum wann der Nutzer angelegt wurde
	Vorname VARCHAR(50) not null, -- Vorname des Nutzers
	Nachname VARCHAR(50) not null, -- Nachname des Nutzers
	Email VARCHAR(160) not null, -- Email des Nutzers
	Algorithmus ENUM('sha256', 'sha1'),
	Stretch INT not null, -- Stretch für Auth Vorgang
	`Salt` VARCHAR(32) not null, -- Salt für Auth Vorgang
	`Hash` VARCHAR(24) not null, -- Hash für Auth Vorgang
	LetzterLogin TIMESTAMP, -- LetzterLogin wann Nutzer sich das letzte mal angemeldet hat
	
	PRIMARY KEY(Nr), -- PK ist Nr was sowohl für interne als auch externe Nummerierung verwendet wird also kein Surrogate
	CONSTRAINT Email UNIQUE(Email), -- Constraint für eindeutige Email
	CONSTRAINT Loginnamen UNIQUE(Loginname) -- Constraint für eindeutigen Loginnamen
);

CREATE TABLE `Gast`(
	NutzerFk INT not null, -- Foreign Key um Spezialisierten Gast mit FE-Nutzer Account zu verbinden
	Grund VARCHAR(30), -- Begründung für Gastzugang
	Ablauf TIMESTAMP default CURRENT_TIMESTAMP  not null, -- Ablaufdatum des Gastzugangs
	CONSTRAINT `GastNutzerFK` FOREIGN KEY(NutzerFK) REFERENCES `FE-Nutzer`(Nr)
		ON DELETE CASCADE
);

CREATE TABLE `FH-Angehöriger`(
	ID INT AUTO_INCREMENT not null,
	FeNutzerFhAngeFk INT not null,
	PRIMARY KEY(ID),
	CONSTRAINT `FeNutzerFhAngeFk` FOREIGN KEY(FeNutzerFhAngeFk) REFERENCES `FE-Nutzer`(Nr)
		ON DELETE CASCADE
);

CREATE TABLE `Mitarbeiter`(
	NutzerFk INT not null, -- Foreign Key um Spezialisierten Gast mit FE-Nutzer Account zu verbinden
	`MA-Nummer` INT not null, -- Mitarbeiternummer da bei jedem Mitarbeiter vorhanden => not null
	`Telefon-Nummer` VARCHAR(40), -- Telefonnummer ist optional
	`Büro` VARCHAR(10), -- Büro ist optional
	CONSTRAINT `MitarbeiterFHFK` FOREIGN KEY(NutzerFK) REFERENCES `FH-Angehöriger`(ID)
		ON DELETE CASCADE -- ON DELETE CASCADE löscht Eintrag mit wenn Nutzer aus FE-Nutzer tabelle entfernt wird
);

CREATE TABLE `Student`(
	NutzerFk INT not null, -- Foreign Key um Spezialisierten Gast mit FE-Nutzer Account zu verbinden
	Matrikelnummer INT not null,
	Studiengang VARCHAR(20) not null,
	CONSTRAINT `StudentFHFK` FOREIGN KEY(NutzerFK) REFERENCES `FH-Angehöriger`(ID)
		ON DELETE CASCADE, -- ON DELETE CASCADE löscht Eintrag mit wenn Nutzer aus FE-Nutzer tabelle entfernt wird
	CONSTRAINT `Matrikelnummer` UNIQUE(Matrikelnummer), CHECK(Matrikelnummer<9999999), CHECK(Matrikelnummer>10000)
	-- Constraint für prüfung ob Matrikelnummer in Range ist und immer einzigartig
);

-- Normale Zutat Tabelle
CREATE TABLE `Zutat`(
	ID INT AUTO_INCREMENT not null,
	Name VARCHAR(120) not null,
	Beschreibung VARCHAR(500),
	Vegan BOOL,
	Vegetarisch BOOL,
	Bio BOOL,
	Glutenfrei BOOL,
	PRIMARY KEY(ID)
);

CREATE TABLE `Preis`(
	ID INT AUTO_INCREMENT not null,
	Gastbetrag FLOAT not null, -- Gastbetrag wird für Gast FE-Nutzer erhoben
	Studentenbetrag FLOAT not null, -- Studentenbetrag wird für Studenten FE-Nutzer erhoben
	Mitarbeiterbetrag FLOAT not null, -- Mitarbeiterbetrag wird für Mitarbeiter FE-Nutzer erhoben
	PRIMARY KEY(ID)
);

CREATE TABLE `Bild`(
	ID MEDIUMINT AUTO_INCREMENT NOT NULL,		-- Unterschied MediumInt/Int MEDIUMINT sollte noch ausreichen da man nicht Millionen von Produktbildern haben wird
	`Binärdaten` BLOB NOT NULL, 					-- Datentyp unbedingt verbessern BLOB Datentyp zur Speicherung von Großen Binärdaten
	AltText VARCHAR(60),								-- ist Attribut nicht optional ... 
	Title VARCHAR(60),								-- ... müssen Sie mit dem NOT NULL ...
	Unterschrift VARCHAR(80),						-- ... Constraint arbeiten!
	PRIMARY KEY(ID)									-- Primarschlüssel der Tabelle festlegen
);

-- Beispiel für benannten Foreign Key Constraint `OberKat`
-- FOREIGN KEY (Klammern!) REFERENCES Table(Column)
CREATE TABLE `Kategorie` (
	ID MEDIUMINT AUTO_INCREMENT not null, -- MEDIUMINT sollte noch ausreichen da man nicht Millionen von Produktkategorien haben wird
	Bezeichnung VARCHAR(100),
	Oberkategorie MEDIUMINT DEFAULT NULL, 	-- DEFAULT NULL ist standard
	CONSTRAINT `OberKat` FOREIGN KEY (Oberkategorie) REFERENCES Kategorie(ID),
	PRIMARY KEY (ID)
);

CREATE TABLE `Produkt`(
	ID INT AUTO_INCREMENT not null,
	PreisFK INT not null,
	KategorieFK MEDIUMINT not null,
	BildFK MEDIUMINT not null,
	Name VARCHAR(90) not null,
	Beschreibung VARCHAR(500) not null,
	Vegan BOOL,
	Vegetarisch BOOL,
	PRIMARY KEY(ID),
	CONSTRAINT `PreisFK` FOREIGN KEY(PreisFK) REFERENCES `Preis`(ID)
		ON DELETE CASCADE,
	CONSTRAINT `KategorieFK` FOREIGN KEY(KategorieFK) REFERENCES `Kategorie`(ID)
		ON DELETE CASCADE,
	CONSTRAINT `BildFK` FOREIGN KEY(BildFK) REFERENCES `Bild`(ID)
		ON DELETE CASCADE -- Produkt wird gelöscht, wenn Daten gelöscht werden mit denen Produkt über FK COnstraint verbunden ist, gelöscht werden!
);

-- Tabelle implementiert n:m Beziehnung zwischen Produkten und Zutaten
CREATE TABLE `ProduktEnthaltZutat`(
	ProduktFK INT not null,
	ZutatFK INT not null,
	INDEX(ProduktFK, ZutatFK),
	FOREIGN KEY(ProduktFK)
	REFERENCES `Produkt`(ID),
	FOREIGN KEY(ZutatFK)
	REFERENCES `Zutat`(ID)
);

-- Tabelle ist über Foreign Key mit FE-Nutzer und BestellungEnthaltProdukt verbunden damit Bestellungen belibig viele Produkte in beliebiger Anzahl für jeden Nutzer enthalten kann
CREATE TABLE `Bestellung`(
	ID INT AUTO_INCREMENT not null,
	NutzerFK INT not null,
	Zeitpunkt TIMESTAMP default CURRENT_TIMESTAMP not null,
	PRIMARY KEY(ID),
	CONSTRAINT `NutzerFK` FOREIGN KEY(NutzerFK) REFERENCES `FE-Nutzer`(Nr)
		ON DELETE CASCADE
);

-- Tabelle implementiert n:1:m Beziehung zwischen Produkt Anzahl und Bestellung
CREATE TABLE `BestellungEnthaltProdukt`(
	ID INT AUTO_INCREMENT not null,
	Anzahl INT not null default(1),
	ProduktFK INT not null,
	BestellungFK INT not null,
	PRIMARY KEY(ID),
	CONSTRAINT `ProduktFK` FOREIGN KEY(ProduktFK) REFERENCES `Produkt`(ID),
	CONSTRAINT `BestellungFK` FOREIGN KEY(BestellungFK) REFERENCES `Bestellung`(ID)
		ON DELETE CASCADE
);

--
--
-- INSERT statements
-- wenn alle Tabellen vollständig definiert sind, fügen Sie Beispieldaten in die Benutzertabellen ein (Aufgabe 2.4)
-- hier ein Insert-Beispiel für die im Stub definierte Tabelle Kategorie (wenn Sie das Schema ändern, kann es auch dazu kommen, dass Sie Änderungen in den INSERT Statements vornehmen müssen)

INSERT INTO `Kategorie` (ID, Bezeichnung, Oberkategorie) VALUES (1, 'Gebäck', NULL);
INSERT INTO `Kategorie` (ID, Bezeichnung, Oberkategorie) VALUES (2, 'Mittagsgerichte', NULL);
INSERT INTO `Kategorie` (ID, Bezeichnung, Oberkategorie) VALUES (3, 'Wok', NULL);
INSERT INTO `Kategorie` (ID, Bezeichnung, Oberkategorie) VALUES (4, 'Getränke', NULL);
INSERT INTO `Kategorie` (ID, Bezeichnung, Oberkategorie) VALUES (5, 'Kalte Getränke', 4);
INSERT INTO `Kategorie` (ID, Bezeichnung, Oberkategorie) VALUES (6, 'Heiße Getränke', 4);

insert into `Bild`(ID,`Binärdaten`,AltText,Title,Unterschrift) values(1, '', 'Alt Text', 'Titel', 'Unterschrift');

insert into `preis` values(1, 1.9, 1.5, 1.1);
insert into `preis` values(2, 1.8, 1.3, 1.2);
insert into `preis` values(3, 1.85, 1.2, 0.9);
insert into `preis` values(4, 1.65, 1.19, 0.65);

insert into `produkt`(ID,PreisFK,KategorieFK,BildFK,Name,Beschreibung,Vegan,Vegetarisch) 
	values(1,3,5,1,'Coca-Cola Zero','Sehr süßes Softgetränk mit Koffein',1,1),
			(2,3,5,1,'Fanta','Sehr süßes Softgetränk mit Orangengeschmack',1,1),
			(3,3,5,1,'Falafel','Teigtasche mit Falafel aus Kichererbsen und Sesam, dazu passt hervorragend der Krautsalat',1,1);

insert into `zutat`(ID,Name) values(1,'Zucker');
insert into `zutat`(ID,Name) values(2,'Wasser');
insert into `zutat`(ID,Name) values(3,'Koffein');
insert into `zutat`(ID,Name) values(4,'Kichererbsen');

insert into `ProduktEnthaltZutat` values(1,1);
insert into `ProduktEnthaltZutat` values(1,2);
insert into `ProduktEnthaltZutat` values(1,3);

insert into `ProduktEnthaltZutat` values(2,1);
insert into `ProduktEnthaltZutat` values(2,2);

insert into `ProduktEnthaltZutat` values(3,4);

insert into `FE-Nutzer`(Nr, Loginname, Aktiv, Vorname, Nachname, Email, Algorithmus, Stretch, Salt, `Hash`) values
(1,'db9382s',1,'Denis','Behrends','denis.behrends@alumni.fl-aachen.de','sha1',64000,'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK','o9JPz62sen0Zf/fgsORhMEd4'),
(2,'db9788s',1,'Denis','Behrends','denis.behrends2@alumni.fl-aachen.de','sha1',64000,'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK','o9JPz62sen0Zf/fgsORhMEd4'),
(3,'db9383s',1,'Denis','Behrends','denis.behrends3@alumni.fl-aachen.de','sha1',64000,'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK','o9JPz62sen0Zf/fgsORhMEd4'),
(4,'db9582s',1,'Denis','Behrends','denis.behrends4@alumni.fl-aachen.de','sha1',64000,'LGK0ocCGHIbo7VbMLlMLvv/H04rv/VXK','o9JPz62sen0Zf/fgsORhMEd4');



insert into `FH-Angehöriger`(ID,FeNutzerFhAngeFk) values(1,1);
insert into `FH-Angehöriger`(ID,FeNutzerFhAngeFk) values(2,2);
insert into `FH-Angehöriger`(ID,FeNutzerFhAngeFk) values(3,4);

insert into `Mitarbeiter` values(3,234534,'0324152543-31',333);


insert into `Student` values(1,3005136,'Informatik');
insert into `Student` values(2,3005156,'Geschichte');

insert into `Gast`(NutzerFK,Grund) values(3,'Gaststudent');

insert into `bestellung`(ID,NutzerFK) values(1,1);

insert into `BestellungEnthaltProdukt`(ID,Anzahl,BestellungFK,ProduktFK) values(1,10,1,1);

-- delete from `FE-Nutzer` where Nr=4; 

-- delete from `FE-Nutzer` where Nr=2;
-- delete from `FE-Nutzer` where Nr=1;  

-- delete from `FE-Nutzer` where Nr=3; 