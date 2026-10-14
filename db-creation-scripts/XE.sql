set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
host /opt/oracle/product/21c/dbhomeXE/bin/orapwd file=/opt/oracle/dbs/orapwXE force=y format=12
@/opt/oracle/admin/BAHIA/scripts/CloneRmanRestore.sql
@/opt/oracle/admin/BAHIA/scripts/cloneDBCreation.sql
@/opt/oracle/admin/BAHIA/scripts/plug_PDBSeed.sql
@/opt/oracle/admin/BAHIA/scripts/postScripts.sql
@/opt/oracle/admin/BAHIA/scripts/lockAccount.sql
@/opt/oracle/admin/BAHIA/scripts/postDBCreation.sql
@/opt/oracle/admin/BAHIA/scripts/PDBCreation.sql
@/opt/oracle/admin/BAHIA/scripts/plug_BAHIAPDB.sql
