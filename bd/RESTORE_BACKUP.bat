@echo off
set "PG_BIN=C:\Program Files\PostgreSQL\17\bin"
set "DB_USER=postgres"
set "DB_HOST=localhost"
set "DB_PORT=5432"
set "PGPASSWORD=123"                
REM pełna ścieżka do pliku dump do przywrócenia:
set "DUMP_FILE=C:\Backups\geneaologia\geneaologia_052025_1919.dump"

echo .
echo ==== Przywracam baze z %DUMP_FILE%
"%PG_BIN%\pg_restore.exe" ^
   -U %DB_USER% -h %DB_HOST% -p %DB_PORT% ^
   --clean --create --if-exists ^
   -d postgres ^
   "%DUMP_FILE%"

if %ERRORLEVEL% equ 0 (
    echo ==== PRZYWRACANIE KOPII ZAPASOWEJ ZAKONCZONE POMYSLNIE
) else (
    echo **** PRZYWRACANIE NIE POWIODLO SIE: (kod %ERRORLEVEL%)
)
pause
