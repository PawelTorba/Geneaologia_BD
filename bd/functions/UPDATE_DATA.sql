-- Aktualizacja daty zgonu osoby (np. ID_Osoba = 1)
UPDATE Osoby
SET Data_Zgonu = '2023-05-01'
WHERE ID_Osoba = 1;

-- Przypisanie osoby do nowej rodziny (np. ID_Osoba = 11, ID_Rodziny = 2)
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (11, 2);

-- Zmiana opisu miejsca (np. ID_Miejsce = 1)
UPDATE Miejsca
SET Opis = 'Zaktualizowany opis miejsca'
WHERE ID_Miejsce = 1;
