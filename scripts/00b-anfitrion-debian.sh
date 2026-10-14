#!/usr/bin/env bash
# =====================================================================
# 00b-anfitrion-debian.sh — Prepara el anfitrión Debian para Qemu/KVM
# Ejecutar en el ANFITRIÓN con un usuario con sudo.
# Tras ejecutarlo: cerrar sesión y volver a entrar (grupos libvirt/kvm).
# =====================================================================
set -euo pipefail

echo "Hilos con VT-x/AMD-V: $(grep -Ec '(vmx|svm)' /proc/cpuinfo)"

sudo apt update
sudo apt install -y qemu-system-x86 qemu-utils libvirt-daemon-system \
                    libvirt-clients virtinst virt-manager
sudo usermod -aG libvirt,kvm "$USER"

# virsh siempre contra qemu:///system (cabezazo 1)
grep -q LIBVIRT_DEFAULT_URI ~/.bashrc 2>/dev/null || \
  echo 'export LIBVIRT_DEFAULT_URI=qemu:///system' >> ~/.bashrc

sudo virsh net-start default 2>/dev/null || true
sudo virsh net-autostart default

virt-host-validate qemu || true
systemctl --no-pager status libvirtd | head -5
sudo virsh net-list --all

echo "Listo. Cierra sesión y vuelve a entrar. Siguiente: 00c-bridge-nmcli.sh (si usas puente)."
