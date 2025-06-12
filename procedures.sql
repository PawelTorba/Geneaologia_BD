-- 1.1  Dodaj osobę
CREATE OR REPLACE FUNCTION sp_dodaj_osobe (
    p_imie           TEXT,
    p_nazwisko       TEXT,
    p_drugie_imie    TEXT,
    p_data_urodzenia DATE,
    p_data_zgonu     DATE 
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


--Aktualizuj osobę
CREATE OR REPLACE PROCEDURE sp_aktualizuj_osobe (
    p_id             INT,
    p_imie           TEXT,
    p_nazwisko       TEXT,
    p_drugie_imie    TEXT ,
    p_data_urodzenia DATE,
    p_data_zgonu     DATE 
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


--Usuń osobę kaskadowo (opcjonalnie p_force = TRUE)
CREATE OR REPLACE PROCEDURE sp_usun_osobe (
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

--Dodaj związek (domyślnie „małżeństwo”)
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


--Zakończ związek
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



--Dodaj relację pokrewieństwa
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

--Dodaj zdarzenie
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

------------------------------------------------------
--sp_merge_osoby(duplikat, oryginal) - Przepisuje wszystkie klucze obce z rekordu duplikat na rekord oryginal, po czym usuwa duplikat.
------------------------------------------------------
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
    UPDATE osoby_rodziny       SET id_osoba = p_oryginal WHERE id_osoba = p_duplikat;

    -- usuń duplikat
    DELETE FROM osoby WHERE id_osoba = p_duplikat;
END;
$$;
COMMENT ON PROCEDURE sp_merge_osoby(INT,INT)
IS 'Scalanie duplikatów osób: przekierowuje FK i usuwa rekord duplikatu.';


------------------------------------------------------
--sp_waliduj_relacje() -- wyświetla błędy "logiczne" w bazie danych (warunki można dodawać wedle potrzeby)
------------------------------------------------------
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
--fn_licznik_zdjec(id_osoba) -- zwaraca na ilu zdjęciach pojawia się dana osoba
------------------------------------------------------
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

