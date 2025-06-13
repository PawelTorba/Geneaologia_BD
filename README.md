# Geneaologia_BD

System zarządzania **drzewem genealogicznym** oparty na PostgreSQL.  
Umożliwia rejestrowanie osób, relacji rodzinnych, wydarzeń (narodziny, śluby, zgony itd.), multimediów (zdjęcia i filmy), a także generowanie raportów i kopii zapasowych.

---

## Kluczowe funkcje

| Priorytet | Funkcja                       | Opis                                         |
|-----------|-------------------------------|----------------------------------------------|
| **P1**    | CRUD osób, rodzin, miejsc i zdarzeń | Pełna obsługa danych podstawowych       |
| **P1**    | Rejestracja zdarzeń            | Narodziny, ślub, zgon                        |
| **P2**    | Zapytania genealogiczne        | Przodkowie, potomkowie, wspólny przodek     |
| **P2**    | Multimedia                     | Powiązanie zdjęć/filmów z osobami i zdarzeniami |
| **P3**    | Eksport CSV                    | Eksport danych osób i zdarzeń do plików CSV  |
| **P3**    | Backup/Restore                 | Skrypty `pg_dump` i `pg_restore`             |
| **P3**    | Generowanie drzewa (PDF/PNG)   | W planach rozwoju                            |

W katalogu `bd/functions/` znajduje się ~20 procedur i funkcji pomocniczych (m.in. `sp_dodaj_osobe`, `sp_dodaj_zwiazek`, `fn_pokrewienstwa`).

---

## Technologia

- **PostgreSQL** ≥ 13  
- **Python** 3.11 – skrypty pomocnicze (`src/`)  
- **Git + GitHub** – kontrola wersji  
- Narzędzia: `psql`, **pgAdmin 4**, **Visual Studio Code**

---

## Struktura repozytorium

```
Geneaologia_BD/
├── bd/
│   ├── CREATE_ACCOUNTS.sql          # Role i użytkownicy
│   ├── CREATE_BACKUP.bat            # Backup bazy
│   ├── RESTORE_BACKUP.bat           # Przywracanie bazy
│   ├── DATA_BASE_TEMPLATE.sql       # Tworzenie struktury bazy
│   ├── example_data/
│   │   └── SAMPLE_DATA.sql          # Dane przykładowe
│   └── functions/
│       ├── FUNCTIONS_PROCEDURES.sql # Procedury i funkcje PL/pgSQL
│       ├── SAMPLE_ADVANCED_QUERIES_*.sql
│       └── SAMPLE_SIMPLE_QUERIES.sql
├── docs/                            # Dokumentacja, diagramy
├── src/                             # Skrypty pomocnicze (Python)
├── LICENSE
└── README.md                        # Niniejszy plik
```

---

## Instalacja bazy danych

1. **Utwórz strukturę bazy danych**:  
   `DATA_BASE_TEMPLATE.sql` – tabele, relacje, indeksy

2. **Dodaj funkcje i procedury**:  
   `FUNCTIONS_PROCEDURES.sql` – logika biznesowa w PL/pgSQL

3. **Załaduj dane przykładowe**:  
   `example_data/SAMPLE_DATA.sql`

---

## Role i uprawnienia

| Rola              | Uprawnienia                            |
|-------------------|-----------------------------------------|
| `GEN_Administrator` | Superuser – pełna kontrola             |
| `GEN_Redaktor`      | `INSERT`, `UPDATE`, `DELETE` – bez DDL |
| `GEN_Przegladajacy` | Tylko `SELECT` + eksport danych         |

Użytkownicy tworzeni są w skrypcie `CREATE_ACCOUNTS.sql`.

---

## Kopie zapasowe

- `bd/CREATE_BACKUP.bat` – generuje kopię `.backup` z użyciem `pg_dump`
- `bd/RESTORE_BACKUP.bat` – przywraca kopię przy użyciu `pg_restore`

---

## Dokumentacja

Pełna dokumentacja projektu (w tym diagram ERD i instrukcja instalacji) znajduje się w katalogu `docs/`.
