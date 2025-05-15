# GenealogiaDB <!-- tytuł repozytorium -->

System zarządzania **drzewem genealogicznym** rodziny.  
Projekt realizowany w ramach przedmiotu *Inżynieria oprogramowania* – **wykonuję samodzielnie**.

---

## Spis treści
1. [Zakres projektu](#zakres-projektu)  
2. [Funkcje i priorytety](#funkcje-i-priorytety)  
3. [Technologie](#technologie)  
4. [Wymagania](#wymagania)  
5. [Szybki start](#szybki-start)  
6. [Struktura katalogów](#struktura-katalogów)  
7. [Historia zmian](#historia-zmian)  
8. [Licencja](#licencja)  
9. [Kontakt](#kontakt)

---

## Zakres projektu

Celem jest zaprojektowanie i implementacja relacyjnej bazy danych pozwalającej na:

* **gromadzenie** danych o osobach (żyjących i zmarłych) – imiona, nazwiska, daty i miejsca urodzin / zgonu,  
* **odwzorowanie relacji rodzinnych** (rodzic ↔ dziecko, małżeństwa, partnerstwa, rodzeństwa, adopcje),  
* **rejestrowanie zdarzeń** (narodziny, śluby, zgony oraz inne) wraz z czasem i lokalizacją,  
* **przechowywanie multimediów** (zdjęcia, filmy) powiązanych z osobami lub zdarzeniami,  
* prowadzenie **historii zmian** oraz wykonywanie **kopii zapasowych**.

Dodatkowe zagadnienia:

* zmienność historyczna (zmiany nazwisk, miejsc zamieszkania),  
* chronologiczne oś czasu,  
* zapytania genealogiczne: wyszukiwanie przodków/potomków, stopnie pokrewieństwa.

---

## Funkcje i priorytety

| Priorytet | Funkcja |
|-----------|----------------------------------------------------------------------------------------------------------------------------------------|
| **P1**    | CRUD osób, rodzin, miejsc, zdarzeń |
| **P1**    | Rejestrowanie zdarzeń podstawowych (narodziny, ślub, zgon) |
| **P2**    | Generowanie wizualizacji drzewa (PDF/PNG) |
| **P2**    | Zapytania genealogiczne (przodkowie, potomkowie, wspólny przodek) |
| **P3**    | Import/eksport CSV |
| **P3**    | Historia zmian i backup |
| **P3**    | Przechowywanie i powiązania multimediów |

Legenda: **P1** – funkcje krytyczne · **P2** – ważne · **P3** – usprawnienia  

---

## Technologie

| Obszar | Narzędzie / wersja |
|--------|-------------------|
| **Silnik bazy** | PostgreSQL ≥ 16 (relacyjna + JSONB + PostGIS) |
| **Interfejs SQL** | `psql` (CLI) |
| **GUI DB** | pgAdmin 4 |
| **Język aplikacji / skryptów** | Python 3.11 |
| **Kontrola wersji** | Git + GitHub |
| **IDE / edytor** | Visual Studio Code |

