# Geneaologia_BD

System zarządzania **drzewem genealogicznym** oparty na PostgreSQL.  
Pozwala rejestrować osoby, relacje, zdarzenia (narodziny, śluby, zgony itp.), multimedia (zdjęcia/filmy), a także generować raporty i kopie zapasowe.

---
## Kluczowe funkcje

| Priorytet | Funkcja | Opis |
|-----------|---------|------|
| **P1** | CRUD osób, rodzin, miejsc i zdarzeń | Pełna obsługa danych podstawowych | 
| **P1** | Rejestracja zdarzeń | Narodziny, ślub, zgon | 
| **P2** | Zapytania genealogiczne | Przodkowie, potomkowie, wspólny przodek | 
| **P2** | Multimedia | Łączenie zdjęć/filmów z osobami i wydarzeniami |
| **P3** | Eksport CSV | Dane osób i zdarzeń |
| **P3** | Backup/Restore | Skrypty `pg_dump` / `pg_restore` |
| **P3** | Generowanie drzewa PDF/PNG | (funkcjonalność w planach) |

W folderze **bd/functions/** znajduje się ok. 20 procedur i funkcji (m.in. `sp_dodaj_osobe`, `sp_dodaj_zwiazek`, `fn_pokrewienstwa`) wspierających bardziej złożone operacje.

---

## Technologia

* **PostgreSQL** ≥ 13  
* **Python** 3.11 – skrypty pomocnicze (folder `src/`)  
* **Git + GitHub** – kontrola wersji  
* Narzędzia: `psql`, **pgAdmin 4**, VS Code

---

## Struktura repozytorium

Geneaologia_BD/
├── bd/
│ ├── CREATE_ACCOUNTS.sql
│ ├── CREATE_BACKUP.bat
│ ├── RESTORE_BACKUP.bat
│ ├── DATA_BASE_TEMPLATE.sql
│ ├── example_data/
│ │ └── SAMPLE_DATA.sql
│ └── functions/
│ ├── FUNCTIONS_PROCEDURES.sql
│ ├── SAMPLE_ADVANCED_QUERIES_*.sql
│ └── SAMPLE_SIMPLE_QUERIES.sql
├── docs/ # diagramy, PDF, dodatkowe materiały
├── src/ # skrypty pomocnicze (Python)
├── LICENSE
└── README.md

---

## Instalacja bazy danych
1. DATA_BASE_TEMPLATE.sql	Tworzy wszystkie tabele, relacje i indeksy
2. FUNCTIONS_PROCEDURES.sql	Dodaje procedury PL/pgSQL / funkcje zapytań
3. SAMPLE_DATA.sql	Wstawia przykładowe rekordy (osoby, rodziny, miejsca)
4. SAMPLE_*.sql	Przykładowe kwerendy (proste i zaawansowane)

---

## Użytkownicy i role
GEN_Administrator	Superuser – pełna kontrola
GEN_Redaktor	INSERT / UPDATE / DELETE, bez DDL
GEN_Przegladajacy	Tylko SELECT + eksport

---

## Kopie zapasowe
bd/CREATE_BACKUP.bat – generuje plik .backup przy użyciu pg_dump
bd/RESTORE_BACKUP.bat – odtwarza bazę przy użyciu pg_restore

---

## Dokumentacja
docs/ – diagram ER oraz PDF z pełnym opisem projektu
