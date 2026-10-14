#!/usr/bin/env bash
# =====================================================================
# 04-esquemas-ejemplo.sh — Instala el esquema HR en la PDB BAHIAPDB
# Ejecutar DENTRO DE LA VM como oracle.
# Se instala en la PDB, nunca en CDB$ROOT (cabezazo 16: ORA-65096).
# hr_install.sql pide: contraseña de HR, tablespace (USERS) y sobrescribir (YES).
# =====================================================================
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SERVICIO="//delfos.inf:1521/bahiapdb.inf"

cd "$HOME"
if [ ! -d db-sample-schemas-main ]; then
  wget https://github.com/oracle-samples/db-sample-schemas/archive/refs/heads/main.tar.gz \
       -O sample-schemas.tar.gz
  tar xzf sample-schemas.tar.gz
fi
cd db-sample-schemas-main/human_resources

lsnrctl status | grep -i bahiapdb
echo ">>> Conectando como SYSTEM a $SERVICIO (debe mostrar CON_NAME = BAHIAPDB)"
sqlplus "system@$SERVICIO" @"$REPO/sql/04-instalar-hr.sql"

echo ">>> Comprobación como HR"
sqlplus "hr@$SERVICIO" @"$REPO/sql/03-verificar-hr.sql"
