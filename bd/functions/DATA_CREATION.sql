-- Dodanie nowej osoby
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) 
VALUES ('Paweł', 'Kowalski', NULL, '2020-06-01', NULL);

-- Przypisanie osoby do rodziny (np. ID_Osoba = 11, ID_Rodziny = 1)
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (11, 1);

-- Dodanie pokrewieństwa (rodzic-dziecko)
-- Załóżmy, że ID_Osoba_1 = 1 (rodzic), ID_Osoba_2 = 11 (dziecko), ID_Pokrewienstwo = 1 (rodzic)
INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) 
VALUES (1, 1, 11);

-- Dodanie nowego miejsca
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) 
VALUES ('Gdańsk', 'Nowe miejsce wydarzenia', POINT(18.6466, 54.3520));

-- Dodanie nowego zdarzenia
-- Załóżmy, że ID_Miejsce = 4 (nowo dodane miejsce)
INSERT INTO Zdarzenia (ID_Miejsce, Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) 
VALUES (4, 'Nowe wydarzenie', 'Opis nowego wydarzenia', '2025-05-29');

-- Przypisanie osoby do zdarzenia
-- Załóżmy, że ID_Osoba = 11, ID_Zdarzenie = 4
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (11, 4);
