-- sample_data.sql
-- UWAGA: plik MUSI być zapisany w UTF-8!
SET client_encoding = 'UTF8';

BEGIN;

--------------------------------------------------------------------
-- 1. Słownik pokrewieństw
--------------------------------------------------------------------
INSERT INTO Pokrewienstwa (ID_Pokrewienstwo, Stopien_Pokrewienstwa)
OVERRIDING SYSTEM VALUE
VALUES
  (1 ,'pradziadek'),
  (2 ,'dziadek'),
  (3 ,'prababcia'),
  (4 ,'babcia'),
  (5 ,'ojciec'),
  (6 ,'matka'),
  (7 ,'kuzynostwo'),
  (8 ,'rodzeństwo'),
  (9 ,'syn'),
  (10,'córka');

--------------------------------------------------------------------
-- 2. Rodziny
--------------------------------------------------------------------
INSERT INTO Rodziny (ID_Rodzina, Nazwisko_Rodziny)
OVERRIDING SYSTEM VALUE
VALUES
  (1,'Nowak'),
  (2,'Kowalski');

--------------------------------------------------------------------
-- 3. Osoby
--------------------------------------------------------------------
INSERT INTO Osoby 
  (ID_Osoba, Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu)
OVERRIDING SYSTEM VALUE
VALUES
  -- Rodzina NOWAK (ID_Rodzina = 1)
  ( 1,'Anna',      'Nowak',     NULL,'1930-03-12',NULL),
  ( 2,'Jan',       'Nowak',     NULL,'1928-08-05',NULL),
  ( 3,'Stanisław', 'Nowak',     NULL,'1931-02-22',NULL),
  ( 4,'Maria',     'Nowak',     NULL,'1932-09-19',NULL),
  ( 5,'Barbara',   'Nowak',     NULL,'1955-07-15',NULL),
  ( 6,'Marek',     'Nowak',     NULL,'1953-01-30',NULL),
  ( 7,'Joanna',    'Nowak',     NULL,'1978-10-10',NULL),
  ( 8,'Adam',      'Nowak',     NULL,'1980-12-22',NULL),
  ( 9,'Katarzyna', 'Nowak',     NULL,'1983-04-17',NULL),
  (10,'Piotr',     'Kowalczyk', NULL,'1976-06-02',NULL),
  (11,'Kamil',     'Nowak',     NULL,'2005-09-14',NULL),
  (12,'Paulina',   'Nowak',     NULL,'2008-11-25',NULL),
  (13,'Łukasz',    'Zieliński', NULL,'1982-03-05',NULL),
  (14,'Mateusz',   'Zieliński', NULL,'2010-07-09',NULL),
  (15,'Agata',     'Zielińska', NULL,'2013-02-11',NULL),

  -- Rodzina KOWALSKI (ID_Rodzina = 2)
  (16,'Helena',    'Kowalska',  NULL,'1931-05-03',NULL),
  (17,'Kazimierz', 'Kowalski',  NULL,'1929-11-20',NULL),
  (18,'Władysław', 'Bąk',       NULL,'1930-04-15',NULL),
  (19,'Janina',    'Bąk',       NULL,'1933-07-12',NULL),
  (20,'Ewa',       'Kowalska',  NULL,'1956-08-24',NULL),
  (21,'Zbigniew',  'Bąk',       NULL,'1954-02-06',NULL),
  (22,'Monika',    'Bąk',       NULL,'1980-09-12',NULL),
  (23,'Tomasz',    'Bąk',       NULL,'1982-01-14',NULL),
  (24,'Alicja',    'Bąk',       NULL,'1984-05-01',NULL),
  (25,'Robert',    'Nowicki',   NULL,'1979-03-08',NULL),
  (26,'Marek',     'Nowicki',   NULL,'2006-10-21',NULL),
  (27,'Anna',      'Nowicka',   NULL,'2009-12-30',NULL),
  (28,'Michał',    'Król',      NULL,'1983-10-19',NULL),
  (29,'Piotr',     'Król',      NULL,'2011-04-25',NULL),
  (30,'Kinga',     'Król',      NULL,'2014-06-17',NULL);

