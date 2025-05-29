-- Historia związków danej osoby (np. ID_Osoba = 3)
SELECT 
    o.Imie || ' ' || o.Nazwisko AS Osoba,
    z.Typ_Relacji,
    z.Data_Rozpoczecia,
    z.Data_Zakonczenia,
    z.Powod_Zakonczenia,
    p.Imie || ' ' || p.Nazwisko AS Partner
FROM Osoby_Zwiazki oz
JOIN Zwiazki z ON oz.ID_Zwiazek = z.ID_Zwiazek
JOIN Osoby o ON oz.ID_Osoba = o.ID_Osoba
JOIN Osoby_Zwiazki partner ON partner.ID_Zwiazek = z.ID_Zwiazek AND partner.ID_Osoba != oz.ID_Osoba
JOIN Osoby p ON p.ID_Osoba = partner.ID_Osoba
WHERE oz.ID_Osoba = 3;

-- Członkowie danej rodziny posortowani według wieku (np. ID_Rodziny = 1)
SELECT 
    o.Imie, o.Nazwisko, o.Data_Urodzenia,
    DATE_PART('year', AGE(o.Data_Urodzenia)) AS Wiek
FROM Osoby o
JOIN Osoby_Rodziny orz ON o.ID_Osoba = orz.ID_Osoba
WHERE orz.ID_Rodziny = 1
ORDER BY o.Data_Urodzenia;

-- Zdarzenia oraz rola pełniona przez każdą osobę
SELECT 
    o.Imie || ' ' || o.Nazwisko AS Osoba,
    z.Nazwa_Zdarzenia,
    z.Data_Zdarzenia,
    z.Opis_Zdarzenia,
    m.Nazwa_Miejsca
FROM Osoby_Zdarzenia oz
JOIN Osoby o ON oz.ID_Osoba = o.ID_Osoba
JOIN Zdarzenia z ON oz.ID_Zdarzenie = z.ID_Zdarzenie
LEFT JOIN Miejsca m ON z.ID_Miejsce = m.ID_Miejsce
ORDER BY o.Nazwisko, z.Data_Zdarzenia;

-- Fotografie danej osoby i związane z nimi miejsca/zdarzenia (np. ID_Osoba = 3)
SELECT 
    f.ID_Zdjecie,
    f.Opis_Zdjecia,
    f.Data_Wykonania,
    m.Nazwa_Miejsca,
    z.Nazwa_Zdarzenia
FROM Osoby_Fotografie ofo
JOIN Fotografie f ON f.ID_Zdjecie = ofo.ID_Zdjecie
LEFT JOIN Miejsca m ON f.ID_Miejsce = m.ID_Miejsce
LEFT JOIN Zdarzenia_Fotografie zf ON zf.ID_Zdjecie = f.ID_Zdjecie
LEFT JOIN Zdarzenia z ON z.ID_Zdarzenie = zf.ID_Zdarzenie
WHERE ofo.ID_Osoba = 3;

-- Pełne drzewo genealogiczne dla danej osoby (np. ID_Osoba = 5)
WITH RECURSIVE Genealogia AS (
    SELECT 
        o.ID_Osoba,
        o.Imie,
        o.Nazwisko,
        0 AS Poziom
    FROM Osoby o
    WHERE o.ID_Osoba = 5

    UNION ALL

    SELECT 
        o2.ID_Osoba,
        o2.Imie,
        o2.Nazwisko,
        g.Poziom + 1
    FROM Genealogia g
    JOIN Osoby_Pokrewienstwa op ON op.ID_Osoba_2 = g.ID_Osoba AND op.ID_Pokrewienstwo = 1  -- tylko rodzice
    JOIN Osoby o2 ON o2.ID_Osoba = op.ID_Osoba_1
)
SELECT * FROM Genealogia ORDER BY Poziom;
