#!/usr/bin/env bash
# =====================================================================
# 06b-cliente-instantclient.sh — Instala Oracle Instant Client + SQL*Plus
# Ejecutar en el EQUIPO CLIENTE (Debian, bash). En CachyOS con fish, ver
# el Apartado 3 del tutorial (set -Ux ...).
# =====================================================================
set -euo pipefail

DEST="$HOME/oracle"
mkdir -p "$DEST" && cd "$DEST"

sudo apt install -y libaio1t64 unzip wget
# Instant Client busca libaio.so.1 (cabezazo 21)
[ -e /usr/lib/x86_64-linux-gnu/libaio.so.1 ] || {
  sudo ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1
  sudo ldconfig
}

wget -N https://download.oracle.com/otn_software/linux/instantclient/instantclient-basic-linuxx64.zip
wget -N https://download.oracle.com/otn_software/linux/instantclient/instantclient-sqlplus-linuxx64.zip
sha256sum instantclient-*.zip
unzip -oq instantclient-basic-linuxx64.zip
unzip -oq instantclient-sqlplus-linuxx64.zip
IC="$(ls -d "$DEST"/instantclient_* | tail -1)"

mkdir -p "$DEST/network/admin"
cp "$(dirname "$0")/tnsnames-cliente.ora" "$DEST/network/admin/tnsnames.ora" 2>/dev/null || true

grep -q ORACLE_IC ~/.bashrc || cat >> ~/.bashrc <<VARS
export ORACLE_IC=$IC
export LD_LIBRARY_PATH=\$ORACLE_IC
export PATH=\$ORACLE_IC:\$PATH
export TNS_ADMIN=$DEST/network/admin
VARS

grep -q delfos.inf /etc/hosts || echo "192.168.3.133   delfos.inf delfos" | sudo tee -a /etc/hosts

echo "Abre una terminal nueva y prueba: sqlplus -v ; sqlplus sys@BAHIA as sysdba ; sqlplus hr@BAHIAPDB"
