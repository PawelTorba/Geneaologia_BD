-- Dodaje przykładową osobę do tabeli Osoby
INSERT INTO Osoby (Imie, Nazwisko, Data_Urodzenia) VALUES ('Pawel', 'Torba', '2010-01-01');

-- Dodaje rodzinę o określonym nazwisku do tabeli Rodziny
INSERT INTO Rodziny (Nazwisko_Rodziny) VALUES ('Torba');

--Dodaje przykładowe miejsce do tabeli Miejsca
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES ('Dukla', 'Miejscowosc', '(42.9383, 11.0614)');

-- Dodaje przykładowe zdarzenie wraz z przypisanym określonym miejscem
INSERT INTO Zdarzenia (ID_Miejsce, Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia)
VALUES (
    (SELECT ID_Miejsce FROM Miejsca WHERE Nazwa_Miejsca='Dukla' LIMIT 1),
    'Slub Jana i Anny',
    'Ceremonia slubna',
    '2025-01-01'
);

-- Wypisywanie danych dotyczących osób
SELECT Imie, Nazwisko, Data_Urodzenia FROM Osoby ORDER BY Nazwisko;

--Wypisywanie wszystkich zdarzeń dotyczących określonej Osoby (po ID_Osoba)
SELECT Zdarzenia.Opis_Zdarzenia, Zdarzenia.Nazwa_Zdarzenia FROM Zdarzenia JOIN Osoby_Zdarzenia on Osoby_Zdarzenia.ID_Zdarzenie = Zdarzenia.ID_Zdarzenie WHERE Osoby_Zdarzenia.ID_Osoba = 1;
