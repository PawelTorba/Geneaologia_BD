---Zapytanie zwraca wszystkich przodków danej osoby, pokolenie po pokoleniu.
 1  WITH RECURSIVE przodkowie AS (
 2      SELECT
 3          op.ID_Osoba_2 AS id_przodka,
 4          1             AS pokolenie
 5      FROM Osoby_Pokrewienstwa op
 6      JOIN Pokrewienstwa pk ON pk.ID_Pokrewienstwo = op.ID_Pokrewienstwo
 7      WHERE op.ID_Osoba_1 = :osoba_id
 8        AND pk.Stopien_Pokrewienstwa = 'rodzic'
 9  
10      UNION ALL
11  
12      SELECT
13          op.ID_Osoba_2,
14          p.pokolenie + 1
15      FROM przodkowie p
16      JOIN Osoby_Pokrewienstwa op
17            ON op.ID_Osoba_1 = p.id_przodka
18      JOIN Pokrewienstwa pk
19            ON pk.ID_Pokrewienstwo = op.ID_Pokrewienstwo
20      WHERE pk.Stopien_Pokrewienstwa = 'rodzic'
21        AND (:g IS NULL OR p.pokolenie < :g)
22  )
23  SELECT
24      o.ID_Osoba,
25      o.Imie,
26      o.Nazwisko,
27      pokolenie
28  FROM przodkowie
29  JOIN Osoby o ON o.ID_Osoba = id_przodka
30  ORDER BY pokolenie, Nazwisko, Imie;


---Zapytanie znajduje pierwszego wspólnego przodka dla dwóch zadanych osbób.
 1  WITH RECURSIVE p1 AS (
 2      SELECT op.ID_Osoba_2 AS id_przodka
 3      FROM Osoby_Pokrewienstwa op
 4      JOIN Pokrewienstwa pk ON pk.ID_Pokrewienstwo = op.ID_Pokrewienstwo
 5      WHERE op.ID_Osoba_1 = :osoba1 AND pk.Stopien_Pokrewienstwa = 'rodzic'
 6      UNION
 7      SELECT op.ID_Osoba_2 FROM Osoby_Pokrewienstwa op
 8      JOIN p1 ON op.ID_Osoba_1 = p1.id_przodka
 9      JOIN Pokrewienstwa pk ON pk.ID_Pokrewienstwo = op.ID_Pokrewienstwo
10      WHERE pk.Stopien_Pokrewienstwa = 'rodzic'
11  ),
12  p2 AS (
13      SELECT op.ID_Osoba_2 AS id_przodka
14      FROM Osoby_Pokrewienstwa op
15      JOIN Pokrewienstwa pk ON pk.ID_Pokrewienstwo = op.ID_Pokrewienstwo
16      WHERE op.ID_Osoba_1 = :osoba2 AND pk.Stopien_Pokrewienstwa = 'rodzic'
17      UNION
18      SELECT op.ID_Osoba_2 FROM Osoby_Pokrewienstwa op
19      JOIN p2 ON op.ID_Osoba_1 = p2.id_przodka
20      JOIN Pokrewienstwa pk ON pk.ID_Pokrewienstwo = op.ID_Pokrewienstwo
21      WHERE pk.Stopien_Pokrewienstwa = 'rodzic'
22  )
23  SELECT o.*
24  FROM Osoby o
25  WHERE o.ID_Osoba IN (SELECT id_przodka FROM p1)
26    AND o.ID_Osoba IN (SELECT id_przodka FROM p2)
27  ORDER BY (SELECT COUNT(*) FROM p1 WHERE id_przodka = o.ID_Osoba) +
28           (SELECT COUNT(*) FROM p2 WHERE id_przodka = o.ID_Osoba)
29  LIMIT 1;


---Układa oś czasu wydarzeń dla zadanej rodziny.
 1  SELECT
 2      z.Data_Zdarzenia,
 3      z.Nazwa_Zdarzenia,
 4      z.Opis_Zdarzenia,
 5      STRING_AGG(o.Imie || ' ' || o.Nazwisko, ', ') AS Uczestnicy
 6  FROM Rodziny r
 7  JOIN Osoby_Rodziny orz ON orz.ID_Rodzina = r.ID_Rodzina
 8  JOIN Osoby_Zdarzenia oz  ON oz.ID_Osoba = orz.ID_Osoba
 9  JOIN Zdarzenia z ON z.ID_Zdarzenie = oz.ID_Zdarzenie
10  JOIN Osoby o ON o.ID_Osoba = orz.ID_Osoba
11  WHERE r.ID_Rodzina = :rodzina_id
12  GROUP BY z.ID_Zdarzenie
13  ORDER BY z.Data_Zdarzenia;
