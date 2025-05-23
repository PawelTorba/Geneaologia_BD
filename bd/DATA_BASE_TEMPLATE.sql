CREATE TABLE Osoby (
    ID_Osoba INT NOT NULL PRIMARY KEY,
    Imie TEXT NOT NULL,
    Nazwisko TEXT NOT NULL,
    Drugie_Imie TEXT,
    Data_Urodzenia DATE NOT NULL,
    Data_Zgonu DATE
);

CREATE TABLE Rodziny (
    ID_Rodziny INT NOT NULL PRIMARY KEY,
    Nazwisko_Rodziny TEXT NOT NULL
);

CREATE TABLE Osoby_Rodziny (
    ID_Osoba_Rodzina INT NOT NULL PRIMARY KEY,
    ID_Osoba INT NOT NULL,
    ID_Rodziny INT NOT NULL,
    FOREIGN KEY (ID_Osoba) REFERENCES Osoby(ID_Osoba),
    FOREIGN KEY (ID_Rodziny) REFERENCES Rodziny(ID_Rodziny)
);

CREATE TABLE Miejsca (
    ID_Miejsce INT NOT NULL PRIMARY KEY,
    Nazwa_Miejsca TEXT,
    Opis TEXT,
    Lokalizacja POINT
);

CREATE TABLE Fotografie (
    ID_Zdjecie INT NOT NULL PRIMARY KEY,
    Plik BYTEA,
    Opis_Zdjecia TEXT,
    Data_Wykonania DATE,
    ID_Miejsce INT,
    FOREIGN KEY (ID_Miejsce) REFERENCES Miejsca(ID_Miejsce)
);

CREATE TABLE Zdarzenia (
    ID_Zdarzenie INT NOT NULL PRIMARY KEY,
    ID_Miejsce INT,
    Opis_Zdarzenia TEXT,
    Nazwa_Zdarzenia TEXT,
    Data_Zdarzenia DATE,
    FOREIGN KEY (ID_Miejsce) REFERENCES Miejsca(ID_Miejsce)
);

CREATE TABLE Zdarzenia_Fotografie (
    ID_Zdarzenia_Fotografie INT NOT NULL PRIMARY KEY,
    ID_Zdjecie INT NOT NULL,
    ID_Zdarzenie INT NOT NULL,
    FOREIGN KEY (ID_Zdjecie) REFERENCES Fotografie(ID_Zdjecie),
    FOREIGN KEY (ID_Zdarzenie) REFERENCES Zdarzenia(ID_Zdarzenie)
);

CREATE TABLE Osoby_Zdarzenia (
    ID_Osoby_Zdarzenia INT NOT NULL PRIMARY KEY,
    ID_Osoba INT NOT NULL,
    ID_Zdarzenie INT NOT NULL,
    FOREIGN KEY (ID_Osoba) REFERENCES Osoby(ID_Osoba),
    FOREIGN KEY (ID_Zdarzenie) REFERENCES Zdarzenia(ID_Zdarzenie)
);

CREATE TABLE Osoby_Fotografie (
    ID_Osoby_Fotografie INT NOT NULL PRIMARY KEY,
    ID_Osoba INT NOT NULL,
    ID_Zdjecie INT NOT NULL,
    FOREIGN KEY (ID_Osoba) REFERENCES Osoby(ID_Osoba),
    FOREIGN KEY (ID_Zdjecie) REFERENCES Fotografie(ID_Zdjecie)
);

CREATE TABLE Pokrewienstwa (
    ID_Pokrewienstwo INT NOT NULL PRIMARY KEY,
    Stopien_Pokrewienstwa TEXT NOT NULL
);

CREATE TABLE Osoby_Pokrewienstwa (
    ID_Osoby_Pokrewienstwo INT NOT NULL PRIMARY KEY,
    ID_Osoba_1 INT NOT NULL,
    ID_Pokrewienstwo INT NOT NULL,
    ID_Osoba_2 INT NOT NULL,
    FOREIGN KEY (ID_Osoba_1) REFERENCES Osoby(ID_Osoba),
    FOREIGN KEY (ID_Osoba_2) REFERENCES Osoby(ID_Osoba),
    FOREIGN KEY (ID_Pokrewienstwo) REFERENCES Pokrewienstwa(ID_Pokrewienstwo)
);

CREATE TABLE Zwiazki (
    ID_Zwiazek INT NOT NULL PRIMARY KEY,
    Typ_Relacji TEXT NOT NULL,
    Data_Rozpoczecia DATE NOT NULL,
    Data_Zakonczenia DATE,
    Powod_Zakonczenia TEXT
);

CREATE TABLE Osoby_Zwiazki (
    ID_Osoba_Zwiazki INT NOT NULL PRIMARY KEY,
    ID_Osoba INT NOT NULL,
    ID_Zwiazek INT NOT NULL,
    FOREIGN KEY (ID_Osoba) REFERENCES Osoby(ID_Osoba),
    FOREIGN KEY (ID_Zwiazek) REFERENCES Zwiazki(ID_Zwiazek)
);
