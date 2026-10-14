#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /opt/oracle
mkdir -p /opt/oracle/admin/BAHIA/adump
mkdir -p /opt/oracle/admin/BAHIA/dpdump
mkdir -p /opt/oracle/admin/BAHIA/pfile
mkdir -p /opt/oracle/admin/BAHIA/scripts
mkdir -p /opt/oracle/audit
mkdir -p /opt/oracle/dbs
mkdir -p /opt/oracle/oradata/BAHIA
mkdir -p /opt/oracle/oradata/BAHIA/BAHIAPDB
mkdir -p /opt/oracle/oradata/BAHIA/pdbseed
umask ${OLD_UMASK}
PERL5LIB=$ORACLE_HOME/rdbms/admin:$PERL5LIB; export PERL5LIB
ORACLE_SID=XE; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/perl/bin:$PATH; export PATH
echo Debe agregar esta entrada en /etc/oratab: XE:/opt/oracle/product/21c/dbhomeXE:Y
/opt/oracle/product/21c/dbhomeXE/bin/sqlplus /nolog @/opt/oracle/admin/BAHIA/scripts/XE.sql
