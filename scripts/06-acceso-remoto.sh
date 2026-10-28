#!/usr/bin/env bash
# =====================================================================
# 06-acceso-remoto.sh — Abre delfos.inf al acceso remoto de Oracle
# Ejecutar DENTRO DE LA VM como sercal.
# =====================================================================
set -euo pipefail

# 1. Cortafuegos: SSH antes que nada, después el listener (cabezazo 19)
sudo ufw allow OpenSSH
sudo ufw allow 1521/tcp
sudo ufw --force enable
sudo ufw status verbose

# 2. El listener debe escuchar en todas las interfaces
ss -tlnp | grep 1521

# 3. Fichero de contraseñas: en 21c está en $ORACLE_BASE/dbs (cabezazo 20)
sudo su - oracle -c 'orabaseconfig; ls -l "$(orabaseconfig)/dbs/"'
sudo su - oracle -c 'sqlplus -s / as sysdba <<SQL
SHOW PARAMETER remote_login_passwordfile
SELECT username, sysdba FROM v\$pwfile_users;
SQL'

# 4. DG4ODBC disponible para el Apartado 4
sudo su - oracle -c 'ls -l $ORACLE_HOME/bin/dg4odbc; ls $ORACLE_HOME/hs/admin/'

echo "Desde un cliente: sqlplus sys@//delfos.inf:1521/BAHIA.inf as sysdba"
