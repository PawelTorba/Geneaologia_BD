---Zapytanie ustawia datę zakończenia związku i oznacza rolę partnera/partnerki na „były”.
  UPDATE zwiazki
  SET    data_zakonczenia = '2020-01-01',
         powod_zakonczenia = 'rozwód'
  WHERE  id_zwiazek = :id_zwiazku;


---Dopisuje do danej osoby datę zgonu oraz tworzy zdarzenie „Zgon” i łączy je z daną osobą.
  UPDATE osoby
  SET    data_zgonu = :data_zgonu
  WHERE  id_osoba   = :osoba;
  
  WITH ins AS (
      INSERT INTO zdarzenia
            (id_miejsce, opis_zdarzenia, nazwa_zdarzenia, data_zdarzenia)
      VALUES (:miejsce,
              'Zgon osoby ID ' || :osoba,
              'Zgon',
              :osoba)
      RETURNING id_zdarzenie
  )
  INSERT INTO osoby_zdarzenia (id_osoba, id_zdarzenie)
  SELECT :person_id, id_zdarzenie FROM ins;
