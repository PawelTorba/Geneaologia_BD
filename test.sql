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
  (2,'Kowalscy');

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
  ( 7,  7, 4),( 8, 8, 4), -- KOWALSCY RODZICE
  ( 9,  10, 5),(10, 11, 5); -- KOWALSCY WUJKOWIE
 

--------------------------------------------------------------------
-- 6. Pokrewieństwa
--------------------------------------------------------------------
INSERT INTO Osoby_Pokrewienstwa
  (ID_Osoby_Pokrewienstwo, ID_Pokrewienstwo, ID_Osoba_1, ID_Osoba_2)
OVERRIDING SYSTEM VALUE
  --1 , 'pradziadek'
  --2 , 'dziadek'
  --3 , 'prababcia'
  --4 , 'babcia'
  --5 , 'ojciec'
  --6 , 'matka'
  --7 , 'kuzynostwo'
  --8 , 'rodzeństwo'
  --9 , 'syn'
  --10, 'córka'
  --11, 'wujek'
  --12, 'ciotka'

VALUES
  -- #### ALICJA KOWALSKA
  ( 1, 1 , 12, 2),  --PRADZIADEK
  ( 2, 3 , 12, 1),  --PRABABCIA
  ( 3, 1 , 12, 3),  --PRADZIADEK
  ( 4, 3 , 12, 4),  --PRABABCIA

  ( 5, 4 , 12, 5),  --BABCIA
  ( 6, 2 , 12, 6), --DZIADEK
  ( 7, 6 , 12, 7),  --MATKA
  ( 8, 5, 12, 8), --OJCIEC

  ( 9, 11 , 12, 9), --WUJEK
  (10, 12 , 12, 10), --CIOTKA
  (11, 11 , 12, 11), --WUJEK

  (11, 8 , 12, 13), --RODZENSTWO

  (11, 7 , 12, 14), --KUZYNOSTWO
  (11, 7 , 12, 15); --KUZYNOSTWO
  

COMMIT;
