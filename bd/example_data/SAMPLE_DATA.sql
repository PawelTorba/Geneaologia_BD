-- sample_data.sql
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
  (10,'córka'),
  (11, 'wujek'),
  (12, 'ciotka');

--------------------------------------------------------------------
-- 2. Rodziny
--------------------------------------------------------------------
INSERT INTO Rodziny (ID_Rodzina, Nazwisko_Rodziny)
OVERRIDING SYSTEM VALUE
VALUES
  (1,'Mak'),
  (2,'Szczurek'),
  (3,'Kowalscy');

--------------------------------------------------------------------
-- 3. Osoby
--------------------------------------------------------------------
INSERT INTO Osoby 
  (ID_Osoba, Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu)
OVERRIDING SYSTEM VALUE
VALUES
  -- Rodzina Mak (ID_Rodzina = 1)
  ( 1,'Joanna',      'Mak',     NULL,'1938-04-01','2008-01-04'), --pra
  ( 2,'Jakub',       'Mak',     NULL,'1932-04-01','2006-01-03'), --pra
  ( 3,'Zbigniew', 'Kowalski',     NULL,'1930-04-02','1997-04-01'), --pra
  ( 4,'Zofia',     'Kowalska',     NULL,'1933-09-01','2003-01-02'), --pra
  ( 5,'Barbara',   'Kowalska',     NULL,'1960-07-01',NULL), --dziadkowie
  ( 6,'Roman',     'Kowalski',     NULL,'1960-04-04','2010-05-06'), --dziadkowie
  ( 7,'Zofia',    'Kowalska',     NULL,'1982-01-07',NULL), --rodzice/wujkowie/ciotki
  ( 8,'Jakub',      'Kowalski',     NULL,'1980-01-04',NULL), --rodzice/wujkowie/ciotki
  ( 9,'Natan', 'Kowalski',     NULL,'1983-05-07','2009-05-07'), --rodzice/wujkowie/ciotki
  (10,'Agata',     'Szczurek', NULL,'1986-03-02',NULL), --rodzice/wujkowie/ciotki
  (11,'Andrzej',     'Szczurek',     NULL,'1987-01-31',NULL), --rodzice/wujkowie/ciotki
  (12,'Alicja',   'Kowalska',     NULL,'2005-02-26',NULL), --rodzice/wujkowie/ciotki
  (13,'Antoni',    'Kowalski', NULL,'2002-01-01',NULL), --rodzice/wujkowie/ciotki
  (14,'Alex',   'Szczurek', NULL,'2006-03-02',NULL), -- kuzynostwo
  (15,'Ada',     'Szczurek', NULL,'2007-08-01',NULL); -- kuzynostwo

--------------------------------------------------------------------
-- 4. Przynależność osób do rodzin
--------------------------------------------------------------------
--ID RODZIN
--1 MAK
--2 SZCZUREK
--3 KOWALSCY
INSERT INTO Osoby_Rodziny (ID_Osoby_Rodziny, ID_Osoba, ID_Rodzina)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1,  1, 1),( 2,  2, 1),( 3,  3, 3),( 4,  4, 3),( 5,  5, 3),
  ( 6,  6, 3),( 7,  7, 3),( 8,  8, 3),( 9,  9, 3),(10, 10, 2),
  (11, 11, 2),(12, 12, 3),(13, 13, 3),(14, 14, 2),(15, 15, 2);

--------------------------------------------------------------------
-- 5. Małżeństwa
--------------------------------------------------------------------
INSERT INTO Zwiazki
  (ID_Zwiazek, Typ_Relacji, Data_Rozpoczecia, Data_Zakonczenia, Powod_Zakonczenia)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1,'małżeństwo','1950-01-15',NULL,NULL), -- MAK PRADZIADKOWIE
  ( 2,'małżeństwo','1952-03-22',NULL,NULL), -- KOWALSCY PRADZIADKOWIE
  ( 3,'małżeństwo','1980-01-01',NULL,NULL), -- KOWALSCY DZIADKOWIE
  ( 4,'małżeństwo','2000-07-11',NULL,NULL), -- KOWALSCY RODZICE
  ( 5,'małżeństwo','2004-09-14',NULL,NULL); -- KOWALSCY WUJKOWIE

