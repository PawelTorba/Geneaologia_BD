----Dodawanie rekordów do Bazy Danych

-- Dodawanie Osoby do bazy

INSERT INTO Osoby (Imie, Nazwisko, Data_Urodzenia)
VALUES ("Pawel", "Torba", "2002-06-18");

-- Dodawanie rodziny o tym samym nazwisku
INSERT INTO Rodziny (Nazwisko_Rodziny)
VALUES ('Torba');

-- Łączenie osoby z rodziną
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny)
VALUES (
    (SELECT ID_Osoba  FROM Osoby   WHERE Imie='Pawel'   AND Nazwisko='Torba' LIMIT 1),
    (SELECT ID_Rodziny FROM Rodziny WHERE Nazwisko_Rodziny='Torba' LIMIT 1)
);

-- Dodawanie przykładowego miejsca

INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja)
VALUES ('Dukla', 'Miejscowosc', '(42.9383, 11.0614)');


-- Dodwanie przykłądowego zdarzenia do miejsca
INSERT INTO Zdarzenia (ID_Miejsce, Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia)
VALUES (
    (SELECT ID_Miejsce FROM Miejsca WHERE Nazwa_Miejsca='Dukla' LIMIT 1),
    'Ślub Jana i Anny',
    'Ceremonia ślubna',
    '2025-01-01'
);


-- Wypisywanie danych dotyczących osób
SELECT Imie, Nazwisko, Data_Urodzenia FROM Osoby ORDER BY Nazwisko;

--Wypisywanie wszystkich zdarzeń dotyczących określonej Osoby (po ID_Osoba)

SELECT Zdarzenia.Opis_Zdarzenia, Zdarzenia.Nazwa_Zdarzenia FROM Zdarzenia JOIN Osoby_Zdarzenia on Osoby_Zdarzenia.ID_Zdarzenie = Zdarzenia.ID_Zdarzenie WHERE Osoby_Zdarzenia.ID_Osoba = 1; 

