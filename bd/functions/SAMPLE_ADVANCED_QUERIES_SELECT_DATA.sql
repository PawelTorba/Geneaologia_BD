---Zapytanie zwraca wszystkich przodków danej osoby, pokolenie po pokoleniu.
  WITH RECURSIVE
  
      mapa(stopien, skok) AS (
          VALUES ('ojciec',1), ('matka',1),
                 ('dziadek',2), ('babcia',2),
                 ('pradziadek',3), ('prababcia',3)
      ),
  
      przodkowie(id_osoba, pokolenie, sciezka) AS (          
          SELECT
              :id_osoba,
              0,
              ARRAY[:id_osoba]
  
          UNION ALL
  
          SELECT
              op.id_osoba_2,
              p.pokolenie + m.skok,
              p.sciezka || op.id_osoba_2
          FROM   przodkowie p
          JOIN   osoby_pokrewienstwa op
                 ON op.id_osoba_1 = p.id_osoba
          JOIN   pokrewienstwa pk
                 ON pk.id_pokrewienstwo = op.id_pokrewienstwo
          JOIN   mapa m
                ON m.stopien = pk.stopien_pokrewienstwa
          WHERE  NOT op.id_osoba_2 = ANY(p.sciezka)           
      )
  
  SELECT   o.id_osoba,
           o.imie,
           o.nazwisko,
           MIN(pokolenie) AS pokolenie                       
  FROM     przodkowie p
  JOIN     osoby o ON o.id_osoba = p.id_osoba                
  GROUP BY o.id_osoba, o.imie, o.nazwisko
  ORDER BY pokolenie, o.nazwisko, o.imie;


---Zapytanie znajduje pierwszego wspólnego przodka dla dwóch zadanych osbób.
  --  :p1  – ID pierwszej osoby
  --  :p2  – ID drugiej osoby
  WITH RECURSIVE
  p1(anc_id, gen, path) AS (
      -- SELF (generacja 0)
      SELECT :p1, 0, ARRAY[5]        
      UNION ALL
      -- RODZICE, DZIADKOWIE, …
      SELECT op.id_osoba_2,
             p1.gen + 1,
             path || op.id_osoba_2     
      FROM   p1
      JOIN   osoby_pokrewienstwa op
             ON op.id_osoba_1       = p1.anc_id
            AND op.id_pokrewienstwo IN (5,6)      
      WHERE  NOT op.id_osoba_2 = ANY(path)        
  ),
  p2(anc_id, gen, path) AS (
      SELECT :p2, 0, ARRAY[:p2]
      UNION ALL
      SELECT op.id_osoba_2,
             p2.gen + 1,
             path || op.id_osoba_2
      FROM   p2
      JOIN   osoby_pokrewienstwa op
             ON op.id_osoba_1       = p2.anc_id
            AND op.id_pokrewienstwo IN (5,6)
      WHERE  NOT op.id_osoba_2 = ANY(path)
  )
  SELECT   o.id_osoba,
           o.imie,
           o.nazwisko,
           p1.gen AS gen_p1,
           p2.gen AS gen_p2
  FROM     p1
  JOIN     p2 USING (anc_id)          
  JOIN     osoby o ON o.id_osoba = p1.anc_id
  ORDER BY (p1.gen + p2.gen)          
  LIMIT 1;

---Układa oś czasu wydarzeń dla zadanej rodziny.
  SELECT   z.data_zdarzenia,
           z.nazwa_zdarzenia,
           z.opis_zdarzenia,
           string_agg(DISTINCT o.imie || ' ' || o.nazwisko, ', ') AS uczestnicy
  FROM     rodziny            r
  JOIN     osoby_rodziny      orz ON orz.id_rodzina   = r.id_rodzina
  JOIN     osoby              o   ON o.id_osoba       = orz.id_osoba
  JOIN     osoby_zdarzenia    oz  ON oz.id_osoba      = o.id_osoba
  JOIN     zdarzenia          z   ON z.id_zdarzenie   = oz.id_zdarzenie
  WHERE    r.id_rodzina = :family_id
  GROUP BY z.id_zdarzenie
  ORDER BY z.data_zdarzenia;
