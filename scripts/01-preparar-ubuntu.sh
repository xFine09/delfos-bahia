#!/usr/bin/env bash
# =====================================================================
# 01-preparar-ubuntu.sh — Configuración inicial de delfos y arquitectura OFA
# Ejecutar DENTRO DE LA VM como sercal (usuario con sudo), desde la raíz
# del repositorio (usa los ficheros de config/).
# Antes: ajustar IP/GATEWAY a vuestra red (cabezazo 3: no copiar la de ejemplo).
# =====================================================================
set -euo pipefail

IP="192.168.3.133"
PREFIJO="24"
GATEWAY="192.168.3.1"
IFACE="enp1s0"
CONFIG="$(cd "$(dirname "$0")/../config" && pwd)"

# --- 1. Actualización ------------------------------------------------
sudo apt update && sudo apt full-upgrade -y

# --- 2. IP fija con netplan --------------------------------------------
echo "Red actual:"; ip -br a; ip route | grep default
sudo cp /etc/netplan/00-installer-config.yaml ~/00-installer-config.yaml.bak
sed -e "s|192.168.3.133/24|$IP/$PREFIJO|" -e "s|192.168.3.1$|$GATEWAY|" \
    -e "s|enp1s0|$IFACE|g" "$CONFIG/00-installer-config.yaml" \
  | sudo tee /etc/netplan/00-installer-config.yaml >/dev/null
sudo chmod 600 /etc/netplan/00-installer-config.yaml
echo ">>> Revisa la MAC del bloque 'match' (ip link) antes de confirmar."
sudo netplan try          # se revierte solo si se pierde la conexión

# --- 3. Nombre completo, zona horaria ---------------------------------
sudo hostnamectl set-hostname delfos.inf
grep -q "delfos.inf" /etc/hosts || echo "$IP   delfos.inf delfos" | sudo tee -a /etc/hosts
hostname -f
sudo timedatectl set-timezone Europe/Madrid

# --- 4. Swap de 2 GB si hace falta ------------------------------------
if [ "$(free -m | awk '/^Swap:/ {print $2}')" -lt 2000 ]; then
  sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile
  sudo mkswap /swapfile && sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi
free -h

# --- 5. Cortafuegos: solo SSH por ahora (1521 se abre en el Apartado 3)
sudo ufw allow OpenSSH
sudo ufw --force enable

# --- 6. OFA: grupos y usuario (no hay paquete preinstall para Ubuntu: cabezazo 4)
getent group oinstall >/dev/null || sudo groupadd -g 54321 oinstall
getent group dba      >/dev/null || sudo groupadd -g 54322 dba
getent group oper     >/dev/null || sudo groupadd -g 54323 oper
id oracle >/dev/null 2>&1 || sudo useradd -u 54321 -g oinstall -G dba,oper -m -s /bin/bash oracle
echo ">>> Contraseña para el usuario oracle:"; sudo passwd oracle

# --- 7. Dependencias --------------------------------------------------
sudo apt install -y libaio1t64 bc alien unixodbc net-tools ksh make gcc binutils

# --- 8. Directorios OFA (chown -R SOLO ahora, antes de instalar Oracle)
sudo mkdir -p /opt/oracle/product/21c/dbhomeXE /opt/oracle/oradata /opt/oracle/admin /opt/oraInventory
sudo chown -R oracle:oinstall /opt/oracle /opt/oraInventory
sudo chmod -R 775 /opt/oracle /opt/oraInventory

# --- 9. Parámetros del kernel y límites -------------------------------
sudo install -m 644 "$CONFIG/99-oracle.conf"    /etc/sysctl.d/99-oracle.conf
sudo install -m 644 "$CONFIG/limits-oracle.conf" /etc/security/limits.d/oracle.conf
sudo sysctl --system | grep -A12 99-oracle.conf

# --- 10. Variables de entorno de oracle -------------------------------
sudo grep -q ORACLE_HOME /home/oracle/.bash_profile 2>/dev/null || \
  sudo tee -a /home/oracle/.bash_profile < "$CONFIG/bash_profile-oracle" >/dev/null
sudo chown oracle:oinstall /home/oracle/.bash_profile

# --- Verificación -----------------------------------------------------
id oracle
ls -ld /opt/oracle /opt/oraInventory
sysctl fs.aio-max-nr kernel.sem
sudo su - oracle -c 'ulimit -Hn; echo $ORACLE_HOME'

echo "Listo. Siguiente: snapshot 's1-preparada-pre-oracle' desde el anfitrión (vm-snapshot.sh)."
