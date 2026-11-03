-- 05-dblink-pg.sql — Database link de BAHIAPDB (usuario HR) a PostgreSQL vía DG4ODBC
-- Ejecutar como HR:  sqlplus hr@//delfos.inf:1521/bahiapdb.inf @05-dblink-pg.sql
-- Antes, como SYSTEM en la PDB:  GRANT CREATE DATABASE LINK TO hr;
-- Usuario y contraseña de PostgreSQL ENTRE COMILLAS DOBLES (si no, Oracle los pasa
-- a mayúsculas). Se usa el descriptor completo en vez del alias de tnsnames.ora para
-- no depender de dónde busca el servidor ese fichero (ORACLE_HOME de solo lectura).
DEFINE pg_clave = 'CambiaEstaClave1'
CREATE DATABASE LINK pg_link
  CONNECT TO "migra" IDENTIFIED BY "&pg_clave"
  USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=delfos.inf)(PORT=1521))(CONNECT_DATA=(SID=PGSQL))(HS=OK))';

-- Prueba: debe devolver las 7 tablas creadas en PostgreSQL
SELECT "tablename" FROM "pg_tables"@pg_link WHERE "schemaname" = 'hr';