-- Osoby w związkach (dwa wiersze na każdy związek)
INSERT INTO Osoby_Zwiazki (ID_Osoby_Zwiazki, ID_Osoba, ID_Zwiazek)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1,  1, 1),( 2,  2, 1), -- MAK PRADZIADKOWIE
  ( 3,  3, 2),( 4,  4, 2), -- KOWALSCY PRADZIADKOWIE
  ( 5,  5, 3),( 6,  6, 3), -- KOWALSCY DZIADKOWIE
  ( 7,  7, 4),( 8,  8, 4), -- KOWALSCY RODZICE
  ( 9, 10, 5),(10, 11, 5); -- KOWALSCY WUJKOWIE

--------------------------------------------------------------------
-- 6. Pokrewieństwa
--------------------------------------------------------------------
INSERT INTO Osoby_Pokrewienstwa
  (ID_Osoby_Pokrewienstwo, ID_Pokrewienstwo, ID_Osoba_1, ID_Osoba_2)
OVERRIDING SYSTEM VALUE
VALUES
  -- #### ALICJA KOWALSKA
  ( 1, 1 , 12, 2),  --PRADZIADEK
  ( 2, 3 , 12, 1),  --PRABABCIA
  ( 3, 1 , 12, 3),  --PRADZIADEK
  ( 4, 3 , 12, 4),  --PRABABCIA

  ( 5, 4 , 12, 5),  --BABCIA
  ( 6, 2 , 12, 6),  --DZIADEK
  ( 7, 6 , 12, 7),  --MATKA
  ( 8, 5 , 12, 8),  --OJCIEC

  ( 9, 11, 12, 9),  --WUJEK
  (10, 12, 12, 10), --CIOTKA
  (11, 11, 12, 11), --WUJEK

  (12, 8 , 12, 13), --RODZENSTWO

  (13, 7 , 12, 14), --KUZYNOSTWO
  (14, 7 , 12, 15), --KUZYNOSTWO

  ( 15, 10,  1,  5),


  ( 16, 10,  2,  5),


  ( 17,  9,  3,  6),


  ( 18,  9,  4,  6),


  ( 19,  9,  5,  8),
  ( 20,  9,  5,  9),


  ( 21,  9,  6,  8),
  ( 22,  9,  6,  9),


  ( 23, 10,  7, 12),
  ( 24,  9,  7, 13),


  ( 25,  6,  8,  5),   -- matka
  ( 26,  5,  8,  6),   -- ojciec
  ( 27,  8,  8,  9),   -- rodzeństwo
  ( 28, 10,  8, 12),   -- córka
  ( 29,  9,  8, 13),   -- syn


  ( 30,  6,  9,  5),   -- matka
  ( 31,  5,  9,  6),   -- ojciec
  ( 32,  8,  9,  8),   -- rodzeństwo


  ( 33,  9, 10, 14),   -- syn  Alex
  ( 34, 10, 10, 15),   -- córka  Ada


  ( 35,  9, 11, 14),   -- syn  Alex
  ( 36, 10, 11, 15),   -- córka  Ada


  ( 37,  3, 13,  1),   -- prababc ia  Joanna
  ( 38,  1, 13,  2),   -- pradziadek  Jakub Mak
  ( 39,  1, 13,  3),   -- pradziadek  Zbigniew Kowalski
  ( 40,  3, 13,  4),   -- prababcia  Zofia Kowalska
  ( 41,  4, 13,  5),   -- babcia
  ( 42,  2, 13,  6),   -- dziadek
  ( 43,  6, 13,  7),   -- matka
  ( 44,  5, 13,  8),   -- ojciec
  ( 45, 11, 13,  9),   -- wujek  Natan
  ( 46, 12, 13, 10),   -- ciotka Agata
  ( 47, 11, 13, 11),   -- wujek  Andrzej
  ( 48,  8, 13, 12),   -- rodzeństwo  Alicja
  ( 49,  7, 13, 14),   -- kuzyn  Alex
  ( 50,  7, 13, 15),   -- kuzynka  Ada

  ( 51,  5, 14, 11),   -- ojciec  Andrzej
  ( 52,  6, 14, 10),   -- matka  Agata
  ( 53,  8, 14, 15),   -- rodzeństwo  Ada
  ( 54,  7, 14, 12),   -- kuzynostwo  Alicja
  ( 55,  7, 14, 13),   -- kuzynostwo  Antoni

  ( 56,  5, 15, 11),   -- ojciec  Andrzej
  ( 57,  6, 15, 10),   -- matka  Agata
  ( 58,  8, 15, 14),   -- rodzeństwo  Alex
  ( 59,  7, 15, 12),   -- kuzynostwo  Alicja
  ( 60,  7, 15, 13);   -- kuzynostwo  Antoni



