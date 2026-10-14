#!/usr/bin/env bash
# =====================================================================
# 00d-crear-vm.sh — Crea la máquina virtual delfos con virt-install
# Ejecutar en el ANFITRIÓN. Requiere br0 activo (00c) o RED=default (NAT).
# Uso: ./00d-crear-vm.sh /ruta/ubuntu-26.04.1-live-server-amd64.iso [br0|default]
# =====================================================================
set -euo pipefail

ISO="${1:?Indica la ruta de la ISO de Ubuntu Server}"
RED="${2:-br0}"
ISO_SHA256="cc8a95cde20f6ced61a322420de00f10cc3c90ced545daa46cb9c1a117f1d927"

# Verificar la ISO
echo "$ISO_SHA256 *$ISO" | sha256sum --check

# Copiarla a una ruta legible por el usuario de qemu
sudo cp -n "$ISO" /var/lib/libvirt/images/
ISO_DEST="/var/lib/libvirt/images/$(basename "$ISO")"

if [ "$RED" = "default" ]; then
  NET="network=default,model=virtio"
else
  ip -br link show "$RED" >/dev/null || { echo "El puente $RED no existe o no está activo (ver 00c)"; exit 1; }
  NET="bridge=$RED,model=virtio"
fi

# Disco de 40 GB (se amplió después a 70 GB: ver 02-ampliar-disco-anfitrion.sh)
sudo virt-install \
  --connect qemu:///system \
  --name delfos \
  --memory 4096 \
  --vcpus 2 \
  --cpu host-passthrough \
  --disk size=40,format=qcow2,bus=virtio \
  --cdrom "$ISO_DEST" \
  --os-variant ubuntu24.04 \
  --network "$NET" \
  --graphics spice

# En el instalador: español, Ubuntu Server estándar, DHCP, LVM con disco completo,
# servidor "delfos", usuario "sercal", instalar OpenSSH, sin snaps adicionales.
