connect target sys/&1;
 
run
{
set command id  to 'PDB$SEED';
RESTORE FOREIGN DATAFILE  2 FORMAT '/opt/oracle/oradata/BAHIA/pdbseed/system01.dbf',4 FORMAT '/opt/oracle/oradata/BAHIA/pdbseed/sysaux01.dbf',9 FORMAT '/opt/oracle/oradata/BAHIA/pdbseed/undotbs01.dbf' FROM BACKUPSET  '/opt/oracle/product/21c/dbhomeXE/assistants/dbca/templates/pdbseed.dfb' ;
}
exit;
