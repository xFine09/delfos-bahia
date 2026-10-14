SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/BAHIA/scripts/CloneRmanRestore.log append
startup mount pfile="/opt/oracle/admin/BAHIA/scripts/initXETempOMF.ora";
execute dbms_backup_restore.resetCfileSection(dbms_backup_restore.RTYP_DFILE_COPY);
execute dbms_backup_restore.resetCfileSection(13);
host /opt/oracle/product/21c/dbhomeXE/bin/rman @/opt/oracle/admin/BAHIA/scripts/rmanRestoreDatafiles.sql &&sysPassword;
column file0 NEW_VALUE file0;
select NAME file0 FROM V$DATAFILE where file# = 3;
column file1 NEW_VALUE file1;
select NAME file1 FROM V$DATAFILE where file# = 1;
column file2 NEW_VALUE file2;
select NAME file2 FROM V$DATAFILE where file# = 4;
column file3 NEW_VALUE file3;
select NAME file3 FROM V$DATAFILE where file# = 7;
spool off
