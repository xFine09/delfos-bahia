#!/usr/bin/env bash
# =====================================================================
# 02-ampliar-disco-anfitrion.sh — Añade 30 GB al disco qcow2 de delfos
# Ejecutar en el ANFITRIÓN (cabezazo 5: alien necesita ~20 GB libres).
# Después, dentro de la VM, 02-instalar-xe.sh extiende partición y LVM.
# =====================================================================
set -euo pipefail

DISCO="/var/lib/libvirt/images/delfos.qcow2"
V="virsh -c qemu:///system"

if $V domstate delfos | grep -q "ejecutando\|running"; then
  $V shutdown delfos
  until $V domstate delfos | grep -q "apagado\|shut off"; do sleep 2; done
fi

sudo qemu-img resize "$DISCO" +30G
sudo qemu-img info "$DISCO" | grep "virtual size"
$V start delfos
