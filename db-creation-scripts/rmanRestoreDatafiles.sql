connect target sys/&1;
 
CATALOG START WITH   '/opt/oracle/product/21c/dbhomeXE/assistants/dbca/templates//XE_Seed_Database.dfb'  NOPROMPT  ;

RUN
{
set newname for datafile 1 to  '/opt/oracle/oradata/BAHIA/system01.dbf' ;
set newname for datafile 3 to  '/opt/oracle/oradata/BAHIA/sysaux01.dbf' ;
set newname for datafile 4 to  '/opt/oracle/oradata/BAHIA/undotbs01.dbf' ;
set newname for datafile 7 to  '/opt/oracle/oradata/BAHIA/users01.dbf' ;
restore datafile 1;
restore datafile 3;
restore datafile 4;
restore datafile 7;
switch datafile all;
}
