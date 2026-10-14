SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/BAHIA/scripts/postScripts.log append
disconnect;
connect "SYSTEM"/"&&systemPassword"
disconnect;
connect "SYS"/"&&sysPassword" as SYSDBA
alter session set "_oracle_script"=TRUE;
execute dbms_datapump_utl.create_default_dir;
commit;
alter session set "_oracle_script"=FALSE;
connect "SYS"/"&&sysPassword" as SYSDBA
host /opt/oracle/product/21c/dbhomeXE/perl/bin/perl /opt/oracle/product/21c/dbhomeXE/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/BAHIA/scripts -v  -b ordlib  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhomeXE/ord/im/admin/ordlib.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
create or replace directory XMLDIR as '/opt/oracle/product/21c/dbhomeXE/rdbms/xml';
create or replace directory XSDDIR as '/opt/oracle/product/21c/dbhomeXE/rdbms/xml/schema';
@/opt/oracle/product/21c/dbhomeXE/rdbms/admin/utlfixdirs.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
host /opt/oracle/product/21c/dbhomeXE/perl/bin/perl /opt/oracle/product/21c/dbhomeXE/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/BAHIA/scripts -v  -b dr0defdp  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhomeXE/ctx/admin/defaults/dr0defdp.sql;
host /opt/oracle/product/21c/dbhomeXE/perl/bin/perl /opt/oracle/product/21c/dbhomeXE/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/BAHIA/scripts -v  -b dr0defin  -U "SYS"/"&&sysPassword" -a 1  /opt/oracle/product/21c/dbhomeXE/ctx/admin/defaults/dr0defin.sql 1\"SPANISH\";
connect "SYS"/"&&sysPassword" as SYSDBA
@/opt/oracle/product/21c/dbhomeXE/rdbms/admin/execocm.sql;
execute dbms_qopatch.replace_logscrpt_dirs;
host /opt/oracle/product/21c/dbhomeXE/perl/bin/perl /opt/oracle/product/21c/dbhomeXE/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/BAHIA/scripts -v  -b execemx  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhomeXE/rdbms/admin/execemx.sql;
spool off
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/BAHIA/scripts/postDBCreation.log append
