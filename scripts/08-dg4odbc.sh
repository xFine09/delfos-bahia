#!/usr/bin/env bash
# =====================================================================
# 08-dg4odbc.sh — Configura el gateway DG4ODBC (SID PGSQL) en el listener
# Ejecutar DENTRO DE LA VM como oracle, desde la raíz del repo.
# Requiere que 'isql -v PG_RRHH' funcione (07-postgres-odbc.sh).
# =====================================================================
set -euo pipefail
: "${ORACLE_HOME:?Ejecuta como oracle}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
OBH="$(orabasehome)"     # en 21c (home de solo lectura) es distinto de ORACLE_HOME

# 1. Fichero del gateway: en ORACLE_HOME y en ORACLE_BASE_HOME por si lo busca allí
cp "$REPO/scripts/initPGSQL.ora" "$ORACLE_HOME/hs/admin/initPGSQL.ora"
if [ "$OBH" != "$ORACLE_HOME" ]; then
  mkdir -p "$OBH/hs/admin"
  cp "$REPO/scripts/initPGSQL.ora" "$OBH/hs/admin/initPGSQL.ora"
fi

# 2. Listener con el SID estático PGSQL y tnsnames.ora del servidor
cp "$ORACLE_HOME/network/admin/listener.ora" "$ORACLE_HOME/network/admin/listener.ora.bak"
cp "$REPO/scripts/listener-dg4odbc.ora" "$ORACLE_HOME/network/admin/listener.ora"
cp "$REPO/scripts/tnsnames-servidor.ora" "$ORACLE_HOME/network/admin/tnsnames.ora"
lsnrctl reload
sleep 5
lsnrctl status | grep -i -A1 pgsql      # servicio PGSQL, estado UNKNOWN (estático)
tnsping PGSQL

# 3. Probar el propio gateway sin base de datos de por medio
dg4odbc </dev/null 2>&1 | head -3 || true
echo "Siguiente: GRANT CREATE DATABASE LINK TO hr (como SYSTEM en BAHIAPDB) y sql/05-dblink-pg.sql"
