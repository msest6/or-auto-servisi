@echo off
REM =========================================================
REM Izvoz skupa podataka auto_servisi: CSV, JSON i dump baze
REM Pokretanje: dvoklik ili "export.bat" iz Command Prompta
REM =========================================================

REM Radi u mapi u kojoj se nalazi ova skripta
cd /d "%~dp0"

REM Putanja do PostgreSQL alata
set PGBIN=C:\Program Files\PostgreSQL\18\bin

REM Podaci za spajanje
set PGHOST=localhost
set PGPORT=5432
set PGUSER=postgres
set PGDATABASE=auto_servisi

echo Izvoz CSV i JSON...
"%PGBIN%\psql.exe" -q -v ON_ERROR_STOP=1 -f export.sql
if errorlevel 1 goto greska

echo Izrada dumpa baze...
"%PGBIN%\pg_dump.exe" --no-owner --no-privileges --encoding=UTF8 -f auto_servisi_dump.sql
if errorlevel 1 goto greska

echo.
echo Gotovo: auto_servisi.csv, auto_servisi.json, auto_servisi_dump.sql
pause
exit /b 0

:greska
echo.
echo Doslo je do greske, pogledaj poruku iznad.
pause
exit /b 1