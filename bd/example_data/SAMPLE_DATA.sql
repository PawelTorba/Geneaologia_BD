INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Liwia', 'Siedlarz', 'Kamila', '1980-11-16', NULL);
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Adrianna', 'Fleszar', 'Natasza', '1956-03-13', '2020-12-19');
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Sylwia', 'Romaniak', 'Aniela', '1965-02-27', '2044-05-18');
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Maksymilian', 'Pachuta', 'Rafał', '1964-07-10', NULL);
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Marek', 'Golisz', NULL, '1978-12-29', '2056-06-01');
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Tadeusz', 'Gałach', NULL, '1966-06-15', NULL);
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Norbert', 'Betlej', NULL, '2005-03-26', NULL);
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Melania', 'Jacak', 'Mieszko', '1968-12-14', NULL);
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Nicole', 'Kłoczko', NULL, '1977-02-09', NULL);
INSERT INTO Osoby (Imie, Nazwisko, Drugie_Imie, Data_Urodzenia, Data_Zgonu) VALUES ('Hubert', 'Moczko', 'Tadeusz', '1945-12-13', '2019-08-31');

INSERT INTO Rodziny (Nazwisko_Rodziny) VALUES ('Welenc');
INSERT INTO Rodziny (Nazwisko_Rodziny) VALUES ('Krekora');
INSERT INTO Rodziny (Nazwisko_Rodziny) VALUES ('Latuszek');

INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (1, 1);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (2, 3);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (3, 1);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (4, 2);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (5, 1);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (6, 1);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (7, 1);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (8, 2);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (9, 2);
INSERT INTO Osoby_Rodziny (ID_Osoba, ID_Rodziny) VALUES (10, 2);

INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES ('Wieluń', 'Ślad kanał służba pająk kalendarz lew pragnąć.', '(19.4664, 51.8716)');
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES ('Iława', 'Jeździć aktywny powszechny.', '(20.0098, 49.2782)');
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES ('Krosno', 'Głowa Szwecja bydło talerz dział wzrost.', '(19.2901, 51.5425)');
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES ('Mysłowice', 'Para jutro zawartość powierzchnia dużo sos.', '(20.8112, 51.4214)');
INSERT INTO Miejsca (Nazwa_Miejsca, Opis, Lokalizacja) VALUES ('Chrzanów', 'Przyjść u niedziela futro występować cesarz.', '(21.1892, 50.6087)');

INSERT INTO Fotografie (Opis_Zdjecia, Data_Wykonania, ID_Miejsce) VALUES ('Rejon potem daleko.', '2023-07-27', 3);
INSERT INTO Fotografie (Opis_Zdjecia, Data_Wykonania, ID_Miejsce) VALUES ('Chory grupa klasa razem anioł mięsień.', '2015-11-23', 2);
INSERT INTO Fotografie (Opis_Zdjecia, Data_Wykonania, ID_Miejsce) VALUES ('Wysokość mieszkać skóra transport krowa wrogość.', '2011-01-01', 3);
INSERT INTO Fotografie (Opis_Zdjecia, Data_Wykonania, ID_Miejsce) VALUES ('Dość przychodzić polityk jądro uderzać nieszczęście.', '2007-04-08', 3);
INSERT INTO Fotografie (Opis_Zdjecia, Data_Wykonania, ID_Miejsce) VALUES ('Rzym pałac gęś metoda podnieść.', '2021-05-30', 2);

INSERT INTO Zdarzenia (Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) VALUES ('Compatible 5thgeneration approach', 'Dawać postawić wysoko. Motyl pomagać wilk. Czechy boleć próbować zegar pomóc projekt książę.', '2024-03-26');
INSERT INTO Zdarzenia (Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) VALUES ('Persistent 5thgeneration matrices', 'Pewien czeski dodawać moralny aby między zakładać.', '2012-08-19');
INSERT INTO Zdarzenia (Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) VALUES ('Profit-focused web-enabled framework', 'Butelka styl chronić jeśli pożar czasownik radość. Niski marzec biologia cień działalność.', '2000-12-04');
INSERT INTO Zdarzenia (Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) VALUES ('Programmable directional strategy', 'Temperatura wyraz idea w czasie USA. Przyrząd położyć herbata bank otrzymywać.', '1995-09-23');
INSERT INTO Zdarzenia (Nazwa_Zdarzenia, Opis_Zdarzenia, Data_Zdarzenia) VALUES ('Managed eco-centric open architecture', 'Sądzić wymagać przemysłowy. Jedynie średni znaczyć Słowacja tworzyć żeby ku.', '2021-09-04');

