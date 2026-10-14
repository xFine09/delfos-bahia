#!/usr/bin/env bash
# =====================================================================
# 00c-bridge-nmcli.sh — Crea y ACTIVA el puente br0 con NetworkManager
# Ejecutar en el ANFITRIÓN, con la pantalla delante (no por SSH):
# la red se corta unos segundos. Solo funciona con conexión por CABLE.
# Uso: ./00c-bridge-nmcli.sh [interfaz] ["nombre conexión cableada"]
# =====================================================================
set -euo pipefail

IFACE="${1:-enp56s0}"
OLDCON="${2:-Conexión cableada 1}"

nmcli device status

# Crear el puente y su esclavo (si no existen)
nmcli -t -f NAME con show | grep -qx br0 || \
  sudo nmcli con add type bridge ifname br0 con-name br0 bridge.stp no
nmcli -t -f NAME con show | grep -qx br0-slave || \
  sudo nmcli con add type bridge-slave ifname "$IFACE" master br0 con-name br0-slave

# ACTIVARLO en una sola orden (cabezazo 2: definido pero no activado)
sudo nmcli con down "$OLDCON"; sudo nmcli con up br0-slave; sudo nmcli con up br0

# Que la conexión antigua no vuelva a activarse al reiniciar
sudo nmcli con modify "$OLDCON" connection.autoconnect no
sudo nmcli con modify br0 connection.autoconnect yes
sudo nmcli con modify br0-slave connection.autoconnect yes

sleep 5
ip -br a show br0
bridge link
ping -c3 1.1.1.1

# Para deshacerlo:
#   sudo nmcli con delete br0-slave br0
#   sudo nmcli con modify "$OLDCON" connection.autoconnect yes
#   sudo nmcli con up "$OLDCON"