--------------------------------------------------------------------
-- 4. Przynależność osób do rodzin
--------------------------------------------------------------------
INSERT INTO Osoby_Rodziny (ID_Osoby_Rodziny, ID_Osoba, ID_Rodzina)
OVERRIDING SYSTEM VALUE
VALUES
  -- Nowak
  ( 1,  1,1),( 2,  2,1),( 3,  3,1),( 4,  4,1),( 5,  5,1),
  ( 6,  6,1),( 7,  7,1),( 8,  8,1),( 9,  9,1),(10, 10,1),
  (11, 11,1),(12, 12,1),(13, 13,1),(14, 14,1),(15, 15,1),
  -- Kowalski
  (16, 16,2),(17, 17,2),(18, 18,2),(19, 19,2),(20, 20,2),
  (21, 21,2),(22, 22,2),(23, 23,2),(24, 24,2),(25, 25,2),
  (26, 26,2),(27, 27,2),(28, 28,2),(29, 29,2),(30, 30,2);

--------------------------------------------------------------------
-- 5. Małżeństwa
--------------------------------------------------------------------
INSERT INTO Zwiazki
  (ID_Zwiazek, Typ_Relacji, Data_Rozpoczecia, Data_Zakonczenia, Powod_Zakonczenia)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1,'małżeństwo','1950-06-15',NULL,NULL),
  ( 2,'małżeństwo','1952-09-22',NULL,NULL),
  ( 3,'małżeństwo','1975-05-03',NULL,NULL),
  ( 4,'małżeństwo','2000-07-11',NULL,NULL),
  ( 5,'małżeństwo','2008-09-14',NULL,NULL),
  ( 6,'małżeństwo','1951-04-10',NULL,NULL),
  ( 7,'małżeństwo','1953-08-20',NULL,NULL),
  ( 8,'małżeństwo','1977-10-12',NULL,NULL),
  ( 9,'małżeństwo','2002-05-25',NULL,NULL),
  (10,'małżeństwo','2009-11-07',NULL,NULL);

-- Osoby w związkach (dwa wiersze na każdy związek)
INSERT INTO Osoby_Zwiazki (ID_Osoby_Zwiazki, ID_Osoba, ID_Zwiazek)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1,  2, 1),( 2,  1, 1),
  ( 3,  3, 2),( 4,  4, 2),
  ( 5,  6, 3),( 6,  5, 3),
  ( 7,  7, 4),( 8, 10, 4),
  ( 9,  9, 5),(10, 13, 5),
  (11, 17, 6),(12, 16, 6),
  (13, 18, 7),(14, 19, 7),
  (15, 21, 8),(16, 20, 8),
  (17, 22, 9),(18, 25, 9),
  (19, 24,10),(20, 28,10);

--------------------------------------------------------------------
-- 6. Pokrewieństwa
--------------------------------------------------------------------
INSERT INTO Osoby_Pokrewienstwa
  (ID_Osoby_Pokrewienstwo, ID_Pokrewienstwo, ID_Osoba_1, ID_Osoba_2)
OVERRIDING SYSTEM VALUE
VALUES
  -- Nowak
  ( 1,1 , 2,11),( 2,3 , 1,11),
  ( 3,2 , 6,11),( 4,4 , 5,11),
  ( 5,5 ,10,11),( 6,6 , 7,11),
  ( 7,9 ,11,10),( 8,10,12, 7),
  ( 9,8 , 7, 8),
  (10,7 ,11,14),(11,7 ,12,15),

  -- Kowalski
  (12,1 ,17,26),(13,3 ,16,26),
  (14,2 ,21,26),(15,4 ,20,26),
  (16,5 ,25,26),(17,6 ,22,26),
  (18,8 ,22,23),
  (19,7 ,26,29),(20,7 ,27,30);

COMMIT;