INSERT INTO Zdarzenia_Fotografie (ID_Zdjecie, ID_Zdarzenie) VALUES (1, 3);
INSERT INTO Zdarzenia_Fotografie (ID_Zdjecie, ID_Zdarzenie) VALUES (2, 1);
INSERT INTO Zdarzenia_Fotografie (ID_Zdjecie, ID_Zdarzenie) VALUES (3, 5);
INSERT INTO Zdarzenia_Fotografie (ID_Zdjecie, ID_Zdarzenie) VALUES (4, 2);
INSERT INTO Zdarzenia_Fotografie (ID_Zdjecie, ID_Zdarzenie) VALUES (5, 5);

INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (1, 2);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (2, 4);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (2, 3);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (3, 3);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (4, 2);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (5, 3);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (6, 3);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (6, 1);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (7, 5);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (8, 2);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (8, 4);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (9, 4);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (9, 2);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (10, 2);
INSERT INTO Osoby_Zdarzenia (ID_Osoba, ID_Zdarzenie) VALUES (10, 2);

INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (1, 5);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (2, 5);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (3, 3);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (4, 5);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (5, 4);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (6, 5);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (7, 4);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (8, 3);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (9, 2);
INSERT INTO Osoby_Fotografie (ID_Osoba, ID_Zdjecie) VALUES (10, 2);

INSERT INTO Pokrewienstwa (Stopien_Pokrewienstwa) VALUES ('rodzic');
INSERT INTO Pokrewienstwa (Stopien_Pokrewienstwa) VALUES ('dziecko');
INSERT INTO Pokrewienstwa (Stopien_Pokrewienstwa) VALUES ('rodzeństwo');
INSERT INTO Pokrewienstwa (Stopien_Pokrewienstwa) VALUES ('wuj/ciotka');
INSERT INTO Pokrewienstwa (Stopien_Pokrewienstwa) VALUES ('kuzyn');

INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) VALUES (9, 1, 8);
INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) VALUES (1, 2, 2);
INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) VALUES (3, 5, 7);
INSERT INTO Osoby_Pokrewienstwa (ID_Osoba_1, ID_Pokrewienstwo, ID_Osoba_2) VALUES (2, 4, 7);

INSERT INTO Zwiazki (Typ_Relacji) VALUES ('Partnerstwo');
INSERT INTO Osoby_Zwiazki (ID_Osoba, ID_Zwiazek) VALUES (7, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek'))), (2, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek')));
INSERT INTO Zwiazki (Typ_Relacji) VALUES ('Partnerstwo');
INSERT INTO Osoby_Zwiazki (ID_Osoba, ID_Zwiazek) VALUES (5, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek'))), (10, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek')));
INSERT INTO Zwiazki (Typ_Relacji) VALUES ('Partnerstwo');
INSERT INTO Osoby_Zwiazki (ID_Osoba, ID_Zwiazek) VALUES (6, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek'))), (8, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek')));
INSERT INTO Zwiazki (Typ_Relacji) VALUES ('Partnerstwo');
INSERT INTO Osoby_Zwiazki (ID_Osoba, ID_Zwiazek) VALUES (3, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek'))), (4, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek')));
INSERT INTO Zwiazki (Typ_Relacji) VALUES ('Partnerstwo');
INSERT INTO Osoby_Zwiazki (ID_Osoba, ID_Zwiazek) VALUES (1, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek'))), (9, currval(pg_get_serial_sequence('Zwiazki','ID_Zwiazek')));