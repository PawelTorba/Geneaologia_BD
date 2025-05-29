---Wprowadza nową osobę i jednocześnie wpisuje zdarzenie związane z jej narodzinami (np.: jeżeli jest to noworodek).
 1  WITH nowa_osoba AS (
 2      INSERT INTO Osoby (Imie, Nazwisko, Data_Urodzenia, ID_Miejsce_Urodzenia)
 3      VALUES (:imie, :nazwisko, :data_urodzenia, :miejsce_urodzenia_id)
 4      RETURNING ID_Osoba
 5  ),
 6  zdarzenie_narodziny AS (
 7      INSERT INTO Zdarzenia (ID_Miejsce, Nazwa_Zdarzenia, Data_Zdarzenia, Opis_Zdarzenia)
 8      VALUES (:miejsce_urodzenia_id, 'Narodziny', :data_urodzenia, 'Narodziny osoby')
 9      RETURNING ID_Zdarzenie
10  )
11  INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie, Rola)
12  SELECT no.ID_Osoba, zn.ID_Zdarzenie, 'noworodek'
13  FROM nowa_osoba no, zdarzenie_narodziny zn;


---Zapytanie dodaje nowe małżeństwo i dodaje do niego partnerów
1  WITH malzenstwo AS (
2      INSERT INTO Zwiazki (Typ_Zwiazku, Data_Rozpoczecia)
3      VALUES ('małżeństwo', :data_slubu)
4      RETURNING ID_Zwiazek
5  )
6  INSERT INTO Osoby_Zwiazki (ID_Zwiazek, ID_Osoba, Rola)
7  VALUES
8      ((SELECT ID_Zwiazek FROM malzenstwo), :maz_id,  'mąż'),
9      ((SELECT ID_Zwiazek FROM malzenstwo), :zona_id, 'żona');


---Zapytanie dodaje nową rodzinę i zapisuje zadaną osobę jako jej członka.
1  WITH nowa_rodzina AS (
2      INSERT INTO Rodziny (Nazwisko_Rodziny)
3      VALUES (:nazwisko_rodzinne)
4      RETURNING ID_Rodzina
5  )
6  INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodzina, Data_Od)
7  SELECT :osoba_id, ID_Rodzina, CURRENT_DATE FROM nowa_rodzina;
