SET VERIFY OFF
spool /opt/oracle/admin/BAHIA/scripts/postDBCreation.log append
host /opt/oracle/product/21c/dbhomeXE/OPatch/datapatch -skip_upgrade_check -db XE;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/opt/oracle/dbs/spfileXE.ora' FROM pfile='/opt/oracle/admin/BAHIA/scripts/init.ora';
connect "SYS"/"&&sysPassword" as SYSDBA
host /opt/oracle/product/21c/dbhomeXE/perl/bin/perl /opt/oracle/product/21c/dbhomeXE/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/BAHIA/scripts -v  -b utlrp  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhomeXE/rdbms/admin/utlrp.sql;
select comp_id, status from dba_registry;
execute dbms_swrf_internal.cleanup_database(cleanup_local => FALSE);
commit;
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
spool off
