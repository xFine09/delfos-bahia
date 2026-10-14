SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/BAHIA/scripts/cloneDBCreation.log append
exec dbms_backup_restore.zerodbid(0);
shutdown immediate;
startup nomount pfile="/opt/oracle/admin/BAHIA/scripts/initXETemp.ora";
Create controlfile reuse set database "BAHIA"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
Datafile 
'&&file0',
'&&file1',
'&&file2',
'&&file3'
LOGFILE GROUP 1 ('/opt/oracle/oradata/BAHIA/redo01.log') SIZE 200M,
GROUP 2 ('/opt/oracle/oradata/BAHIA/redo02.log') SIZE 200M,
GROUP 3 ('/opt/oracle/oradata/BAHIA/redo03.log') SIZE 200M RESETLOGS;
alter system enable restricted session;
alter database "BAHIA" open resetlogs;
DECLARE 
cursor cur_services is 
select name from dba_services where name like 'xe%'; 
BEGIN 
 for i in cur_services loop 
 dbms_service.delete_service(i.name); 
 end loop; 
END; 
/
alter database rename global_name to "BAHIA.inf";
ALTER TABLESPACE TEMP ADD TEMPFILE '/opt/oracle/oradata/BAHIA/temp01.dbf' SIZE 20480K REUSE AUTOEXTEND ON NEXT 640K MAXSIZE UNLIMITED;
select tablespace_name from dba_tablespaces where tablespace_name='USERS';
ALTER PROFILE default LIMIT PASSWORD_VERIFY_FUNCTION null;
alter user sys account unlock identified by "&&sysPassword";
connect "SYS"/"&&sysPassword" as SYSDBA
alter user system account unlock identified by "&&systemPassword";
host /opt/oracle/product/21c/dbhomeXE/OPatch/datapatch -skip_upgrade_check -db XE;