INSERT INTO Osoby_Pokrewienstwa
        (ID_Osoby_Pokrewienstwo, ID_Pokrewienstwo, ID_Osoba_1, ID_Osoba_2)
OVERRIDING SYSTEM VALUE
VALUES
  (61, 2,  7,  2),  -- dziadek  Jakub Mak
  (62, 4,  7,  1),  -- babcia  Joanna Mak
  (63, 2,  7,  3),  -- dziadek  Zbigniew Kowalski
  (64, 4,  7,  4),  -- babcia  Zofia Kowalska

  (65, 2,  8,  2),
  (66, 4,  8,  1),
  (67, 2,  8,  3),
  (68, 4,  8,  4),

  (69, 2,  9,  2),
  (70, 4,  9,  1),
  (71, 2,  9,  3),
  (72, 4,  9,  4),

  (73, 2, 10,  2),
  (74, 4, 10,  1),
  (75, 2, 10,  3),
  (76, 4, 10,  4),

  (77, 2, 11,  2),
  (78, 4, 11,  1),
  (79, 2, 11,  3),
  (80, 4, 11,  4),

  (81, 1, 14,  2),  -- pradziadek  Jakub Mak
  (82, 3, 14,  1),  -- prababcia  Joanna Mak
  (83, 1, 14,  3),  -- pradziadek  Zbigniew Kowalski
  (84, 3, 14,  4),  -- prababcia  Zofia Kowalska

  (85, 1, 15,  2),
  (86, 3, 15,  1),
  (87, 1, 15,  3),
  (88, 3, 15,  4),

  (89, 4, 14,  5),  -- babcia  Barbara Kowalska
  (90, 2, 14,  6),  -- dziadek Roman Kowalski
  (91, 4, 15,  5),
  (92, 2, 15,  6);





INSERT INTO Osoby_Pokrewienstwa
        (ID_Osoby_Pokrewienstwo, ID_Pokrewienstwo, ID_Osoba_1, ID_Osoba_2)
OVERRIDING SYSTEM VALUE
VALUES

  (93, 6, 10, 5),   -- matka
  (94, 5, 10, 6),   -- ojciec


  (95, 8, 10, 8),   -- rodzeństwo Agata–Jakub
  (96, 8, 10, 9),   -- rodzeństwo Agata–Natan


  (97, 12, 14,  7),   -- ciotka  Zofia
  (98, 11, 14,  8),   -- wujek   Jakub
  (99, 11, 14,  9),   -- wujek   Natan
  (100,12, 15,  7),   -- ciotka  Zofia
  (101,11, 15,  8),   -- wujek   Jakub
  (102,11, 15,  9);   -- wujek   Natan



