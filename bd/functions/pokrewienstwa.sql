CREATE OR REPLACE FUNCTION f_pokrewienstwa(_id int)
RETURNS TABLE (
    imie           text,
    nazwisko       text,
    pokrewienstwo  text
) LANGUAGE SQL STABLE AS
$$
WITH rel AS (                                   -- łapiemy wszystkie surowe wiersze
    SELECT
        CASE WHEN op.ID_Osoba_1 = _id
             THEN op.ID_Osoba_2 ELSE op.ID_Osoba_1 END       AS id_krewnego,
        op.ID_Pokrewienstwo                                  AS rel_orig,
        (op.ID_Osoba_1 = _id)                                AS i_am_side1
    FROM Osoby_Pokrewienstwa op
    WHERE _id IN (op.ID_Osoba_1, op.ID_Osoba_2)
),
mapped AS (                                -- zamieniamy relacje na „jak ja je widzę”
    SELECT
        o.ID_Osoba                                         AS id_krewnego,
        o.Imie,
        o.Nazwisko,
        CASE
            WHEN i_am_side1 THEN pk.Stopien_Pokrewienstwa
            ELSE
                CASE rel_orig
                     WHEN 1  THEN CASE WHEN o.Imie LIKE '%a' THEN 'prawnuczka'      ELSE 'prawnuk'       END
                     WHEN 3  THEN CASE WHEN o.Imie LIKE '%a' THEN 'prawnuczka'      ELSE 'prawnuk'       END
                     WHEN 2  THEN CASE WHEN o.Imie LIKE '%a' THEN 'wnuczka'         ELSE 'wnuk'          END
                     WHEN 4  THEN CASE WHEN o.Imie LIKE '%a' THEN 'wnuczka'         ELSE 'wnuk'          END
                     WHEN 5  THEN CASE WHEN o.Imie LIKE '%a' THEN 'córka'           ELSE 'syn'           END
                     WHEN 6  THEN CASE WHEN o.Imie LIKE '%a' THEN 'córka'           ELSE 'syn'           END
                     WHEN 9  THEN CASE WHEN o.Imie LIKE '%a' THEN 'matka'           ELSE 'ojciec'        END
                     WHEN 10 THEN CASE WHEN o.Imie LIKE '%a' THEN 'matka'           ELSE 'ojciec'        END
                     WHEN 11 THEN CASE WHEN o.Imie LIKE '%a' THEN 'siostrzenica'    ELSE 'siostrzeniec'  END
                     WHEN 12 THEN CASE WHEN o.Imie LIKE '%a' THEN 'siostrzenica'    ELSE 'siostrzeniec'  END
                     WHEN  8 THEN 'rodzeństwo'
                     WHEN  7 THEN 'kuzynostwo'
                     ELSE  pk.Stopien_Pokrewienstwa
                END
        END AS pokrewienstwo
    FROM rel
    JOIN Osoby          o  ON o.ID_Osoba         = rel.id_krewnego
    JOIN Pokrewienstwa  pk ON pk.ID_Pokrewienstwo = rel.rel_orig
)
SELECT DISTINCT ON (id_krewnego, pokrewienstwo)   -- usuwa duplikaty
       imie,
       nazwisko,
       pokrewienstwo
FROM   mapped
ORDER  BY id_krewnego, pokrewienstwo, nazwisko, imie;
$$;
