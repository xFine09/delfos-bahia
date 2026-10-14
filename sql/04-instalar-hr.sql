-- 04-instalar-hr.sql — Lanza el instalador oficial de HR comprobando antes
-- que la sesión está en la PDB (no en CDB$ROOT: ORA-65096).
-- Ejecutar desde db-sample-schemas-main/human_resources como:
--   sqlplus system@//delfos.inf:1521/bahiapdb.inf @04-instalar-hr.sql
SHOW CON_NAME
WHENEVER SQLERROR EXIT FAILURE
BEGIN
  IF SYS_CONTEXT('USERENV','CON_NAME') <> 'BAHIAPDB' THEN
    RAISE_APPLICATION_ERROR(-20001, 'No estás en BAHIAPDB: conecta al servicio bahiapdb.inf');
  END IF;
END;
/
WHENEVER SQLERROR CONTINUE
@hr_install.sql