DELETE FROM Osoby_Pokrewienstwa
WHERE  ID_Osoba_1 IN (7, 11)
  AND  ID_Osoba_2 IN (1, 2, 3, 4)
  AND  ID_Pokrewienstwo IN (1, 2, 3, 4);

/* ---------------------------------------------------------------
   Zsynchronizowanie wszystkich sekwencji
---------------------------------------------------------------- */

-- Osoby
SELECT setval(pg_get_serial_sequence('osoby','id_osoba'),
              (SELECT COALESCE(MAX(id_osoba),0)+1 FROM osoby),   false);

-- Rodziny
SELECT setval(pg_get_serial_sequence('rodziny','id_rodzina'),
              (SELECT COALESCE(MAX(id_rodzina),0)+1 FROM rodziny), false);

-- Miejsca
SELECT setval(pg_get_serial_sequence('miejsca','id_miejsce'),
              (SELECT COALESCE(MAX(id_miejsce),0)+1 FROM miejsca), false);

-- Zdarzenia
SELECT setval(pg_get_serial_sequence('zdarzenia','id_zdarzenie'),
              (SELECT COALESCE(MAX(id_zdarzenie),0)+1 FROM zdarzenia), false);

-- Pokrewienstwa (słownik stopni pokrewieństwa)
SELECT setval(pg_get_serial_sequence('pokrewienstwa','id_pokrewienstwo'),
              (SELECT COALESCE(MAX(id_pokrewienstwo),0)+1 FROM pokrewienstwa), false);

-- Osoby_Rodziny
SELECT setval(pg_get_serial_sequence('osoby_rodziny','id_osoby_rodziny'),
              (SELECT COALESCE(MAX(id_osoby_rodziny),0)+1 FROM osoby_rodziny), false);

-- Zwiazki (małżeństwa / relacje)
SELECT setval(pg_get_serial_sequence('zwiazki','id_zwiazek'),
              (SELECT COALESCE(MAX(id_zwiazek),0)+1 FROM zwiazki), false);

-- Osoby_Zwiazki
SELECT setval(pg_get_serial_sequence('osoby_zwiazki','id_osoby_zwiazki'),
              (SELECT COALESCE(MAX(id_osoby_zwiazki),0)+1 FROM osoby_zwiazki), false);

-- Osoby_Zdarzenia
SELECT setval(pg_get_serial_sequence('osoby_zdarzenia','id_osoby_zdarzenia'),
              (SELECT COALESCE(MAX(id_osoby_zdarzenia),0)+1 FROM osoby_zdarzenia), false);

-- Osoby_Pokrewienstwa
SELECT setval(pg_get_serial_sequence('osoby_pokrewienstwa','id_osoby_pokrewienstwo'),
              (SELECT COALESCE(MAX(id_osoby_pokrewienstwo),0)+1 FROM osoby_pokrewienstwa), false);

/* ------------------------------------------------------------- */

-- 4. Miejsca
INSERT INTO Miejsca (ID_Miejsce, Nazwa_Miejsca, Opis, Lokalizacja)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1,'Szpital Uniwersytecki w Krakowie',                'Szpital przy ul. Kopernika 36 w Krakowie',                               '(50.0669,19.9500)'),
  ( 2,'Szpital Kliniczny Dzieciatka Jezus w Warszawie',   'Szpital kliniczny przy ul. Lindleya 4 w Warszawie',                       '(52.2228,21.0038)'),
  ( 3,'Urzad Stanu Cywilnego Krakow',                     'USC Krakow, ul. Lubelska 29',                                             '(50.0736,19.9400)'),
  ( 4,'Urzad Stanu Cywilnego Warszawa',                   'USC Warszawa, ul. Andersa 5',                                             '(52.2500,21.0000)'),
  ( 5,'Cmentarz Rakowicki',                               'Cmentarz komunalny w Krakowie przy ul. Rakowickiej',                       '(50.0730,19.9650)'),
  ( 6,'Cmentarz Powazkowski',                             'Stary cmentarz w Warszawie przy ul. Powazkowskiej',                        '(52.2570,20.9790)');

