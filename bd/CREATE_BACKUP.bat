@echo off
set "PG_BIN=C:\Program Files\PostgreSQL\17\bin"
set "DB_NAME=geneaologia"
set "DB_USER=postgres"
set "DB_HOST=localhost"
set "DB_PORT=5432"
set "PGPASSWORD=123"           
set "BACKUP_DIR=C:\Backups\geneaologia"

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Tworzenie wyznacznika czasu (tzn. z kiedy jest kopia zapasowa)
for /f "tokens=1-4 delims=.-/ " %%a in ("%date%") do (set YYYY=%%d&set MM=%%b&set DD=%%c)
for /f "tokens=1-2 delims=:." %%a in ("%time%") do (set HH=%%a&set MN=%%b)
set "STAMP=%YYYY%%MM%%DD%_%HH%%MN%"
set "FILE=%BACKUP_DIR%\%DB_NAME%_%STAMP%.dump"

echo .
echo ==== Rozpoczynam backup %DB_NAME% → %FILE%
"%PG_BIN%\pg_dump.exe" ^
   -U %DB_USER% -h %DB_HOST% -p %DB_PORT% ^
   -Fc -f "%FILE%" %DB_NAME%

if %ERRORLEVEL% equ 0 (
    echo ==== Backup ZAKONCZONY pomyslnie
) else (
    echo **** BACKUP ZAKONCZYL SIE NIEPOWODZENIEM: (kod %ERRORLEVEL%)
)
pause
