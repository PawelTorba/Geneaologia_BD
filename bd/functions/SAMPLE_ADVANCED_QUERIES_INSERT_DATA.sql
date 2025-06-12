---Wprowadza nową osobę i jednocześnie wpisuje zdarzenie związane z jej narodzinami (np.: jeżeli jest to noworodek).
   WITH np AS (
    INSERT INTO osoby (imie, nazwisko, data_urodzenia)
    VALUES (:imie, :nazwisko, :data_ur) RETURNING id_osoba),
  be AS (
    INSERT INTO zdarzenia (id_miejsce, opis_zdarzenia, nazwa_zdarzenia, data_zdarzenia)
    VALUES (:miejsce, 'Narodziny '||:imie||' '||:nazwisko,
            'Narodziny '||:imie||' '||:nazwisko, :data_ur)
    RETURNING id_zdarzenie)
  INSERT INTO osoby_zdarzenia (id_osoba, id_zdarzenie)
  SELECT np.id_osoba, be.id_zdarzenie FROM np, be;


---Zapytanie dodaje nowe małżeństwo i dodaje do niego partnerów
  WITH z AS (
    INSERT INTO zwiazki (typ_relacji, data_rozpoczecia)
    VALUES ('slub', :data) RETURNING id_zwiazek)
  INSERT INTO osoby_zwiazki (id_osoba, id_zwiazek)
  SELECT id, z.id_zwiazek
  FROM   (VALUES (:partner1), (:partner2)) AS v(id), z;


---Zapytanie dodaje nową rodzinę i zapisuje zadaną osobę jako jej członka.
  WITH nf AS (
  INSERT INTO rodziny (nazwisko_rodziny) VALUES (:nazwisko) RETURNING id_rodzina)
  INSERT INTO osoby_rodziny (id_osoba, id_rodzina)
  SELECT 16, nf.id_rodzina FROM nf;
