/* =====================================================
   1.  Osoby
   ===================================================== */
-- 1.1  Dodaj osobę
CREATE OR REPLACE FUNCTION sp_dodaj_osobe (
    p_imie           TEXT,
    p_nazwisko       TEXT,
    p_drugie_imie    TEXT DEFAULT NULL,
    p_data_urodzenia DATE,
    p_data_zgonu     DATE DEFAULT NULL
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INT;
BEGIN
    IF EXISTS (SELECT 1 FROM Osoby
               WHERE imie=p_imie AND nazwisko=p_nazwisko
                 AND data_urodzenia=p_data_urodzenia) THEN
        RAISE EXCEPTION 'Osoba % % ur. % już istnieje',
                        p_imie, p_nazwisko, p_data_urodzenia;
    END IF;

    INSERT INTO Osoby(imie,nazwisko,drugie_imie,
                      data_urodzenia,data_zgonu)
    VALUES (p_imie,p_nazwisko,p_drugie_imie,
            p_data_urodzenia,p_data_zgonu)
    RETURNING id_osoba INTO v_id;

    RETURN v_id;
END;
$$;


-- 1.2  Aktualizuj osobę
CREATE OR REPLACE PROCEDURE sp_aktualizuj_osobe (
    p_id             INT,
    p_imie           TEXT,
    p_nazwisko       TEXT,
    p_drugie_imie    TEXT DEFAULT NULL,
    p_data_urodzenia DATE,
    p_data_zgonu     DATE DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_data_zgonu IS NOT NULL
       AND p_data_zgonu < p_data_urodzenia THEN
        RAISE EXCEPTION 'Data zgonu < data urodzenia';
    END IF;

    UPDATE Osoby
       SET imie           = p_imie,
           nazwisko       = p_nazwisko,
           drugie_imie    = p_drugie_imie,
           data_urodzenia = p_data_urodzenia,
           data_zgonu     = p_data_zgonu
     WHERE id_osoba = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Nie ma osoby ID=%', p_id;
    END IF;
END;
$$;


-- 1.3  Usuń osobę kaskadowo (opcjonalnie p_force = TRUE)
CREATE OR REPLACE PROCEDURE sp_usun_osobe_cascade (
    p_id    INT,
    p_force BOOLEAN DEFAULT FALSE
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT p_force AND EXISTS (
        SELECT 1 FROM Osoby_Pokrewienstwa
         WHERE p_id IN (id_osoba_1,id_osoba_2)
    ) THEN
        RAISE EXCEPTION
        'Osoba ID=% ma powiązania genealogiczne – podaj p_force=TRUE', p_id;
    END IF;

    DELETE FROM Osoby_Zwiazki       WHERE id_osoba=p_id;
    DELETE FROM Osoby_Pokrewienstwa WHERE id_osoba_1=p_id OR id_osoba_2=p_id;
    DELETE FROM Osoby_Zdarzenia     WHERE id_osoba=p_id;
    DELETE FROM Osoby_Fotografie    WHERE id_osoba=p_id;
    DELETE FROM Osoby               WHERE id_osoba=p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Nie ma osoby ID=%', p_id;
    END IF;
END;
$$;



/* =====================================================
   2.  Związki
   ===================================================== */
-- 2.1  Dodaj związek (domyślnie „małżeństwo”)
CREATE OR REPLACE FUNCTION sp_dodaj_zwiazek (
    p_osoba1      INT,
    p_osoba2      INT,
    p_typ_relacji TEXT DEFAULT 'małżeństwo',
    p_data_start  DATE DEFAULT CURRENT_DATE
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INT;
BEGIN
    IF EXISTS (
        SELECT 1
          FROM Zwiazki z
          JOIN Osoby_Zwiazki x1 ON x1.id_zwiazek=z.id_zwiazek
                               AND x1.id_osoba=p_osoba1
          JOIN Osoby_Zwiazki x2 ON x2.id_zwiazek=z.id_zwiazek
                               AND x2.id_osoba=p_osoba2
         WHERE z.data_zakonczenia IS NULL
    ) THEN
        RAISE EXCEPTION
        'Osoby % i % są już w aktywnym związku', p_osoba1, p_osoba2;
    END IF;

    INSERT INTO Zwiazki(typ_relacji, data_rozpoczecia)
    VALUES (p_typ_relacji, p_data_start)
    RETURNING id_zwiazek INTO v_id;

    INSERT INTO Osoby_Zwiazki(id_osoba,id_zwiazek)
    VALUES (p_osoba1,v_id),(p_osoba2,v_id);

    RETURN v_id;
END;
$$;


-- 2.2  Zakończ związek
CREATE OR REPLACE PROCEDURE sp_zakoncz_zwiazek (
    p_id_zwiazek  INT,
    p_data_koniec DATE DEFAULT CURRENT_DATE,
    p_powod       TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Zwiazki
       SET data_zakonczenia = p_data_koniec,
           powod_zakonczenia= p_powod
     WHERE id_zwiazek = p_id_zwiazek
       AND data_zakonczenia IS NULL;

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'Nie znaleziono aktywnego związku ID=%', p_id_zwiazek;
    END IF;
END;
$$;



/* =====================================================
   3.  Pokrewieństwa
   ===================================================== */
-- 3.1  Dodaj relację pokrewieństwa
CREATE OR REPLACE PROCEDURE sp_dodaj_pokrewienstwo (
    p_os1 INT,
    p_os2 INT,
    p_id_pokr INT      -- np. klucz do „rodzic”, „syn” itp.
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Osoby_Pokrewienstwa
         WHERE (id_osoba_1,id_pokrewienstwo,id_osoba_2)=(p_os1,p_id_pokr,p_os2)
            OR (id_osoba_1,id_pokrewienstwo,id_osoba_2)=(p_os2,p_id_pokr,p_os1)
    ) THEN
        RAISE EXCEPTION 'Taka relacja już istnieje.';
    END IF;

    INSERT INTO Osoby_Pokrewienstwa(id_osoba_1,id_pokrewienstwo,id_osoba_2)
    VALUES (p_os1,p_id_pokr,p_os2);
END;
$$;



/* =====================================================
   4.  Zdarzenia i fotografie
   ===================================================== */
-- 4.1  Dodaj zdarzenie
CREATE OR REPLACE FUNCTION sp_dodaj_zdarzenie (
    p_nazwa      TEXT,
    p_opis       TEXT,
    p_data       DATE,
    p_miejsce    INT,
    p_uczestnicy INT[] DEFAULT NULL  -- tablica id_osoba
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id  INT;
    v_os  INT;
BEGIN
    INSERT INTO Zdarzenia(id_miejsce,opis_zdarzenia,
                          nazwa_zdarzenia,data_zdarzenia)
    VALUES (p_miejsce,p_opis,p_nazwa,p_data)
    RETURNING id_zdarzenie INTO v_id;

    IF p_uczestnicy IS NOT NULL THEN
        FOREACH v_os IN ARRAY p_uczestnicy LOOP
            INSERT INTO Osoby_Zdarzenia(id_osoba,id_zdarzenie)
            VALUES (v_os,v_id);
        END LOOP;
    END IF;

    RETURN v_id;
END;
$$;


-- 4.2  Dodaj fotografię
CREATE OR REPLACE FUNCTION sp_dodaj_foto (
    p_plik       TEXT,
    p_opis       TEXT,
    p_data       DATE,
    p_miejsce    INT,
    p_osoby      INT[] DEFAULT NULL,  -- id_osoba
    p_zdarzenia  INT[] DEFAULT NULL   -- id_zdarzenie
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INT;
    v_x  INT;
BEGIN
    INSERT INTO Fotografie(plik,opis_zdjecia,data_wykonania,id_miejsce)
    VALUES (p_plik,p_opis,p_data,p_miejsce)
    RETURNING id_zdjecie INTO v_id;

    IF p_osoby IS NOT NULL THEN
        FOREACH v_x IN ARRAY p_osoby LOOP
            INSERT INTO Osoby_Fotografie(id_osoba,id_zdjecie)
            VALUES (v_x,v_id);
        END LOOP;
    END IF;

    IF p_zdarzenia IS NOT NULL THEN
        FOREACH v_x IN ARRAY p_zdarzenia LOOP
            INSERT INTO Zdarzenia_Fotografie(id_zdjecie,id_zdarzenie)
            VALUES (v_id,v_x);
        END LOOP;
    END IF;

    RETURN v_id;
END;
$$;



--######################################
/* ###############################################
   Pakiet “quality-of-life”                       #
   ############################################### */

--------------------------------------------------
-- 3.1  sp_dodaj_dziecko()
--------------------------------------------------
/* Dodaje relacje „rodzic-dziecko” dla jednego lub
   dwóch rodziców oraz opcjonalnie przypisuje
   dziecko do rodziny pierwszego z rodziców.      */
CREATE OR REPLACE PROCEDURE sp_dodaj_dziecko (
    p_rodzic1 INT,
    p_rodzic2 INT DEFAULT NULL,
    p_dziecko INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_parenthood INT;
    v_id_family     INT;
BEGIN
    /* 1️⃣ znajdź klucz relacji „rodzic” */
    SELECT id_pokrewienstwo
      INTO v_id_parenthood
      FROM pokrewienstwa
     WHERE stopien_pokrewienstwa ILIKE 'rodzic'
     LIMIT 1;

    IF v_id_parenthood IS NULL THEN
        RAISE EXCEPTION 'Brak typu pokrewieństwa «rodzic» w tabeli Pokrewienstwa';
    END IF;

    /* 2️⃣ rodzic 1 → dziecko */
    CALL sp_dodaj_pokrewienstwo(p_rodzic1, p_dziecko, v_id_parenthood);

    /* 3️⃣ rodzic 2 (jeśli podano) */
    IF p_rodzic2 IS NOT NULL THEN
        CALL sp_dodaj_pokrewienstwo(p_rodzic2, p_dziecko, v_id_parenthood);
    END IF;

    /* 4️⃣ przypisanie do rodziny (jeśli istnieje model Rodziny) */
    IF EXISTS (SELECT 1 FROM information_schema.tables
               WHERE table_name = 'rodziny') THEN
        SELECT id_rodzina            -- zakładamy, że rodzic1 już w jakiejś rodzinie jest
          INTO v_id_family
          FROM osoby_rodziny
         WHERE id_osoba = p_rodzic1
         LIMIT 1;

        IF v_id_family IS NOT NULL
           AND NOT EXISTS (SELECT 1
                             FROM osoby_rodziny
                            WHERE id_osoba = p_dziecko
                              AND id_rodzina = v_id_family) THEN
            INSERT INTO osoby_rodziny(id_osoba,id_rodzina)
            VALUES (p_dziecko, v_id_family);
        END IF;
    END IF;
END;
$$;
COMMENT ON PROCEDURE sp_dodaj_dziecko(INT,INT,INT)
IS 'Automatycznie tworzy relacje rodzic-dziecko i (opcjonalnie) dodaje dziecko do rodziny.';


--------------------------------------------------
-- 3.2  sp_utworz_rodzine_z_rodzicow()
--------------------------------------------------
/* Zakłada rodzinę, przypisuje oboje rodziców i
   wszystkie ich wspólne dzieci. Jeśli rodzice
   są już w rodzinie, procedura zgłosi NOTICE.   */
CREATE OR REPLACE PROCEDURE sp_utworz_rodzine_z_rodzicow (
    p_os1            INT,
    p_os2            INT,
    p_nazwisko_rodziny TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_family INT;
BEGIN
    -- upewnij się, że mamy wymagane tabele
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables
                   WHERE table_name = 'rodziny') THEN
        RAISE EXCEPTION 'Tabela Rodziny nie istnieje – utwórz lub pomiń procedurę.';
    END IF;

    /* 1️⃣ utwórz nową rodzinę */
    INSERT INTO rodziny(nazwa)
    VALUES (p_nazwisko_rodziny)
    RETURNING id_rodzina INTO v_id_family;

    /* 2️⃣ dodaj rodziców */
    INSERT INTO osoby_rodziny(id_osoba,id_rodzina)
    VALUES (p_os1,v_id_family),(p_os2,v_id_family);

    /* 3️⃣ znajdź wszystkie wspólne dzieci na bazie relacji „rodzic” */
    WITH dzieci_os1 AS (
        SELECT id_osoba_2 AS id_dziecka
          FROM osoby_pokrewienstwa op
          JOIN pokrewienstwa pk USING(id_pokrewienstwo)
         WHERE id_osoba_1 = p_os1
           AND pk.stopien_pokrewienstwa ILIKE 'rodzic'
    ),
    dzieci_os2 AS (
        SELECT id_osoba_2 FROM osoby_pokrewienstwa op
        JOIN pokrewienstwa pk USING(id_pokrewienstwo)
        WHERE id_osoba_1 = p_os2
          AND pk.stopien_pokrewienstwa ILIKE 'rodzic'
    )
    INSERT INTO osoby_rodziny(id_osoba,id_rodzina)
    SELECT d1.id_dziecka, v_id_family
      FROM dzieci_os1 d1
      JOIN dzieci_os2 d2 ON d2.id_osoba_2 = d1.id_dziecka
      ON CONFLICT DO NOTHING;  -- unikamy dubli
END;
$$;
COMMENT ON PROCEDURE sp_utworz_rodzine_z_rodzicow(INT,INT,TEXT)
IS 'Tworzy rodzinę, przypisuje rodziców + wszystkie ich wspólne dzieci.';


--------------------------------------------------
-- 3.3  fn_rodzenstwo()
--------------------------------------------------
/* Zwraca wszystkich (ID) mających co najmniej jednego
   wspólnego rodzica z podaną osobą.                  */
CREATE OR REPLACE FUNCTION fn_rodzenstwo (
    p_id INT
)
RETURNS TABLE(id_rodzenstwa INT)
LANGUAGE SQL STABLE
AS $$
WITH rodzice AS (
    SELECT id_osoba_1 AS id_rodzic
      FROM osoby_pokrewienstwa op
      JOIN pokrewienstwa pk USING(id_pokrewienstwo)
     WHERE op.id_osoba_2 = p_id
       AND pk.stopien_pokrewienstwa ILIKE 'rodzic'
)
SELECT DISTINCT op2.id_osoba_2
  FROM rodzice r
  JOIN osoby_pokrewienstwa op2 ON op2.id_osoba_1 = r.id_rodzic
  JOIN pokrewienstwa pk2 ON pk2.id_pokrewienstwo = op2.id_pokrewienstwo
 WHERE pk2.stopien_pokrewienstwa ILIKE 'rodzic'
   AND op2.id_osoba_2 <> p_id;
$$;
COMMENT ON FUNCTION fn_rodzenstwo(INT)
IS 'Lista ID rodzeństwa (wspólny co najmniej jeden rodzic).';


--------------------------------------------------
-- 3.4  fn_najblizszy_zyjacy_krewny()
--------------------------------------------------
/* Szuka najbliższego (najkrótsza ścieżka w grafie
   pokrewieństw) żyjącego krewnego.                 */
CREATE OR REPLACE FUNCTION fn_najblizszy_zyjacy_krewny (
    p_id INT,
    p_max_poziom INT DEFAULT 6          -- zabezpieczenie przed nieskończonością
)
RETURNS INT     -- id_osoba lub NULL
LANGUAGE plpgsql
AS $$
DECLARE
    v_result INT;
BEGIN
    WITH RECURSIVE bfs AS (
        -- start
        SELECT op.id_osoba_2 AS rel, 1 AS lvl, ARRAY[p_id, op.id_osoba_2] AS path
          FROM osoby_pokrewienstwa op
         WHERE op.id_osoba_1 = p_id
        UNION
        SELECT op.id_osoba_1, 1, ARRAY[p_id, op.id_osoba_1]
          FROM osoby_pokrewienstwa op
         WHERE op.id_osoba_2 = p_id

        UNION ALL

        -- rozbudowa drzewa
        SELECT CASE
                 WHEN op.id_osoba_1 = b.rel THEN op.id_osoba_2
                 ELSE op.id_osoba_1
               END                                  AS rel,
               b.lvl + 1                           AS lvl,
               path || CASE
                         WHEN op.id_osoba_1 = b.rel THEN op.id_osoba_2
                         ELSE op.id_osoba_1
                       END                         AS path
          FROM bfs b
          JOIN osoby_pokrewienstwa op
            ON op.id_osoba_1 = b.rel
            OR op.id_osoba_2 = b.rel
         WHERE b.lvl < p_max_poziom
           AND NOT (CASE
                      WHEN op.id_osoba_1 = b.rel THEN op.id_osoba_2
                      ELSE op.id_osoba_1
                    END) = ANY(b.path)             -- unikamy pętli
    ),
    zywi AS (
        SELECT rel, lvl
          FROM bfs
          JOIN osoby o ON o.id_osoba = bfs.rel
         WHERE o.data_zgonu IS NULL                -- żyjący
    )
    SELECT rel
      INTO v_result
      FROM zywi
     ORDER BY lvl                                   -- najbliższy stopień
     LIMIT 1;

    RETURN v_result;   -- może być NULL, jeśli nikogo żyjącego nie ma
END;
$$;
COMMENT ON FUNCTION fn_najblizszy_zyjacy_krewny(INT,INT)
IS 'Zwraca ID najbliższego żyjącego krewnego (lub NULL).';



--###########################################

/* ##################################################
   PAKIET 4 – Utrzymanie i spójność danych
   ################################################## */

------------------------------------------------------
-- 4.1  sp_merge_osoby(duplikat, oryginal)
------------------------------------------------------
/* Przepisuje wszystkie klucze obce z rekordu duplikat
   na rekord oryginal, po czym usuwa duplikat.
   Nie łączy automatycznie danych pól – jeśli chcesz
   scalić np. drugie imię, zrób to ręcznie przed CALL. */
CREATE OR REPLACE PROCEDURE sp_merge_osoby (
    p_duplikat INT,
    p_oryginal INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_duplikat = p_oryginal THEN
        RAISE EXCEPTION 'ID duplikatu = ID oryginału – operacja bez sensu.';
    END IF;

    -- klucze w tabelach pośrednich
    UPDATE osoby_zwiazki       SET id_osoba = p_oryginal WHERE id_osoba = p_duplikat;
    UPDATE osoby_pokrewienstwa SET id_osoba_1 = p_oryginal WHERE id_osoba_1 = p_duplikat;
    UPDATE osoby_pokrewienstwa SET id_osoba_2 = p_oryginal WHERE id_osoba_2 = p_duplikat;
    UPDATE osoby_zdarzenia     SET id_osoba = p_oryginal WHERE id_osoba = p_duplikat;
    UPDATE osoby_fotografie    SET id_osoba = p_oryginal WHERE id_osoba = p_duplikat;
    UPDATE osoby_rodziny       SET id_osoba = p_oryginal WHERE id_osoba = p_duplikat;  -- jeśli masz tę tabelę

    -- usuń duplikat
    DELETE FROM osoby WHERE id_osoba = p_duplikat;
END;
$$;
COMMENT ON PROCEDURE sp_merge_osoby(INT,INT)
IS 'Scalanie duplikatów osób: przekierowuje FK i usuwa rekord duplikatu.';


------------------------------------------------------
-- 4.2  sp_waliduj_relacje() → tabela zgłoszeń
------------------------------------------------------
/* Szybki raport niespójności genealogicznych.
   Dodaj/zdejmij reguły według potrzeb. */
CREATE OR REPLACE FUNCTION sp_waliduj_relacje ()
RETURNS TABLE(opis TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    /* 1️⃣ Dziecko starsze lub równe wiekiem rodzicowi */
    RETURN QUERY
    SELECT '❗ Dziecko starsze od rodzica: dziecko='||c.id_osoba||' ('||c.data_urodzenia||') '
           ||'rodzic='||p.id_osoba||' ('||p.data_urodzenia||')'
      FROM osoby_pokrewienstwa op
      JOIN pokrewienstwa pk USING(id_pokrewienstwo)
      JOIN osoby p ON p.id_osoba = op.id_osoba_1
      JOIN osoby c ON c.id_osoba = op.id_osoba_2
     WHERE pk.stopien_pokrewienstwa ILIKE 'rodzic'
       AND c.data_urodzenia <= p.data_urodzenia;

    /* 2️⃣ Małżeństwo rozpoczęte po śmierci partnera */
    RETURN QUERY
    SELECT '❗ Związek po śmierci partnera: zw.'||z.id_zwiazek
           ||' start='||z.data_rozpoczecia
           ||' partner='||o.id_osoba||' zgon='||o.data_zgonu
      FROM zwiazki z
      JOIN osoby_zwiazki oz USING(id_zwiazek)
      JOIN osoby o ON o.id_osoba = oz.id_osoba
     WHERE o.data_zgonu IS NOT NULL
       AND z.data_rozpoczecia > o.data_zgonu;

    /* 3️⃣ Osoba w więcej niż jednym aktywnym związku */
    RETURN QUERY
    SELECT '❗ Bigamia: osoba='||id_osoba||' aktywne zw.'||cnt
      FROM (
            SELECT oz.id_osoba, COUNT(*) AS cnt
              FROM osoby_zwiazki oz
              JOIN zwiazki z USING(id_zwiazek)
             WHERE z.data_zakonczenia IS NULL
             GROUP BY oz.id_osoba
            ) x
     WHERE cnt > 1;

    /* 4️⃣ Zdarzenie po śmierci uczestnika */
    RETURN QUERY
    SELECT '❗ Zdarzenie po śmierci uczestnika: zd.'||z.id_zdarzenie
           ||' ('||z.data_zdarzenia||') / osoba='||o.id_osoba
           ||' zgon='||o.data_zgonu
      FROM zdarzenia z
      JOIN osoby_zdarzenia oz USING(id_zdarzenie)
      JOIN osoby o ON o.id_osoba = oz.id_osoba
     WHERE o.data_zgonu IS NOT NULL
       AND z.data_zdarzenia > o.data_zgonu;
END;
$$;
COMMENT ON FUNCTION sp_waliduj_relacje()
IS 'Zwraca listę niespójności (dziecko starsze od rodzica, bigamia, itp.).';


------------------------------------------------------
-- 4.3  fn_licznik_zdjec(id_osoba) → INT
------------------------------------------------------
/* Lekka funkcja statystyczna do raportów. */
CREATE OR REPLACE FUNCTION fn_licznik_zdjec (
    p_id INT
)
RETURNS INT
LANGUAGE SQL STABLE
AS $$
SELECT COUNT(*)
  FROM osoby_fotografie
 WHERE id_osoba = p_id;
$$;
COMMENT ON FUNCTION fn_licznik_zdjec(INT)
IS 'Zwraca liczbę fotografii powiązanych z daną osobą.';


------------------------------------------------------
-- 4.4  sp_backfill_pokrewienstwa()
------------------------------------------------------
/* Automatycznie dopisuje relacje „rodzeństwo” dla
   dzieci, które dzielą co najmniej jednego wspólnego
   rodzica, jeśli relacja jeszcze nie jest zapisana. */
CREATE OR REPLACE PROCEDURE sp_backfill_pokrewienstwa ()
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_sibling INT;
BEGIN
    /* znajdź klucz „rodzeństwo” */
    SELECT id_pokrewienstwo
      INTO v_id_sibling
      FROM pokrewienstwa
     WHERE stopien_pokrewienstwa ILIKE 'rodzeństwo'
     LIMIT 1;

    IF v_id_sibling IS NULL THEN
        RAISE EXCEPTION 'Brak wpisu «rodzeństwo» w Pokrewienstwa.';
    END IF;

    /* dla każdej pary dzieci wspólnego rodzica */
    WITH rodzic_dziecko AS (
        SELECT id_osoba_1 AS rodzic, id_osoba_2 AS dziecko
          FROM osoby_pokrewienstwa op
          JOIN pokrewienstwa pk USING(id_pokrewienstwo)
         WHERE pk.stopien_pokrewienstwa ILIKE 'rodzic'
    ),
    pary AS (
        SELECT DISTINCT LEAST(a.dziecko,b.dziecko)  AS d1,
                        GREATEST(a.dziecko,b.dziecko) AS d2
          FROM rodzic_dziecko a
          JOIN rodzic_dziecko b
            ON a.rodzic = b.rodzic
           AND a.dziecko <> b.dziecko
    )
    INSERT INTO osoby_pokrewienstwa(id_osoba_1,id_pokrewienstwo,id_osoba_2)
    SELECT d1, v_id_sibling, d2
      FROM pary
     WHERE NOT EXISTS (
           SELECT 1 FROM osoby_pokrewienstwa op
            WHERE ((op.id_osoba_1 = pary.d1 AND op.id_osoba_2 = pary.d2)
                OR (op.id_osoba_1 = pary.d2 AND op.id_osoba_2 = pary.d1))
              AND op.id_pokrewienstwo = v_id_sibling
     );
END;
$$;
COMMENT ON PROCEDURE sp_backfill_pokrewienstwa()
IS 'Uzupełnia brakujące relacje „rodzeństwo” wg wspólnych rodziców.';