-- 5. Zdarzenia
INSERT INTO Zdarzenia (ID_Zdarzenie, ID_Miejsce, Opis_Zdarzenia, Nazwa_Zdarzenia, Data_Zdarzenia)
OVERRIDING SYSTEM VALUE
VALUES
  ( 1, 1,'Narodziny Barbary Kowalskiej w Szpitalu Uniwersyteckim w Krakowie','Narodziny Barbary','1960-07-01'),
  ( 2, 1,'Narodziny Romana Kowalskiego w Szpitalu Uniwersyteckim w Krakowie','Narodziny Romana','1960-04-04'),
  ( 3, 1,'Narodziny Zofii Kowalskiej w Szpitalu Uniwersyteckim w Krakowie','Narodziny Zofii','1982-01-07'),
  ( 4, 1,'Narodziny Jakuba Kowalskiego w Szpitalu Uniwersyteckim w Krakowie','Narodziny Jakuba','1980-01-04'),
  ( 5, 1,'Narodziny Natana Kowalskiego w Szpitalu Uniwersyteckim w Krakowie','Narodziny Natana','1983-05-07'),
  ( 6, 2,'Narodziny Agaty Szczurek w Szpitalu Klinicznym Dzieciatka Jezus w Warszawie','Narodziny Agaty','1986-03-02'),
  ( 7, 2,'Narodziny Andrzeja Szczurka w Szpitalu Klinicznym Dzieciatka Jezus w Warszawie','Narodziny Andrzeja','1987-01-31'),
  ( 8, 1,'Narodziny Alicji Kowalskiej w Szpitalu Uniwersyteckim w Krakowie','Narodziny Alicji','2005-02-26'),
  ( 9, 1,'Narodziny Antoniego Kowalskiego w Szpitalu Uniwersyteckim w Krakowie','Narodziny Antoniego','2002-01-01'),
  (10, 2,'Narodziny Alexa Szczurka w Szpitalu Klinicznym Dzieciatka Jezus w Warszawie','Narodziny Alexa','2006-03-02'),
  (11, 2,'Narodziny Ady Szczurek w Szpitalu Klinicznym Dzieciatka Jezus w Warszawie','Narodziny Ady','2007-08-01'),
  (12, 5,'Smierc Romana Kowalskiego na cmentarzu Rakowickim w Krakowie','Smierc Romana','2010-05-06'),
  (13, 5,'Smierc Natana Kowalskiego na cmentarzu Rakowickim w Krakowie','Smierc Natana','2009-05-07'),
  (14, 3,'Slub Barbary i Romana w Urzedzie Stanu Cywilnego w Krakowie','Slub Barbary i Romana','1980-01-01'),
  (15, 3,'Slub Zofii i Jakuba w Urzedzie Stanu Cywilnego w Krakowie','Slub Zofii i Jakuba','2000-07-11'),
  (16, 4,'Slub Agaty i Andrzeja w Urzedzie Stanu Cywilnego w Warszawie','Slub Agaty i Andrzeja','2004-09-14');

-- 6. Osoby_Zdarzenia
INSERT INTO Osoby_Zdarzenia (ID_Osoby_Zdarzenia, ID_Osoba, ID_Zdarzenie)
OVERRIDING SYSTEM VALUE
VALUES
  (  1,  5,  1),
  (  2,  6,  2),
  (  3,  7,  3),
  (  4,  8,  4),
  (  5,  9,  5),
  (  6, 10,  6),
  (  7, 11,  7),
  (  8, 12,  8),
  (  9, 13,  9),
  ( 10, 14, 10),
  ( 11, 15, 11),
  ( 12,  6, 12),
  ( 13,  9, 13),
  ( 14,  5, 14),
  ( 15,  6, 14),
  ( 16,  7, 15),
  ( 17,  8, 15),
  ( 18, 10, 16),
  ( 19, 11, 16);


COMMIT;
