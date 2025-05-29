-- Rodziny
INSERT INTO Rodziny (Nazwisko_Rodziny) VALUES ('Kowalski');
INSERT INTO Rodziny (Nazwisko_Rodziny) VALUES ('Nowak');

-- Osoby (Rodzina Kowalskich)
-- Pokolenie 1
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES 
('Jan', 'Kowalski', NULL, '1950-05-10', NULL),     -- ID 1
('Maria', 'Kowalska', NULL, '1952-07-22', NULL);   -- ID 2

-- Pokolenie 2
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES 
('Piotr', 'Kowalski', NULL, '1975-03-15', NULL),   -- ID 3
('Anna', 'Kowalska', NULL, '1978-09-30', NULL);    -- ID 4

-- Pokolenie 3
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES 
('Marek', 'Kowalski', NULL, '2000-12-01', NULL),   -- ID 5
('Ola', 'Kowalska', NULL, '2003-06-15', NULL);     -- ID 6

-- Osoby (Rodzina Nowaków)
-- Pokolenie 1
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES 
('Andrzej', 'Nowak', NULL, '1960-04-05', NULL),    -- ID 7
('Elżbieta', 'Nowak', NULL, '1962-02-18', NULL);   -- ID 8

-- Pokolenie 2
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES 
('Tomasz', 'Nowak', NULL, '1985-11-12', NULL),     -- ID 9
('Katarzyna', 'Nowak', NULL, '1988-06-08', NULL);  -- ID 10

-- Pokolenie 3
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES 
('Julia', 'Nowak', NULL, '2010-10-10', NULL);      -- ID 11

-- Przypisanie do rodzin
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1),
(7, 2), (8, 2), (9, 2), (10, 2), (11, 2);

-- Pokrewieństwa
INSERT INTO Pokrewienstwa (Stopien_Pokrewienstwa) VALUES 
('rodzic'), ('dziecko'), ('rodzeństwo');

-- Pokrewieństwa rodziny Kowalskich
INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) VALUES
-- Jan i Maria -> Piotr i Anna
(1, 1, 3), (2, 1, 3),
(1, 1, 4), (2, 1, 4),
-- Piotr i Anna są rodzeństwem
(3, 3, 4), (4, 3, 3),
-- Piotr i Anna -> Marek i Ola
(3, 1, 5), (4, 1, 5),
(3, 1, 6), (4, 1, 6),
-- Marek i Ola są rodzeństwem
(5, 3, 6), (6, 3, 5);

-- Pokrewieństwa rodziny Nowaków
INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) VALUES
-- Andrzej i Elżbieta -> Tomasz i Katarzyna
(7, 1, 9), (8, 1, 9),
(7, 1, 10), (8, 1, 10),
-- Tomasz i Katarzyna są rodzeństwem
(9, 3, 10), (10, 3, 9),
-- Tomasz i Katarzyna -> Julia
(9, 1, 11), (10, 1, 11);

-- Miejsca
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES
('Warszawa', 'Szpital wojewódzki, miejsce urodzenia', POINT(21.0122, 52.2297)),  -- ID 1
('Kraków', 'Kościół Mariacki, miejsce ślubu', POINT(19.9400, 50.0614)),          -- ID 2
('Poznań', 'Cmentarz komunalny', POINT(16.9252, 52.4064));                      -- ID 3

-- Zdarzenia
INSERT INTO Zdarzenia (ID_Miejsce, Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) VALUES
(1, 'Narodziny Marka Kowalskiego', 'Marek przyszedł na świat w szpitalu w Warszawie', '2000-12-01'),
(2, 'Ślub Piotra i Anny Kowalskich', 'Piotr i Anna zawarli małżeństwo w Krakowie', '1999-05-15'),
(1, 'Narodziny Julii Nowak', 'Julia urodziła się w Warszawie', '2010-10-10');

-- Osoby_Zdarzenia
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES
(5, 1),
(3, 2), (4, 2),
(11, 3);


-- Zwiazki
INSERT INTO Zwiazki (Typ_Relacji, Data_Rozpoczecia, Data_Zakonczenia, Powod_Zakonczenia) VALUES
('małżeństwo', '1974-06-10', NULL, NULL),  -- Jan i Maria Kowalscy
('małżeństwo', '1998-04-22', NULL, NULL),  -- Piotr i Anna Kowalscy
('małżeństwo', '1984-09-01', NULL, NULL),  -- Andrzej i Elżbieta Nowak
('związek nieformalny', '2009-01-01', '2011-12-31', 'rozstanie');  -- Tomasz i Katarzyna Nowak

-- Osoby_Zwiazki
INSERT INTO Osoby_Zwiazki (ID_Osoba, ID_Zwiazek) VALUES
(1, 1), (2, 1),
(3, 2), (4, 2),
(7, 3), (8, 3),
(9, 4), (10, 4);

-- Fotografie
INSERT INTO Fotografie (Plik, Opis_Zdjecia, Data_Wykonania, ID_Miejsce) VALUES
(E'\\x', 'Zdjęcie ze ślubu Piotra i Anny', '1999-05-15', 2),  -- ID 1
(E'\\x', 'Noworodek Marek w szpitalu', '2000-12-01', 1),       -- ID 2
(E'\\x', 'Rodzina Nowaków w parku', '2010-10-10', 1);          -- ID 3

-- Zdarzenia_Fotografie
INSERT INTO Zdarzenia_Fotografie (ID_Zdjecie, ID_Zdarzenie) VALUES
(1, 2),
(2, 1),
(3, 3);

-- Osoby_Fotografie
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES
(3, 1), (4, 1),
(5, 2),
(7, 3), (8, 3), (9, 3), (10, 3), (11, 3);
