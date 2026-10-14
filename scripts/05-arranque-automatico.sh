#!/usr/bin/env bash
# =====================================================================
# 05-arranque-automatico.sh — Arranque automático de BAHIA y el listener
# Ejecutar DENTRO DE LA VM como sercal (oracle no tiene sudo: cabezazo 18).
# =====================================================================
set -euo pipefail

CONFIG="$(cd "$(dirname "$0")/../config" && pwd)"
OH=/opt/oracle/product/21c/dbhomeXE

# 1. Marcar la instancia para dbstart
sudo sed -i "s|^XE:$OH:N|XE:$OH:Y|" /etc/oratab
grep "^XE:" /etc/oratab

# 2. Parar lo arrancado a mano
sudo su - oracle -c 'echo "SHUTDOWN IMMEDIATE" | sqlplus -s / as sysdba; lsnrctl stop' || true

# 3. Servicio systemd
sudo install -m 644 "$CONFIG/oracle-xe.service" /etc/systemd/system/oracle-xe.service
sudo systemctl daemon-reload
sudo systemctl enable --now oracle-xe
systemctl --no-pager status oracle-xe | head -6

# 4. Comprobación
ps -ef | grep [p]mon
sudo su - oracle -c 'lsnrctl status | grep -i bahia'
sudo su - oracle -c 'echo "SHOW PDBS" | sqlplus -s / as sysdba'

echo "Prueba definitiva: sudo reboot y repetir las comprobaciones."
echo "Después: snapshot 's2-bahia-completa' desde el anfitrión."
