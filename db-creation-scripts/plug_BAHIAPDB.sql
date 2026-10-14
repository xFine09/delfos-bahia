SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/BAHIA/scripts/plugDatabase1R.log append
spool /opt/oracle/admin/BAHIA/scripts/plugDatabase1R.log append
host mkdir -p /opt/oracle/oradata/BAHIA/BAHIAPDB;
select d.name||'|'||t.name from v$datafile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;
select d.name||'|'||t.name from v$tempfile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;
