-- 1. Tworzenie ról
CREATE ROLE "GEN_Administrator"   LOGIN PASSWORD 'admin';
CREATE ROLE "GEN_Redaktor"        LOGIN PASSWORD 'redaktor';
CREATE ROLE "GEN_Przegladajacy"   LOGIN PASSWORD 'przegladajacy';

-- 2. Uprawnienia do bazy
GRANT CONNECT ON DATABASE geneaologia
    TO "GEN_Administrator", "GEN_Redaktor", "GEN_Przegladajacy";

--\c geneaologia-- przełącz się do właściwej bazy

/* Dodawanie uprawnien dla GEN_Administrator */
GRANT ALL PRIVILEGES ON DATABASE geneaologia TO "GEN_Administrator";
GRANT ALL PRIVILEGES ON SCHEMA public          TO "GEN_Administrator";
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO "GEN_Administrator";
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "GEN_Administrator";

ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT ALL PRIVILEGES ON TABLES    TO "GEN_Administrator";
ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT ALL PRIVILEGES ON SEQUENCES TO "GEN_Administrator";

/* Dodawanie uprawnien dla GEN_Redaktor */
GRANT USAGE ON SCHEMA public TO "GEN_Redaktor";

GRANT SELECT, INSERT, UPDATE, DELETE
      ON ALL TABLES    IN SCHEMA public TO "GEN_Redaktor";
GRANT USAGE, SELECT
      ON ALL SEQUENCES IN SCHEMA public TO "GEN_Redaktor";

ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES    TO "GEN_Redaktor";
ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT USAGE, SELECT                ON SEQUENCES TO "GEN_Redaktor";

/* Dodawanie uprawnien dla GEN_Przegladajacy */
GRANT USAGE ON SCHEMA public TO "GEN_Przegladajacy";

GRANT SELECT ON ALL TABLES    IN SCHEMA public TO "GEN_Przegladajacy";
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO "GEN_Przegladajacy";

ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT SELECT ON TABLES    TO "GEN_Przegladajacy";
ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT SELECT ON SEQUENCES TO "GEN_Przegladajacy";

/* ############################################## */
/* Wyświetlanie użytkowników bazy i ich uprawnień */
/* ############################################## */
-- 1. Wszystkie role z podstawowymi atrybutami
SELECT rolname          AS rola,
       rolcanlogin      AS moze_logowac,
       rolsuper         AS superuser,
       rolcreatedb      AS moze_tw_bazy,
       rolcreaterole    AS moze_tw_role
FROM   pg_roles
ORDER  BY rolname;

-- 2. Członkostwa ról
SELECT grantee AS rola,
       role    AS w_grupie
FROM   information_schema.applicable_roles
ORDER  BY rola, w_grupie;

-- 3. Uprawnienia do tabel
SELECT grantee          AS rola,
       table_name       AS tabela,
       string_agg(privilege_type, ', ' ORDER BY privilege_type) AS prawa
FROM   information_schema.role_table_grants
WHERE  table_schema = 'public'
GROUP  BY rola, tabela
ORDER  BY rola, tabela;
