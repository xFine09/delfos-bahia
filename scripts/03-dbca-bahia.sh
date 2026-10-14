#!/usr/bin/env bash
# =====================================================================
# 03-dbca-bahia.sh — Listener y creación de BAHIA.inf con DBCA (modo silencioso)
# Ejecutar DENTRO DE LA VM como oracle:  sudo su - oracle  (o ssh oracle@delfos.inf)
# Recomendado lanzarlo dentro de tmux: la creación tarda varios minutos.
# DBCA pide por teclado las contraseñas de SYS, SYSTEM y PDBADMIN.
# =====================================================================
set -euo pipefail

: "${ORACLE_HOME:?Ejecuta como oracle con el .bash_profile cargado}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS_DBCA=/opt/oracle/admin/BAHIA/scripts

# Parámetros comunes (BAHIA.inf, SID XE, AL32UTF8; la plantilla XE fija bloque 8 KB)
# Sin -sampleSchema: DBCA 21c no lo admite (cabezazo 11) -> 04-esquemas-ejemplo.sh
PARAMS=(
  -templateName XE_Database.dbc
  -gdbName BAHIA.inf -sid XE
  -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16
  -createAsContainerDatabase true -numberOfPDBs 1 -pdbName BAHIAPDB
  -datafileDestination /opt/oracle/oradata -storageType FS
  -memoryMgmtType AUTO_SGA -totalMemory 1536
  -emConfiguration NONE
)

# --- 0. oradism debe ser de root con SUID (cabezazo 13) ---------------
if [ "$(stat -c %U "$ORACLE_HOME/bin/oradism")" != "root" ]; then
  echo "oradism no pertenece a root. Ejecuta antes, como sercal:"
  echo "  sudo $ORACLE_HOME/root.sh"
  exit 1
fi

# --- 1. Listener -------------------------------------------------------
mkdir -p "$ORACLE_HOME/network/admin"
cp "$REPO/config/listener.ora" "$ORACLE_HOME/network/admin/listener.ora"
lsnrctl status >/dev/null 2>&1 || lsnrctl start

# --- 2. Scripts de creación (requisito del enunciado) -----------------
#     Termina con NullPointerException pero los genera completos (cabezazo 12).
mkdir -p "$SCRIPTS_DBCA"
dbca -silent -generateScripts "${PARAMS[@]}" -scriptDest "$SCRIPTS_DBCA" || true
ls "$SCRIPTS_DBCA"
grep -E "db_name|db_domain|db_block_size" "$SCRIPTS_DBCA/init.ora"

# --- 3. Creación de la base de datos ----------------------------------
dbca -silent -createDatabase "${PARAMS[@]}"

# --- 4. Abrir la PDB y guardar su estado (cabezazo 15) + verificación -
sqlplus -s / as sysdba @"$REPO/sql/01-abrir-pdb.sql"
sqlplus -s / as sysdba @"$REPO/sql/02-verificar-bahia.sql"
lsnrctl status | grep -i bahia

echo "Listo. Copia $SCRIPTS_DBCA a db-creation-scripts/ del repo."
echo "Siguiente: snapshot 's2-bahia-creada' y 04-esquemas-ejemplo.sh."
