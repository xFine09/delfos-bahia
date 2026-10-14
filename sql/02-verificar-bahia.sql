-- 02-verificar-bahia.sql — Comprueba que BAHIA cumple el enunciado
-- Ejecutar como: sqlplus / as sysdba @02-verificar-bahia.sql
-- Esperado: BAHIA.INF | AL32UTF8 | 8192 | XE OPEN | BAHIAPDB READ WRITE
SET LINESIZE 120 PAGESIZE 100
COLUMN value FORMAT A20
SELECT * FROM global_name;
SELECT value FROM nls_database_parameters WHERE parameter = 'NLS_CHARACTERSET';
SHOW PARAMETER db_block_size
SELECT instance_name, status FROM v$instance;
SHOW PDBS
EXIT
