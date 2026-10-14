#!/usr/bin/env bash
# =====================================================================
# 00a-anfitrion-cachyos.sh — Prepara el anfitrión CachyOS (Arch) para Qemu/KVM
# Ejecutar en el ANFITRIÓN con un usuario con sudo.
# Tras ejecutarlo: cerrar sesión y volver a entrar (grupos libvirt/kvm).
# =====================================================================
set -euo pipefail

# 1. Comprobar virtualización por hardware (>0 = soportada)
echo "Hilos con VT-x/AMD-V: $(grep -Ec '(vmx|svm)' /proc/cpuinfo)"

# 2. Paquetes y servicio libvirt (en Arch los servicios no se activan solos)
sudo pacman -S --needed qemu-desktop libvirt virt-install virt-manager dnsmasq
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt,kvm "$USER"

# 3. Que virsh use siempre la conexión del sistema (cabezazo 1)
#    El shell por defecto de CachyOS es fish:
if command -v fish >/dev/null; then
  fish -c 'set -Ux LIBVIRT_DEFAULT_URI qemu:///system'
fi
grep -q LIBVIRT_DEFAULT_URI ~/.bashrc 2>/dev/null || \
  echo 'export LIBVIRT_DEFAULT_URI=qemu:///system' >> ~/.bashrc

# 4. Red NAT por defecto de libvirt
sudo virsh net-start default 2>/dev/null || true
sudo virsh net-autostart default

# 5. ufw viene activado en CachyOS: permitir el tráfico de virbr0 (modo NAT)
if command -v ufw >/dev/null; then
  sudo ufw allow in on virbr0
  sudo ufw route allow in on virbr0
  sudo ufw route allow out on virbr0
fi

# 6. Verificación
virt-host-validate qemu || true
systemctl --no-pager status libvirtd | head -5
sudo virsh net-list --all

echo "Listo. Cierra sesión y vuelve a entrar. Siguiente: 00c-bridge-nmcli.sh (si usas puente)."
