#!/usr/bin/env bash
# =====================================================================
# vm-snapshot.sh — Apaga delfos, crea una instantánea y la vuelve a arrancar
# Ejecutar en el ANFITRIÓN.
# Uso: ./vm-snapshot.sh <nombre> "<descripción>"
# Instantáneas del proyecto:
#   s1-preparada-pre-oracle  "Ubuntu + OFA, sin Oracle"
#   s2-xe-instalado          "Oracle XE 21c instalado, sin BAHIA"
#   s2-bahia-creada          "BAHIA.inf creada con DBCA, sin esquemas de ejemplo"
#   s2-bahia-completa        "BAHIA.inf + HR + arranque automatico"
# Restaurar: virsh -c qemu:///system snapshot-revert delfos <nombre>
# =====================================================================
set -euo pipefail

NOMBRE="${1:?Indica el nombre de la instantánea}"
DESC="${2:-}"
V="virsh -c qemu:///system"

if $V domstate delfos | grep -q "ejecutando\|running"; then
  $V shutdown delfos
  echo -n "Esperando a que delfos se apague"
  until $V domstate delfos | grep -q "apagado\|shut off"; do sleep 2; echo -n "."; done; echo
fi

$V snapshot-create-as delfos --name "$NOMBRE" --description "$DESC"
$V snapshot-list delfos
$V start delfos
