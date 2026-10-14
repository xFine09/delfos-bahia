-- 01-abrir-pdb.sql — Abre BAHIAPDB y guarda su estado para que se abra
-- sola en cada arranque. Ejecutar como: sqlplus / as sysdba @01-abrir-pdb.sql
WHENEVER SQLERROR CONTINUE
ALTER PLUGGABLE DATABASE BAHIAPDB OPEN;
ALTER PLUGGABLE DATABASE BAHIAPDB SAVE STATE;
SHOW PDBS
EXIT
