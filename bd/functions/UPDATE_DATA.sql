---Zapytanie ustawia datę zakończenia związku i oznacza rolę partnera/partnerki na „były”.
UPDATE Zwiazki
SET Data_Zakonczenia = :data_rozwodu
WHERE ID_Zwiazek = :zwiazek_id;

UPDATE Osoby_Zwiazki
SET Rola = 'były_' || Rola
WHERE ID_Zwiazek = :zwiazek_id;


---Dopisuje do danej osoby datę zgonu oraz tworzy zdarzenie „Zgon” i łączy je z daną osobą.
UPDATE Osoby
SET Data_Zgonu = :data_zgonu
WHERE ID_Osoba = :osoba_id;

INSERT INTO Zdarzenia (ID_Miejsce, Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia)
VALUES (:miejsce_id, 'Zgon', 'Rejestracja zgonu', :data_zgonu)
RETURNING ID_Zdarzenie INTO :zgon_event_id;

INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie, Rola)
VALUES (:osoba_id, :zgon_event_id, 'zmarły');
